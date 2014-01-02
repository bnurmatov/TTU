////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 11, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import flash.net.FileReference;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.utils.SupportedFileFormat;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * LessonSoundDataLoadedCommand class 
	 */
	public class SoundDataLoadedCommand extends BaseAirCommand
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
		 * LessonSoundDataLoadedCommand 
		 */
		public function SoundDataLoadedCommand()
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
			if(notification.getBody() && soundAssetsProxy)
			{
				// get file ref, and save extension type for use later in import
				var fileReference:FileReference = notification.getBody() as FileReference;
				var mediaType:String = SupportedFileFormat.extractFileType(fileReference);
				
				// check supported sound
				if(SupportedMediaFormat.isSupportedSound(mediaType))
				{
					soundAssetsProxy.mediaType 				= mediaType;
					soundAssetsProxy.mediaVo.binaryContent 	= fileReference.data;
					soundAssetsProxy.mediaVo.fileName 		= fileReference.name;
					if(soundAssetsProxy.mediaVo.binaryContent)
					{
						if(notification.getName() == CourseAirConstants.LESSON_SOUND_DATA_LOADED)
							sendNotification(CourseServiceNotification.ASSOCIATE_LESSON_AUDIO, soundAssetsProxy.mediaVo);
						else
							sendNotification(CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO, soundAssetsProxy.mediaVo);
						
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