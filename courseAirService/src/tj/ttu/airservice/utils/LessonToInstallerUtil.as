////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.TrimUtil;
	
	[Event(name="installerCreationComplete", type="tj.ttu.airservice.utils.events.UtilEvent")]
	[Event(name="utilError", type="tj.ttu.airservice.utils.events.UtilEvent")]
	/**
	 * LessonToInstallerUtil class 
	 */
	public class LessonToInstallerUtil extends EventDispatcher
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
		 * Name of the lesson xml file
		 */
		private static const LESSON_XML_FILENAME:String = 'lesson.xml';
		
		/**
		 * Name of the unit xml file 
		 */
		private static const UNIT_XML_FILENAME:String = 'unit.xml';
		
		/**
		 * Root path of executables
		 */
		private const PATH_UTIL:String = "utils/";
		
		/**
		 * Root path of executables
		 */
		private const NSIS_PATH:String = "NSIS/";
		
		/**
		 * Root path of executables
		 */
		private const MAKENSIS_PATH:String = "NSIS/makensis.exe";
		public static const START_MENU_GROUP:String ='TTU_Lessons';
		public static const LICENSE_FILE:String ='TTU_LessonPlayer_license.rtf';
		public static const INSTALLER_NSI:String ='installer.nsi';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
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
		 * Executable file to make installer 
		 */		
		private var makensis:File;
		
		/**
		 * State of conversion  
		 */		
		private var isConverting:Boolean;
		
		/**
		 * Native process which runs executable
		 */	
		private var process:NativeProcess
		
		/**
		 *  Mac osx version
		 */
		private var is64:Boolean;
		
		/*
		* All punctuation for separate box
		*/ 
		private var punctuation:RegExp = /([\u0021|\u002C|\u002E|\u003A|\u003F|\u003B|\u060C|\u061F|\u06D4|\u00AB|\u00BB|\u201E|\u201D|\u2026|\u300C|\u300D|\uFE41|\uFE42|\u201C|\u0022|\u00BF|\u0964|\u3001|\u3002|\u30fc|\uff01|\uFF0E])/ig;
		private var numbers:RegExp = /([0-9])/ig;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonToInstallerUtil 
		 */
		public function LessonToInstallerUtil()
		{
			super();
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
		private function get appSourcePath():String
		{
			var applicationStorageDirectory:File = new File(appStorageDirectoryPath);
			var srcDirectory:File = applicationStorageDirectory.resolvePath(lessonHomeDirectory + AssetsUtil.TEMP_PATH + AssetsUtil.INSTALLER_PATH);
			var path:String = srcDirectory.nativePath;
			return path.replace(/\\/g, "/");
		}
		
		/**
		 * The path of the list home directory. i.e.: b4x/42A21919-DA9C-D045-8683-DE19D20D25B7_0
		 */		
		private function get artifactPath():String
		{
			var applicationStorageDirectory:File = new File(appStorageDirectoryPath);
			var artifactDirectory:File = applicationStorageDirectory.resolvePath(lessonHomeDirectory + AssetsUtil.ARTIFACT_PATH);
			if(!artifactDirectory.exists)
				artifactDirectory.createDirectory();
			var path:String = artifactDirectory.nativePath;
			return path.replace(/\\/g, "/");
		}
		
		
		/**
		 * The path of the list home directory. i.e.: b4x/42A21919-DA9C-D045-8683-DE19D20D25B7_0
		 */		
		private function get licenseFilePath():String
		{
			var _licenseFile:File = new File(appDirectoryPath);
			if (isWindows)
				_licenseFile = _licenseFile.resolvePath(PATH_UTIL + NSIS_PATH + LICENSE_FILE);
			
			if(_licenseFile && _licenseFile.exists)
			{
				var path:String = _licenseFile.nativePath;
				return path.replace(/\\/g, "/");
			}
			return null;
		}
		
		/**
		 * The path of the list home directory. i.e.: b4x/42A21919-DA9C-D045-8683-DE19D20D25B7_0
		 */		
		private function get installerNSIPath():String
		{
			var _installerNSI:File = new File(appDirectoryPath);
			if (isWindows)
				_installerNSI = _installerNSI.resolvePath(PATH_UTIL + NSIS_PATH + INSTALLER_NSI);
			
			if(_installerNSI && _installerNSI.exists)
			{
				var path:String = _installerNSI.nativePath;
				return path.replace(/\\/g, "/");
			}
			return null;
		}
		
		/**
		 * Retusn true if os is windows
		 */		
		private function get isWindows():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf( "windows" ) != -1; 			
		}
		
		/**
		 * Retusn true if os is Mac OS
		 */		
		private function get isMac():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf( "mac" ) != -1)
			{
				var ver:Number = parseFloat(Capabilities.os.replace("Mac OS ", ""));
				if(ver >= 10.7) 
					is64 = true;
				return true;
			}
			return false;
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
		 *  @public
		 */
		public function close():void
		{
			AssetsUtil.deleteLessonInstallerContentFromTempFolder( lesson.guid, lesson.version, appStorageDirectoryPath );
			lesson = null;
			languageCode = null;
			lessonStorageDirectory = null;
			appDirectoryPath = null;
			appStorageDirectoryPath = null;
			makensis = null;
			process = null;
			isConverting = false;
		}
		/**
		 *  @private
		 */
		
		/**
		 * Convert a <code>LessonVO</code> object and associated assets into a packaged .b4x file.
		 * Upon completion (after all assets are transcoded and added), an Event.COMPLETE event 
		 * is dispatched.
		 * 
		 * @param lesson					The <code>LessonVO</code> object representing the lesson
		 * @param lessonStorageDirectory		The directory where lists are stored, i.e.: b4x/ or harmoneLists/
		 */
		public function convertLessonToInstaller(lesson:LessonVO, languageCode:String, lessonStorageDirectory:String, appDirectoryPath:String, appStorageDirectoryPath:String):void
		{
			this.lesson 				= lesson;
			this.languageCode			= languageCode;
			this.lessonStorageDirectory	= lessonStorageDirectory;
			this.appDirectoryPath		= appDirectoryPath;
			this.appStorageDirectoryPath= appStorageDirectoryPath;
			
			// add lessonXML and image assets to b4x
			addPlayerToTempFolder();
			addLessonXmlToTempFolder(lesson);
			generateUnitXmlAndCopyToTempFolder();
			copyBackgroundImagesToTempFolder();
			copyLessonAssetsToTempFolder();
		}
		
		
		
		//--------------------------------------------------------------------------
		//  Private
		//--------------------------------------------------------------------------
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
			AssetsUtil.writeXMLToLocalStorage(lesson.guid, lesson.version, ba, LESSON_XML_FILENAME, AssetsUtil.INSTALLER_PATH, appStorageDirectoryPath);
		}
		
		/**
		 * Create b4x.properties file with properties, and add to the to the .b4x container.
		 */
		private function addPlayerToTempFolder():void
		{
			AssetsUtil.copyPlayerToTempFolder( lesson.guid, lesson.version, AssetsUtil.INSTALLER_PATH, appDirectoryPath, appStorageDirectoryPath);
			AssetsUtil.copyFontsToTempFolder( lesson.guid, lesson.version, AssetsUtil.INSTALLER_PATH, appDirectoryPath, appStorageDirectoryPath);
			AssetsUtil.copyModulesToTempFolder( lesson.guid, lesson.version, AssetsUtil.INSTALLER_PATH, appDirectoryPath, appStorageDirectoryPath);
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
			AssetsUtil.writeXMLToLocalStorage(lesson.guid, lesson.version, ba, UNIT_XML_FILENAME, AssetsUtil.INSTALLER_PATH, appStorageDirectoryPath);
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
			AssetsUtil.copyBackgroundImagesToTempFolder( lesson.guid, lesson.version, AssetsUtil.INSTALLER_PATH, appDirectoryPath, appStorageDirectoryPath );
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
			AssetsUtil.copyLessonResourcesToTempFolder( lesson.guid, lesson.version, AssetsUtil.INSTALLER_PATH, appStorageDirectoryPath );
			makeInstaller();
		}
		
		
		
		private function makeInstaller():void
		{
			if(isConverting)
				return;
			
			try
			{
				makensis = getNativeProcessFile();
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = makensis;
				nativeProcessStartupInfo.arguments = getMakensisArgs();
				isConverting = true;
				process = new NativeProcess();
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, 	onProgress);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, 	onProgress);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, 	onProgress);
				process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, onProgress);
				
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardIOError);
				process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, 	onStandardIOError);
				process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, 	onStandardIOError);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardIOError);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, 	onStandardIOError); 
				process.addEventListener(IOErrorEvent.IO_ERROR,					onStandardIOError); 
				process.addEventListener(IOErrorEvent.VERIFY_ERROR, 			onStandardIOError); 
				
				process.addEventListener(Event.STANDARD_ERROR_CLOSE,			onStandardErrorClose); 
				process.addEventListener(Event.STANDARD_INPUT_CLOSE,  			onStandardErrorClose);
				process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, 			onStdOutClose);
				process.start(nativeProcessStartupInfo);
			}
			catch (err:Error)
			{
				detachEvents(process);
				dispatchEvent( new UtilEvent(UtilEvent.UTIL_ERROR, err.toString()));
			}
		}
		
		private function onComplete():void
		{
			var installerPath:String = artifactPath + "/" + lesson.name + ".exe";
			dispatchEvent(new UtilEvent(UtilEvent.INSTALLER_CREATION_COMPLETE, installerPath, true));
		}
		
		
		
		private function getNativeProcessFile():File
		{
			var npFile:File = new File(appDirectoryPath);
			if (isWindows)
				npFile = npFile.resolvePath(PATH_UTIL + MAKENSIS_PATH);
			
			if(npFile && npFile.exists)
			{
				npFile.nativePath = npFile.nativePath.replace(/\\/g, "/");
				return npFile;
			}
			return null;
		}
		
		/**
		 * Sets makensis based on file type
		 */ 
		private function getMakensisArgs():Vector.<String>
		{
			var regKey:String = lesson.name.replace(punctuation, "");
			regKey = TrimUtil.trim(regKey.replace(numbers, ""));
			var args:Vector.<String> = new Vector.<String>();
			args.push("/DStartMenuGroup=" + START_MENU_GROUP);
			args.push("/DAppSrc="+appSourcePath);
			args.push("/DCourseName="+lesson.name);
			args.push("/DRegKeyValue="+regKey);
			args.push("/DExeOut="+artifactPath);
			args.push("/DLicenseFile="+licenseFilePath);
			args.push(installerNSIPath);
			return args;
		}
		
		/**
		 * @private
		 * Remvoe event listeners and kill the process
		 * TODO Find way write into input without closing the process each time
		 */
		private function detachEvents(process:NativeProcess):void
		{
			if(process)
			{
				if (process.running)
					process.exit(true);
				process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, 	onProgress);
				process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, 	onProgress);
				process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, 	onProgress);
				process.removeEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, onProgress);
				process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardIOError);
				process.removeEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, 	onStandardIOError);
				process.removeEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, 	onStandardIOError);
				process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardIOError);
				process.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, 	onStandardIOError); 
				process.removeEventListener(IOErrorEvent.IO_ERROR,					onStandardIOError); 
				process.removeEventListener(IOErrorEvent.VERIFY_ERROR, 			onStandardIOError); 
				
				process.removeEventListener(Event.STANDARD_ERROR_CLOSE,			onStandardErrorClose); 
				process.removeEventListener(Event.STANDARD_INPUT_CLOSE,  			onStandardErrorClose);
				process.removeEventListener(Event.STANDARD_OUTPUT_CLOSE, 			onStdOutClose);
				process = null;
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		
		protected function onProgress(event:ProgressEvent):void
		{
			var str:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			trace(str);
		}
		
		/**
		 * @private
		 */	
		private function onStandardIOError(event:IOErrorEvent):void
		{
			detachEvents(event.target as NativeProcess);
			dispatchEvent( new UtilEvent(UtilEvent.UTIL_ERROR, event.text));
		}
		
		/**
		 * @private
		 */	
		protected function onStandardErrorClose(event:Event):void
		{
			detachEvents(event.target as NativeProcess);
			dispatchEvent( new UtilEvent(UtilEvent.UTIL_ERROR, "NSIS Error"));
		}
		
		/**
		 * @private
		 */	
		
		protected function onStdOutClose(event:Event):void
		{
			detachEvents( event.target as NativeProcess);
			isConverting = false;
			onComplete();
		}
		
	}
}