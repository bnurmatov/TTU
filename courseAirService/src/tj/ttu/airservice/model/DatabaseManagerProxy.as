////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 21, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.common.RegisterAirCommand;
	import tj.ttu.airservice.controller.common.RemoveAirCommand;
	import tj.ttu.airservice.model.chapter.ChapterAdapterProxy;
	import tj.ttu.airservice.model.convertor.SoundConvertorProxy;
	import tj.ttu.airservice.model.image.ImageAdapterProxy;
	import tj.ttu.airservice.model.lesson.LessonAdapterProxy;
	import tj.ttu.airservice.model.question.QuestionAdapterProxy;
	import tj.ttu.airservice.model.resource.ResourceAdapterProxy;
	import tj.ttu.airservice.model.sound.SoundAdapterProxy;
	import tj.ttu.airservice.model.user.UserAdapterProxy;
	import tj.ttu.airservice.model.video.VideoAdapterProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.ApplicationInfoUtil;
	import tj.ttu.airservice.utils.StatementUtil;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * DatabaseManagerProxy class 
	 */
	public class DatabaseManagerProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'DatabaseManagerProxy';
		
		/**
		 * Relative path within application storage
		 */
		public static const LOCAL_LESSONS_PATH:String = "Lessons/";
		
		/**
		 * Relative path within application storage
		 */
		public static const DELIMITER_VERSION:String = "_";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 * <code>File</code> reference for database.
		 */
		private var dbFile:File;
		
		/**
		 * @private
		 * Flag to determine if previous database exists.
		 */
		private var dbExists:Boolean;
		
		/**
		 * Flag determining db connectivity.
		 */
		private var isDisconnect:Boolean = false;
		/**
		 * <code>SQLConnection</code> used to connect to the database.
		 */
		private var connection:SQLConnection;
		/**
		 * State of the loader. Since loader does not have any property 
		 * which indicates if it is loading or not, 
		 * we need to keep track of its state 
		 */
		protected var isLoading:Boolean = false;
		/**
		 * Request stack
		 */
		protected var requestStack:Array;
		/**
		 * Collection of <code>SQLStatement</code> objects, used by library.
		 */
		protected var sqlStatements:Array;
		
		/**
		 * Flag determining whether to commit or rollback.
		 */
		private var isSQLError:Boolean;
		
		/**
		 * Name of next notification to be sent on load complete.
		 */	
		public var nextNoteName:String;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * DatabaseManagerProxy 
		 */
		public function DatabaseManagerProxy()
		{
			super(NAME);
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * we currently only have a single user system 
		 */		
		private var _userId:uint = 1;
		
		/**
		 * Current user ID. Always set to 1 currently, since its a single user system.
		 */
		public function get userId():uint
		{
			return _userId;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
			
			//
			
			//init air commands
			facade.registerCommand(CourseAirConstants.REGISTER_AIR_COMMAND, RegisterAirCommand);
			facade.registerCommand(CourseAirConstants.REMOVE_AIR_COMMAND, RemoveAirCommand);
			facade.registerProxy( new LessonAdapterProxy());
			facade.registerProxy( new ChapterAdapterProxy());
			facade.registerProxy( new SoundConvertorProxy());
			facade.registerProxy( new ImageAdapterProxy());
			facade.registerProxy( new SoundAdapterProxy());
			facade.registerProxy( new VideoAdapterProxy());
			facade.registerProxy( new QuestionAdapterProxy());
			facade.registerProxy( new ResourceAdapterProxy());
			facade.registerProxy( new UserAdapterProxy());
			sendNotification(CourseAirConstants.REGISTER_AIR_COMMAND);
			
			// get database name from description xml
			var dbPath:String = ApplicationInfoUtil.id;
			
			// create our File object - storage @ C:\Users\<username>\AppData\Roaming\<databaseName>\Local Store
			dbFile = File.applicationStorageDirectory.resolvePath( dbPath );
			// set flag now, since openAsync() will create file if it does not already exist
			dbExists = dbFile.exists;	
			
			//init statements
			sqlStatements = StatementUtil.initSqlStatements();
			
			//init request stack
			requestStack = [];
			
			// create connection
			connection = new SQLConnection();
			connection.addEventListener( SQLEvent.OPEN, onConnectionOpen );
			connection.addEventListener( SQLErrorEvent.ERROR, onConnectionOpenError );
			connection.addEventListener( SQLEvent.CLOSE, onConnectionClose );
			isDisconnect = false;
			
			// check if we need to send note to create database
			if(!dbExists)
				sendNotification(CourseAirConstants.CREATE_DB_SCHEMA, dbFile);
			else
				sendNotification(CourseAirConstants.UPDATE_DB_SCHEMA);
			
		}
		
		override public function onRemove():void
		{
			sendNotification(CourseAirConstants.REMOVE_AIR_COMMAND);
			facade.removeCommand(CourseAirConstants.REGISTER_AIR_COMMAND);
			facade.removeCommand(CourseAirConstants.REMOVE_AIR_COMMAND);
			facade.removeProxy(LessonAdapterProxy.NAME);
			facade.removeProxy(ChapterAdapterProxy.NAME);
			facade.removeProxy(SoundConvertorProxy.NAME);
			facade.removeProxy(ImageAdapterProxy.NAME);
			facade.removeProxy(SoundAdapterProxy.NAME);
			facade.removeProxy(VideoAdapterProxy.NAME);
			facade.removeProxy(QuestionAdapterProxy.NAME);
			facade.removeProxy(ResourceAdapterProxy.NAME);
			facade.removeProxy(UserAdapterProxy.NAME);
			
			removeSQLStatements();
			connection.close();
			isLoading = false;
			requestStack = null;
			connection = null;
			dbFile = null;
			sqlStatements = null;
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
		//--------------------------------------------------------------------------
		//  Public
		//--------------------------------------------------------------------------
		/**
		 * Fetch <code>SQLConnection</code> object from collection by key.
		 * 
		 * @param <code>key</code> String ID of the desired <code>SQLConnection</code>.
		 * @return <code>SQLConnection</code> object determined by the <code>key</code>.
		 */
		public function getSQLStatement( key:String ) : SQLStatement
		{
			if( sqlStatements )
			{
				var statement:SQLStatement = sqlStatements[ key ] as SQLStatement;
				statement.clearParameters();	// just in case old params are around
				return statement;
			}
			
			return null;
		}
		
		public function get conn():SQLConnection
		{
			if(!isDisconnect && !connection.connected)
				connection.open(dbFile);
			return connection;
			
		}
		
		/**
		 * @private
		 */		
		public function disconnect():void
		{
			if(connection && connection.connected)
			{
				connection.cancel();
				connection.close();
			}
			
			isDisconnect = true;
		}
		
		/**
		 * Execute a request. Save the next note name, for sending upon 
		 * successful completion. For transactions, call <code>beginTransaction()</code>,
		 * execute requests, then call <code>endTransaction()</code>.
		 * 
		 * @param <code>RequestVo</code> Request to be executed.
		 */
		public function executeRequest(request:AirRequestVO):void
		{
			if(isDisconnect)
				return;
			if(!connection.connected)
				connection.open(dbFile);
			
			// if busy, add to queue
			if(isLoading && requestStack)
			{	
				requestStack.push(request);
				return;
			}
			
			// save the next note to send upon completion
			nextNoteName = request.nextNote;
			
			// get statement and connection, then execute
			var statement:SQLStatement = request.statement;
			statement.sqlConnection = connection;
			isLoading = true;
			statement.execute( -1, new Responder( onExecuteComplete, onExecuteError ) );
		}
		
		/**
		 * Used for executing multiple statements. <code>endTransaction()</code> should be 
		 * called after executions, to close transaction.
		 * 
		 * @param <code>Array</code> Array of <code>RequestVo</code> objects to be executed.
		 * @param <code>transactionCompleteNote</code> Notification to be sent upon a 
		 * successful transaction completion.
		 */
		public function beginTransaction():void
		{
			if(isDisconnect)
				return;
			
			if(!connection.connected)
				connection.open(dbFile);
			
			// set error flag, and begin transaction
			isSQLError = false;
			connection.begin();
		}
		
		/**
		 * Used for executing multiple statements. <code>beginTransaction()</code> should be 
		 * called initially, before executions. Upon failure of an execution, the 
		 * <code>isSQLError</code> flag is set, and a rollback will occur.
		 * 
		 * @param <code>transactionCompleteNote</code> Notification to be sent upon a 
		 * successful transaction completion, if needed.
		 */
		public function endTransaction(transactionCompleteNote:String = null):void
		{
			if(isDisconnect)
				return;
			
			// save our next note for transaction completion, and rollback or commit
			nextNoteName = transactionCompleteNote;
			if(isSQLError)
				connection.rollback(new Responder(onRollbackSuccess, onRollbackFailure));
			else
				connection.commit(new Responder(onSQLCommitSuccess, onSQLCommitFailure));
		}
		/**
		 *  @private
		 */
		
		/** 
		 * Step through each statement, and ensure connection is removed.
		 */
		private function removeSQLStatements():void
		{
			if (sqlStatements )
			{
				var currentStatement:SQLStatement;
				
				for( var i:uint = 0; i < sqlStatements.length; i++ )
				{
					currentStatement = sqlStatements[i] as SQLStatement;
					
					if (currentStatement.executing ) 
						currentStatement.cancel();
					
					currentStatement.sqlConnection = null;
					currentStatement = null;
				}
			}
		}
		
		/**
		 * Remove all connection listeners.
		 */
		private function removeConnectionListeners():void
		{
			isLoading = false;
			if(connection)
			{
				connection.removeEventListener( SQLEvent.OPEN, onConnectionOpen );
				connection.removeEventListener( SQLErrorEvent.ERROR, onConnectionOpenError );
				connection.removeEventListener( SQLEvent.CLOSE, onConnectionClose );
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
		 * Handle a successful connection closed event.
		 */
		private function onConnectionClose(event:SQLEvent) : void
		{
			removeConnectionListeners();
		}
		
		/**
		 * @private
		 * Handle a successful connection opened event.
		 */
		
		private function onConnectionOpen(event:SQLEvent) : void
		{
			removeConnectionListeners();
		}
		
		/**
		 * @private
		 * Handle a open connection failure event. Dispatch custom event.
		 */
		
		private function onConnectionOpenError( evt:SQLErrorEvent ) : void
		{
			removeConnectionListeners();
			
			var errMsg:String = "Error opening database connection: " + evt.text;
			sendNotification(CourseAirConstants.SHOW_ERROR_WINDOW, errMsg);
		}
		
		/**
		 * @private
		 * Send completion notification.
		 */
		protected function onExecuteComplete( result:SQLResult ) : void
		{
			isLoading = false;
			
			switch (nextNoteName)
			{
				case CourseServiceNotification.ALL_DEPARTMENTS_RETRIEVED:
				case CourseServiceNotification.DEPARTMENTS_RETRIEVED:
					var departments:IList = new ArrayCollection(result.data);
					sendNotification(nextNoteName, departments);
					break;
				case CourseServiceNotification.SPECIALITIES_RETRIEVED:
					var specialities:IList = new ArrayCollection(result.data);
					sendNotification(CourseServiceNotification.SPECIALITIES_RETRIEVED, specialities);
					break;
				case CourseServiceNotification.LESSON_NAME_VALIDATION_RESULT:
					var lessonNameValid:Boolean = result.data ? false : true ;
					sendNotification(CourseServiceNotification.LESSON_NAME_VALIDATION_RESULT, lessonNameValid);
					break;
				case CourseServiceNotification.USER_SETTINGS_RETRIEVED:
					sendNotification(CourseServiceNotification.USER_SETTINGS_RETRIEVED, result.data ? result.data[0] : null);
					break;
				default:
					if(nextNoteName)
						sendNotification(nextNoteName, result.data);
					break;
			}
			
			// check if more requests are in queue
			if(requestStack && requestStack.length >0)
			{
				executeRequest(requestStack.shift());
			}
		}
		
		
		
		/**
		 * Handle a status error.
		 */
		private function onExecuteError( event:SQLError ) : void
		{
			isLoading = false;
			isSQLError = true;
			var errMsg:String = event.message + " -- " + event.details;
			sendNotification(CourseAirConstants.SHOW_ERROR_WINDOW, errMsg);
		}
		
		/**
		 * Handle successful rollback. Error has already been sent which had triggered
		 * the rollback originally.
		 */
		
		private function onRollbackSuccess(event:SQLEvent):void
		{
			//sendNotification(BykiConstants.ROLLBACK_SUCCESS, errMsg);
		}
		
		/**
		 * Handle rollback failure. Send error notification.
		 */
		
		private function onRollbackFailure(event:SQLErrorEvent):void
		{
			var errMsg:String = "Error rolling back transaction: " + event.text;
			sendNotification(CourseAirConstants.SHOW_ERROR_WINDOW, errMsg);
		}
		
		/**
		 * Handle successful commit. Send nextNoteName notification.
		 */
		
		private function onSQLCommitSuccess(event:SQLEvent) : void
		{
			if(nextNoteName)
				sendNotification(nextNoteName);
		}
		
		
		/**
		 * Handle commit failure. Send error notification.
		 */
		private function onSQLCommitFailure( event:* ) : void
		{
			var errMsg:String = "Error committing transaction: ";
			if(event is SQLError)
				errMsg +=  SQLError(event).message;
			else if (event is SQLErrorEvent)
				errMsg +=  SQLErrorEvent(event).text;
			sendNotification(CourseAirConstants.SHOW_ERROR_WINDOW, errMsg);
		}
	}
}