////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer
{
	import mx.core.FlexVersion;

	/**
	 * Version class 
	 */
	[Bindable]
	public class Version
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Stores Flex SDK version.
		 */
		public static const FLEX_SDK:uint = FlexVersion.CURRENT_VERSION;
		
		/**
		 * The application version.
		 * <p>
		 * The version has the form: major.minor.revision.build_number:
		 * <ul>
		 * 	<il>major - major version number;</il>
		 * 	<il>minor - minor version number;</il>
		 * 	<il>revision - sprint number;</il>
		 * 	<il>build_number - cruise control build number;</il>
		 * </ul>
		 * for example: 1.x.xxx
		 * </p>
		 */
		public static const VERSION:String = "1.0.000";		
		
	}
}