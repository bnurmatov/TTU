////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.states
{
	/**
	 * CourseBaseState class 
	 */
	public class CourseBaseState
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		public static const NORMAL:String = 'normal';
		
		
		public static const DISABLED:String = 'disabled';
		
		
		public static const COURSE_LIST:String = 'lessonList';
		
		
		public static const CREATE_COURSE:String = 'createLesson';
		
		public static const LESSON_PLAYER:String = 'lessonPlayer';
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public static function getViewIndex(stateName:String):int
		{
			switch(stateName)
			{
				case CREATE_COURSE:
					return 0;
				case COURSE_LIST:
					return 1;
				default:	
					return 1;
			}
			
		}
		public static function getViewName(viewIndex:int):String
		{
			switch(viewIndex)
			{
				case 0:
					return CREATE_COURSE;
				case 1:
					return COURSE_LIST;
				default:
					return COURSE_LIST;
			}
		}		
	}
}