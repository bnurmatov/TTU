////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 26, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.chapter.add
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * AddNewChapterCompleteCommand class 
	 */
	public class AddNewChapterCompleteCommand extends BaseAirCommand
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
		 * AddNewChapterCompleteCommand 
		 */
		public function AddNewChapterCompleteCommand()
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
			if(chapterAdapterProxy)
			{
				sendNotification(CourseServiceNotification.CHAPTER_ADDED, chapterAdapterProxy.currentChapter);
				chapterAdapterProxy.cleanUp();
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