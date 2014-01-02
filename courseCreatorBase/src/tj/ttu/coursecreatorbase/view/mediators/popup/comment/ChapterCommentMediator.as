////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 25, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup.comment
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.components.events.ChapterEvent;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.popup.comment.ChapterCommentPopup;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * ChapterCommentMediator class 
	 */
	public class ChapterCommentMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterCommentMediator';
		
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
		 * ChapterCommentMediator 
		 */
		public function ChapterCommentMediator(viewComponent:ChapterCommentPopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():ChapterCommentPopup
		{
			return viewComponent as ChapterCommentPopup;
		}
		
		public function get courseProxy():CourseProxy
		{
			return facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy;
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
				component.addEventListener(ChapterEvent.CHANGE_CHAPTER_COMMENT, onSendChangedComment);
			}
			
			rootApp = FlexGlobals.topLevelApplication as DisplayObject;
			if(rootApp)
				rootApp.addEventListener(Event.RESIZE, onResize);
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(CloseEvent.CLOSE, onClose);
				component.removeEventListener(ChapterEvent.CHANGE_CHAPTER_COMMENT, onSendChangedComment);
				component.resetComponent();
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onSendChangedComment(event:ChapterEvent):void
		{
			if(courseProxy && courseProxy.currentChapter && component)
			{
				courseProxy.currentChapter.comment = component.comment;
				courseProxy.hasChange = true;
			}
			facade.removeMediator( NAME );
		}
		
		protected function onResize(event:Event):void
		{
			PopUpManager.centerPopUp( component );
		}
		
		protected function onClose(event:Event):void
		{
			facade.removeMediator( NAME );
		}
		
	}
}