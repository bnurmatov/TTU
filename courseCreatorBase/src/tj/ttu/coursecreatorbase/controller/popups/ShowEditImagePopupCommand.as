////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.popups
{
	import flash.display.DisplayObject;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.coursecreatorbase.view.components.popup.image.EditImagePopup;
	import tj.ttu.coursecreatorbase.view.mediators.popup.image.EditImagePopupMediator;
	import tj.ttu.coursecreatorbase.view.skins.popup.image.EditImagePopupSkin;
	
	/**
	 * ShowEditImagePopupCommand class 
	 */
	public class ShowEditImagePopupCommand extends SimpleCommand
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
		 * ShowEditImagePopupCommand 
		 */
		public function ShowEditImagePopupCommand()
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
		/**
		 *  Launch Insert image popups.
		 */ 
		override public function execute(note:INotification):void
		{
			var imgVo:InlineGraphicElement = note.getBody() as InlineGraphicElement;
			if(!imgVo)
				return;
			
			var view:EditImagePopup = new EditImagePopup();
			view.setStyle("skinClass", EditImagePopupSkin);
			var top:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			var nw:Number =  Math.min(top.width, 	800);
			var nh:Number =  Math.min(top.height, 600);
			var factor:Number = Math.min(0.8, Math.min(nw / 800, nh / 600));
			view.width = nw *factor;
			view.height =nh *factor;
			view.insertImageVo = imgVo;
			if(facade.hasMediator(EditImagePopupMediator.NAME))
				facade.removeMediator(EditImagePopupMediator.NAME);
			facade.registerMediator(new EditImagePopupMediator(view));
			PopUpManager.addPopUp( view, top, true );
			PopUpManager.centerPopUp( view );
			view.setFocus();
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