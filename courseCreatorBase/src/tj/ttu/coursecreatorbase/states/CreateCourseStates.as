////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.states
{
	/**
	 * CreateCourseStates class 
	 */
	public class CreateCourseStates
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const COURSE_DETAILS:String = 'editInformation';
		
		public static const EDIT_CHAPTERS:String = 'editChapters';
		
		public static const EDIT_RESOURCES:String = 'editResources';
		
		public static const PUBLISH_LESSON:String = 'publishLesson';
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
		 * CreateCourseStates 
		 */
		public function CreateCourseStates()
		{
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
				case CreateCourseStates.COURSE_DETAILS:
					return 0;
				case CreateCourseStates.EDIT_CHAPTERS:
					return 1;
				case CreateCourseStates.EDIT_RESOURCES:
					return 2;
				case CreateCourseStates.PUBLISH_LESSON:
					return 3;
				
			}
			
			return 0;
		}
		public static function getViewName(viewIndex:int):String
		{
			switch(viewIndex)
			{
				case 0:
					return CreateCourseStates.COURSE_DETAILS;
				case 1:
					return CreateCourseStates.EDIT_CHAPTERS;
				case 2: 
					return CreateCourseStates.EDIT_RESOURCES;
				case 3: 
					return CreateCourseStates.PUBLISH_LESSON;
			}
			return CreateCourseStates.COURSE_DETAILS;
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