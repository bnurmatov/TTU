////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 17, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.image
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * ImageAssetProxy class 
	 */
	public class ImageAssetProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Proxy Name
		 */
		public static const NAME:String = "ImageAssetProxy";
		
		/**
		 * Default image type 
		 */		
		public static const DEFAULT_IMAGE_TYPE:String = SupportedMediaFormat.PNG_TYPE;
		
		
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
		 * Previous image url 
		 */		
		public var previousImage:String;
		
		/**
		 * Notification to send upon completion
		 */
		private var completionNotification:String;
		
		/**
		 * Notification's body to send upon completion
		 */
		private var notificationBody:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageAssetProxy 
		 */
		public function ImageAssetProxy()
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
			return _mediaType ? _mediaType : SupportedMediaFormat.PNG_TYPE;
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
		/**
		 *  @private
		 */
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
		 *  @public
		 */
		/**
		 * Clean up all properties
		 */
		public function cleanUp():void 
		{
			mediaVo = null;
			previousImage = null;
			completionNotification = null;
			notificationBody = null;
			mediaType = null;
		}
		
		/**
		 * Write an image file to disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send, if needed
		 */	
		public function writeImageToDisk(completionNotification:String = "", notificationBody:Object = null):String
		{
			var path:String = AssetsUtil.writeImageToLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.binaryContent, mediaVo.fileName);
			// send completion notification, if needed
			if(completionNotification)
				sendNotification(completionNotification, notificationBody);
			return path;
		}
		
		/**
		 * Delete a previous image file from disk. 
		 */	
		public function deletePreviousImage():void
		{
			if(previousImage)
			{
				previousImage = FileNameUtil.getFileName(previousImage);
				AssetsUtil.deleteImageFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, previousImage);
				previousImage = null;
			}
		}
		
		/**
		 * Delete an image file from disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send
		 */	
		public function deleteImageFromDisk(completionNotification:String = null, notificationBody:Object = null):void
		{
			AssetsUtil.deleteImageFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName);
			
			// send completion notification
			sendNotification(completionNotification, notificationBody);
		}
		
		/**
		 * Transcode an image steam to .png format.
		 */
		public function transcodeImageFromStream():void
		{
			
		}
		
		
	}
}