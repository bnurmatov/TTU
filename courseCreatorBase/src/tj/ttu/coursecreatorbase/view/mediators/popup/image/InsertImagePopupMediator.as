////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup.image
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.coursecreatorbase.view.components.popup.image.InsertImagePopup;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;

	/**
	 * InsertImagePopupMediator class 
	 */
	public class InsertImagePopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "InsertImagePopupMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var insertNotification:String;
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
		 * InsertImagePopupMediator 
		 */
		public function InsertImagePopupMediator(viewComponent:InsertImagePopup, insertNotification:String=null)
		{
			super(NAME, viewComponent);
			this.insertNotification = insertNotification;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():InsertImagePopup
		{
			return viewComponent as InsertImagePopup;
		}
		
		protected function get topApplication():DisplayObject
		{
			return FlexGlobals.topLevelApplication as DisplayObject;
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
				component.addEventListener( CourseEvent.INSERT_IMAGE, onInsertImage);
				component.addEventListener( Event.CLOSE, onClose);
				if(topApplication)
					topApplication.addEventListener(Event.RESIZE, onResizePopup);
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener( CourseEvent.INSERT_IMAGE, onInsertImage);
				component.removeEventListener( Event.CLOSE, onClose);
				if(topApplication)
					topApplication.removeEventListener(Event.RESIZE, onResizePopup);
				
				PopUpManager.removePopUp( component as IFlexDisplayObject);
			}
			sendNotification(CourseServiceNotification.POPUP_WINDOW_CLOSE);
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
		
		protected function onInsertImage(event:CourseEvent):void
		{
			sendNotification( TTUConstants.SPIN_START );
			sendNotification(insertNotification, event.data );
			onClose(null);
		}
		
		/**
		 * 
		 * Handler for <code>Event.CLOSE</code> event dispatched by view.
		 * 
		 * @param event The event dispatched by view.
		 * 
		 */
		protected function onClose(event:Event):void
		{
			facade.removeMediator(NAME);
		}
		
		protected function onResizePopup(event:Event):void
		{
			var nw:Number =  Math.min(topApplication.width, 	800);
			var nh:Number =  Math.min(topApplication.height, 600);
			var factor:Number = Math.min(nw / 800, nh / 600);
			component.width = nw *factor;
			component.height =nh *factor;
			component.validateNow();
			
			PopUpManager.centerPopUp(component as IFlexDisplayObject);
		}
	}
}