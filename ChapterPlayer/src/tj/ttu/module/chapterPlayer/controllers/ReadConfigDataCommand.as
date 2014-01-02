////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.controllers
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ConfigurationVO;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.models.ChapterPlayerProxy;
	
	/**
	 * ReadConfigDataCommand class 
	 */
	public class ReadConfigDataCommand extends SimpleCommand
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
		 * ReadConfigDataCommand 
		 */
		public function ReadConfigDataCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _chapterPlayerProxy:ChapterPlayerProxy;
		
		public function get chapterPlayerProxy():ChapterPlayerProxy
		{
			if(!_chapterPlayerProxy)
				_chapterPlayerProxy = facade.retrieveProxy( ChapterPlayerProxy.NAME ) as ChapterPlayerProxy;
			return _chapterPlayerProxy;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(notification:INotification):void
		{
			var config:ConfigurationVO = notification.getBody() as ConfigurationVO;
			if(config && chapterPlayerProxy)
			{
				chapterPlayerProxy.cleanUp();
				chapterPlayerProxy.config 				= config;
				chapterPlayerProxy.moduleDescription 	= config.activityDescription;
				if(config.dataURLs[0] is LessonVO)
				{
					chapterPlayerProxy.lesson 				= config.dataURLs[0] as LessonVO;
					sendNotification(ChapterPlayerNotifications.CONFIGURATION_DATA_LOADED);
				}
				else if(config.dataURLs[0] is String)
				{
					sendNotification(TTUConstants.LOAD_XML, config.dataURLs[0]); 
				}
			}
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