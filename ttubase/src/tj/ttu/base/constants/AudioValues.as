////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.constants
{
	/**
	 * The AudioValues is set of the definitions for audio values.
	 */
	public class AudioValues
	{

		//----------------------------------------------------------------------
		//
		//  Class Constants
		//
		//----------------------------------------------------------------------
		/**
		 *  Used to notify about availability of raw sound data.
		 *  When raw sound data is loaded and avilable an event type of <code>SOUND_DATA_LOADED</code>
		 *  is dipatched
		 */ 
		public static const MAX_SOUND_LENGTH:Number = 3000000;

		
		/**
		 * Defines initial sound palyback speed.  
		 */		
		public static const SOUND_SPEED:Number			= 0.85;

		/**
		 * Minimum value for sound speed.  
		 */		
		public static const SOUND_SPEED_MIN:Number		= 0.7;

		/**
		 * Maximum value for sound speed.  
		 */		
		public static const SOUND_SPEED_MAX:Number		= 1.3;

		/**
		 * Step for sound speed.  
		 */			
		public static const SOUND_SNAP_INTERVAL:Number	= 0.01;

		/**
		 * Default volume.  
		 */		
		public static const VOLUME:Number				= 0.7;

		/**
		 * Minimum volume value.  
		 */			
		public static const VOLUME_MIN:Number			= 0;

		/**
		 * Maximum volume value.  
		 */		
		public static const VOLUME_MAX:Number			= 1;	

		/**
		 * Step interval for volume.  
		 */			
		public static const VOLUME_SNAP_INTERVAL:Number	= 0.05

		/**
		 * Constructor
		 */
		public function AudioValues()
		{
		}
	}
}