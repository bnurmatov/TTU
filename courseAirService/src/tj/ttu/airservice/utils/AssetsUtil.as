////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.IList;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.LessonArtifactVO;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	
	/**
	 * AssetsUtil class 
	 */
	public class AssetsUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Relative path to sounds
		 */
		public static const SOUND_PATH:String = "/sounds/";
		
		/**
		 * Relative path to video
		 */
		public static const VIDEO_PATH:String = "/video/";
		
		/**
		 * Relative path to images
		 */
		public static const IMAGE_PATH:String = "/images/";
		
		/**
		 * Relative path to resources
		 */
		public static const RESOURCE_PATH:String = "/resources/";
		
		/**
		 * Relative path to resources
		 */
		public static const ARTIFACT_PATH:String = "/artifacts/";
		
		/**
		 * Relative path to resources
		 */
		public static const TEMP_PATH:String = "/_TEMP/";
		
		/**
		 * Relative path to resources
		 */
		public static const INSTALLER_PATH:String = "/installer/";
		
		/**
		 * Relative path to resources
		 */
		public static const DVD_CONTENT_PATH:String = "/dvd_content/";
		
		/**
		 * Relative path to resources
		 */
		public static const CONTENT_PATH:String = "/content/";
		
		/**
		 * Relative path to resources
		 */
		public static const PLAYER_PATH:String = "utils/LessonPlayer/";
		
		/**
		 * Relative path to resources
		 */
		public static const ASSETS_PATH:String = "assets/";
		
		/**
		 * Relative path to resources
		 */
		public static const BACKGROUND_IMAGES_PATH:String = "backgroundImages/";
		
		/**
		 * Relative path to resources
		 */
		public static const FONTS_PATH:String = "fonts/";
		
		/**
		 * Relative path to resources
		 */
		public static const MODULES_PATH:String = "modules/";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AssetsUtil 
		 */
		public function AssetsUtil()
		{
		}
		
		
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
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyPlayerToTempFolder(lessonUuid:String, lessonVersion:uint, folderName:String):void
		{
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + folderName;
			
			var sourceDirectory:File = File.applicationDirectory.resolvePath(PLAYER_PATH);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationListPath + "/" + sourceFile.name);
				sourceFile.copyTo(destinationFile, true);
			}
		}
		/**
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyBackgroundImagesToTempFolder(lessonUuid:String, lessonVersion:uint, folderName:String):void
		{
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + folderName + CONTENT_PATH + BACKGROUND_IMAGES_PATH;
			
			var sourceDirectory:File = File.applicationDirectory.resolvePath(ASSETS_PATH + BACKGROUND_IMAGES_PATH);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationListPath + "/" + sourceFile.name);
				sourceFile.copyTo(destinationFile, true);
			}
		}
		
		/**
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyLessonResourcesToTempFolder(lessonUuid:String, lessonVersion:uint, folderName:String):void
		{
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + folderName + CONTENT_PATH;
			var sourcePath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			
			var sourceDirectory:File = File.applicationStorageDirectory.resolvePath(sourcePath);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var fileName:String = "/" + FileNameUtil.getFileName( sourceFile.url ) + "/";
				if(fileName != ARTIFACT_PATH && fileName != TEMP_PATH )
				{
					var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationListPath + "/" + sourceFile.name);
					sourceFile.copyTo(destinationFile, true);
				}
			}
		}
		
		/**
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyFontsToTempFolder(lessonUuid:String, lessonVersion:uint, folderName:String):void
		{
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + folderName;
			
			var sourceDirectory:File = File.applicationDirectory.resolvePath(FONTS_PATH);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationListPath + "/" + FONTS_PATH + sourceFile.name);
				sourceFile.copyTo(destinationFile, true);
			}
		}
		
		/**
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyModulesToTempFolder(lessonUuid:String, lessonVersion:uint, folderName:String):void
		{
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + folderName;
			
			var sourceDirectory:File = File.applicationDirectory.resolvePath(MODULES_PATH);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationListPath + "/" + MODULES_PATH + sourceFile.name);
				sourceFile.copyTo(destinationFile, true);
			}
		}
		
		/**
		 * Copy lesson assets for a clone of a local lesson. Copy from the draft storage location
		 * to the draft storage location.
		 * 
		 * @param sourceUuid			UUID of the source lesson
		 * @param sourceVersion			Version of the source lesson
		 * @param destinationUuid		UUID of the destination lesson
		 * @param destinationVersion	Version of the destination lesson
		 */
		public static function copyLocalLessonAssets(sourceUuid:String, sourceVersion:uint, destinationUuid:String, destinationVersion:uint):void
		{
			var sourceListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + sourceUuid + DatabaseManagerProxy.DELIMITER_VERSION + sourceVersion;
			var destinationListPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + destinationUuid + DatabaseManagerProxy.DELIMITER_VERSION + destinationVersion;
			
			copyLessonAssets(sourceListPath, destinationListPath);
		}
		
		/**
		 * Copy sound and image assets from one list folder to another.
		 * 
		 * @param sourceDirectoryPath			The directory path to copy from 	i.e.: /b4x/{uuid}/sounds
		 * @param destinationDirectoryPath		The directory path to copy to 		i.e.: /harmoneLists/{uuid}/sounds
		 */
		private static function copyLessonAssets(sourcePath:String, destinationPath:String):void
		{
			copyDirectoryFiles(sourcePath + SOUND_PATH, destinationPath + SOUND_PATH);
			copyDirectoryFiles(sourcePath + IMAGE_PATH, destinationPath + IMAGE_PATH);
			copyDirectoryFiles(sourcePath + VIDEO_PATH, destinationPath + VIDEO_PATH);
			copyDirectoryFiles(sourcePath + RESOURCE_PATH, destinationPath + RESOURCE_PATH);
		}
		
		/**
		 * Copy all files in the source directory to the destination directory. Maintain file names,
		 * and do not copy recursively.
		 * 
		 * @param sourceDirectoryPath			The directory path to copy from
		 * @param destinationDirectoryPath		The directory path to copy to
		 */
		private static function copyDirectoryFiles(sourcePath:String, destinationPath:String):void
		{
			var sourceDirectory:File = File.applicationStorageDirectory.resolvePath(sourcePath);
			
			// get all files in directory
			var files:Array = [];
			if(sourceDirectory.exists && sourceDirectory.isDirectory)
				files = sourceDirectory.getDirectoryListing();
			
			// copy each file
			for each (var sourceFile:File in files)
			{
				var destinationFile:File = File.applicationStorageDirectory.resolvePath(destinationPath + "/" + sourceFile.name);
				sourceFile.copyTo(destinationFile, true);
			}
		}
		/**
		 * Write a sound file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param soundBytes		The bytes contain sound data.
		 * @param fileName			Sound name.
		 */
		public static function writeSoundToLocalStorage(lessonUuid:String, lessonVersion:uint, soundBytes:ByteArray, fileName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var soundFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + SOUND_PATH + fileName);
			writeToLocalStorage(soundFile, soundBytes);
			return soundFile.url;
		}
		/**
		 * Write a b4x file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param b4xBytes		The bytes contain b4x data.
		 * @param fileName			b4x name.
		 */
		public static function writeB4XToLocalStorage(lessonUuid:String, lessonVersion:uint, b4xBytes:ByteArray, fileName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var b4xFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + ARTIFACT_PATH + fileName);
			writeToLocalStorage(b4xFile, b4xBytes);
			return b4xFile.url;
		}
		
		/**
		 * Write a b4x file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param b4xBytes		The bytes contain b4x data.
		 * @param fileName			b4x name.
		 */
		public static function writeXMLToLocalStorage(lessonUuid:String, lessonVersion:uint, b4xBytes:ByteArray, fileName:String, folderName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var b4xFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + TEMP_PATH + folderName + CONTENT_PATH + fileName);
			writeToLocalStorage(b4xFile, b4xBytes);
			return b4xFile.url;
		}
		
		/**
		 * Write a b4x file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param b4xBytes		The bytes contain b4x data.
		 * @param fileName			b4x name.
		 */
		public static function writeAutorunFileToLocalStorage(lessonUuid:String, lessonVersion:uint, b4xBytes:ByteArray, fileName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var autorunFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + TEMP_PATH + DVD_CONTENT_PATH + fileName);
			writeToLocalStorage(autorunFile, b4xBytes);
			return autorunFile.url;
		}
		
		/**
		 * Write a video file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param soundBytes		The bytes contain sound data.
		 * @param fileName			Video name.
		 */
		public static function writeVideoToLocalStorage(lessonUuid:String, lessonVersion:uint, videoBytes:ByteArray, fileName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var videoFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + VIDEO_PATH + fileName);
			writeToLocalStorage(videoFile, videoBytes);
			return videoFile.url;
		}
		
		/**
		 * Write a resource file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param resourceBytes		The bytes contain resource data.
		 * @param fileName			Resource name.
		 */
		public static function writeResourceToLocalStorage(lessonUuid:String, lessonVersion:uint, resourceBytes:ByteArray, fileName:String):String
		{
			var lessonPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var resourceFile:File = File.applicationStorageDirectory.resolvePath(lessonPath + RESOURCE_PATH + fileName);
			writeToLocalStorage(resourceFile, resourceBytes);
			return resourceFile.url;
		}
		
		/**
		 * Write an image file to the local storage.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param imageBytes		The bytes contain image data.
		 * @param fileName			Image name.
		 */
		public static function writeImageToLocalStorage(lessonUuid:String, lessonVersion:uint, imageBytes:ByteArray, fileName:String):String
		{
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var imageFile:File = File.applicationStorageDirectory.resolvePath(listPath + IMAGE_PATH + fileName);
			writeToLocalStorage(imageFile, imageBytes);
			return imageFile.url;
		}
		
		
		/**
		 * Write a file to the local storage.
		 * 
		 * @param file		The file to write to local storage.
		 * @param bytes	    The bytes contain the file data.
		 */
		private static function writeToLocalStorage(file:File, bytes:ByteArray):void
		{
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.WRITE); 
			fileStream.writeBytes(bytes);
			fileStream.close();
		}
		
		/**
		 * Remove all assets associated with UUID and version.
		 * 
		 * @param lessonUuid		UUID of the lesson to delete
		 * @param lessonVersion	Version of the lesson to delete
		 */
		public static function deleteLessonAssetsFromLocalStorage(lessonUuid:String, lessonVersion:uint):void
		{
			var lessonStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var listDirectory:File = File.applicationStorageDirectory.resolvePath(lessonStorageDirectory); 
			if(listDirectory.exists)
				listDirectory.deleteDirectory(true);
		}
		
		/**
		 * Remove all assets associated with UUID and version.
		 * 
		 * @param lessonUuid		UUID of the lesson to delete
		 * @param lessonVersion	Version of the lesson to delete
		 */
		public static function deleteLessonArtifactsFromLocalStorage(lessonUuid:String, lessonVersion:uint):void
		{
			var artifactDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + ARTIFACT_PATH;
			var directory:File = File.applicationStorageDirectory.resolvePath(artifactDirectory); 
			if(directory.exists)
				directory.deleteDirectory(true);
		}
		/**
		 * Remove all assets associated with UUID and version.
		 * 
		 * @param lessonUuid		UUID of the lesson to delete
		 * @param lessonVersion	Version of the lesson to delete
		 */
		public static function deleteLessonInstallerContentFromTempFolder(lessonUuid:String, lessonVersion:uint):void
		{
			var installerContentDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + INSTALLER_PATH;
			var directory:File = File.applicationStorageDirectory.resolvePath(installerContentDirectory); 
			if(directory.exists)
				directory.deleteDirectory(true);
		}
		/**
		 * Remove all assets associated with UUID and version.
		 * 
		 * @param lessonUuid		UUID of the lesson to delete
		 * @param lessonVersion	Version of the lesson to delete
		 */
		public static function deleteLessonDvdContentFromTempFolder(lessonUuid:String, lessonVersion:uint):void
		{
			var dvdContentDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion + TEMP_PATH + DVD_CONTENT_PATH;
			var directory:File = File.applicationStorageDirectory.resolvePath(dvdContentDirectory); 
			if(directory.exists)
				directory.deleteDirectory(true);
		}
		
		/**
		 * Delete an image file from the local storage.
		 * 
		 * @param lessonUuid			UUID of the lessson
		 * @param lessonVersion		Version of the lessson
		 * @param fileName			Image name.
		 */
		public static function deleteImageFromLocalStorage(lessonUuid:String, lessonVersion:uint, fileName:String):void
		{
			if(!fileName)
				return;
			
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var imageFile:File = File.applicationStorageDirectory.resolvePath(listPath + IMAGE_PATH + fileName);
			if(imageFile.exists)
				imageFile.deleteFile();
		}
		
		/**
		 * Delete a sound file from the local storage.
		 * 
		 * @param lessonUuid			UUID of the lessson
		 * @param lessonVersion		Version of the lessson
		 * @param fileName			Sound name.
		 */
		public static function deleteSoundFromLocalStorage(lessonUuid:String, lessonVersion:uint, fileName:String, isCleanupOgg:Boolean = true ):void
		{
			if(!fileName)
				return;
			
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var soundFile:File = File.applicationStorageDirectory.resolvePath(listPath + SOUND_PATH + fileName);
			if(soundFile.exists)
				soundFile.deleteFile();
			
			if(isCleanupOgg)
			{
				var oggSoundFile:File = File.applicationStorageDirectory.resolvePath(listPath + SOUND_PATH + fileName.replace(/\.mp3$/ig, ".ogg"));
				if(oggSoundFile.exists)
					oggSoundFile.deleteFile();
			}
		}
		
		/**
		 * Delete a video file from the local storage.
		 * 
		 * @param lessonUuid			UUID of the lessson
		 * @param lessonVersion		Version of the lessson
		 * @param fileName			Video name.
		 */
		public static function deleteVideoFromLocalStorage(lessonUuid:String, lessonVersion:uint, fileName:String):void
		{
			if(!fileName)
				return;
			
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var videoFile:File = File.applicationStorageDirectory.resolvePath(listPath +  VIDEO_PATH + fileName);
			if(videoFile.exists)
				videoFile.deleteFile();
		}
		/**
		 * Delete a resource file from the local storage.
		 * 
		 * @param lessonUuid			UUID of the lessson
		 * @param lessonVersion		Version of the lessson
		 * @param fileName			resource name.
		 */
		public static function deleteResourceFromLocalStorage(lessonUuid:String, lessonVersion:uint, fileName:String):void
		{
			if(!fileName)
				return;
			
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var resourceFile:File = File.applicationStorageDirectory.resolvePath(listPath +  RESOURCE_PATH + fileName);
			if(resourceFile.exists)
				resourceFile.deleteFile();
		}
		
		/**
		 * Creates a new image File object.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param fileName			Image name.
		 */
		public static function resolveImage(lessonUuid:String, lessonVersion:uint, fileName:String):File
		{
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			return File.applicationStorageDirectory.resolvePath(listPath + IMAGE_PATH + fileName);
		}
		
		/**
		 * Creates a new sound File object.
		 * 
		 * @param lessonUuid			UUID of the lesson
		 * @param lessonVersion		Version of the lesson
		 * @param fileName			Sound name.
		 */
		public static function resolveSound(lessonUuid:String, lessonVersion:uint, fileName:String):File
		{
			var listPath:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			return File.applicationStorageDirectory.resolvePath(listPath + SOUND_PATH + fileName);
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lesson				LessonVO 
		 * @return 						Returns the lesson
		 */
		public static function prependRootPathForLesson(lesson:LessonVO):LessonVO
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lesson.guid + DatabaseManagerProxy.DELIMITER_VERSION + lesson.version;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var image:ImageVO in lesson.aboutCreatorImages)
			{
				if(image && !StringUtil.isNullOrEmpty(image.imageUrl))
					image.imageUrl = rootPath + image.imageUrl;
			}
			return lesson;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param artifacts					LessonArtifactVO 
		 * @return 						Returns the artifacts
		 */
		public static function prependRootPathForArtifacts(lessonUuid:String, lessonVersion:int, artifacts:Array):Array
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var artifact:LessonArtifactVO in artifacts)
			{
				if(artifact && !StringUtil.isNullOrEmpty(artifact.url) && artifact.url.indexOf(rootPath) == -1)
					artifact.url = rootPath + artifact.url;
			}
			return artifacts;
		}
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param images					LessonVO 
		 * @return 						Returns the images
		 */
		public static function prependRootPathForImages(lessonUuid:String, lessonVersion:int, images:IList):IList
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var image:ImageVO in images)
			{
				if(image && !StringUtil.isNullOrEmpty(image.imageUrl) && image.imageUrl.indexOf(rootPath) == -1)
					image.imageUrl = rootPath + image.imageUrl;
			}
			return images;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param images					LessonVO 
		 * @return 						Returns the images
		 */
		public static function prependRootPathForSounds(lessonUuid:String, lessonVersion:int, sounds:IList):IList
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var sound:SoundVO in sounds)
			{
				if(sound && !StringUtil.isNullOrEmpty(sound.soundUrl)  && sound.soundUrl.indexOf(rootPath) == -1)
					sound.soundUrl = rootPath + sound.soundUrl;
			}
			return sounds;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param images					LessonVO 
		 * @return 						    Returns the video list
		 */
		public static function prependRootPathForVideoList(lessonUuid:String, lessonVersion:int, videoList:IList):IList
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var video:VideoVO in videoList)
			{
				if(video && !StringUtil.isNullOrEmpty(video.videoUrl)  && video.videoUrl.indexOf(rootPath) == -1)
					video.videoUrl = rootPath + video.videoUrl;
			}
			return videoList;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param resources					ResourceVO 
		 * @return 						    Returns the resource list
		 */
		public static function prependRootPathForResourceList(lessonUuid:String, lessonVersion:int, resources:Array):Array
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			for each(var resource:ResourceVO in resources)
			{
				if(resource && !StringUtil.isNullOrEmpty(resource.resourcePath)  && resource.resourcePath.indexOf(rootPath) == -1)
					resource.resourcePath = rootPath + resource.resourcePath;
			}
			return resources;
		}
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lessonUuid				LessonVO 
		 * @param lessonVersion				LessonVO 
		 * @param resource					ResourceVO 
		 * @return 						    Returns the resource
		 */
		public static function prependRootPathForSingleResource(lessonUuid:String, lessonVersion:int, resource:ResourceVO):ResourceVO
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			
			if(resource && !StringUtil.isNullOrEmpty(resource.resourcePath)  && resource.resourcePath.indexOf(rootPath) == -1)
				resource.resourcePath = rootPath + resource.resourcePath;
			return resource;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lesson				LessonVO 
		 * @return 						Returns the lesson
		 */
		public static function prependRootPathForSingleImage(lessonUuid:String, lessonVersion:int, image:ImageVO):ImageVO
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			if(image && !StringUtil.isNullOrEmpty( image.imageUrl ) && image.imageUrl.indexOf(rootPath) == -1)
				image.imageUrl = rootPath + image.imageUrl;
			return image;
		}
		
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lesson				LessonVO 
		 * @return 						Returns the lesson
		 */
		public static function prependRootPathForSingleSound(lessonUuid:String, lessonVersion:int, sound:SoundVO):SoundVO
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			if(sound && !StringUtil.isNullOrEmpty(sound.soundUrl) && sound.soundUrl.indexOf(rootPath) == -1)
				sound.soundUrl = rootPath + sound.soundUrl;
			return sound;
		}
		/**
		 * Prepend the root path to each asset url within lesson.
		 *
		 * @param lesson				LessonVO 
		 * @return 						Returns the lesson
		 */
		public static function prependRootPathForSingleVideo(lessonUuid:String, lessonVersion:int, video:VideoVO):VideoVO
		{
			var listStorageDirectory:String = DatabaseManagerProxy.LOCAL_LESSONS_PATH + lessonUuid + DatabaseManagerProxy.DELIMITER_VERSION + lessonVersion;
			var rootPath:String = File.applicationStorageDirectory.resolvePath(listStorageDirectory).url;
			if(video && !StringUtil.isNullOrEmpty(video.videoUrl) && video.videoUrl.indexOf(rootPath) == -1)
				video.videoUrl = rootPath + video.videoUrl;
			return video;
		}
		
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the sound
		 */
		public static function normalizeSoundPath(fullPath:String):String
		{
			if(fullPath && fullPath.indexOf(SOUND_PATH) != 0)
				return SOUND_PATH + FileNameUtil.getFileName(fullPath);
			
			return fullPath;
		}
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the video
		 */
		public static function normalizeVideoPath(fullPath:String):String
		{
			if(fullPath && fullPath.indexOf(VIDEO_PATH) != 0)
				return VIDEO_PATH + FileNameUtil.getFileName(fullPath);
			
			return fullPath;
		}
		
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the sound
		 */
		public static function normalizeImagePath(fullPath:String):String
		{
			if(fullPath && fullPath.indexOf(IMAGE_PATH) != 0)
				return IMAGE_PATH + FileNameUtil.getFileName(fullPath);
			
			return fullPath;
		}
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the artifact
		 */
		public static function normalizeArtifactPath(fullPath:String):String
		{
			if(fullPath && fullPath.indexOf(ARTIFACT_PATH) != 0)
				return ARTIFACT_PATH + FileNameUtil.getFileName(fullPath);
			
			return fullPath;
		}
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the artifact
		 */
		public static function normalizeDvdContentPath(fullPath:String):String
		{
			if(fullPath)
			{
				fullPath = fullPath.replace(/\\/g, "/");
				var start:int = fullPath.indexOf(DVD_CONTENT_PATH);
				if(start != -1)
				return fullPath.substr(start + DVD_CONTENT_PATH.length);
			}
			
			return fullPath;
		}
		/**
		 * Convert a single URL
		 * 
		 * @param fullPath	The full path to the resource
		 */
		public static function normalizeResourcePath(fullPath:String):String
		{
			if(fullPath && fullPath.indexOf(RESOURCE_PATH) != 0)
				return RESOURCE_PATH + FileNameUtil.getFileName(fullPath);
			
			return fullPath;
		}
	}
}