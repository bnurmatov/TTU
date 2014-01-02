////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 28, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * RemovePreviousLessonSoundCommand class 
	 */
	public class RemovePreviousLessonSoundCommand extends BaseAirCommand
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
		 * RemovePreviousLessonSoundCommand 
		 */
		public function RemovePreviousLessonSoundCommand()
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
			var sounds:Array = notification.getBody() as Array;
			if(sounds && sounds.length > 0 && soundAdapterProxy && soundAssetsProxy)
			{
				var soundVO:SoundVO = sounds[0] as SoundVO;
				var mediaVO:MediaVO = soundAssetsProxy.mediaVo;
				soundAssetsProxy.previousSound = soundVO;
				soundAssetsProxy.deletePreviousSound(true);
				soundAdapterProxy.removeSound(soundVO, mediaVO.targetGuid, null, true );
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