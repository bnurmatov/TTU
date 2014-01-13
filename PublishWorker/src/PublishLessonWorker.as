////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 6, 2014, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.System;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.LessonToB4XUtil;
	import tj.ttu.airservice.utils.LessonToDVDContentUtil;
	import tj.ttu.airservice.utils.LessonToInstallerUtil;
	import tj.ttu.airservice.utils.LessonToPDFUtil;
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.LanguageInfoUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.LessonArtifactVO;
	import tj.ttu.base.vo.PublishOptionVO;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	
	/**
	 * PublishLessonWorker class 
	 */
	public class PublishLessonWorker extends Sprite
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const LESSON_STORAGE_DIRECTORY:String = "Lessons/";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var workerToMain:MessageChannel;
		private var mainToWorker:MessageChannel;
		
		private var b4xUtil:LessonToB4XUtil;
		
		private var installerUtil:LessonToInstallerUtil;
		
		private var dvdContentUtil:LessonToDVDContentUtil;
		private var pdfUtil:LessonToPDFUtil;
		private var lesson:LessonVO;
		private var appStorageDirectory:String;
		private var appDirectory:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * PublishLessonWorker 
		 */
		public function PublishLessonWorker()
		{
			super();
			registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
			registerClassAlias("tj.ttu.base.coretypes.LessonVO", LessonVO);
			registerClassAlias("tj.ttu.base.coretypes.ChapterVO", ChapterVO);
			registerClassAlias("tj.ttu.base.vo.ImageVO", ImageVO);
			registerClassAlias("tj.ttu.base.vo.SoundVO", SoundVO);
			registerClassAlias("tj.ttu.base.vo.VideoVO", VideoVO);
			registerClassAlias("tj.ttu.base.vo.ResourceVO", ResourceVO);
			registerClassAlias("tj.ttu.base.vo.QuestionVo", QuestionVo);
			registerClassAlias("tj.ttu.base.vo.AnswerVo", AnswerVo);
			registerClassAlias("tj.ttu.base.vo.LessonArtifactVO", LessonArtifactVO);
			workerToMain = Worker.current.getSharedProperty("workerToMain");
			mainToWorker = Worker.current.getSharedProperty("mainToWorker");
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
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
		private function destroy():void
		{
			mainToWorker.removeEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
			mainToWorker = null;
			workerToMain = null;
			try
			{
				System.gc();
			} 
			catch(error:Error){}
		}
		
		private function sendMessageToMainThread(name:String, body:Object = null):void
		{
			if(workerToMain)
			{
				var message:Object = {"name":name, "body":body};
				workerToMain.send(message);
			}
		}
		
		private function generatePDF(resourceStrings:Object):void
		{
			if(!pdfUtil)
			{
				pdfUtil = new LessonToPDFUtil();
				pdfUtil.addEventListener(Event.COMPLETE, onPdfCreationComplete);
			}
			pdfUtil.setFonts(appDirectory);
			pdfUtil.convertToPDF(lesson, resourceStrings);
		}
		
		private function generateDVDContent():void
		{
			if(!dvdContentUtil)
			{
				dvdContentUtil = new LessonToDVDContentUtil();
				dvdContentUtil.addEventListener(UtilEvent.DVD_CONTENT_CREATION_COMPLETE, onDvdContentCreationComplete);
				dvdContentUtil.addEventListener(UtilEvent.UTIL_ERROR, onDvdContentCreationError);
			}
			var lang:String = LanguageInfoUtil.getInstance().getLanguageCode(lesson.locale);
			dvdContentUtil.convertLessonToDVDContent(lesson,  lang, LESSON_STORAGE_DIRECTORY, appDirectory, appStorageDirectory);
		}
		
		private function removeDVDContentUtil():void
		{
			if(dvdContentUtil)
			{
				dvdContentUtil.removeEventListener(UtilEvent.DVD_CONTENT_CREATION_COMPLETE, onDvdContentCreationComplete);
				dvdContentUtil.removeEventListener(UtilEvent.UTIL_ERROR, onDvdContentCreationError);
				dvdContentUtil.close();
				dvdContentUtil = null;
			}
		}
		
		
		private function generateInstaller():void
		{
			if(!installerUtil)
			{
				installerUtil = new LessonToInstallerUtil();
				installerUtil.addEventListener(UtilEvent.INSTALLER_CREATION_COMPLETE, onInstallerCreationComplete);
				installerUtil.addEventListener(UtilEvent.UTIL_ERROR, onInstallerCreationError);
			}
			var lang:String = LanguageInfoUtil.getInstance().getLanguageCode(lesson.locale);
			installerUtil.convertLessonToInstaller(lesson,  lang, LESSON_STORAGE_DIRECTORY, appDirectory, appStorageDirectory);
		}
		
		private function removeInstallerUtil():void
		{
			if(installerUtil)
			{
				installerUtil.removeEventListener(UtilEvent.INSTALLER_CREATION_COMPLETE, onInstallerCreationComplete);
				installerUtil.removeEventListener(UtilEvent.UTIL_ERROR, onInstallerCreationError);
				installerUtil.close();
				installerUtil = null;
			}
		}
		
		private function generateB4X():void
		{
			if(!b4xUtil)
			{
				b4xUtil = new LessonToB4XUtil();
				b4xUtil.addEventListener(UtilEvent.B4X_CREATION_COMPLETE, onB4XCreationComplete);
			}
			
			b4xUtil.convertLessonToB4x(lesson, appStorageDirectory, LESSON_STORAGE_DIRECTORY);
		}
		
		//--------------------------------------------------------------------------
		//
		// Event Handler Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		
		protected function onMainToBack(event:Event):void
		{
			while(mainToWorker.messageAvailable)
			{
				var message:Object = mainToWorker.receive();
				switch(message.name)
				{
					case "settings":
					{
						appStorageDirectory = message.body.appStorageDirectory;
						appDirectory = message.body.appDirectory;
						lesson = message.body.lesson as LessonVO;
						replaceResourcesPath();
						break;
					}
					case PublishOptionVO.PDF:
					{
						generatePDF(message.body);
						break;
					}
					case PublishOptionVO.B4X_CONTENT:
					{
						generateB4X();
						break;
					}
					case PublishOptionVO.DVD_CONTENT:
					{
						generateDVDContent();
						break;
					}
					case PublishOptionVO.WINDOWS_INSTALLER:
					{
						generateInstaller();
						break;
					}
					case "destroy":
					{
						destroy();
						break;
					}
						
				}
			}
		}	
		
		private function replaceResourcesPath():void
		{
			if(!lesson)
				return;
			if(lesson.sound)
				lesson.sound.soundUrl = replaceAppStorageToNativePath(lesson.sound.soundUrl);
			for each(var item:ImageVO in lesson.aboutCreatorImages)
			{
				item.imageUrl = replaceAppStorageToNativePath(item.imageUrl);
			}
			
			for each(var chapter:ChapterVO in lesson.chapters)
			{
				for each(var image:ImageVO in chapter.images)
				{
					image.imageUrl = replaceAppStorageToNativePath(image.imageUrl);
				}
				for each(var sound:SoundVO in chapter.sounds)
				{
					sound.soundUrl = replaceAppStorageToNativePath(sound.soundUrl);
				}
				for each(var video:VideoVO in chapter.videoList)
				{
					video.videoUrl = replaceAppStorageToNativePath(video.videoUrl);
				}
			}
			
			for each(var resource:ResourceVO in lesson.resources)
			{
				resource.resourcePath = replaceAppStorageToNativePath(resource.resourcePath);
			}
		}
		
		private function replaceAppStorageToNativePath(fullPath:String):String
		{
			if(!fullPath)
				return null;
			return fullPath.replace("app-storage:", appStorageDirectory);
		}
		
		protected function onPdfCreationComplete(event:Event):void
		{
			var pdfBytes:ByteArray = pdfUtil.result;
			var fileName:String = lesson.name + "_" + lesson.guid + ".pdf";
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorageFromWorker(lesson.guid, lesson.version, pdfBytes, fileName, appStorageDirectory);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.PDF;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			sendMessageToMainThread("pdfCreated", artifact);
			pdfUtil.removeEventListener(Event.COMPLETE, onPdfCreationComplete);
			pdfUtil = null;
		}	
		
		protected function onDvdContentCreationComplete(event:UtilEvent):void
		{
			removeDVDContentUtil();
			var b4xBytes:ByteArray = event.data as ByteArray;
			var fileName:String = lesson.name + "_" + lesson.guid + ".zip";
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorageFromWorker(lesson.guid, lesson.version, b4xBytes, fileName, appStorageDirectory);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.DVD_CONTENT;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			sendMessageToMainThread("dvdContentCreated", artifact);
		}
		
		protected function onDvdContentCreationError(event:UtilEvent):void
		{
			removeDVDContentUtil();
			sendMessageToMainThread("error", event.data);
		}
		
		protected function onInstallerCreationComplete(event:UtilEvent):void
		{
			removeInstallerUtil();
			var installerPath:String = event.data as String;
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.WINDOWS_INSTALLER;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= installerPath;
			sendMessageToMainThread("installerCreated", artifact);
		}		
		
		protected function onInstallerCreationError(event:UtilEvent):void
		{
			removeInstallerUtil();
			sendMessageToMainThread("error", event.data);
		}	
		
		protected function onB4XCreationComplete(event:UtilEvent):void
		{
			if(b4xUtil)
			{
				b4xUtil.removeEventListener(UtilEvent.B4X_CREATION_COMPLETE, onB4XCreationComplete);
				b4xUtil.close();
				b4xUtil = null;
			}
			var b4xBytes:ByteArray = event.data as ByteArray;
			var fileName:String = lesson.name + "_" + lesson.guid + SupportedMediaFormat.B4X_TYPE;
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorageFromWorker(lesson.guid, lesson.version, b4xBytes, fileName, appStorageDirectory);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.B4X_CONTENT;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			sendMessageToMainThread("b4xCreated", artifact);
		}
	}
}