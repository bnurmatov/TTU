////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.video
{
	import flash.net.FileReference;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.utils.SupportedFileFormat;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * VideoDataLoadedCommand class 
	 */
	public class VideoDataLoadedCommand extends BaseAirCommand
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
		 * VideoDataLoadedCommand 
		 */
		public function VideoDataLoadedCommand()
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
			if(notification.getBody() && videoAssetProxy)
			{
				// get file ref, and save extension type for use later in import
				var fileReference:FileReference = notification.getBody() as FileReference;
				var mediaType:String = SupportedFileFormat.extractFileType(fileReference);
				
				// check supported video
				if(SupportedMediaFormat.isSupportedVideo(mediaType))
				{
					videoAssetProxy.mediaType 				= mediaType;
					videoAssetProxy.mediaVo.binaryContent 	= fileReference.data;
					videoAssetProxy.mediaVo.fileName 		= fileReference.name;
					if(videoAssetProxy.mediaVo.binaryContent)
					{
						if(notification.getName() == CourseAirConstants.CHAPTER_VIDEO_DATA_LOADED)
							sendNotification(CourseServiceNotification.ASSOCIATE_CHAPTER_VIDEO, videoAssetProxy.mediaVo);
						else
							sendNotification(CourseServiceNotification.ASSOCIATE_LESSON_VIDEO, videoAssetProxy.mediaVo);
						
					}
					
				}
				else
				{
					var errorMessage:String = 'Not Supported File Format Message : ' + mediaType;					
					sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, errorMessage);
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