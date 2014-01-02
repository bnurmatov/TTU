////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 21, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.image
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	
	/**
	 * RetrieveLocalLessonImagesCompleteCommand class 
	 */
	public class RetrieveLocalLessonImagesCompleteCommand extends BaseAirCommand
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
		 * RetrieveLocalLessonImagesCompleteCommand 
		 */
		public function RetrieveLocalLessonImagesCompleteCommand()
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
				var images:IList = new ArrayCollection(notification.getBody() as Array);
				lessonAdapterProxy.currentLesson.aboutCreatorImages = AssetsUtil.prependRootPathForImages(lessonAdapterProxy.currentLesson.guid, lessonAdapterProxy.currentLesson.version, images);
				lessonAdapterProxy.getCurrentLessonSound();
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