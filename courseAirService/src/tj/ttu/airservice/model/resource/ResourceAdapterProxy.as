////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 9, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.resource
{
	import flash.data.SQLStatement;
	
	import mx.collections.IList;
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * ResourceAdapterProxy class 
	 */
	public class ResourceAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ResourceAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var currentResource:ResourceVO;
		public var currentResources:Array;
		public var serviceVO:ResourceServiceVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ResourceAdapterProxy 
		 */
		public function ResourceAdapterProxy()
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
		public function cleanUp():void
		{
			currentResource = null;
			currentResources = null;
			serviceVO = null;
		}
		/**
		 * Retrieves any resources that belong to the 'current' lesson.
		 * 
		 */
		public function retrieveResourcesByLessonUuid(lessonUuid:String, completionNotification:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.GET_RESOURCES_BY_LESSON_UUID_SQL;
			statement.parameters[":lessonUuid"] = lessonUuid;
			statement.itemClass = ResourceVO;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);
		}
		
		/**
		 *  @public
		 */
		public function addNewResource(resource:ResourceVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			createResource( resource, completionNotification, isTransaction );
		}
		
		/**
		 *  @public
		 */
		public function removeExistingResource(resource:ResourceVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			currentResource = resource;
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			deleteResource( resource);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 *  @public
		 */
		public function createResource(resource:ResourceVO, completionNotification:String, isTransaction:Boolean = true, isEdit:Boolean = false):void
		{
			// create new UUID and reset version, unless editing
			if(!isEdit|| StringUtil.isNullOrEmpty(resource.resourceUuid))
			{
				resource.resourceUuid = UIDUtil.createUID();
			}
			
			currentResource 		= resource;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			insertResource(resource, isEdit);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Insert a new resource into the database.
		 * 
		 * @param resource 	The <code>ResourceVO</code> object representing the ResourceVO to insert
		 * @param isEdit	Flag determining whether or not we are editing
		 */
		private function insertResource(resource:ResourceVO, isEdit:Boolean = false):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.CREATE_RESOURCE_SQL_KEY);
			
			statement.parameters[':lesson_uuid']		= resource.lessonUuid;
			statement.parameters[':resource_uuid']		= resource.resourceUuid;
			statement.parameters[':resource_title']		= resource.title;
			statement.parameters[':resource_url']		= resource.url;
			statement.parameters[':resource_path']		= AssetsUtil.normalizeResourcePath(resource.resourcePath);
			statement.parameters[':resource_comment']	= resource.comment;
			statement.parameters[':resouce_type']		= resource.resouceType;
			statement.parameters[':resource_position']	= resource.position;
			statement.parameters[':published']			= resource.isPublished;
			statement.parameters[':version']			= resource.version;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		
		
		/**
		 * Updates an existing ResourceVO to the new state.
		 * 
		 * @param resource The array of <code>ResourceVO</code> object
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateResources(lesson:LessonVO, completionNotification:String = "", isTransaction:Boolean = true):void
		{
			if(!databaseMangerProxy) return;
			
			currentResources = lesson.resources;
			databaseMangerProxy.beginTransaction();
			
			for each(var resource:ResourceVO in currentResources)
			{
				if(resource)
				{
					if(resource.resouceType == ResourceVO.INTERNET_RESOURCE && !StringUtil.isNullOrEmpty(resource.resourcePath))
					{
						var resourceName:String = FileNameUtil.getFileName(resource.resourcePath);
						AssetsUtil.deleteResourceFromLocalStorage(lesson.guid, lesson.version, resourceName);
						resource.resourcePath = null;
					}
					updateResource( resource );
				}
			}
			
			databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Updates an existing resource to the new state.
		 * 
		 * @param resource The <code>ResourceVO</code> object representing the resource to update
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateResource(resource:ResourceVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// save chapter to proxy
			currentResource = resource;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			
			updateResourceRecord(resource);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		/**
		 * Updates an existing resource to the new state.
		 * 
		 * @param resource The <code>ResourceVO</code> object representing the resource to update
		 * @param completionNotification	Notification to send upon completion, if needed
		 * @param isTransaction				Flag determining whether or not to wrap calls in a transaction 
		 */
		public function updateResourcePath(resource:ResourceVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			// save chapter to proxy
			currentResource = resource;
			
			// update list and cards in atomic transaction
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			
			updateResourcePathRecord(resource);
			
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		/**
		 * Update resource to match the <code>ResourceVO</code> object which represents
		 * the resource's new state.
		 * 
		 * @param resource The <code>ResourceVO</code> object representing the resource to update
		 */
		private function updateResourcePathRecord(resource:ResourceVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_RESOURCE_PATH_SQL_KEY);
			
			statement.parameters[':resource_uuid']		= resource.resourceUuid;
			statement.parameters[':resource_path']		= AssetsUtil.normalizeResourcePath(resource.resourcePath);
			
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}
		/**
		 * Update resource to match the <code>ResourceVO</code> object which represents
		 * the resource's new state.
		 * 
		 * @param resource The <code>ResourceVO</code> object representing the resource to update
		 */
		private function updateResourceRecord(resource:ResourceVO):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.UPDATE_RESOURCE_SQL_KEY);
			
			statement.parameters[':lesson_uuid']		= resource.lessonUuid;
			statement.parameters[':resource_uuid']		= resource.resourceUuid;
			statement.parameters[':resource_title']		= resource.title;
			statement.parameters[':resource_url']		= resource.url;
			statement.parameters[':resource_path']		= AssetsUtil.normalizeResourcePath(resource.resourcePath);
			statement.parameters[':resource_comment']	= resource.comment;
			statement.parameters[':resouce_type']		= resource.resouceType;
			statement.parameters[':resource_position']	= resource.position;
			statement.parameters[':version']			= resource.version;
			
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			databaseMangerProxy.executeRequest(request);
		}

		/**
		 * 
		 * Remove the resource
		 * 
		 * @param resource The <code>ResourceVO</code> object representing the resource to update
		 */

		private function deleteResource(resource:ResourceVO):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.REMOVE_RESOURCE_SQL_KEY );
			
			statement.parameters[':resourceUuid'] 			= resource.resourceUuid;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}
		
		/**
		 * Get a max resource position by the lesson's uuid. 
		 * 
		 * @param lessonUuid 					UUID of the parent lesson
		 * @param lessonVersion 				Version of the parent lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getMaxResourcePosition(lessonUuid:String, lessonVersion:uint, completionNotification:String):void
		{
			// fetch SQL statement
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_MAX_RESOURCE_POSITION_SQL_KEY);
			statement.parameters[':lesson_uuid'] 	= lessonUuid;
			statement.parameters[':version'] 		= lessonVersion;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
	}
}