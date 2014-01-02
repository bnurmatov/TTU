////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 11, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.convertor
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * SoundConvertorProxy class 
	 */
	public class SoundConvertorProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Root path of executables
		 */
		private const PATH_UTIL:String = "utils/";
		public static const NAME:String = 'SoundConverterproxy';
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Executable file to convert sounds 
		 */		
		private var ffmpeg:File;
		
		/**
		 * State of conversion  
		 */		
		private var isConverting:Boolean;
		
		/**
		 * Holds List of sounds which need to be converted 
		 */		
		private var fileStack:Vector.<SoundItem>;
		
		/**
		 * Number of the sound files waiting for conversion 
		 */	
		private var fileCount:uint;
		
		/**
		 *Current sound file whic is under conversion
		 */	
		private var currFile:SoundItem;
		
		/**
		 * Native process which runs executable
		 */	
		private var process:NativeProcess
		/**
		 * Native process which runs executable
		 */	
		private var completerNote:INotification;
		
		/**
		 *  Mac osx version
		 */
		private var is64:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SoundConvertorProxy 
		 */
		public function SoundConvertorProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
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
		/**
		 * On register
		 */
		override public function onRegister():void
		{
			super.onRegister();
			ffmpeg = getNativeProcessFile();
			if(!ffmpeg)
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, "Can not find executable for ffmpeg");
			
		}
		
		/**
		 * On remove
		 */
		override public function onRemove():void
		{
			ffmpeg = null;
			detachEvents(process);
			fileStack = null;
			currFile = null;
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
		 * Convert audio file in srcPath to destPath, asynchronously. NativeProcess does not support
		 * blocking (synchronous) methods. 
		 * 
		 * 	Note:	For some reason, FFmpeg is only writing to STDERR and not STDOUT. This is why
		 * 			the logic for handling a successful event is in the error handler.
		 * 
		 * FFmpeg Flags:
		 * 		-i		Path to the source file
		 * 		-ar		Audio sampling frequency (44100)
		 * 		-ab		Audio bitrate (160)
		 * 		-ac		Audio channel (set to mono)
		 * 		-y		Overwrite output files
		 */		
		public function convert(srcPath:String, destPath:String = null, completerNote:INotification=null):void
		{
			if(srcPath)
				srcPath = srcPath.replace(/\\/g, "/");
			if(destPath)
				destPath = destPath.replace(/\\/g, "/");
			if(completerNote)
				this.completerNote = completerNote;
			
			if(isConverting && fileStack)
			{	
				fileStack.push(new SoundItem(srcPath, destPath));
				fileCount = fileStack.length;
				return;
			}
			
			
			try
			{
				
				currFile = new SoundItem(srcPath, destPath);
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = ffmpeg;
				nativeProcessStartupInfo.arguments = getFfmpegArgs(currFile.srcPath, currFile.destPath);;
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
				sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, err.toString());
			}
			
		}
		/**
		 *  @private
		 */
		
		private function deleteFile(srcPath:String):void
		{
			if(!isOgg(srcPath) && !isMp3(srcPath))
			{
				var file:File = File.applicationStorageDirectory.resolvePath(srcPath);
				if(file.exists)
					file.deleteFile();
			}
		}		
		
		/**
		 * Gets ffmpeg file
		 */
		private function getNativeProcessFile():File
		{
			var npFile:File = File.applicationDirectory;
			if (isWindows)
				npFile = npFile.resolvePath(PATH_UTIL + "Windows/bin/ffmpeg.exe");
			else if(isMac)
				npFile = is64 ? npFile.resolvePath(PATH_UTIL + "MacOS/64bit/bin/ffmpeg") :npFile.resolvePath(PATH_UTIL + "MacOS/32bit/bin/ffmpeg");
			else
				npFile = null;
			
			if(npFile && npFile.exists)
			{
				return npFile;
			}
			return null;
		}
		
		/**
		 * Sets ffarguments based on file type
		 */ 
		private function getFfmpegArgs(srcPath:String, destPath:String):Vector.<String>
		{
			var args:Vector.<String> = new Vector.<String>();
			args.push("-i", srcPath);
			if(isOgg(destPath))
			{
				args.push("-ar", "22050");
				args.push("-aq", "32k");
				args.push("-acodec", "libvorbis");
				args.push("-ac", "1");
			}
			else
			{	
				args.push("-ar", "44100");
				args.push("-ab", "160");
				args.push("-ac", "2");
			}
			args.push("-y",  destPath);
			return args;
		}
		
		/**
		 * @private 
		 */		
		private function isOgg(path:String):Boolean
		{
			return /\.ogg$/ig.test(path);
		}
		
		/**
		 * @private 
		 */		
		private function isMp3(path:String):Boolean
		{
			return /\.mp3$/ig.test(path);
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
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		/**
		 * @private
		 */
		
		protected function onProgress(event:ProgressEvent):void
		{
			//			trace(event.toString());
			
		}
		
		/**
		 * @private
		 */	
		private function onStandardIOError(event:IOErrorEvent):void
		{
			//detachEvents(event.target as NativeProcess);
			sendNotification(CourseServiceNotification.SHOW_ERROR_WINDOW, event.text);
			if( process.standardOutput &&  process.standardOutput.bytesAvailable > 0)
			{
				var str:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable); 
				//				trace(str);
			}
		}
		
		/**
		 * @private
		 */	
		protected function onStandardErrorClose(event:Event):void
		{
			//trace(event.toString());
		}
		
		/**
		 * @private
		 */	
		
		protected function onStdOutClose(event:Event):void
		{
			detachEvents( event.target as NativeProcess);
			isConverting = false;
			
			if(currFile)
			{
				deleteFile(currFile.srcPath);
				var oggFile:File = File.applicationStorageDirectory.resolvePath(currFile.destPath.replace(/\.mp3$/ig, ".ogg"));
				if(!oggFile.exists)
				{
					convert(currFile.destPath, oggFile.nativePath);
					return;					
				}
			}
			
			if(fileStack && fileStack.length > 0)
			{
				var cf:SoundItem = fileStack.shift();
				convert(cf.srcPath, cf.destPath);
			}
			else
			{
				if(completerNote)
				{
					sendNotification(completerNote.getName(),completerNote.getBody() );
					completerNote = null;
				}
			}
		}
		
		
		
	}
}

class SoundItem
{
	public var srcPath:String;
	public var destPath:String;
	public function SoundItem(srcPath:String, destPath:String)
	{
		this.srcPath = srcPath;
		this.destPath = destPath;
	}
}