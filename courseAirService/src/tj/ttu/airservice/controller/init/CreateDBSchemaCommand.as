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
	 * CreateDBSchemaCommand class 
	 */
	public class CreateDBSchemaCommand extends BaseAirCommand
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
		 * CreateDBSchemaCommand 
		 */
		public function CreateDBSchemaCommand()
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
			// fetch schema statements
			var statements:Array = getSchemaStatements();
			
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
			// end transaction - insert data upon completion
			databaseManagerProxy.endTransaction(CourseAirConstants.INSERT_DB_DATA);
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
		private function getSchemaStatements():Array
		{
			var statements:Array = [];
			
			// tables
			statements.push(String(new EmbeddedSqls.Spec));
			statements.push(String(new EmbeddedSqls.Lessons));
			statements.push(String(new EmbeddedSqls.Kaferdra));
			statements.push(String(new EmbeddedSqls.Users));
			statements.push(String(new EmbeddedSqls.UserLessons));
			statements.push(String(new EmbeddedSqls.Images));
			statements.push(String(new EmbeddedSqls.Sounds));
			statements.push(String(new EmbeddedSqls.Video));
			statements.push(String(new EmbeddedSqls.Chapters));
			statements.push(String(new EmbeddedSqls.Questions));
			statements.push(String(new EmbeddedSqls.Answers));
			statements.push(String(new EmbeddedSqls.Resources));
			statements.push(String(new EmbeddedSqls.Artifacts));
			statements.push(String(new EmbeddedSqls.UserSettings));
			
			// triggers
			statements.push(String(new EmbeddedSqls.UsersInsertTrigger));
			statements.push(String(new EmbeddedSqls.LessonsDeleteTrigger));
			statements.push(String(new EmbeddedSqls.ChaptersDeleteTrigger));
			statements.push(String(new EmbeddedSqls.QuestionsDeleteTrigger));
			
			return statements;
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