////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 29, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.mediators.videoplayer
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.view.components.videoplayer.VideoPlayerPopup;
	
	/**
	 * VideoPlayerPopupMediator class 
	 */
	public class VideoPlayerPopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'VideoPlayerPopupMediator';
		
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
		 * VideoPlayerPopupMediator 
		 */
		public function VideoPlayerPopupMediator(viewComponent:VideoPlayerPopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get compoenent():VideoPlayerPopup
		{
			return viewComponent as VideoPlayerPopup;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
			if(compoenent)
			{
				compoenent.addEventListener(CloseEvent.CLOSE, onClose);
			}
			topLevelApp = FlexGlobals.topLevelApplication as DisplayObject;
			if(topLevelApp)
				topLevelApp.addEventListener(Event.RESIZE, onResize);
		}
		
		
		override public function onRemove():void
		{
			if(compoenent)
			{
				compoenent.addEventListener(CloseEvent.CLOSE, onClose);
				compoenent.videoUrl = null;
				PopUpManager.removePopUp( compoenent );
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
			facade.removeMediator( NAME );
		}
		
		protected function onResize(event:Event):void
		{
			PopUpManager.centerPopUp( compoenent );
		}
		/**
		 *  @private
		 */
		
		
	}
}