////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 27, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.sound
{
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.model.convertor.SoundConvertorProxy;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SoundAssetProxy class 
	 */
	public class SoundAssetProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'SoundAssetProxy';
		/**
		 * Default sound type 
		 */		
		public static const DEFAULT_SOUND_TYPE:String = SupportedMediaFormat.MP3_TYPE;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 * Current <code>MediaVO</code> that is being worked with
		 */
		public var mediaVo:MediaVO;
		
		/**
		 * Previous sound url 
		 */		
		public var previousSound:SoundVO;
		
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
		private var soundUrl:String;
		/**
		 * @private 
		 */		
		private var soundPath:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SoundAssetProxy 
		 */
		public function SoundAssetProxy()
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
			return _mediaType ? _mediaType : SupportedMediaFormat.WAV_TYPE;
		}
		
		/**
		 * @private
		 */
		public function set mediaType(value:String):void
		{
			_mediaType = value;
		}
		
		/**
		 * The converter used to transcode sounds to .mp3
		 */
		private function get soundConverter():SoundConvertorProxy
		{
			return facade.retrieveProxy(SoundConvertorProxy.NAME) as SoundConvertorProxy;
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
			previousSound = null;
			completionNotification = null;
			notificationBody = null;
			mediaType = null;
		}
		
		/**
		 * Write a sound file to disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send, if needed
		 */	
		public function writeSoundToDisk(completionNotification:String = "", notificationBody:Object = null):String
		{
			var path:String =  AssetsUtil.writeSoundToLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.binaryContent, mediaVo.fileName);
			/*if(notificationBody)
				LessonVO(notificationBody).sound = path;*/
			
			// send completion notification, if needed
			if(completionNotification)
				sendNotification(completionNotification, notificationBody);
			return path;
		}
		
		/**
		 * Delete a previous sound file from disk. 
		 */	
		public function deletePreviousSound(isCleanupOgg:Boolean = false):void
		{
			if(previousSound)
			{
				
				var soundName:String = FileNameUtil.getFileName(previousSound.soundUrl);
				AssetsUtil.deleteSoundFromLocalStorage(mediaVo.targetGuid, mediaVo.lessonVersion, soundName);
				
				if(isCleanupOgg)
					AssetsUtil.deleteSoundFromLocalStorage(mediaVo.targetGuid, mediaVo.lessonVersion, soundName.replace(/\.mp3$/ig, ".ogg"));
				previousSound = null;
			}
		}
		
		/**
		 * Delete a sound file from disk. 
		 * 
		 * @param completionNotification	Notification to send upon write-to-disk completion
		 * @param notificationBody			Notification's body to send
		 */	
		public function deleteSoundFromDisk(completionNotification:String, notificationBody:Object = null, isCleanupOgg:Boolean = false):void
		{
			AssetsUtil.deleteSoundFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName);
			
			if(isCleanupOgg)
				AssetsUtil.deleteSoundFromLocalStorage(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName.replace(/\.mp3$/ig, ".ogg"));
			
			// send completion notification
			sendNotification(completionNotification, notificationBody);
		}
		
		/**
		 * Transcode a sound file to .mp3 format.
		 * @param completionNotification	Notification to send upon transcoding completion
		 * @param notificationBody			Notification's body to send, if needed 
		 */
		public function transcodeSoundFromFile(completionNotification:String = "", notificationBody:Object = null):void
		{
			this.completionNotification = completionNotification;
			this.notificationBody 		= notificationBody;
			
			var soundFile:File = AssetsUtil.resolveSound(mediaVo.lessonUuid, mediaVo.lessonVersion, mediaVo.fileName);
			var typePattern:RegExp = new RegExp("\\" + mediaType + "$", "ig");
			
			soundUrl = soundFile.url.replace(typePattern, "");
			soundPath = soundFile.nativePath.replace(typePattern, "")
			soundUrl = soundUrl + DEFAULT_SOUND_TYPE;
			if(mediaVo.soundVO) 
				mediaVo.soundVO.soundUrl = AssetsUtil.normalizeSoundPath(soundUrl);
			
			var destPath:String = soundPath + (mediaType != DEFAULT_SOUND_TYPE ? DEFAULT_SOUND_TYPE : SupportedMediaFormat.OGG_TYPE);
			soundConverter.convert(soundPath + mediaType, destPath, new Notification(completionNotification,notificationBody));
		}
		
		
	}
}