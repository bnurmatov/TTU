////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 11, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.AssetsUtil;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SaveLocalLessonSoundCommand class 
	 */
	public class SaveLocalSoundCompleteCommand extends BaseAirCommand
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
		 * SaveLocalLessonSoundCommand 
		 */
		public function SaveLocalSoundCompleteCommand()
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
		override public function execute(notification:INotification):void
		{
			if(soundAdapterProxy && soundAssetsProxy)
			{
				var sound:SoundVO = soundAdapterProxy.currentSound;
				var mediaVo:MediaVO = soundAssetsProxy.mediaVo;
				sound = AssetsUtil.prependRootPathForSingleSound(mediaVo.lessonUuid, mediaVo.lessonVersion, sound)
				sendNotification(CourseServiceNotification.AUDIO_ASSOCIATED, sound);
				soundAdapterProxy.cleanUp();
				soundAssetsProxy.cleanUp();
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