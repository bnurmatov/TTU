////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.department
{
	import flash.data.SQLStatement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.base.vo.DepartmentVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RetrieveDepartmentsCommand class 
	 */
	public class RetrieveDepartmentsCommand extends BaseAirCommand
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
		 * RetrieveDepartmentsCommand 
		 */
		public function RetrieveDepartmentsCommand()
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
			// fetch statement, and set itemClass for return data
			var statement:SQLStatement = databaseManagerProxy.getSQLStatement(SqlQueryConstants.GET_DEPARTMENTS_SQL_KEY);
			statement.parameters[':locale'] = resourceProxy.locale;
			statement.itemClass = DepartmentVO;
			
			
			// create our request object
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote 	= CourseServiceNotification.DEPARTMENTS_RETRIEVED;
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