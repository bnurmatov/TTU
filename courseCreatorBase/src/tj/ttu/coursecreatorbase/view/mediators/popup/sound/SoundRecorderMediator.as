////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 20, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.mediators.popup.sound
{
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.popup.sound.SoundRecorderWindow;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SoundLoaderMediator class 
	 */
	public class SoundRecorderMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "SoundRecorderMediator";
		
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
		 * SoundLoaderMediator 
		 */
		public function SoundRecorderMediator( viewComponent:SoundRecorderWindow)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get component() : SoundRecorderWindow
		{
			return viewComponent as SoundRecorderWindow;
		}
		
		//-----------------------------------------
		// courseProxy
		//-----------------------------------------
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
				component.addEventListener( CourseEvent.SAVE_SOUND, onChangeSoundHandler);
				component.addEventListener( CourseEvent.MICROPHONE_CONFIGURED, onMocrophoneConfigured);
				component.addEventListener( Event.CLOSE ,    onCloseHandler);
				if(courseProxy)
					component.isMicrophoneConfigured = courseProxy.isMicrophoneConfigured;
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener( CourseEvent.SAVE_SOUND, onChangeSoundHandler);
				component.removeEventListener( CourseEvent.MICROPHONE_CONFIGURED, onMocrophoneConfigured);
				component.removeEventListener( Event.CLOSE ,    onCloseHandler);
				component.isNoSound = false;
				PopUpManager.removePopUp( component as IFlexDisplayObject);
			}
			sendNotification( CourseServiceNotification.POPUP_WINDOW_CLOSE );
			viewComponent = null;
			super.onRemove();
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				default:
				{
					break;
				}
			}
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
		
		protected function onChangeSoundHandler(event:CourseEvent):void
		{
			var mediaVo:MediaVO = event.data as MediaVO;
			if(!mediaVo) return;
			var note:String;
			if(mediaVo.target == MediaVO.LESSON)
				note = CourseServiceNotification.ASSOCIATE_LESSON_AUDIO;
			else if(mediaVo.target == MediaVO.CHAPTER)
				note = CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO;
			
			sendNotification(note, mediaVo);
			onCloseHandler(null);
		}
		
		private function onCloseHandler(event:Event):void
		{
			facade.removeMediator( NAME );
		}
		
		protected function onMocrophoneConfigured(event:CourseEvent):void
		{
			if(courseProxy)
				courseProxy.isMicrophoneConfigured = event.data as Boolean;
		}		
		
	}
}