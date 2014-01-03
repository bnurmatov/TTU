////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.user
{
	import flash.data.SQLStatement;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.courseservice.model.vo.UserSettingsVO;
	
	/**
	 * UserProxy class 
	 */
	public class UserAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'UserAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var currentUserSettinsVO:UserSettingsVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * UserProxy 
		 */
		public function UserAdapterProxy()
		{
			super(NAME);
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
		public function cleanUp():void
		{
			currentUserSettinsVO = null;
		}
		/**
		 *  @public
		 */
		public function createUserSettings(settingVO:UserSettingsVO, completionNotification:String, isTransaction:Boolean = true):void
		{
			currentUserSettinsVO = settingVO;			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			insertUserSettings(settingVO);
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 *  @private
		 * 
		 */
		/**
		 * Insert a new lesson into the database.
		 * 
		 * @param lesson 	The <code>LessonVO</code> object representing the list to insert
		 * @param isEdit	Flag determining whether or not we are editing
		 */
		private function insertUserSettings(settingVO:UserSettingsVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_USER_SETTINGS_SQL_KEY);
			
			statement.parameters[':userId']					= settingVO.userId;
			statement.parameters[':lessonUuid']				= settingVO.currentLessonUUID;
			statement.parameters[':viewIndex']				= settingVO.createViewIndex;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
	
		/**
		 * Updates an existing lesson to the new state, including chapters.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to create
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isUpdateChapters				Flag determining whether or not to update chapters 
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateUserSettings(settingVO:UserSettingsVO, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			// save settingVO to proxy
			currentUserSettinsVO = settingVO;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			updateUserSettingsRecord(settingVO);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update lesson to match the <code>LessonVO</code> object which represents
		 * the lesson's new state.
		 * 
		 * @param lesson The <code>LessonVO</code> object representing the lesson to update
		 */
		private function updateUserSettingsRecord(settingVO:UserSettingsVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_USER_SETTINGS_SQL_KEY);
			
			statement.parameters[':userId']				= settingVO.userId;
			statement.parameters[':lessonUuid']			= settingVO.currentLessonUUID;
			statement.parameters[':viewIndex']			= settingVO.createViewIndex ;
			statement.parameters[':locale']				= settingVO.locale ;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param lessonUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getUserSettingsByUserId(completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_USER_SETTINGS_BY_USER_ID_SQL_KEY);
			statement.itemClass = UserSettingsVO;
			statement.parameters[':userId'] 		= databaseMangerProxy.userId;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
		
		/**
		 *  @private
		 */
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
	}
}