////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 5, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.model.font.FontManagerProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.coursecreator.view.mediators.CCAplicationMediator;
	import tj.ttu.coursecreator.view.mediators.main.CCHolderMediator;
	
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
			facade.removeCommand( TTUConstants.STARTUP );
			facade.removeCommand( TTUConstants.DISPOSE );
			facade.removeCommand(TTUConstants.LANGUAGE_CHANGE);
			facade.removeCommand(TTUConstants.SHOW_IMAGE_FULL_SCREEN_WINDOW);
			facade.removeCommand(TTUConstants.SHOW_VIDEO_PLAYER);
			facade.removeCommand(TTUConstants.SHOW_ERROR_WINDOW);
			facade.removeCommand(TTUConstants.SET_MODULE_DATA);
			facade.removeCommand(TTUConstants.SHOW_BUSY_PROGRESS_BAR);
			
			//proxies
			facade.removeProxy( AppConfigProxy.NAME);
			facade.removeProxy( FontManagerProxy.NAME);
			facade.removeProxy( ResourceProxy.NAME);
			facade.removeProxy( DatabaseManagerProxy.NAME);
			
			//mediators
			facade.removeMediator( CCAplicationMediator.NAME );
			facade.removeMediator( CCHolderMediator.NAME );
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