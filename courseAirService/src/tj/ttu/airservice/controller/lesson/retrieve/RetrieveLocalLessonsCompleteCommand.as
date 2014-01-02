////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 20, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.retrieve
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	
	/**
	 * RetrieveLocalLessonComplete class 
	 */
	public class RetrieveLocalLessonsCompleteCommand extends BaseAirCommand
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
		 * RetrieveLocalLessonComplete 
		 */
		public function RetrieveLocalLessonsCompleteCommand()
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
			if(!lessonAdapterProxy ) return;
			
			var lessons:Array = notification.getBody() as Array; 
			// Check to see if new lists were sent in body, and save to proxy if needed.
			if(!lessonAdapterProxy.currentLessons)
				lessonAdapterProxy.currentLessons = lessons;
			
			// shift to the first (or next) list in array - sets the 'currentBykiList' property of proxy.
			lessonAdapterProxy.shiftCurrentLesson();
			
			// If next list is not null get cards. Otherwise, send completion notification with lists in body.
			if(lessonAdapterProxy.currentLesson)
			{
				lessonAdapterProxy.getCurrentLessonImages();
			}
			else
			{
				// some notifications need to convert to ArrayCollection
				switch(lessonAdapterProxy.lessonBuildingCompleteNotification)
				{
					case CourseAirConstants.PARSE_LOCAL_LESSONS:
						sendNotification(lessonAdapterProxy.lessonBuildingCompleteNotification, new ArrayCollection(lessonAdapterProxy.currentLessons));
						break;
					default:
						sendNotification(lessonAdapterProxy.lessonBuildingCompleteNotification, lessonAdapterProxy.currentLessons);
						break;
				}
				
				lessonAdapterProxy.cleanUp();
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