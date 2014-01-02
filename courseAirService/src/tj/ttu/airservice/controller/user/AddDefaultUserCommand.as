////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 27, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.user
{
	import flash.data.SQLStatement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	
	/**
	 * AddUserCommand class 
	 */
	public class AddDefaultUserCommand extends BaseAirCommand
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Dummy username, created for the single user system.
		 */
		public static const DEFAULT_USERNAME:String = "defaultUsername";
		
		/** 
		 * Dummy password, created for the single user system.
		 */
		public static const DEFAULT_PASSWORD:String = "defaultPassword";
		
		/**
		 * Default role, created for the single user system.
		 */
		public static const DEFAULT_ROLE:String = "defaultRole";
		
		
		
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
		 * AddUserCommand 
		 */
		public function AddDefaultUserCommand()
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
		override public function execute( notification:INotification ) : void
		{
			// create statement, and set parameters
			var statement:SQLStatement = databaseManagerProxy.getSQLStatement(SqlQueryConstants.CREATE_DEFAULT_USER_SQL_KEY);
			statement.parameters[':login']					= DEFAULT_USERNAME;
			statement.parameters[':password']				= DEFAULT_PASSWORD;
			statement.parameters[':role']					= DEFAULT_ROLE;
			
			// create our request, and execute
			var request:AirRequestVO = new AirRequestVO();
			request.statement = statement;
			//request.nextNote = BykiConstants.CREATE_DEFAULT_USER_COMPLETE;
			databaseManagerProxy.executeRequest(request);
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