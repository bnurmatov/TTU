////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.components.components.popup.UnsavedPopup;
	import tj.ttu.components.events.LessonEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * UnsavedPopupMediator class 
	 */
	public class UnsavedPopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'UnsavedPopupMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var rootApp:DisplayObject;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * UnsavedPopupMediator 
		 */
		public function UnsavedPopupMediator(viewComponent:UnsavedPopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private function get component():UnsavedPopup
		{
			return viewComponent as UnsavedPopup;
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
				component.addEventListener(LessonEvent.SAVE_CHANGES, onSaveChanges);
				component.addEventListener(LessonEvent.DISCARD_CHANGES, onDiscardChanges);
				component.addEventListener(CloseEvent.CLOSE, onClose);
			}
			rootApp = FlexGlobals.topLevelApplication as DisplayObject;
			if(rootApp)
				rootApp.addEventListener(Event.RESIZE, onResize);
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(LessonEvent.SAVE_CHANGES, onSaveChanges);
				component.removeEventListener(LessonEvent.DISCARD_CHANGES, onDiscardChanges);
				component.removeEventListener(CloseEvent.CLOSE, onClose);
				PopUpManager.removePopUp( component );
			}
			if(rootApp)
				rootApp.removeEventListener(Event.RESIZE, onResize);
			sendNotification( CourseServiceNotification.POPUP_WINDOW_CLOSE );
			rootApp = null;
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
		private function removeMediator():void
		{
			facade.removeMediator(NAME);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onResize(event:Event):void
		{
			PopUpManager.centerPopUp( component );
		}
		
		
		protected function onClose(event:Event):void
		{
			removeMediator();
		}
		
		protected function onDiscardChanges(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.DISCARD_CHANGES);
			removeMediator();
		}
		
		protected function onSaveChanges(event:Event):void
		{
			sendNotification(CourseCreatorNotifications.SAVE_CHANGES);
			removeMediator();
		}
	}
}