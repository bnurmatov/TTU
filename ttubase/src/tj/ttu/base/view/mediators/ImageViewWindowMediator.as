////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.mediators
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.view.components.popup.imageviewer.ImageViewer;
	
	/**
	 * ImageViewWindowMediator class 
	 */
	public class ImageViewWindowMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ImageViewWindowMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var topLevelApp:DisplayObject;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageViewWindowMediator 
		 */
		public function ImageViewWindowMediator(viewComponent:ImageViewer)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():ImageViewer
		{
			return viewComponent as ImageViewer;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
			if(component)
			{
				component.addEventListener(CloseEvent.CLOSE, onClose);
			}
			topLevelApp = FlexGlobals.topLevelApplication as DisplayObject;
			if(topLevelApp)
				topLevelApp.addEventListener(Event.RESIZE, onResize);
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(CloseEvent.CLOSE, onClose);
				PopUpManager.removePopUp( component );
			}
			if(topLevelApp)
				topLevelApp.removeEventListener(Event.RESIZE, onResize);
			
			topLevelApp = null;
			viewComponent = null;
			super.onRemove();
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
		protected function onClose(event:Event):void
		{
			facade.removeMediator(NAME);
		}
		
		protected function onResize(event:Event):void
		{
			var nw:Number =  Math.min(topLevelApp.width, 	800);
			var nh:Number =  Math.min(topLevelApp.height, 600);
			var factor:Number = Math.min(nw / 800, nh / 600);
			component.width = nw *factor;
			component.height =nh *factor;
			component.validateNow();
			PopUpManager.centerPopUp(component);
		}
		/**
		 *  @private
		 */
		
		
	}
}