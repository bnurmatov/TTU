////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	
	
	/**
	 * Uniform Resource Identifier Util class 
	 */
	public class URIUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 */		
		private static var port:String 		= "(\\:(6553[0-5]|655[0-2][0-9]\\d|65[0-4](\\d){2}|6[0-4](\\d){3}|[1-5](\\d){4}|[1-9](\\d){0,3}))?";
		
		/**
		 * 
		 */		
		private static var ip:String 		= "(([01]?\\d?\\d|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d?\\d|2[0-4]\\d|25[0-5])";
		
		/**
		 * 
		 */		
		private static var protocol:String 	= "(((http|https|ftp)\\://)|(file\\:///))?";
		
		/**
		 * 
		 */		
		private static var dns:String 		= "([a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,4})";
		
		/**
		 * 
		 */		
		private static var other:String 	= "((localhost)|([A-Za-z]{1,2}\\:))";
		
		/**
		 * 
		 */		
		private static var path:String		= "(/\\S*)?";
		
		/**
		 * 
		 */		
		private static var fileName:String	= "(?<!/)/([\\w\\%\\-]+\\.\\w+)?$";
		
		/**
		 * 
		 */		
		private static var auth:String		= "(\\w+\\:\\w+\\@)?"; //root:toor@
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function check( url:String ) : Boolean
		{
			var patternIP:RegExp 	= new RegExp( "^" + protocol + auth + ip + port + path + "$", "ig" );
			var patternDNS:RegExp 	= new RegExp( "^" + protocol + auth + dns + port + path + "$", "ig" );
			var patternLB:RegExp 	= new RegExp( "^" + protocol + auth + other + port + path + "$", "ig" );
			
			url = TrimUtil.trim( url );
			
			var matchOne:Array 	= url.match( patternDNS );
			var matchTwo:Array 	= url.match( patternIP );
			var matchThree:Array = url.match( patternLB );
			
			if( matchOne && matchOne.length == 0 &&
				matchTwo && matchTwo.length == 0 && 
				matchThree && matchThree.length == 0
			)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function isDNS( url:String ) : Boolean
		{
			if( check( url ) )
			{
				var pattern:RegExp 	= new RegExp( "^" + protocol + auth + dns, "ig" );
				var match:Array 	= url.match( pattern );
				
				if( match && match.length == 1 )
				{
					return true;
				}				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */
		public static function isIP( url:String ) : Boolean
		{
			if( check( url ) )
			{
				var pattern:RegExp 	= new RegExp( "^" + protocol + auth + ip, "ig" );
				var match:Array 	= url.match( pattern );
				
				if( match && match.length == 1 )
				{
					return true;
				}				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return false;			
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getProtocol( url:String ) : String
		{
			if( check( url ) )
			{
				var pattern:RegExp 	= new RegExp( "^" + protocol.substr( 0, port.length - 1 ), "ig" );
				var match:Array 	= url.match( pattern );
				
				if( match && match.length == 1 )
				{
					var substr:String = match.shift();
					return substr.replace( "://", "" );
				}				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getPort( url:String ) : uint
		{
			if( check( url ) )
			{
				var pattern:RegExp 	= new RegExp( port.substr( 0, port.length - 1 ), "ig" );
				//var tmp:String 		= url.replace( pattern, "{$1}" );
				var match:Array 	= url.match( pattern );
				
				if( match && match.length == 1 )
				{
					var substr:String = match.shift();
					return uint( substr.replace( ":", "" ) );
				}
				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return 0;
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getHost( url:String ) : String
		{
			if( check( url ) )
			{
				var pattern:RegExp;
				
				if( isIP( url ) )
					pattern = new RegExp( ip, "ig" );
				else
					pattern = new RegExp( dns, "ig" );
				
				url = url.replace( getPathWithFileName( url ), "" );
				
				var match:Array = url.match( pattern );
				
				if( match && match.length == 1 )
				{
					return match.shift() as String;
				}
				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return null;			
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getPath( url:String ) : String
		{
			if( check( url ) )
			{
				var pattern:RegExp;
/*				
				if( isDNS( url ) )
					pattern = new RegExp( "^" + protocol + dns + port, "ig" );				
				else
					pattern = new RegExp( "^" + protocol + ip + port, "ig" );
				//var pattern:RegExp 	= new RegExp( protocol, "ig" );
				
				var substr:String = url.replace( pattern, '' );*/
				
				var substr:String = getPathWithFileName( url );
				pattern = new RegExp( fileName, "ig" );
				
				return substr.replace( pattern, '' );
				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return null;			
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getPathWithFileName( url:String ) : String
		{
			if( check( url ) )
			{
				var pattern:RegExp;
				if( isDNS( url ) )
					pattern = new RegExp( "^" + protocol + auth + dns + port, "ig" );				
				else
					pattern = new RegExp( "^" + protocol + auth + ip + port, "ig" );
				//var pattern:RegExp 	= new RegExp( protocol, "ig" );
				
				var substr:String = url.replace( pattern, '' );
				return substr;
				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return null;			
		}
		
		/**
		 * 
		 * @param url
		 * @return 
		 * 
		 */		
		public static function getFileName( url:String ) : String
		{
			if( check( url ) )
			{
				var pattern:RegExp 	= new RegExp( fileName, "ig" );
				var match:Array 	= url.match( pattern );
				
				if( match && match.length == 1 )
				{
					var substr:String = match.shift();
					return substr.replace( "/", "" );					
				}				
			}
			else
			{
				throw new ArgumentError("Parameter url not correct");
			}
			
			return null;			
		}
	}
}