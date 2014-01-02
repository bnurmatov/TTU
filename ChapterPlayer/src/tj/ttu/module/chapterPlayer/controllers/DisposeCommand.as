////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.controllers
{
	import flash.system.System;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerConstants;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.models.ChapterPlayerProxy;
	import tj.ttu.module.chapterPlayer.views.mediators.ChapterPlayerMediator;
	import tj.ttu.module.chapterPlayer.views.mediators.ChapterPlayerPanelMediator;
	import tj.ttu.module.chapterPlayer.views.mediators.StartScreenMediator;
	import tj.ttu.module.chapterPlayer.views.mediators.junction.ChapterPlayerJunctionMediator;
	
	/**
	 * DisposeCommand class 
	 */
	public class DisposeCommand extends SimpleCommand
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
		 * DisposeCommand 
		 */
		public function DisposeCommand()
		{
			super();
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
		override public function execute(notification:INotification):void
		{
			//commands
			facade.removeCommand(ChapterPlayerNotifications.STARTUP);
			facade.removeCommand(ChapterPlayerNotifications.DISPOSE);
			facade.removeCommand(ChapterPlayerNotifications.GENERATE_TEST_CONFIGURATION_DATA);
			facade.removeCommand(ChapterPlayerNotifications.READ_CONFIGURATION_DATA);
			
			//mediators
			facade.removeMediator(ChapterPlayerMediator.NAME);
			facade.removeMediator(ChapterPlayerPanelMediator.NAME);
			facade.removeMediator(StartScreenMediator.NAME);
			facade.removeMediator(ChapterPlayerJunctionMediator.NAME);
			
			//models
			facade.removeProxy(ChapterPlayerProxy.NAME);
			
			Facade.removeCore(ChapterPlayerConstants.FACADE_NAME);
			
			try
			{
				System.gc();
			} 
			catch(error:Error) 
			{
				
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