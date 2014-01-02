////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 15, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.image
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * ImageAdapterProxy class 
	 */
	public class ImageAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ImageAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var currentImage:ImageVO;
		
		public var currentImages:IList;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageAdapterProxy 
		 */
		public function ImageAdapterProxy()
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
		
		/**
		 *  @public
		 */
		public function cleanUp():void
		{
			currentImage = null;
			currentImages = null;
		}
		
		/**
		 *  @public
		 */
		public function createImage(imageVo:ImageVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(imageVo.imageUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The image havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentImage = imageVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			insertImage(imageVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function insertImage(imageVo:ImageVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.CREATE_IMAGE_SQL_KEY );
			
			statement.parameters[':target_uuid'] 			= targetUuid;
			statement.parameters[':image_url'] 				= AssetsUtil.normalizeImagePath(imageVo.imageUrl);
			statement.parameters[':original_image_url'] 	= imageVo.originalImageUrl;
			statement.parameters[':width'] 					= imageVo.width;
			statement.parameters[':height'] 				= imageVo.height;
			statement.parameters[':location'] 				= imageVo.location;
			statement.parameters[':text_position'] 			= imageVo.textPosition;
			statement.parameters[':padding_left'] 			= imageVo.paddingLeft;
			statement.parameters[':padding_right'] 			= imageVo.paddingRight;
			statement.parameters[':padding_top'] 			= imageVo.paddingTop;
			statement.parameters[':padding_bottom'] 		= imageVo.paddingBottom;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		/**
		 *  @public
		 */
		public function updateImage(imageVo:ImageVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(imageVo.imageUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The image havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentImage = imageVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			updateImageRecord(imageVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function updateImageRecord(imageVo:ImageVO, targetUuid:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.UPDATE_IMAGE_SQL;
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':imageUrl'] 				= AssetsUtil.normalizeImagePath(imageVo.imageUrl);
			statement.parameters[':width'] 					= imageVo.width;
			statement.parameters[':height'] 				= imageVo.height;
			statement.parameters[':location'] 				= imageVo.location;
			statement.parameters[':textPosition'] 			= imageVo.textPosition;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		public function removeImage(imageVo:ImageVO, targetUuid:String, completionNotification:String = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(imageVo.imageUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The image havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentImage = imageVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			deleteImage(imageVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function deleteImage(imageVo:ImageVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.DELETE_IMAGE_SQL_KEY );
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':imageUrl'] 				= imageVo.imageUrl;
			
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
		public function getImagesByTargetUuid(targetUuid:String, completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = new SQLStatement();
			/*			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_IMAGES_BY_UUID_SQL_KEY);*/
			statement.text = SqlQueryConstants.GET_IMAGES_BY_UUID_SQL;
			statement.itemClass = ImageVO;
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
		public function updateImages(lessonUuid:String, lessonVersion:int, targetUuid:String, images:IList, completionNotification:String = null):void
		{
			if(StringUtil.isNullOrEmpty(targetUuid)) return;
			
			var mediaVO:MediaVO;
			var updateImages:IList = getUpdateImages(currentImages, images );
			if(updateImages)
			{
				for each(var item:ImageVO in updateImages)
				{
					updateImage(item, targetUuid, null, false);
				}
			}
			
			var insertImages:IList = getInsertImages( currentImages, images );
			if(insertImages)
			{
				for each(var image:ImageVO in insertImages)
				{
					mediaVO = new MediaVO(targetUuid)
					mediaVO.fileName = UIDUtil.createUID() + ImageAssetProxy.DEFAULT_IMAGE_TYPE;
					image.imageUrl = AssetsUtil.IMAGE_PATH + mediaVO.fileName;
					mediaVO.binaryContent = image.binarySource;
					mediaVO.lessonVersion = lessonVersion;
					mediaVO.lessonUuid = lessonUuid;
					mediaVO.imageVO = image;
					
					addNewImage(mediaVO);
				}
			}
			var deleteImages:IList = getDeleteImages( currentImages, images );
			
			if(deleteImages)
			{
				for each(var imageVO:ImageVO in deleteImages)
				{
					mediaVO = new MediaVO(targetUuid)
					mediaVO.fileName = FileNameUtil.getFileName( imageVO.imageUrl );
					mediaVO.lessonVersion = lessonVersion;
					mediaVO.lessonUuid = lessonUuid;
					mediaVO.imageVO = imageVO;
					removeExistingImage( mediaVO );
				}
			}
		}
		/**
		 * Get a lesson by the uuid. 
		 * 
		 * @param targetUuid 					UUID of the lesson
		 * @param completionNotification	Notification to send upon completion
		 */	
		public function updateImageMetaData(imageVo:ImageVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.UPDATE_IMAGE_METADATA_SQL;
			
			statement.parameters[':imageUrl'] 				= AssetsUtil.normalizeImagePath(imageVo.imageUrl);
			statement.parameters[':width'] 					= imageVo.width;
			statement.parameters[':height'] 				= imageVo.height;
			statement.parameters[':location'] 				= imageVo.location;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		public function addNewImage(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(imageAssetsProxy && mediaVO)
			{
				imageAssetsProxy.mediaVo = mediaVO;
				imageAssetsProxy.writeImageToDisk();
				createImage(mediaVO.imageVO, mediaVO.targetGuid, completionNotification, isTransaction );
			}
		}
		
		public function removeExistingImage(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(imageAssetsProxy && mediaVO)
			{
				imageAssetsProxy.mediaVo = mediaVO;
				imageAssetsProxy.deleteImageFromDisk();
				removeImage(mediaVO.imageVO, mediaVO.targetGuid, completionNotification, isTransaction );
			}
		}
		
		public function removeImageByImageUrl(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(imageAssetsProxy && mediaVO)
			{
				imageAssetsProxy.mediaVo = mediaVO;
				imageAssetsProxy.deleteImageFromDisk();
				
				var statement:SQLStatement = new SQLStatement();
				statement.text = SqlQueryConstants.DELETE_IMAGE_BY_IMAGE_URL_SQL;
				
				statement.parameters[':imageUrl'] 	= AssetsUtil.normalizeImagePath(mediaVO.imageVO.imageUrl);
				
				// insert within transaction if flag is set
				if(isTransaction)
					databaseMangerProxy.beginTransaction();
				
				var requestVO:AirRequestVO = new AirRequestVO();
				requestVO.statement = statement;
				databaseMangerProxy.executeRequest( requestVO );
				// close transaction if needed
				if(isTransaction)
					databaseMangerProxy.endTransaction(completionNotification);
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
		private function getUpdateImages(existImages:IList, updateImages:IList):IList
		{
			if(!existImages) return null;
			var newImages:IList = new ArrayCollection();
			var imageUrl:String;
			for each(var item:ImageVO in updateImages)
			{
				if(item)
				{
					imageUrl = AssetsUtil.normalizeImagePath(item.imageUrl);
					for each(var image:ImageVO in existImages)
					{
						if(image && image.imageUrl == imageUrl && image.textPosition != item.textPosition)
						{
							newImages.addItem( item );
							break;
						}
					}
				}
			}
			
			return newImages.length > 0 ? newImages : null;
		}
		/**
		 *  @private
		 */
		private function getInsertImages(existImages:IList, updateImages:IList):IList
		{
			if(!existImages) return updateImages;
			var newImages:IList = new ArrayCollection();
			for each(var item:ImageVO in updateImages)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var image:ImageVO in existImages)
					{
						if(image && image.imageUrl != AssetsUtil.normalizeImagePath(item.imageUrl))
							existFlag = false;
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						newImages.addItem( item );
					
				}
			}
			
			return newImages.length > 0 ? newImages : null;
		}
		
		/**
		 *  @private
		 */
		private function getDeleteImages(existImages:IList, updateImages:IList):IList
		{
			if(!existImages) return null;
			var deleteImages:IList = new ArrayCollection();
			for each(var item:ImageVO in existImages)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var image:ImageVO in updateImages)
					{
						if(image &&  AssetsUtil.normalizeImagePath(image.imageUrl) != item.imageUrl)
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
						deleteImages.addItem( item );
				}
			}
			
			return deleteImages.length > 0 ? deleteImages : null;
		}
		
	}
}