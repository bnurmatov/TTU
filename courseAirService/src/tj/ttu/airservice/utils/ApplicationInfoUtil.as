////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 21, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.desktop.NativeApplication;

	/**
	 * ApplicationInfoUtil class 
	 */
	public class ApplicationInfoUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  Public
		//--------------------------------------------------------------------------
		/**
		 * The content of the filename for the application.
		 *  
		 * @return The filename for the application. 
		 */		
		public static function get filename():String
		{
			return appDescription.*::filename.text();
		}
		
		/**
		 * The content of the name for the application.
		 *  
		 * @return The name for the application. 
		 */
		public static function get name():String
		{
			return appDescription.*::name.text();
		}
		
		/**
		 * The content of a universally unique application identifier.
		 *  
		 * @return A universally unique application identifier.
		 */		
		public static function get id():String
		{
			return appDescription.*::id.text();
		}
		
		/**
		 * A string value of the format <0-999>.<0-999>.<0-999> that represents application version.
		 *  
		 * @return The version for the application. 
		 */		
		public static function get versionNumber():String
		{
			return appDescription.*::versionNumber.text();
		}
		
		/**
		 * A string value (such as "v1", "2.5", or "Alpha 1") that represents the version of the application.
		 *  
		 * @return The version number for the application. 
		 */		
		public static function get versionLabel():String
		{
			return appDescription.*::versionLabel.text();
		}
		
		/**
		 * The content of the description for the application.
		 *  
		 * @return The description for the application. 
		 */		
		public static function get description():String
		{
			return appDescription.*::description.text();
		}
		
		/**
		 * The content of the copyright for the application.
		 *  
		 * @return The copyright for the application. 
		 */		
		public static function get copyright():String
		{
			return appDescription.*::copyright.text();
		}
		
		
		//--------------------------------------------------------------------------
		//  Private
		//--------------------------------------------------------------------------
		/**
		 * The contents of the application descriptor file for this AIR application.
		 * 
		 * @return The application descriptor file for this AIR application.
		 */		
		public static function get appDescription():XML
		{
			return NativeApplication.nativeApplication.applicationDescriptor;
		}
	}
}