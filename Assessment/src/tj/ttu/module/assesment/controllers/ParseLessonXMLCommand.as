////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.controllers
{
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.XMLToLessonUtil;
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	
	/**
	 * ParseLessonXMLCommand class 
	 */
	public class ParseLessonXMLCommand extends SimpleCommand
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const APP_FOLDER:String = "app:/";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ParseLessonXMLCommand 
		 */
		public function ParseLessonXMLCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _assesmentPlayerProxy:AssesmentPlayerProxy;
		
		public function get assesmentPlayerProxy():AssesmentPlayerProxy
		{
			if(!_assesmentPlayerProxy)
				_assesmentPlayerProxy = facade.retrieveProxy( AssesmentPlayerProxy.NAME ) as AssesmentPlayerProxy;
			return _assesmentPlayerProxy;
		}
		
		private function get isAir():Boolean
		{
			return Capabilities.playerType == "Desktop";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(note:INotification):void
		{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			
			var xml:XML 
			try
			{
				xml  = XML(note.getBody());
			}
			catch(e:Error)
			{
				sendError();
				return;
			}
			//TO DO move it to proxy
			if( !populateFromXML(xml))
				return;
			
			
			//we can set XML global properties back here since we finished parsing it
			XML.ignoreWhitespace = true;
			XML.prettyPrinting = true;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		private function populateFromXML(value:XML):Boolean
		{
			var rootDataPath:String;
			if(assesmentPlayerProxy && assesmentPlayerProxy.config)
				rootDataPath = assesmentPlayerProxy.config.rootDataPath;
			if(rootDataPath && isAir)
			{
				rootDataPath = rootDataPath.charAt(0) == "/" ? rootDataPath.substring(1) : rootDataPath;
				rootDataPath = APP_FOLDER  + rootDataPath;
			}
			var xmlToLesson:XMLToLessonUtil = new XMLToLessonUtil();
			xmlToLesson.createLesson( value, rootDataPath);
			assesmentPlayerProxy.lesson = xmlToLesson.lesson;
			assesmentPlayerProxy.questions = getQuestions(xmlToLesson.lesson.chapters);
			sendNotification(AssesmentNotifications.CONFIGURATION_DATA_LOADED);
			return true;
		}
		
		/**
		 *  @private
		 */
		private function getQuestions(chapters:Array):IList
		{
			var questionList:ArrayCollection = new ArrayCollection();
			for each(var item:ChapterVO in chapters)
			{
				questionList.addAll( item.questions );
			}
			return questionList;
		}
		/**
		 * @private
		 *  Sends error to main app
		 */		
		private function sendError():void
		{
			var errString:String ="Xml malformed.";
			var msg:ModuleMessage = new ModuleMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				TTUConstants.SHOW_ERROR_WINDOW,
				errString);
			sendNotification(AssesmentNotifications.SEND_MESSAGE_TO_SHELL, msg);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		
	}
}