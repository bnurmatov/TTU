////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.controller.popup
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.view.components.popup.ErrorWindow;
	import tj.ttu.base.view.mediators.ErrorWindowMediator;
	import tj.ttu.base.view.skins.popup.ErrorWindowSkin;
	
	/**
	 * ShowErrorWindowCommand class 
	 */
	public class ShowErrorWindowCommand extends SimpleCommand
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
		 * ShowErrorWindowCommand 
		 */
		public function ShowErrorWindowCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get root():DisplayObject
		{
			return FlexGlobals.topLevelApplication as DisplayObject;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function execute(notification:INotification):void
		{
			if(!facade.hasMediator(ErrorWindowMediator.NAME))
			{
			   var view:ErrorWindow = new ErrorWindow();
			   view.setStyle("skinClass", ErrorWindowSkin);
			   facade.registerMediator( new ErrorWindowMediator(view));
			   PopUpManager.addPopUp(view, root, true);
			   PopUpManager.centerPopUp(view);
			   view.errorText = notification.getBody() as String;
			   view.setFocus();
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