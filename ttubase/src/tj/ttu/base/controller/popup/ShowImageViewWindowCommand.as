////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 15, 2013, Tajik Technical University
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
	
	import tj.ttu.base.view.components.popup.imageviewer.ImageViewer;
	import tj.ttu.base.view.mediators.ImageViewWindowMediator;
	import tj.ttu.base.view.skins.popup.imageviewer.ImageViewerSkin;
	
	/**
	 * ShowImageViewWindowCommand class 
	 */
	public class ShowImageViewWindowCommand extends SimpleCommand
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
		 * ShowImageViewWindowCommand 
		 */
		public function ShowImageViewWindowCommand()
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
			var image:String = String( notification.getBody());
			var view:ImageViewer = new ImageViewer();
			view.setStyle("skinClass", ImageViewerSkin);
			
			var nw:Number =  Math.min(root.width, 	800);
			var nh:Number =  Math.min(root.height, 600);
			var factor:Number = Math.min(1, Math.min(nw / 800, nh / 600));
			view.width = nw *factor;
			view.height = nh *factor;
			
			view.imageURL = image;
			if(facade.hasMediator(ImageViewWindowMediator.NAME))
				facade.removeMediator(ImageViewWindowMediator.NAME);
			facade.registerMediator(new ImageViewWindowMediator(view));
			
			PopUpManager.addPopUp(view, root, true);
			PopUpManager.centerPopUp(view)
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