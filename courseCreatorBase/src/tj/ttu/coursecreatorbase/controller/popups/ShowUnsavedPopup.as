////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.popups
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.components.components.popup.UnsavedPopup;
	import tj.ttu.components.skins.popup.UnsavedPopupSkin;
	import tj.ttu.coursecreatorbase.view.mediators.popup.UnsavedPopupMediator;
	
	/**
	 * ShowUnsavedPopup class 
	 */
	public class ShowUnsavedPopup extends SimpleCommand
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
		 * ShowUnsavedPopup 
		 */
		public function ShowUnsavedPopup()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get rootApp():DisplayObject
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
			var popup:UnsavedPopup = new UnsavedPopup();
			popup.setStyle("skinClass", UnsavedPopupSkin);
			
			if(facade.hasMediator(UnsavedPopupMediator.NAME))
				facade.removeMediator(UnsavedPopupMediator.NAME);
			facade.registerMediator(new UnsavedPopupMediator(popup));
			
			PopUpManager.addPopUp(popup, rootApp, true);
			PopUpManager.centerPopUp(popup);
			popup.setFocus();
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