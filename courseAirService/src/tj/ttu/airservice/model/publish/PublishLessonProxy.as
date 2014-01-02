////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.publish
{
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.LessonToB4XUtil;
	import tj.ttu.airservice.utils.LessonToDVDContentUtil;
	import tj.ttu.airservice.utils.LessonToInstallerUtil;
	import tj.ttu.airservice.utils.LessonToPDFUtil;
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.LessonArtifactVO;
	import tj.ttu.base.vo.PublishOptionVO;
	import tj.ttu.courseservice.model.vo.PublishServiceVO;
	
	/**
	 * PublishLessonProxy class 
	 */
	public class PublishLessonProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'PublishLessonProxy';
		public static const LESSON_STORAGE_DIRECTORY:String = "Lessons/";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		public var currentArtifacts:Array;
		public var currentArtifact:LessonArtifactVO;
		/**
		 * The current PublishServiceVO that is being worked with
		 */
		public var lesson:LessonVO;
		
		/**
		 * The current PublishServiceVO that is being worked with
		 */
		public var serviceVO:PublishServiceVO;
		
		public var currentOption:PublishOptionVO;
		
		/**
		 * The index of our current working PublishOption
		 */
		private var currentPublishOptionIndex:int;
		
		public var publishBuildingCompleteNotification:String;
		
		private var b4xUtil:LessonToB4XUtil;
		
		private var installerUtil:LessonToInstallerUtil;
		
		private var dvdContentUtil:LessonToDVDContentUtil;
		private var pdfUtil:LessonToPDFUtil;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * PublishLessonProxy 
		 */
		public function PublishLessonProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  publishOptions
		//--------------------------------------------------------------------------
		private var _publishOptions:Array;
		
		public function get publishOptions():Array
		{
			return _publishOptions;
		}
		
		public function set publishOptions(value:Array):void
		{
			if(_publishOptions != value)
			{
				_publishOptions = value;
				currentPublishOptionIndex = _publishOptions ? _publishOptions.length : -1;
			}
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
		public function cleanUp():void
		{
			currentPublishOptionIndex = 0;
			publishOptions = null;
			serviceVO = null;
			currentArtifacts = null;
			currentArtifact = null;
			publishBuildingCompleteNotification = null;
		}
		/**
		 * Shift to the next <code>ChapterVO</code> in array of current chapters.
		 */
		public function shiftCurrentOption():void
		{
			currentOption = publishOptions ? publishOptions[--currentPublishOptionIndex] : null;
		}
		
		public function publishLesson():void
		{
			if(!lesson || !serviceVO)
				return;
			removeArtifactsByLessonUUID(lesson.guid, null, true);
			removeArtifactsByLessonFromLocalStorage(lesson);
			publishFromNextOption();
		}
		
		private function publishFromNextOption():void
		{
			shiftCurrentOption();
			if(!currentOption)
			{
				retrieveArtifactsByLessonUuid(lesson.guid, publishBuildingCompleteNotification);
				//sendNotification(publishBuildingCompleteNotification);
				return;
			}
			
			switch(currentOption.publishType)
			{
				case PublishOptionVO.PDF:
				{
					generatePDF();
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
			}
		}
		
		private function generateB4X():void
		{
			if(!b4xUtil)
			{
				b4xUtil = new LessonToB4XUtil();
				b4xUtil.addEventListener(UtilEvent.B4X_CREATION_COMPLETE, onB4XCreationComplete);
			}
			b4xUtil.convertLessonToB4x(lesson, LESSON_STORAGE_DIRECTORY);
		}
		
		private function generatePDF():void
		{
			if(!pdfUtil)
			{
				pdfUtil = new LessonToPDFUtil();
				pdfUtil.addEventListener(Event.COMPLETE, onPdfCreationComplete);
			}
			pdfUtil.setFonts( "ENGLISH", "RUSSIAN" );
			pdfUtil.convertToPDF(lesson);
		}
		
		protected function onPdfCreationComplete(event:Event):void
		{
			var pdfBytes:ByteArray = pdfUtil.result;
			var fileName:String = lesson.name + "_" + new Date().time + ".pdf";
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorage(lesson.guid, lesson.version, pdfBytes, fileName);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.PDF;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			addNewArtifact( artifact, null, true);
			publishFromNextOption();
			pdfUtil.removeEventListener(Event.COMPLETE, onPdfCreationComplete);
			pdfUtil = null;
		}
		
		private function generateDVDContent():void
		{
			if(!dvdContentUtil)
			{
				dvdContentUtil = new LessonToDVDContentUtil();
				dvdContentUtil.addEventListener(UtilEvent.DVD_CONTENT_CREATION_COMPLETE, onDvdContentCreationComplete);
				dvdContentUtil.addEventListener(UtilEvent.UTIL_ERROR, onDvdContentCreationError);
			}
			dvdContentUtil.convertLessonToDVDContent(lesson, LESSON_STORAGE_DIRECTORY, serviceVO.languageCode);
		}
		
		private function removeDVDContentUtil():void
		{
			if(dvdContentUtil)
			{
				dvdContentUtil.removeEventListener(UtilEvent.INSTALLER_CREATION_COMPLETE, onInstallerCreationComplete);
				dvdContentUtil.removeEventListener(UtilEvent.UTIL_ERROR, onInstallerCreationError);
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
			installerUtil.convertLessonToInstaller(lesson, LESSON_STORAGE_DIRECTORY, serviceVO.languageCode);
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
		/**
		 * Retrieves any artifacts that belong to the 'current' lesson.
		 * 
		 */
		public function retrieveArtifactsByLessonUuid(lessonUuid:String, completionNotification:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.GET_ARTIFACT_BY_LESSON_UUID_SQL;
			statement.parameters[":lessonUuid"] = lessonUuid;
			statement.itemClass = LessonArtifactVO;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 *  @public
		 */
		public function addNewArtifact(artifact:LessonArtifactVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			createArtifact( artifact, completionNotification, isTransaction );
		}
		
		/**
		 *  @public
		 */
		public function removeArtifactsByLessonUUID(lessonUUID:String, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.REMOVE_ARTIFACTS_BY_LESSON_UUID_SQL_KEY );
			
			statement.parameters[':lessonUuid'] 			= lessonUUID;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 *  @public
		 */
		public function removeArtifactsByLessonFromLocalStorage(lesson:LessonVO):void
		{
			if(!lesson)
				return;
			AssetsUtil.deleteLessonArtifactsFromLocalStorage( lesson.guid, lesson.version );
		}
		
		/**
		 *  @public
		 */
		public function removeExistingArtifact(artifact:LessonArtifactVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			currentArtifact = artifact;
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			deleteArtifact( artifact );
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 *  @public
		 */
		public function createArtifact(artifact:LessonArtifactVO, completionNotification:String, isTransaction:Boolean = true):void
		{
			
			currentArtifact 		= artifact;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			insertArtifact(artifact);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Insert a new artifact into the database.
		 * 
		 * @param artifact 	The <code>LessonArtifactVO</code> object representing the LessonArtifactVO to insert
		 */
		private function insertArtifact(artifact:LessonArtifactVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_ARTIFACT_SQL_KEY);
			
			statement.parameters[':lesson_uuid']		= artifact.lessonUuid;
			statement.parameters[':artifact_url']		= AssetsUtil.normalizeArtifactPath(artifact.url);
			statement.parameters[':artifact_type']		= artifact.artifactType;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * 
		 * Remove the resource
		 * 
		 * @param artifact The <code>LessonArtifactVO</code> object representing the artifact to remove
		 */
		
		private function deleteArtifact(artifact:LessonArtifactVO):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.REMOVE_ARTIFACT_SQL_KEY );
			
			statement.parameters[':id'] 			= artifact.id;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onB4XCreationComplete(event:UtilEvent):void
		{
			if(b4xUtil)
			{
				b4xUtil.removeEventListener(UtilEvent.B4X_CREATION_COMPLETE, onB4XCreationComplete);
				b4xUtil.close();
				b4xUtil = null;
			}
			var b4xBytes:ByteArray = event.data as ByteArray;
			var fileName:String = lesson.name + "_" + new Date().time + SupportedMediaFormat.B4X_TYPE;
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorage(lesson.guid, lesson.version, b4xBytes, fileName);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.B4X_CONTENT;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			addNewArtifact( artifact, null, true);
			publishFromNextOption();
		}
		
		protected function onInstallerCreationComplete(event:UtilEvent):void
		{
			removeInstallerUtil();
			var installerPath:String = event.data as String;
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.WINDOWS_INSTALLER;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= installerPath;
			addNewArtifact( artifact, null, true);
			publishFromNextOption();
		}		
		
		protected function onInstallerCreationError(event:UtilEvent):void
		{
			removeInstallerUtil();
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, event.data);
		}		
		
		protected function onDvdContentCreationComplete(event:UtilEvent):void
		{
			removeDVDContentUtil();
			var b4xBytes:ByteArray = event.data as ByteArray;
			var fileName:String = lesson.name + "_" + new Date().time + ".zip";
			var fileUrl:String = AssetsUtil.writeB4XToLocalStorage(lesson.guid, lesson.version, b4xBytes, fileName);
			var artifact:LessonArtifactVO = new LessonArtifactVO();
			artifact.artifactType 	= LessonArtifactVO.DVD_CONTENT;
			artifact.lessonUuid 	= lesson.guid;
			artifact.url 			= fileUrl;
			addNewArtifact( artifact, null, true);
			publishFromNextOption();
		}
		
		protected function onDvdContentCreationError(event:UtilEvent):void
		{
			removeDVDContentUtil();
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, event.data);
		}
		
	}
}