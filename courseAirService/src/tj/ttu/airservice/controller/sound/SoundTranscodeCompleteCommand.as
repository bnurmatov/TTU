////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 19, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.sound
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * SoundTranscodeCompleteCommand class 
	 */
	public class SoundTranscodeCompleteCommand extends BaseAirCommand
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
		 * SoundTranscodeCompleteCommand 
		 */
		public function SoundTranscodeCompleteCommand()
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
			if(soundAssetsProxy)
			{
				var mediaVO:MediaVO = soundAssetsProxy.mediaVo;
				if(mediaVO && soundAdapterProxy)
				{
					soundAdapterProxy.createSound(mediaVO.soundVO, mediaVO.targetGuid, CourseAirConstants.SAVE_LOCAL_SOUND_COMPLETE);
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