////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	

	/**
	 * StringUtil is a util class for string manipulation 
	 */
	public class StringUtil
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Utility mthod for checking if a sring is <code>null</code> or <code>empty</code>.
		 * 
		 * @param str The String to check.
		 * 
		 * @return <code>true</code> means that string is <code>null</code> or <code>empty</code>,  
		 * <code>false</code> otherwise.
		 * 
		 */		
		public static function isNullOrEmpty(str:String):Boolean
		{
			str = TrimUtil.trim( str );
			return str == null || str == "";
		}
		
		
		public static function compare(str1:String, str2:String):Boolean
		{
			str1 = TrimUtil.trim( str1 );
			str2 = TrimUtil.trim( str2 );
			if(isNullOrEmpty( str1 ) && isNullOrEmpty( str2 ))
				return false;
			
			return str1 != str2;
			
		}
		
	}
}