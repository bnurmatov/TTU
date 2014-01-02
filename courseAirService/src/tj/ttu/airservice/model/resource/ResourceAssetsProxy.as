////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 9, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.resource
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * ResourceAssetsProxy class 
	 */
	public class ResourceAssetsProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ResourceAssetsProxy';
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
		 * Previous resource url 
		 */		
		public var previousResource:ResourceVO;
		
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
		private var resourceUrl:String;
		/**
		 * @private 
		 */		
		private var resourcePath:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ResourceAssetsProxy 
		 */
		public function ResourceAssetsProxy()
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
			previousResource = null;
			completionNotification = null;
			notificationBody = null;
			mediaType = null;
		}
		
		/**
		 * Write a resource file to disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send, if needed
		 */	
		public function writeResourceToDisk(completionNotification:String = "", notificationBody:Object = null):String
		{
			var path:String =  AssetsUtil.writeResourceToLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.binaryContent, mediaVo.fileName);
			
			// send completion notification, if needed
			if(completionNotification)
				sendNotification(completionNotification, notificationBody);
			return path;
		}
		
		/**
		 * Delete a previous resource file from disk. 
		 */	
		public function deletePreviousResource():void
		{
			if(previousResource)
			{
				
				var resourceName:String = FileNameUtil.getFileName(previousResource.resourcePath);
				AssetsUtil.deleteResourceFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, resourceName);
				previousResource = null;
			}
		}
		
		/**
		 * Delete a resource file from disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send
		 */	
		public function deleteResourceFromDisk(completionNotification:String, notificationBody:Object = null):void
		{
			AssetsUtil.deleteResourceFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName);
			
			// send completion notification
			sendNotification(completionNotification, notificationBody);
		}
		
	}
}