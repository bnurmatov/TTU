////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.video
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * VideoAdapterProxy class 
	 */
	public class VideoAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'VideoAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 *
		 */
		public var currentVideo:VideoVO;
		
		public var currentVideoList:IList;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * VideoAdapterProxy 
		 */
		public function VideoAdapterProxy()
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
			// TODO Auto Generated method stub
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
			currentVideo = null;
			currentVideoList = null;
		}
		/**
		 *  @public
		 */
		public function createVideo(videoVo:VideoVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(videoVo.videoUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The video havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentVideo = videoVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			insertVideo(videoVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function insertVideo(videoVo:VideoVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.CREATE_VIDEO_SQL_KEY );
			
			statement.parameters[':target_uuid'] 			= targetUuid;
			statement.parameters[':video_url'] 				= AssetsUtil.normalizeVideoPath(videoVo.videoUrl);
			statement.parameters[':location'] 				= videoVo.location;
			statement.parameters[':text_position'] 			= videoVo.textPosition;
			statement.parameters[':padding_left'] 			= videoVo.paddingLeft;
			statement.parameters[':padding_right'] 			= videoVo.paddingRight;
			statement.parameters[':padding_top'] 			= videoVo.paddingTop;
			statement.parameters[':padding_bottom'] 		= videoVo.paddingBottom;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		/**
		 *  @public
		 */
		public function updateVideo(videoVo:VideoVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(videoVo.videoUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The video havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentVideo = videoVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			updateVideoRecord(videoVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function updateVideoRecord(videoVo:VideoVO, targetUuid:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.UPDATE_VIDEO_SQL;
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':videoUrl'] 				= AssetsUtil.normalizeVideoPath(videoVo.videoUrl);
			statement.parameters[':location'] 				= videoVo.location;
			statement.parameters[':textPosition'] 			= videoVo.textPosition;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		public function removeVideo(videoVo:VideoVO, targetUuid:String, completionNotification:String = null, isTransaction:Boolean = true):void
		{
			if( StringUtil.isNullOrEmpty(videoVo.videoUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The video havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentVideo = videoVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			deleteVideo(videoVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function deleteVideo(videoVo:VideoVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.DELETE_VIDEO_SQL_KEY );
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':videoUrl'] 				= videoVo.videoUrl;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		/**
		 *  @public
		 */
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param targetUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function getVideoByTargetUuid(targetUuid:String, completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.GET_VIDEO_LIST_BY_UUID_SQL;
			statement.itemClass = VideoVO;
			statement.parameters[':targetUuid'] 	= targetUuid;
			
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote = completionNotification;
			databaseMangerProxy.executeRequest(request);			
		}
		
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param targetUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function updateVideoList(lessonUuid:String, lessonVersion:int, targetUuid:String, videoList:IList, completionNotification:String = null):void
		{
			if(StringUtil.isNullOrEmpty(targetUuid) || !videoList)	return;
			
			var mediaVO:MediaVO;
			var updateVideoList:IList = getUpdateVideoList(currentVideoList, videoList );
			if(updateVideoList)
			{
				for each(var item:VideoVO in updateVideoList)
				{
					updateVideo(item, targetUuid, null, false);
				}
			}
			
			var deleteVideoList:IList = getDeleteVideoList( currentVideoList, videoList );
			
			if(deleteVideoList)
			{
				for each(var videoVO:VideoVO in deleteVideoList)
				{
					mediaVO = new MediaVO(targetUuid)
					mediaVO.fileName = FileNameUtil.getFileName( videoVO.videoUrl );
					mediaVO.lessonVersion = lessonVersion;
					mediaVO.lessonUuid = lessonUuid;
					mediaVO.videoVO = videoVO;
					removeExistingVideo( mediaVO );
				}
			}
		}
		
		public function addNewVideo(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(videoAssetProxy && mediaVO)
			{
				videoAssetProxy.mediaVo = mediaVO;
				videoAssetProxy.writeVideoToDisk(CourseAirConstants.WRITE_VIDEO_TO_DISK_COMPLETE);
				//soundAssetsProxy.transcodeSoundFromFile(CourseAirConstants.SOUND_TRANSCODE_COMPLETE);
				//createSound(mediaVO.soundVO, mediaVO.targetGuid, completionNotification, isTransaction );
			}
		}
		
		public function removeExistingVideo(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(videoAssetProxy && mediaVO)
			{
				videoAssetProxy.mediaVo = mediaVO;
				videoAssetProxy.deleteVideoFromDisk(null);
				removeVideo(mediaVO.videoVO, mediaVO.targetGuid, completionNotification, isTransaction );
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
		private function getUpdateVideoList(existVideoList:IList, updateVideoList:IList):IList
		{
			if(!existVideoList) return null;
			var newVideoList:IList = new ArrayCollection();
			var videoUrl:String;
			for each(var item:VideoVO in updateVideoList)
			{
				if(item)
				{
					videoUrl = AssetsUtil.normalizeVideoPath(item.videoUrl);
					for each(var video:VideoVO in existVideoList)
					{
						if(video && video.videoUrl == videoUrl && video.textPosition != item.textPosition)
						{
							newVideoList.addItem( item );
							break;
						}
					}
				}
			}
			
			return newVideoList.length > 0 ? newVideoList : null;
		}
		
		/**
		 *  @private
		 */
		private function getDeleteVideoList(existVideoList:IList, updateVideoList:IList):IList
		{
			if(!existVideoList) return null;
			var deleteVideoList:IList = new ArrayCollection();
			for each(var item:VideoVO in existVideoList)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var video:VideoVO in updateVideoList)
					{
						if(video && AssetsUtil.normalizeVideoPath(video.videoUrl) != item.videoUrl)
						{
							existFlag = false;
						}
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						deleteVideoList.addItem( item );
				}
			}
			
			return deleteVideoList.length > 0 ? deleteVideoList : null;
		}
	}
}