////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.controllers.DisposeCommand;
	import tj.ttu.module.chapterPlayer.controllers.GenerateTestDataCommand;
	import tj.ttu.module.chapterPlayer.controllers.ParseLessonXMLCommand;
	import tj.ttu.module.chapterPlayer.controllers.ReadConfigDataCommand;
	import tj.ttu.module.chapterPlayer.controllers.StartupCommand;
	import tj.ttu.moduleUtility.controller.LoadXMLCommand;
	
	/**
	 * ChapterPlayerFacade class 
	 */
	public class ChapterPlayerFacade extends Facade
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
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
		 * ChapterPlayerFacade 
		 */
		public function ChapterPlayerFacade(key:String)
		{
			super(key);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(ChapterPlayerNotifications.STARTUP, StartupCommand);
			registerCommand(ChapterPlayerNotifications.DISPOSE, DisposeCommand);
			registerCommand(ChapterPlayerNotifications.GENERATE_TEST_CONFIGURATION_DATA, GenerateTestDataCommand);
			registerCommand(ChapterPlayerNotifications.READ_CONFIGURATION_DATA, ReadConfigDataCommand);
			registerCommand(TTUConstants.LOAD_XML, LoadXMLCommand);
			registerCommand(TTUConstants.XML_LOADED, ParseLessonXMLCommand);
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
		 * ApplicationFacade Factory Method
		 */
		public static function getInstance(key:String):ChapterPlayerFacade
		{
			if (instanceMap[key] == null)
				instanceMap[key] = new ChapterPlayerFacade(key);
			
			return instanceMap[key];
		}

		public function startup(application:ChapterPlayer, test:Boolean = false):void
		{
			this.sendNotification(ChapterPlayerNotifications.STARTUP, application);
			
			if (test)
				sendNotification( ChapterPlayerNotifications.GENERATE_TEST_CONFIGURATION_DATA );			
		}
		
		
		/**
		 *  @private
		 */
		
		
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