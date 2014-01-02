////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 4, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.lesson.parser
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * ParseLocalListCommand class 
	 */
	public class ParseLocalLessonsCommand extends BaseAirCommand
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
		 * ParseLocalListCommand 
		 */
		public function ParseLocalLessonsCommand()
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
		override public function execute(note:INotification):void
		{
			var lessons:IList = note.getBody() as IList;
			for each(var item:LessonVO in lessons)
			{
				if(item)
				{
					item.chapters 	= item.chapters ? item.chapters : [];
					item.resources 	= item.resources ? item.resources : [];
				}
			}
			sendNotification( CourseServiceNotification.LESSONS_BY_DEPARTMENT_RETRIEVED, lessons);	
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