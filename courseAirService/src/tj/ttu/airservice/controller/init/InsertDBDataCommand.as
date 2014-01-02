////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.init
{
	import flash.data.SQLStatement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.airservice.utils.EmbeddedSqls;
	
	/**
	 * InsertDBDataCommand class 
	 */
	public class InsertDBDataCommand extends BaseAirCommand
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 * The delimiter separates between SQL statements.
		 */		
		public static const DELIMITER_SQL_STATEMENT:String = "$$";
		
		
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
		 * InsertDBDataCommand 
		 */
		public function InsertDBDataCommand()
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
			// fetch schema's data statements
			var statements:Array = getSchemaDataStatements();
			
			// create vars for loop, and begin transaction
			var statement:SQLStatement;
			var request:AirRequestVO;
			databaseManagerProxy.beginTransaction();
			
			// iterate through, creating SQLStatement for each query - do not commit
			for(var i:uint = 0; i < statements.length; i++)
			{
				statement = new SQLStatement();
				statement.text = statements[i];
				request = new AirRequestVO();
				request.statement = statement;
				databaseManagerProxy.executeRequest(request);
			}
			
			// end transaction 
			databaseManagerProxy.endTransaction(CourseAirConstants.ADD_DEFAULT_USER);
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
		/**
		 * Read all schema's data resources into an array of strings.
		 */
		private function getSchemaDataStatements():Array
		{
			var statements:Array = [];
			
			// table's data
			statements = statements.concat(getMultiStatements(String(new EmbeddedSqls.SpecData)));
			statements = statements.concat(getMultiStatements(String(new EmbeddedSqls.KaferdraData)));
			
			return statements;
		}
		
		
		/**
		 * Create multi SQL statements
		 * 
		 * @param statements	SQL statements
		 * @return 				New array of SQL statements
		 */		
		public static function getMultiStatements(statements:String):Array
		{
			if(!statements)
				return null;
			
			// ignore SQLite comments single command (--) and multiple comment (/**/)
			statements = statements.replace(/(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|(\-\-.*)/ig, "");
			// replace all new line sympols
			statements = statements.replace(/[\r\n\t]/ig, "");
			// clear empty items
			return removeEmptyStatements(statements.split(DELIMITER_SQL_STATEMENT));
		}
		
		/**
		 * Clear empty items from the array.
		 * 
		 * @param statements	An array of <code>String</code> objects representing the SQL statements
		 * @return 				New array without empty items
		 */		
		public static function removeEmptyStatements(statements:Array):Array
		{
			var arr:Array = [];
			
			for each (var statement:String in statements) 
			{
				if(statement)
					arr.push(statement);
			}
			
			return arr;
		}
		
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