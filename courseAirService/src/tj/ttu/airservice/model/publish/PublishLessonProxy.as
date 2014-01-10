////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.publish
{
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.LessonToB4XUtil;
	import tj.ttu.airservice.utils.LessonToDVDContentUtil;
	import tj.ttu.airservice.utils.LessonToInstallerUtil;
	import tj.ttu.airservice.utils.LessonToPDFUtil;
	import tj.ttu.airservice.utils.PublishLessonWorker;
	import tj.ttu.airservice.utils.Workers;
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
		
		private var publishLessonWorker:Worker;
		private var publishLessonWorkerToMain:MessageChannel;
		private var mainToPublishLessonWorker:MessageChannel;
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
		private var w:PublishLessonWorker;
		public function publishLesson():void
		{
			if(!lesson || !serviceVO)
				return;
			removeArtifactsByLessonUUID(lesson.guid, null, true);
			removeArtifactsByLessonFromLocalStorage(lesson);
			initPublishLessonWorker();
			var settings:Object = {"lesson":lesson, "appStorageDirectory":File.applicationStorageDirectory.nativePath, "appDirectory":File.applicationDirectory.nativePath };
			/*w = new PublishLessonWorker();
			w.sett = settings;*/
			sendMessageToWorker("settings", settings);
			publishFromNextOption();
		}
		
		/**
		 *  @public
		 */
		private function initPublishLessonWorker():void
		{
			publishLessonWorker = WorkerDomain.current.createWorker(Workers.PublishLessonWorker, true);
			publishLessonWorkerToMain = publishLessonWorker.createMessageChannel(Worker.current);
			mainToPublishLessonWorker = Worker.current.createMessageChannel(publishLessonWorker);
			
			publishLessonWorker.setSharedProperty("workerToMain", publishLessonWorkerToMain);
			publishLessonWorker.setSharedProperty("mainToWorker", mainToPublishLessonWorker);
			
			publishLessonWorker.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
			publishLessonWorker.start();
		}
		
		private function sendMessageToWorker(name:String, body:Object = null):void
		{
			if(mainToPublishLessonWorker)
			{
				var message:Object = {"name":name, "body":body};
				mainToPublishLessonWorker.send(message);
			}
		}
		
		/**
		 *  @public
		 */
		private function destroyPublishLessonWorker():void
		{
			sendMessageToWorker("destroy");
			publishLessonWorker.removeEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
			publishLessonWorkerToMain = null;
			mainToPublishLessonWorker = null;
			publishLessonWorker.terminate();
			publishLessonWorker = null;
		}
		
		private function publishFromNextOption():void
		{
			shiftCurrentOption();
			if(!currentOption)
			{
				retrieveArtifactsByLessonUuid(lesson.guid, publishBuildingCompleteNotification);
				return;
			}
			sendMessageToWorker(currentOption.publishType);
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
		
		protected function onWorkerToMain(event:Event):void
		{
			while(publishLessonWorkerToMain.messageAvailable)
			{
				var message:Object = publishLessonWorkerToMain.receive();
				switch(message.name)
				{
					case "pdfCreated":
					case "b4xCreated":
					case "installerCreated":
					case "dvdContentCreated":
					{
						addNewArtifact( message.body as LessonArtifactVO, null, true);
						publishFromNextOption();
						break;
					}
					case "error":
					{
						sendNotification(TTUConstants.SHOW_ERROR_WINDOW, message.body);	
						break;
					}
					case "trace":
					{
						trace("",message.body);	
						break;
					}
				}
			}
		}
	}
}