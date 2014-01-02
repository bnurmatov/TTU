////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup.image
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.popup.image.EditImagePopup;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * EditImagePopupMediator class 
	 */
	public class EditImagePopupMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "EditImagePopupMediator";
		
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
		 * EditImagePopupMediator 
		 */
		public function EditImagePopupMediator( viewComponent:EditImagePopup)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():EditImagePopup
		{
			return viewComponent as EditImagePopup;
		}
		
		private var _courseProxy:CourseProxy;
		public function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy;
			return _courseProxy;
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
				component.addEventListener( CourseEvent.UPDATE_IMAGE, onImageChange);
				component.addEventListener( CourseEvent.REMOVE_IMAGE, onImageChange);
				component.addEventListener( Event.CLOSE, onClosePopup);
				if(topApplication)
					topApplication.addEventListener(Event.RESIZE, onResizePopup);
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener( CourseEvent.UPDATE_IMAGE, onImageChange);
				component.removeEventListener( CourseEvent.REMOVE_IMAGE, onImageChange);
				component.removeEventListener( Event.CLOSE, onClosePopup);
				if(topApplication)
					topApplication.removeEventListener(Event.RESIZE, onResizePopup);
				
				PopUpManager.removePopUp(component as IFlexDisplayObject);
			}
			viewComponent = null;
			sendNotification(CourseServiceNotification.POPUP_WINDOW_CLOSE);
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
		
		private function convertToVO(ige:InlineGraphicElement):MediaVO
		{
			var imgVO:ImageVO 	= new ImageVO();
			imgVO.imageUrl 		= String(ige.source);
			imgVO.width 		= String(ige.width);
			imgVO.height 		= String(ige.height);
			imgVO.location 		= String(ige.float);
			var vo:MediaVO 		= new MediaVO();
			vo.lessonUuid 		= courseProxy.currentLesson.guid;
			vo.lessonVersion 	= courseProxy.currentLesson.version;
			vo.imageVO			= imgVO;
			return vo;
		}
		
		public function showBusyProgressBar(message:String):void
		{
			sendNotification(TTUConstants.SHOW_BUSY_PROGRESS_BAR, message );
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		protected function onClosePopup(event:Event):void
		{
			facade.removeMediator( NAME );
		}
		/**
		 *  @protected
		 */
		
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
		
		protected function onImageChange(event:CourseEvent):void
		{
			if(!courseProxy || !courseProxy.currentLesson)
				return;
			var spinMessage:String;
			var lessonBaseUrl:String = "Lessons/"+ courseProxy.currentLesson.guid + "_" + courseProxy.currentLesson.version;
			var ilg:InlineGraphicElement = event.data as InlineGraphicElement;
			var url:String = ilg.source is String? String(ilg.source): null;
			var isSaved:Boolean = url != null && url.indexOf(lessonBaseUrl) != -1; 
			if(event.type == CourseEvent.UPDATE_IMAGE)
			{
				sendNotification(CourseCreatorNotifications.UPDATE_IMAGE_ELEMENT, ilg);
				if(isSaved)
				{
					spinMessage = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, 'updatingImageProgressMessage') || 'Image updating';
					showBusyProgressBar( spinMessage );
					sendNotification(CourseServiceNotification.UPDATE_IMAGE, convertToVO(ilg));
				}
			}
			if(event.type == CourseEvent.REMOVE_IMAGE)
			{
				sendNotification(CourseCreatorNotifications.REMOVE_IMAGE_ELEMENT, event.data);
				if(isSaved)
				{
					spinMessage = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, 'removingImageProgressMessage') || 'Image removing';
					showBusyProgressBar( spinMessage );
					sendNotification(CourseServiceNotification.REMOVE_IMAGE, convertToVO(ilg));
				}
			}
			
			facade.removeMediator(NAME);
		}
		
	}
}