////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 27, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model.sound
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.UIDUtil;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.model.BaseProxy;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SoundAdapterProxy class 
	 */
	public class SoundAdapterProxy extends BaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'SoundAdapterProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var currentSound:SoundVO;
		
		public var currentSounds:IList;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SoundAdapterProxy 
		 */
		public function SoundAdapterProxy()
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
			currentSound = null;
			currentSounds = null;
		}
		/**
		 *  @public
		 */
		public function createSound(soundVo:SoundVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(soundVo.soundUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The sound havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentSound = soundVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			insertSound(soundVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function insertSound(soundVo:SoundVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.CREATE_SOUND_SQL_KEY );
			
			statement.parameters[':target_uuid'] 			= targetUuid;
			statement.parameters[':sound_url'] 				= AssetsUtil.normalizeSoundPath(soundVo.soundUrl);
			statement.parameters[':location'] 				= soundVo.location;
			statement.parameters[':text_position'] 			= soundVo.textPosition;
			statement.parameters[':padding_left'] 			= soundVo.paddingLeft;
			statement.parameters[':padding_right'] 			= soundVo.paddingRight;
			statement.parameters[':padding_top'] 			= soundVo.paddingTop;
			statement.parameters[':padding_bottom'] 		= soundVo.paddingBottom;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		/**
		 *  @public
		 */
		public function updateSound(soundVo:SoundVO, targetUuid:String, completionNotification:String  = null, isTransaction:Boolean = true):void
		{
			// check list name length
			if( StringUtil.isNullOrEmpty(soundVo.soundUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The sound havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentSound = soundVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			updateSoundRecord(soundVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function updateSoundRecord(soundVo:SoundVO, targetUuid:String):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.text = SqlQueryConstants.UPDATE_SOUND_SQL;
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':soundUrl'] 				= AssetsUtil.normalizeSoundPath(soundVo.soundUrl);
			statement.parameters[':location'] 				= soundVo.location;
			statement.parameters[':textPosition'] 			= soundVo.textPosition;
			
			var requestVO:AirRequestVO = new AirRequestVO();
			requestVO.statement = statement;
			databaseMangerProxy.executeRequest( requestVO );
		}		
		
		public function removeSound(soundVo:SoundVO, targetUuid:String, completionNotification:String = null, isTransaction:Boolean = true):void
		{
			if( StringUtil.isNullOrEmpty(soundVo.soundUrl) )
			{
				sendNotification(TTUConstants.SHOW_ERROR_WINDOW, "The sound havn't url address.");
				sendNotification(completionNotification);
				return;
			}
			
			
			currentSound = soundVo;
			
			// insert within transaction if flag is set
			if(isTransaction)
				databaseMangerProxy.beginTransaction();
			deleteSound(soundVo, targetUuid);
			
			// close transaction if needed
			if(isTransaction)
				databaseMangerProxy.endTransaction(completionNotification);
		}
		
		private function deleteSound(soundVo:SoundVO, targetUuid:String):void
		{
			var statement:SQLStatement = databaseMangerProxy.getSQLStatement( SqlQueryConstants.DELETE_SOUND_SQL_KEY );
			
			statement.parameters[':targetUuid'] 			= targetUuid;
			statement.parameters[':soundUrl'] 				= soundVo.soundUrl;
			
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
		public function getSoundsByTargetUuid(targetUuid:String, completionNotification:String):void
		{
			// fetch SQL statement, set itemclass
			var statement:SQLStatement = new SQLStatement();
/*			var statement:SQLStatement = databaseMangerProxy.getSQLStatement(SqlQueryConstants.GET_SOUNDS_BY_UUID_SQL_KEY);*/
			statement.text = SqlQueryConstants.GET_SOUNDS_BY_UUID_SQL;
			statement.itemClass = SoundVO;
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
		public function updateSounds(lessonUuid:String, lessonVersion:int, targetUuid:String, sounds:IList, completionNotification:String = null):void
		{
			if(StringUtil.isNullOrEmpty(targetUuid) || !sounds)	return;
			
			var mediaVO:MediaVO;
			var updateSounds:IList = getUpdateSounds(currentSounds, sounds );
			if(updateSounds)
			{
				for each(var item:SoundVO in updateSounds)
				{
					updateSound(item, targetUuid, null, false);
				}
			}
			
			var insertSounds:IList = getInsertSounds( currentSounds, sounds );
			if(insertSounds)
			{
				for each(var sound:SoundVO in insertSounds)
				{
					mediaVO = new MediaVO(targetUuid)
					mediaVO.fileName = UIDUtil.createUID() + SoundAssetProxy.DEFAULT_SOUND_TYPE;
					sound.soundUrl = AssetsUtil.SOUND_PATH + mediaVO.fileName;
					mediaVO.binaryContent = sound.binarySource;
					mediaVO.lessonVersion = lessonVersion;
					mediaVO.lessonUuid = lessonUuid;
					mediaVO.soundVO = sound;
					
					addNewSound(mediaVO);
				}
			}
			var deleteSounds:IList = getDeleteSounds( currentSounds, sounds );
			
			if(deleteSounds)
			{
				for each(var soundVO:SoundVO in deleteSounds)
				{
					mediaVO = new MediaVO(targetUuid)
					mediaVO.fileName = FileNameUtil.getFileName( soundVO.soundUrl );
					mediaVO.lessonVersion = lessonVersion;
					mediaVO.lessonUuid = lessonUuid;
					mediaVO.soundVO = soundVO;
					removeExistingSound( mediaVO );
				}
			}
		}
		
		public function addNewSound(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(soundAssetsProxy && mediaVO)
			{
				soundAssetsProxy.mediaVo = mediaVO;
				soundAssetsProxy.writeSoundToDisk();
				soundAssetsProxy.transcodeSoundFromFile(CourseAirConstants.SOUND_TRANSCODE_COMPLETE);
				//createSound(mediaVO.soundVO, mediaVO.targetGuid, completionNotification, isTransaction );
			}
		}
		
		public function removeExistingSound(mediaVO:MediaVO, completionNotification:String = null, isTransaction:Boolean = false):void
		{
			if(soundAssetsProxy && mediaVO)
			{
				soundAssetsProxy.mediaVo = mediaVO;
				soundAssetsProxy.deleteSoundFromDisk(null);
				removeSound(mediaVO.soundVO, mediaVO.targetGuid, completionNotification, isTransaction );
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
		private function getUpdateSounds(existSounds:IList, updateSounds:IList):IList
		{
			if(!existSounds) return null;
			var newSounds:IList = new ArrayCollection();
			var soundUrl:String;
			for each(var item:SoundVO in updateSounds)
			{
				if(item)
				{
					soundUrl = AssetsUtil.normalizeSoundPath(item.soundUrl);
					for each(var sound:SoundVO in existSounds)
					{
						if(sound && sound.soundUrl == soundUrl && sound.textPosition != item.textPosition)
						{
							newSounds.addItem( item );
							break;
						}
					}
				}
			}
			
			return newSounds.length > 0 ? newSounds : null;
		}
		/**
		 *  @private
		 */
		private function getInsertSounds(existSounds:IList, updateSounds:IList):IList
		{
			if(!existSounds) return updateSounds;
			var newSounds:IList = new ArrayCollection();
			var soundUrl:String;
			for each(var item:SoundVO in updateSounds)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					soundUrl = AssetsUtil.normalizeSoundPath(item.soundUrl);
					for each(var sound:SoundVO in existSounds)
					{
						if(sound && sound.soundUrl != soundUrl && sound.textPosition != item.textPosition)
							existFlag = false;
						else
						{
							existFlag = true;
							break;
						}
					}
					
					if(!existFlag)
						newSounds.addItem( item );
				}
			}
			
			return newSounds.length > 0 ? newSounds : null;
		}
		
		/**
		 *  @private
		 */
		private function getDeleteSounds(existSounds:IList, updateSounds:IList):IList
		{
			if(!existSounds) return null;
			var deleteSounds:IList = new ArrayCollection();
			for each(var item:SoundVO in existSounds)
			{
				var existFlag:Boolean = false;
				if(item)
				{
					for each(var sound:SoundVO in updateSounds)
					{
						if(sound && AssetsUtil.normalizeSoundPath(sound.soundUrl) != item.soundUrl && sound.textPosition != item.textPosition)
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
						deleteSounds.addItem( item );
				}
			}
			
			return deleteSounds.length > 0 ? deleteSounds : null;
		}
		
		
	}
}