////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flash.utils.ByteArray;

	/**
	 * SupportedMediaFormat class 
	 */
	public class SupportedMediaFormat
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		//  type of supported file formats
		//-----------------------------------------
		/**
		 * Type of the zip .b4x format. 
		 */		
		public static const B4X_TYPE:String = ".b4x";
		
		//-----------------------------------------
		//  type of supported audio formats
		//-----------------------------------------
		/**
		 * Type of the audio .ogg format. 
		 */		
		public static const OGG_TYPE:String = ".ogg";
		
		/**
		 * Type of the audio .mp3 format. 
		 */		
		public static const MP3_TYPE:String = ".mp3";
		
		/**
		 * Type of the audio .wav format. 
		 */		
		public static const WAV_TYPE:String = ".wav";
		
		/**
		 * Type of the audio .aac format. 
		 */		
		public static const AAC_TYPE:String = ".aac";
		
		//-----------------------------------------
		//  extension of supported audio formats
		//-----------------------------------------
		/**
		 * Extension of the audio .ogg format. 
		 */		
		public static const OGG_EXTENSION:String = "ogg";
		
		/**
		 * Extension of the audio .mp3 format. 
		 */		
		public static const MP3_EXTENSION:String = "mp3";
		
		/**
		 * Extension of the audio .wav format. 
		 */		
		public static const WAV_EXTENSION:String = "wav";
		
		/**
		 * Extension of the audio .aac format. 
		 */		
		public static const AAC_EXTENSION:String = "aac";
		
		//-----------------------------------------
		//  filter of supported audio formats
		//-----------------------------------------
		/**
		 * Filter of the audio .ogg format. 
		 */		
		public static const OGG_FILTER:String = "*.ogg";
		
		/**
		 * Filter of the audio .mp3 format. 
		 */		
		public static const MP3_FILTER:String = "*.mp3";
		
		/**
		 * Filter of the audio .wav format. 
		 */		
		public static const WAV_FILTER:String = "*.wav";
		
		/**
		 * Filter of the audio .aac format. 
		 */		
		public static const AAC_FILTER:String = "*.aac";
		//-----------------------------------------
		//  filter of supported book formats
		//-----------------------------------------
		/**
		 * Filter of the book .pdf format. 
		 */		
		public static const PDF_FILTER:String = "*.pdf";
		
		//-----------------------------------------
		//  type of supported video formats
		//-----------------------------------------
		/**
		 * Type of the video .flv format. 
		 */		
		public static const FLV_TYPE:String = ".flv";
		
		/**
		 * Type of the video .f4v format. 
		 */		
		public static const F4V_TYPE:String = ".f4v";
		
		/**
		 * Type of the video .mp4 format. 
		 */		
		public static const  MP4_TYPE:String = ".mp4";
		
		/**
		 * Type of the video .mov format. 
		 */		
		public static const  MOV_TYPE:String = ".mov";
		
		//-----------------------------------------
		//  filter of supported video formats
		//-----------------------------------------
		/**
		 * Filter of the video .flv format. 
		 */		
		public static const FLV_FILTER:String = "*.flv";
		/**
		 * Filter of the video .f4v format. 
		 */		
		public static const F4V_FILTER:String = "*.f4v";
		
		/**
		 * Filter of the video .mp4 format. 
		 */		
		public static const  MP4_FILTER:String = "*.mp4";
		
		/**
		 * Filter of the video .mov format. 
		 */		
		public static const  MOV_FILTER:String = "*.mov";
		//-----------------------------------------
		//  type of supported image formats
		//-----------------------------------------
		/**
		 * Type of the image .png format. 
		 */		
		public static const PNG_TYPE:String = ".png";
		
		/**
		 * Type of the image .jpeg format. 
		 */		
		public static const JPEG_TYPE:String = ".jpeg";
		
		/**
		 * Type of the image .jpg format. 
		 */		
		public static const JPG_TYPE:String = ".jpg";
		
		/**
		 * Type of the image .bmp format. 
		 */		
		public static const BMP_TYPE:String = ".bmp";
		
		/**
		 * Type of the image .gif format. 
		 */		
		public static const GIF_TYPE:String = ".gif";
		
		
		//-----------------------------------------
		//  extension of supported image formats
		//-----------------------------------------
		/**
		 * Extension of the image .png format. 
		 */		
		public static const PNG_EXTENSION:String = "png";
		
		/**
		 * Extension of the image .jpeg format. 
		 */		
		public static const JPEG_EXTENSION:String = "jpeg";
		
		/**
		 * Extension of the image .jpg format. 
		 */		
		public static const JPG_EXTENSION:String = "jpg";
		
		/**
		 * Extension of the image .bmp format. 
		 */		
		public static const BMP_EXTENSION:String = "bmp";
		
		/**
		 * Extension of the image .gif format. 
		 */		
		public static const GIF_EXTENSION:String = "gif";
		
	
		//-----------------------------------------
		//  filter of supported image formats
		//-----------------------------------------
		/**
		 * Filter of the image .png format. 
		 */		
		public static const PNG_FILTER:String = "*.png";
		
		/**
		 * Filter of the image .jpeg format. 
		 */		
		public static const JPEG_FILTER:String = "*.jpeg";
		
		/**
		 * Filter of the image .jpg format. 
		 */		
		public static const JPG_FILTER:String = "*.jpg";
		
		/**
		 * Filter of the image .bmp format. 
		 */		
		public static const BMP_FILTER:String = "*.bmp";
		
		/**
		 * Filter of the image .gif format. 
		 */		
		public static const GIF_FILTER:String = "*.gif";
		
		
		
		//-----------------------------------------
		//  maximum size of supported audio formats
		//-----------------------------------------
		/**
		 * Maximum size of the audio .ogg format. 
		 */	
		public static const OGG_MAX_FILE_SIZE:int =  1887436;
		
		/**
		 * Maximum size of the audio .mp3 format. 
		 */	
		public static const MP3_MAX_FILE_SIZE:int =  1520435;
		
		/**
		 * Maximum size of the audio .wav format. 
		 */	
		public static const WAV_MAX_FILE_SIZE:int = 12058624;
		
		/**
		 * Maximum size of the audio .aac format. 
		 */	
		public static const AAC_MAX_FILE_SIZE:int =   597688;
		
		/**
		 * Maximum label size of the audio .ogg format. 
		 */
		public static const OGG_MAX_FILE_SIZE_LABEL:String =   "2.0";
		
		/**
		 * Maximum label size of the audio .mp3 format. 
		 */
		public static const MP3_MAX_FILE_SIZE_LABEL:String =   "1.5";
		
		/**
		 * Maximum label size of the audio .wav format. 
		 */
		public static const WAV_MAX_FILE_SIZE_LABEL:String =  "12.0";
		
		/**
		 * Maximum label size of the audio .aac format. 
		 */
		public static const AAC_MAX_FILE_SIZE_LABEL:String =   "0.6";
		
		
		//-----------------------------------------
		//  maximum resolution of supported image formats
		//-----------------------------------------
		/**
		 * Maximum width resolution of the image. 
		 */
		public static const IMAGE_MAX_WIDTH:Number = 768;
		
		/**
		 * Maximum height resolution of the image. 
		 */
		public static const IMAGE_MAX_HEIGHT:Number = 520;
		
		//-----------------------------------------
		//  other constants
		//-----------------------------------------
		/**
		 * The delimiter separates between extension filter.
		 */		
		public static const FILTER_DELIMITER:String = ";";
		
		public static const NOT_SUPPORTED_IMAGE_FORMAT:String = "notSupportedImageFormat";
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  Public Static
		//--------------------------------------------------------------------------
		/**
		 * Image extensions to filter by in browse dialog
		 *  
		 *  "*.jpeg;*.jpg;*.gif;*.png"
		 */
		public static function getSupportedImageFilterExtensions():String
		{
			var supportedImages:Array = [JPEG_FILTER, JPG_FILTER, GIF_FILTER, PNG_FILTER, BMP_FILTER];
			return supportedImages.join(FILTER_DELIMITER); 
		}
		
		/**
		 * Sound extensions to filter by in browse dialog
		 * 
		 * "*.mp3;*.ogg;*.wav;*.aac"
		 */
		public static function getSupportedSoundFilterExtensions():String
		{
			var supportedSounds:Array = [MP3_FILTER, OGG_FILTER, WAV_FILTER, AAC_FILTER];
			return supportedSounds.join(FILTER_DELIMITER); 
		}
		
		/**
		 * Book extensions to filter by in browse dialog
		 * 
		 * "*.pdf;
		 */
		public static function getSupportedBookFilterExtensions():String
		{
			var supportedBooks:Array = [PDF_FILTER];
			return supportedBooks.join(FILTER_DELIMITER); 
		}
		
		/**
		 * Video extensions to filter by in browse dialog
		 * 
		 * "*.flv"
		 */
		public static function getSupportedVideoFilterExtensions():String
		{
			var supportedVideo:Array = [FLV_FILTER, F4V_FILTER, MP4_FILTER, MOV_FILTER];
			return supportedVideo.join(FILTER_DELIMITER); 
		}
		
		/**
		 * Check image type is supported or not
		 * 
		 * @imageType Type of sound.
		 */
		public static function isSupportedImage(imageType:String):Boolean
		{
			var supportedImages:Array = [JPEG_TYPE, JPG_TYPE, GIF_TYPE, PNG_TYPE, BMP_TYPE];
			return supportedImages.indexOf(imageType) != -1; 
		}
		
		/**
		 * Check sound type is supported or not
		 * 
		 * @soundType Type of sound.
		 */
		public static function isSupportedSound(soundType:String):Boolean
		{
			var supportedSounds:Array = [MP3_TYPE, OGG_TYPE, WAV_TYPE, AAC_TYPE];
			return supportedSounds.indexOf(soundType) != -1; 
		}
		
		/**
		 * Check video type is supported or not
		 * 
		 * @videoType Type of video.
		 */
		public static function isSupportedVideo(videoType:String):Boolean
		{
			var supportedVideo:Array = [FLV_TYPE, F4V_TYPE, MP4_TYPE, MOV_TYPE];
			return supportedVideo.indexOf(videoType) != -1; 
		}
		
		/**
		 *  @private
		 */
		public static function getSupportedImageType(imageData:ByteArray):String
		{
			if(isPng(imageData))
				return PNG_TYPE;
			if(isJpeg(imageData))
				return JPEG_TYPE;
			if(isBmp(imageData))
				return BMP_TYPE;
			if(isGif(imageData) )
				return GIF_TYPE;
			
			return NOT_SUPPORTED_IMAGE_FORMAT;
		}
		
		/**
		 *  @private
		 */
		public static function readablizeBytes(bytes:uint):String {
			var s:Array = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
			var e:Number = Math.floor(Math.log(bytes)/Math.log(1024));
			return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
		}
		
		/**
		 * 
		 * @param length
		 * @param fileType
		 * @return 
		 * 
		 */		
		public static function isAudioFileSizeLong(length:uint, fileType:String):Boolean
		{
			return length > getAudioMaxSizeByFileType(fileType);
		}
		
		/**
		 *  @public
		 */
		public static function getAudioMaxSizeByFileType(fileType:String):int
		{
			switch(fileType)
			{
				case OGG_TYPE:
					return OGG_MAX_FILE_SIZE;
				case MP3_TYPE:
					return MP3_MAX_FILE_SIZE;
				case WAV_TYPE:
					return WAV_MAX_FILE_SIZE;
				case AAC_TYPE:
					return AAC_MAX_FILE_SIZE;
				default:	
					return 0;
			}
		}
		
		/**
		 *  @public
		 */
		public static function getAudioMaxSizeLabelByFileType(fileType:String):String
		{
			switch(fileType)
			{
				case OGG_TYPE:
					return OGG_MAX_FILE_SIZE_LABEL;
				case MP3_TYPE:
					return MP3_MAX_FILE_SIZE_LABEL;
				case WAV_TYPE:
					return WAV_MAX_FILE_SIZE_LABEL;
				case AAC_TYPE:
					return AAC_MAX_FILE_SIZE_LABEL;
				default:	
					return null;
			}
		}
		
		/**
		 * @private 
		 */		
		public static function isOgg(path:String):Boolean
		{
/*			var typePattern:RegExp = new RegExp("\\" + OGG_TYPE + "$", "ig");
			return typePattern.test(path);*/
			return /\.ogg$/ig.test(path);
		}
		
		/**
		 * @private 
		 */		
		public static function isMp3(path:String):Boolean
		{
			return /\.mp3$/ig.test(path);
		}
		
		/**
		 * @private 
		 */		
		public static function isFLV(path:String):Boolean
		{
			return /\.flv$/ig.test(path);
		}
		
		public static function isF4V(path:String):Boolean
		{
			return /\.f4v$/ig.test(path);
		}
		
		public static function isMP4(path:String):Boolean
		{
			return /\.mp4$/ig.test(path);
		}
		
		public static function isMOV(path:String):Boolean
		{
			return /\.mov$/ig.test(path);
		}
		
		public static function isVideo(path:String):Boolean
		{
			if(isFLV(path))
				return true;
			if(isF4V(path))
				return true;
			if(isMP4(path))
				return true;
			if(isMOV(path))
				return true;
			return false;
		}
		
		public static function isPDF(path:String):Boolean
		{
			return /\.pdf$/ig.test(path);
		}
		//--------------------------------------------------------------------------
		//  Private Static
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		private static function isJpeg(bytes:ByteArray):Boolean
		{
			
			if(bytes[0] == 0xFF && bytes[1] == 0xD8 )
				return true;
			return false;
		}
		
		/**
		 *  @private
		 */
		private static function isBmp(bytes:ByteArray):Boolean
		{
			if(bytes[0] == 0x42 && bytes[1] == 0x4D )
				return true;
			return false;
		}
		
		/**
		 *  @private
		 */
		private  static function isPng(bytes:ByteArray):Boolean
		{
			if(bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47)
				return true;
			return false;
		}
		
		/**
		 *  @private
		 */
		private  static function isGif(bytes:ByteArray):Boolean
		{
			if(bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46)
				return true;
			return false;
		}
	}
}