////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 11, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	
	import flash.net.FileReference;
	
	import tj.ttu.base.utils.TrimUtil;

	/**
	 * SupportedFileFormat class 
	 */
	public class SupportedFileFormat
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private static var conflictFileTypeMap:Array 	= [".wave"];
		private static var replaceFileTypeMap:Array 	= [".wav"];

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  Public Static
		//--------------------------------------------------------------------------
		/**
		 * Extract file type from FileReference
		 *  
		 *  e.g. .b4x
		 */		
		public static function extractFileType(fileRef:FileReference):String
		{
			if(!fileRef)
				return null;
			
			var dot:String = ".";
			var fileName:String = fileRef.name;
			var fileType:String = fileRef.type;
			// type is null in MacOS
			if(!fileType)
			{
				var extProperty:String = "extension";
				fileType = fileRef.hasOwnProperty(extProperty) ? fileRef[extProperty] as String : null;
			}
			
			// extension works only AIR
			if(!fileType)
				fileType = fileName.substr(fileName.lastIndexOf(dot));
			
			// add dot symbol if doesn't exist
			if(fileType.indexOf(dot) == -1)
				fileType = dot + fileType;
			
			fileType = TrimUtil.trim(fileType);
			return normalizeFileType(fileType.toLowerCase());
		}
		
		/**
		 * 
		 * @param fileType
		 * @return 
		 * 
		 */		
		public static function normalizeFileType(fileType:String):String
		{
			if(!fileType)
				return null;
			
			fileType = fileType.toLowerCase();
			var mapIndex:int = conflictFileTypeMap.indexOf(fileType);
			return mapIndex != -1 ? replaceFileTypeMap[mapIndex] : fileType;
		}
	}
}