package tj.ttu.components.components.validator
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class URLValidator extends Validator 
	{
		// Define Array for the return value of doValidation().
		private var results:Array;
		
		public function URLValidator ()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array 
		{
			var url:String = value as String;
			if(!url || url == "")
				return [];
			
			results = [];
			results = super.doValidation(value);        
			if (results.length > 0 )
				return results;
			
			var urlPat:RegExp = /^(((ht|f)tp(s?):\/\/)?([-a-z0-9]*\.+)?[-a-zA-Z0-9]*\.[-a-zA-Z]+)([\/&\?=\.;%\+\$@~][\S]*)?/;
			if (!urlPat.test(url)) 
			{
				results.push(new ValidationResult(true, "url", "malformedUrl", "URL is malformed"));
				return results;
			}
				return results;
		}
	}
}
			