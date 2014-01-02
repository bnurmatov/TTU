////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.popups
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.popup.sound.SoundRecorderWindow;
	import tj.ttu.coursecreatorbase.view.mediators.popup.sound.SoundRecorderMediator;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * ShowSoundRecorderPopup class 
	 */
	public class ShowSoundRecorderPopup extends SimpleCommand
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
		 * ShowSoundRecorderPopup 
		 */
		public function ShowSoundRecorderPopup()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get courseProxy():CourseProxy
		{
			return facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy; 
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(note:INotification):void
		{
			var mediaVO:MediaVO = note.getBody() as MediaVO;
			if(!(mediaVO && courseProxy))
				return;
			
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			var view:SoundRecorderWindow = new SoundRecorderWindow();
			view.mediaVO = mediaVO;
			view.sndData = null;
			view.userSndData = null;
			
			
			if( mediaVO.target == MediaVO.LESSON && courseProxy && courseProxy.currentLesson)
			{
				var lesson:LessonVO = courseProxy.currentLesson;
				var previousSound:String = lesson.sound ? lesson.sound.soundUrl : null;
				view.currentSound = previousSound;
				view.isNoSound = isNullOrEmpty( previousSound );
				view.soundText = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "lessonSoundLabel") || "Lesson Sound";
			}
			else if( mediaVO.target == MediaVO.CHAPTER )
			{
				view.isNoSound = isNullOrEmpty( null );
				view.soundText = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "chapterSoundLabel") || "Chapter Sound";
			}
			
			if(facade.hasMediator(SoundRecorderMediator.NAME))
				facade.removeMediator(SoundRecorderMediator.NAME);
			
			facade.registerMediator(new SoundRecorderMediator(view));
			PopUpManager.addPopUp( view, rootApp, true );
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
		/**
		 *  @private
		 */
		private function isNullOrEmpty(str:String):Boolean
		{
			return str == "" || !str;
		}
		
		
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