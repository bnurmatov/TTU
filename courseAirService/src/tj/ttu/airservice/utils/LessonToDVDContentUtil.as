////////////////////////////////////////////////////////////////////////////////
// Copyright May 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.coretypes.LessonVO;
	
	/**
	 * LessonToDVDContentUtil class 
	 */
	public class LessonToDVDContentUtil extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Name of the lesson xml file
		 */
		private static const LESSON_XML_FILENAME:String = 'lesson.xml';
		
		/**
		 * Name of the unit xml file 
		 */
		private static const UNIT_XML_FILENAME:String = 'unit.xml';
		
		/**
		 * Name of the autorun file 
		 */
		private static const AUTORUN_FILENAME:String = 'autorun.inf';
		
		/**
		 * Name of the autorun file 
		 */
		private static const PLAYER_EXE_FILE:String = 'TTULessonPlayer.exe';
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * The path of the lesson storage directory. i.e.: b4x/ or harmoneLists/
		 */
		private var languageCode:String;
		
		/**
		 * The path of the lesson storage directory. i.e.: b4x/ or harmoneLists/
		 */
		private var lessonStorageDirectory:String;
		
		/**
		 * The path of the lesson storage directory. i.e.: b4x/ or harmoneLists/
		 */
		private var appStorageDirectoryPath:String;
		
		/**
		 * The path of the lesson storage directory. i.e.: b4x/ or harmoneLists/
		 */
		private var appDirectoryPath:String;
		
		/**
		 * The lesson we are working with
		 */
		private var lesson:LessonVO;
		
		/**
		 * <code>FZip</code> containing dvd content
		 */
		private var zip:FZip;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonToDVDContentUtil 
		 */
		public function LessonToDVDContentUtil(target:IEventDispatcher=null)
		{
			super(target);
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
		
		/**
		 * The path of the list home directory. i.e.: b4x/42A21919-DA9C-D045-8683-DE19D20D25B7_0
		 */		
		private function get dvdContentDirectory():File
		{
			var dvdContentPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lesson.guid + DatabaseManagerProxy.DELIMITER_VERSION + lesson.version + AssetsUtil.TEMP_PATH + AssetsUtil.DVD_CONTENT_PATH;
			var applicationStorageDirectory:File = new File(appStorageDirectoryPath);
			return applicationStorageDirectory.resolvePath(dvdContentPath);
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
		/**
		 * Convert a <code>LessonVO</code> object and associated assets into a packaged .b4x file.
		 * Upon completion (after all assets are transcoded and added), an Event.COMPLETE event 
		 * is dispatched.
		 * 
		 * @param lesson					The <code>LessonVO</code> object representing the lesson
		 * @param lessonStorageDirectory		The directory where lists are stored, i.e.: b4x/ or harmoneLists/
		 */
		public function convertLessonToDVDContent(lesson:LessonVO, languageCode:String, lessonStorageDirectory:String, appDirectoryPath:String, appStorageDirectoryPath:String):void
		{
			this.lesson 				= lesson;
			this.languageCode			= languageCode;
			this.lessonStorageDirectory	= lessonStorageDirectory;
			this.appDirectoryPath		= appDirectoryPath;
			this.appStorageDirectoryPath= appStorageDirectoryPath;
			
			// add lessonXML and image assets to b4x
			addPlayerToTempFolder();
			addLessonXmlToTempFolder(lesson);
			generateAutorunAndCopyToTempFolder();
			generateUnitXmlAndCopyToTempFolder();
			copyBackgroundImagesToTempFolder();
			copyLessonAssetsToTempFolder();
		}
		
		public function close():void
		{
			AssetsUtil.deleteLessonDvdContentFromTempFolder( lesson.guid, lesson.version, appStorageDirectoryPath);
			lesson = null;
			languageCode = null;
			lessonStorageDirectory = null;
			appDirectoryPath = null;
			appStorageDirectoryPath = null;
		}
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
		/**
		 * Create list.xml file based on the <code>BykiList</code>, and add to the to the .b4x container.
		 * 
		 * @param lesson	The <code>LessonVO</code> object representing the lesson
		 */
		private function addLessonXmlToTempFolder(lesson:LessonVO):void
		{
			var listXml:XML = LessonToXMLUtil.generateLessonXml(lesson);
			var str:String = '<?xml version="1.0" encoding="UTF-8"?>\n';
			str+= listXml.toXMLString();
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes( str );
			ba.position = 0;
			AssetsUtil.writeXMLToLocalStorage(lesson.guid, lesson.version, ba, LESSON_XML_FILENAME, AssetsUtil.DVD_CONTENT_PATH, appStorageDirectoryPath);
		}
		
		/**
		 * Create b4x.properties file with properties, and add to the to the .b4x container.
		 */
		private function addPlayerToTempFolder():void
		{
			AssetsUtil.copyPlayerToTempFolder( lesson.guid, lesson.version, AssetsUtil.DVD_CONTENT_PATH, appDirectoryPath, appStorageDirectoryPath);
			AssetsUtil.copyFontsToTempFolder( lesson.guid, lesson.version, AssetsUtil.DVD_CONTENT_PATH, appDirectoryPath, appStorageDirectoryPath);
			AssetsUtil.copyModulesToTempFolder( lesson.guid, lesson.version, AssetsUtil.DVD_CONTENT_PATH, appDirectoryPath, appStorageDirectoryPath);
		}
		
		
		
		/**
		 * Add assets to our b4x container. Image and sound URLs are taken from each <code>BykiCard</code>.
		 * If no sounds are present, generate the .b4x immediately. If sounds are present, start process
		 * to transcode .mp3 to .ogg.
		 * 
		 * @param bykiList	The <code>BykiList</code> to copy assets from
		 */
		private function generateAutorunAndCopyToTempFolder():void
		{
			var str:String = '[autorun] \r\nopen='+ PLAYER_EXE_FILE +' \r\nicon='+ PLAYER_EXE_FILE +',0';
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes( str );
			ba.position = 0;
			AssetsUtil.writeAutorunFileToLocalStorage(lesson.guid, lesson.version, ba, AUTORUN_FILENAME, appStorageDirectoryPath);
		}
		/**
		 * Add assets to our b4x container. Image and sound URLs are taken from each <code>BykiCard</code>.
		 * If no sounds are present, generate the .b4x immediately. If sounds are present, start process
		 * to transcode .mp3 to .ogg.
		 * 
		 * @param bykiList	The <code>BykiList</code> to copy assets from
		 */
		private function generateUnitXmlAndCopyToTempFolder():void
		{
			var unitXml:XML = UnitUtil.generateUnitXML(lesson.name, languageCode);
			var str:String = '<?xml version="1.0" encoding="UTF-8"?>\n';
			str+= unitXml.toXMLString();
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes( str );
			ba.position = 0;
			AssetsUtil.writeXMLToLocalStorage(lesson.guid, lesson.version, ba, UNIT_XML_FILENAME, AssetsUtil.DVD_CONTENT_PATH, appStorageDirectoryPath);
		}
		
		/**
		 * Add assets to our b4x container. Image and sound URLs are taken from each <code>BykiCard</code>.
		 * If no sounds are present, generate the .b4x immediately. If sounds are present, start process
		 * to transcode .mp3 to .ogg.
		 * 
		 * @param bykiList	The <code>BykiList</code> to copy assets from
		 */
		private function copyBackgroundImagesToTempFolder():void
		{
			AssetsUtil.copyBackgroundImagesToTempFolder( lesson.guid, lesson.version, AssetsUtil.DVD_CONTENT_PATH, appDirectoryPath, appStorageDirectoryPath );
		}
		
		/**
		 * Add assets to our b4x container. Image and sound URLs are taken from each <code>BykiCard</code>.
		 * If no sounds are present, generate the .b4x immediately. If sounds are present, start process
		 * to transcode .mp3 to .ogg.
		 * 
		 * @param bykiList	The <code>BykiList</code> to copy assets from
		 */
		private function copyLessonAssetsToTempFolder():void
		{
			AssetsUtil.copyLessonResourcesToTempFolder( lesson.guid, lesson.version , AssetsUtil.DVD_CONTENT_PATH, appStorageDirectoryPath);
			makeZipFile();
		}
		
		
		
		private function makeZipFile():void
		{
			getFilesRecursive( dvdContentDirectory );
			onComplete();
		}
		
		private function getFilesRecursive(folder:File):void
		{
			var files:Array = [];
			if(folder.exists && folder.isDirectory)
				files = folder.getDirectoryListing();
			//iterate and put files in the result and process the sub folders recursively
			var name:String;
			for each (var sourceFile:File in files)
			{
				if(sourceFile && sourceFile.isDirectory)
				{
					/*if(!zip)
						zip = new FZip();
					var name:String = AssetsUtil.normalizeDvdContentPath( sourceFile.nativePath );
					zip.addFile(name, null, false);*/
					getFilesRecursive(sourceFile);
				}
				else if(sourceFile)
				{
					name = AssetsUtil.normalizeDvdContentPath( sourceFile.nativePath );
					addFileToZip(sourceFile, name);
				}
			}
		}

		
		/**
		 * Add a single file asset to the .b4x container (b4xZip).
		 * 
		 * @param file	The file to add to the .b4x container
		 * @param name	The name (and relative path) to save the url to (i.e.: images/image-001.jpg)
		 */
		private function addFileToZip(file:File, name:String):void
		{
			var bytes:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream(); 
			if(file.exists)
			{
				fileStream.open(file, FileMode.READ); 
				fileStream.readBytes(bytes);
				if(!zip)
					zip = new FZip();
				zip.addFile(name, bytes, false);
				fileStream.close();
			}
		}
		
		private function onComplete():void
		{
			var zipBytes:ByteArray = new ByteArray();
			zip.serialize(zipBytes);
			zipBytes.position = 0;
			zip.close();
			zip = null;
			dispatchEvent(new UtilEvent(UtilEvent.DVD_CONTENT_CREATION_COMPLETE, zipBytes, true));
		}
	}
}