////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.video
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * VideoAssetsProxy class 
	 */
	public class VideoAssetProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'VideoAssetsProxy';
		/**
		 * Default video type 
		 */		
		public static const DEFAULT_VIDEO_TYPE:String = SupportedMediaFormat.FLV_TYPE;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Current <code>MediaVO</code> that is being worked with
		 */
		public var mediaVo:MediaVO;
		
		/**
		 * Previous video url 
		 */		
		public var previousVideo:VideoVO;
		
		/**
		 * Notification to send upon completion
		 */
		private var completionNotification:String;
		
		/**
		 * Notification's body to send upon completion
		 */
		private var notificationBody:Object;
		
		/**
		 * @private 
		 */		
		private var videoUrl:String;
		/**
		 * @private 
		 */		
		private var videoPath:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * VideoAssetsProxy 
		 */
		public function VideoAssetProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//	mediaType
		//-----------------------------------
		private var _mediaType:String;
		
		/**
		 * Extension of a media file. 
		 */
		public function get mediaType():String
		{
			return _mediaType ? _mediaType : SupportedMediaFormat.FLV_TYPE;
		}
		
		/**
		 * @private
		 */
		public function set mediaType(value:String):void
		{
			_mediaType = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		/**
		 *  @private
		 */
		override public function onRemove():void
		{
			cleanUp();
			super.onRemove();
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
		 * Clean up all properties
		 */
		public function cleanUp():void 
		{
			mediaVo = null;
			previousVideo = null;
			completionNotification = null;
			notificationBody = null;
			mediaType = null;
		}
		
		/**
		 * Write a video file to disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send, if needed
		 */	
		public function writeVideoToDisk(completionNotification:String = "", notificationBody:Object = null):String
		{
			var path:String =  AssetsUtil.writeVideoToLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.binaryContent, mediaVo.fileName);
			
			// send completion notification, if needed
			if(completionNotification)
				sendNotification(completionNotification, notificationBody);
			return path;
		}
		
		/**
		 * Delete a previous video file from disk. 
		 */	
		public function deletePreviousVideo():void
		{
			if(previousVideo)
			{
				
				var videoName:String = FileNameUtil.getFileName(previousVideo.videoUrl);
				AssetsUtil.deleteVideoFromLocalStorage(mediaVo.targetGuid, mediaVo.lessonVersion, videoName);
				previousVideo = null;
			}
		}
		
		/**
		 * Delete a video file from disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send
		 */	
		public function deleteVideoFromDisk(completionNotification:String, notificationBody:Object = null):void
		{
			AssetsUtil.deleteVideoFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName);
			
			// send completion notification
			sendNotification(completionNotification, notificationBody);
		}
		
	}
}