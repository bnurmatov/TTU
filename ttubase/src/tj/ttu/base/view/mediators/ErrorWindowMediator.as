////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 16, 2013, Tajik Technical University
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
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.view.components.popup.ErrorWindow;
	
	/**
	 * ErrorWindowMediator class 
	 */
	public class ErrorWindowMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ErrorWindowMediator';
		
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
		 * ErrorWindowMediator 
		 */
		public function ErrorWindowMediator(viewComponent:ErrorWindow)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():ErrorWindow
		{
			return viewComponent as ErrorWindow;
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
				component.errorText = null;
				PopUpManager.removePopUp(component);
			}
			if(topLevelApp)
				topLevelApp.removeEventListener(Event.RESIZE, onResize);
			
			topLevelApp = null;
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			if(note.getName() == TTUConstants.SHOW_ERROR_WINDOW)
			{
				component.errorText = note.getBody() as String;
				PopUpManager.centerPopUp(component);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.SHOW_ERROR_WINDOW];
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
			PopUpManager.centerPopUp(component);
		}
		
		/**
		 *  @private
		 */
		
		
	}
}