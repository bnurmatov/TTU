////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.question.retrieve
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RetriveQuestionsByChapterUuidCommand class 
	 */
	public class RetrieveQuestionsByChapterUuidCommand extends BaseAirCommand
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
		 * RetriveQuestionsByChapterUuidCommand 
		 */
		public function RetrieveQuestionsByChapterUuidCommand()
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
			var chapterUuid:String = notification.getBody() as String;
			if(questionAdapterProxy && !StringUtil.isNullOrEmpty(chapterUuid))
			{
				questionAdapterProxy.retrieveQuestionsByChapterUuid(chapterUuid, CourseAirConstants.RETRIEVE_QUESTIONS_BY_CHAPTER_UUID_COMPLETE, CourseServiceNotification.QUESTIONS_BY_CHAPTER_UUID_RETRIVED);
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