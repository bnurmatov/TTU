////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 29, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * RetrieveLocalLessonSoundCompleteCommand class 
	 */
	public class RetrieveLocalLessonSoundCompleteCommand extends BaseAirCommand
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
		 * RetrieveLocalLessonSoundCompleteCommand 
		 */
		public function RetrieveLocalLessonSoundCompleteCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(notification:INotification):void
		{
			if(lessonAdapterProxy && lessonAdapterProxy.currentLesson)
			{
				var sounds:Array = notification.getBody() as Array;
				lessonAdapterProxy.currentLesson.sound = sounds ? AssetsUtil.prependRootPathForSingleSound(lessonAdapterProxy.currentLesson.guid, lessonAdapterProxy.currentLesson.version, sounds[0]) : null;
				if(lessonAdapterProxy.shouldGetChapters)
					lessonAdapterProxy.getCurrentLessonChapters();
				else
					sendNotification(CourseAirConstants.RETRIEVE_LOCAL_LESSON_COMPLETE);
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