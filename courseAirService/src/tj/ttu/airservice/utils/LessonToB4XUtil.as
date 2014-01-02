////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 17, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import deng.fzip.FZip;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.utils.ByteArray;
	
	import mx.collections.IList;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.airservice.model.convertor.SoundConvertorProxy;
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	
	[Event(name="b4xCreationComplete", type="tj.ttu.airservice.utils.events.UtilEvent")]
	/**
	 * LessonToB4XUtil class 
	 */
	public class LessonToB4XUtil extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
		/**
		 * Name of the xml file within .b4x container
		 */
		private static const LESSON_XML_FILENAME:String = 'lesson.xml';
		
		/**
		 * Name of the properties file within .b4x container
		 */
		private static const B4X_PROPERTIES_FILENAME:String = 'b4x.properties';
		
		/**
		 * Relative path to sounds in .b4x container
		 */
		private static const SOUND_PATH:String = "sounds/";
		
		/**
		 * Relative path to images in .b4x container
		 */
		private static const IMAGE_PATH:String = "images/";
		
		/**
		 * Relative path to video in .b4x container
		 */
		private static const VIDEO_PATH:String = "video/";
		
		/**
		 * Relative path to resources in .b4x container
		 */
		private static const RESOURCE_PATH:String = "resources/";
		
		/**
		 * Format of the date
		 * 
		 * M - Month in year.
		 * d - Day of the month.
		 * y - Year.
		 * H - Hour of the day in a 24-hour format [0 - 23].
		 * m - Minute of the hour [0 - 59].
		 * s - Seconds in the minute [0 - 59].
		 * S - Milliseconds.
		 * for more detail http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3//flash/globalization/DateTimeFormatter.html
		 */
		private static const DEFAULT_DATE_FORMAT:String = "MM/dd/yyyy HH:mm:ss";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * <code>FZip</code> containing b4x
		 */
		private var b4xZip:FZip;
		
		/**
		 * The path of the lesson storage directory. i.e.: b4x/ or harmoneLists/
		 */
		private var lessonStorageDirectory:String;
		
		/**
		 * The lesson we are working with
		 */
		private var lesson:LessonVO;
		/**
		 * Array of sound file paths after transcoding to .ogg
		 */
		private var transcodedSoundPaths:Array;
		private var transcodedNameSoundPaths:Array;
		
		/**
		 * @private
		 */
		private var isCleanupOggs:Boolean = false;
		private var soundConverter:SoundConvertorProxy;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonToB4XUtil 
		 */
		public function LessonToB4XUtil()
		{
			super();
			//this.soundConverter = soundConverter;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * The path of the list home directory. i.e.: b4x/42A21919-DA9C-D045-8683-DE19D20D25B7_0
		 */		
		private function get lessonHomeDirectory():String
		{
			if(lesson)
				return lessonStorageDirectory + lesson.guid  + DatabaseManagerProxy.DELIMITER_VERSION + lesson.version;
			
			return lessonStorageDirectory;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function close():void
		{
			soundConverter = null;
			b4xZip = null;
			lesson = null;
			transcodedSoundPaths = null;
		}
		/**
		 * Convert a <code>LessonVO</code> object and associated assets into a packaged .b4x file.
		 * Upon completion (after all assets are transcoded and added), an Event.COMPLETE event 
		 * is dispatched.
		 * 
		 * @param lesson					The <code>LessonVO</code> object representing the lesson
		 * @param lessonStorageDirectory		The directory where lists are stored, i.e.: b4x/ or harmoneLists/
		 */
		public function convertLessonToB4x(lesson:LessonVO, lessonStorageDirectory:String, isCleanupOggs:Boolean = true):void
		{
			this.isCleanupOggs 			= isCleanupOggs;
			this.lesson 				= lesson;
			this.lessonStorageDirectory	= lessonStorageDirectory;
			
			//CardUtil.removeRootPaths(bykiList.cards, SOUND_PATH, IMAGE_PATH);
			// initialize zip
			b4xZip = new FZip();
			// add properties file to b4x
			addB4xPropertiesToB4x();
			// add lessonXML and image assets to b4x
			addLessonXmlToB4x(lesson);
			calculateAndAddAssetsToB4x(lesson);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  Private
		//--------------------------------------------------------------------------
		/**
		 * Create list.xml file based on the <code>BykiList</code>, and add to the to the .b4x container.
		 * 
		 * @param lesson	The <code>LessonVO</code> object representing the lesson
		 */
		private function addLessonXmlToB4x(lesson:LessonVO):void
		{
			var listXml:XML = LessonToXMLUtil.generateLessonXml(lesson);
			if(b4xZip)
			{
				var str:String = '<?xml version="1.0" encoding="UTF-8"?>\n';
				str+= listXml.toXMLString();
				b4xZip.addFileFromString(LESSON_XML_FILENAME, str);
			}
		}
		
		/**
		 * Create b4x.properties file with properties, and add to the to the .b4x container.
		 */
		private function addB4xPropertiesToB4x():void
		{
			var properties:String = "";
			properties += addProperty("Version", "1.0");
			properties += addProperty("Creator", getAppNameWithVersionNumber());
			properties += addProperty("Created", currentDate());
			if(b4xZip)
				b4xZip.addFileFromString(B4X_PROPERTIES_FILENAME, properties);
		}
		
		/**
		 * Get application name and version number from description xml.
		 *  
		 * @return Application name with version number
		 */		
		private function getAppNameWithVersionNumber():String
		{
			return ApplicationInfoUtil.name + " (" + ApplicationInfoUtil.versionNumber + ")";
		}
		
		/**
		 * Current date with specific format.
		 *  
		 * @return Formatted current date.
		 */		
		private function currentDate():String
		{
			var formatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
			formatter.setDateTimePattern(DEFAULT_DATE_FORMAT);
			return formatter.format(new Date());
		}
		
		/**
		 * Create new string with key and value.
		 * 
		 * @param key	
		 * @param value	
		 * @param nl	
		 * @return 		New string with key, value and new line.
		 */		
		private function addProperty(key:String, value:String, nl:String = "\r\n"):String
		{
			return key + " = " + value + nl;
		}
		
		/**
		 * Add assets to our b4x container. Image and sound URLs are taken from each <code>BykiCard</code>.
		 * If no sounds are present, generate the .b4x immediately. If sounds are present, start process
		 * to transcode .mp3 to .ogg.
		 * 
		 * @param bykiList	The <code>BykiList</code> to copy assets from
		 */
		private function calculateAndAddAssetsToB4x(lesson:LessonVO):void
		{
			// gather all asset URLs from cards
			var imagePaths:Array = [];
			var soundPaths:Array = [];
			var videoPaths:Array = [];
			var resourcePaths:Array = [];
			
			if(lesson.sound)
				soundPaths.push(lessonHomeDirectory + AssetsUtil.normalizeSoundPath(lesson.sound.soundUrl));
			
			imagePaths = imagePaths.concat( calculateImages(lesson.aboutCreatorImages));
			
			for each(var chapter:ChapterVO in lesson.chapters)
			{
				if(chapter)
				{
					imagePaths = imagePaths.concat( calculateImages(chapter.images));
					soundPaths = soundPaths.concat( calculateSounds(chapter.sounds));
					videoPaths = videoPaths.concat( calculateVideo(chapter.videoList));
				}
			}
			
			for each(var resource:ResourceVO in lesson.resources)
			{
				if(resource && resource.resouceType == ResourceVO.BOOK)
					resourcePaths.push(lessonHomeDirectory + "/" + AssetsUtil.normalizeResourcePath(resource.resourcePath));
			}
			
			
			// add image assets to b4x
			addImagesToB4x(imagePaths, IMAGE_PATH);
			addSoundsToB4x(soundPaths, SOUND_PATH);
			addVideoToB4x(videoPaths, VIDEO_PATH);
			addResourcesToB4x(resourcePaths, RESOURCE_PATH);
			onComplete();
		}
		
		
		
		private function calculateImages(images:IList):Array
		{
			var imagePaths:Array = [];
			for each(var image:ImageVO in images)
			{
				if(image)
					imagePaths.push(lessonHomeDirectory + "/" + AssetsUtil.normalizeImagePath(image.imageUrl));
			}
			return imagePaths;
		}
		
		private function calculateSounds(sounds:IList):Array
		{
			var soundPaths:Array = [];
			for each(var sound:SoundVO in sounds)
			{
				if(sound)
					soundPaths.push(lessonHomeDirectory + "/" + AssetsUtil.normalizeSoundPath(sound.soundUrl));
			}
			return soundPaths;
		}
		
		private function calculateVideo(videoList:IList):Array
		{
			var videoPaths:Array = [];
			for each(var video:VideoVO in videoList)
			{
				if(video)
					videoPaths.push(lessonHomeDirectory + "/" + AssetsUtil.normalizeVideoPath(video.videoUrl));
			}
			return videoPaths;
		}
		
		/**
		 * Add all image paths in array to the .b4x container.
		 * 
		 * @param imagePaths			Array of image URLs that need to be added to .b4x
		 * @param relativeFolderPath	What relative path to write the assets to
		 */
		private function addImagesToB4x(imagePaths:Array, relativeFolderPath:String):void
		{
			var imageFile:File;
			for each(var assetPath:String in imagePaths)
			{
				imageFile = File.applicationStorageDirectory.resolvePath(assetPath);
				if(imageFile.exists)
					addAssetToB4x(imageFile, relativeFolderPath + imageFile.name);
			}
		}
		
		/**
		 * Add all sound paths in array to the .b4x container.
		 * 
		 * @param soundPaths			Array of sound URLs that need to be added to .b4x
		 * @param relativeFolderPath	What relative path to write the assets to
		 */
		private function addSoundsToB4x(soundPaths:Array, relativeFolderPath:String):void
		{
			var mp3SoundFile:File;
			var oggSoundFile:File;
			for each(var assetPath:String in soundPaths)
			{
				mp3SoundFile = File.applicationStorageDirectory.resolvePath(assetPath);
				if(mp3SoundFile.exists)
					addAssetToB4x(mp3SoundFile, relativeFolderPath + mp3SoundFile.name);
				assetPath = assetPath.replace(/\.mp3$/ig, ".ogg");
				oggSoundFile = File.applicationStorageDirectory.resolvePath(assetPath);
				if(oggSoundFile.exists)
					addAssetToB4x(oggSoundFile, relativeFolderPath + oggSoundFile.name);
			}
		}
		
		/**
		 * Add all video paths in array to the .b4x container.
		 * 
		 * @param videoPaths			Array of video URLs that need to be added to .b4x
		 * @param relativeFolderPath	What relative path to write the assets to
		 */
		private function addVideoToB4x(videoPaths:Array, relativeFolderPath:String):void
		{
			var videoFile:File;
			for each(var assetPath:String in videoPaths)
			{
				videoFile = File.applicationStorageDirectory.resolvePath(assetPath);
				if(videoFile.exists)
					addAssetToB4x(videoFile, relativeFolderPath + videoFile.name);
			}
		}
		/**
		 * Add all resource paths in array to the .b4x container.
		 * 
		 * @param resourcePaths			Array of resource URLs that need to be added to .b4x
		 * @param relativeFolderPath	What relative path to write the assets to
		 */
		private function addResourcesToB4x(resourcePaths:Array, relativeFolderPath:String):void
		{
			var resourceFile:File;
			for each(var assetPath:String in resourcePaths)
			{
				resourceFile = File.applicationStorageDirectory.resolvePath(assetPath);
				if(resourceFile.exists)
					addAssetToB4x(resourceFile, relativeFolderPath + resourceFile.name);
			}
		}
		
		/**
		 * Write a zip file to the local storage.
		 * 
		 * @param file		The file to write to local storage.
		 * @param b4XBytes	The bytes contain .b4x data.
		 */
		private function writeB4xToLocalStorage(file:File, b4XBytes:ByteArray):void
		{
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.WRITE); 
			fileStream.writeBytes(b4XBytes);
			fileStream.close();
		}
		
		/**
		 * Add a single file asset to the .b4x container (b4xZip).
		 * 
		 * @param file	The file to add to the .b4x container
		 * @param name	The name (and relative path) to save the url to (i.e.: images/image-001.jpg)
		 */
		private function addAssetToB4x(file:File, name:String):void
		{
			var bytes:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream(); 
			if(file.exists)
			{
				fileStream.open(file, FileMode.READ); 
				fileStream.readBytes(bytes);
				if(b4xZip)
					b4xZip.addFile(name, bytes, false);
				fileStream.close();
			}
		}
		
		
		private function onComplete():void
		{
			var b4xBytes:ByteArray = new ByteArray();
			b4xZip.serialize(b4xBytes);
			b4xBytes.position = 0;
			b4xZip.close();
			b4xZip = null;
			dispatchEvent(new UtilEvent(UtilEvent.B4X_CREATION_COMPLETE, b4xBytes, true));
		}
	}
}