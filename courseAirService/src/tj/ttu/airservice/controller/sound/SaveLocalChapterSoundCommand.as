////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 28, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import mx.utils.UIDUtil;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SaveLocalChapterSoundCommand class 
	 */
	public class SaveLocalChapterSoundCommand extends BaseAirCommand
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
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
		 * SaveLocalChapterSoundCommand 
		 */
		public function SaveLocalChapterSoundCommand()
		{
			super();
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
		override public function execute(note:INotification):void
		{
			var mediaVO:MediaVO = note.getBody() as MediaVO;
			if(mediaVO && soundAssetsProxy)
			{
				soundAssetsProxy.mediaVo = mediaVO;
				if(mediaVO.soundVO && mediaVO.binaryContent)
				{
					var soundVo:SoundVO = mediaVO.soundVO;
					mediaVO.fileName = UIDUtil.createUID() + soundAssetsProxy.mediaType;
					soundVo.soundUrl = AssetsUtil.SOUND_PATH + mediaVO.fileName;
					mediaVO.soundVO = soundVo;
					
					if(soundAdapterProxy)
					{
						soundAdapterProxy.currentSound = soundVo;
						soundAdapterProxy.addNewSound(mediaVO, CourseAirConstants.SAVE_LOCAL_SOUND_COMPLETE, true);
					}
				}
				else
				{
					fileRefferenceProxy.browseForSound(CourseAirConstants.CHAPTER_SOUND_DATA_LOADED,
						CourseServiceNotification.SAVE_SOUND_CANCELED, null, null, TTUConstants.SPIN_START);
				}
			}
		}
		
		
		
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