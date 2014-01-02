////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.speciality
{
	import flash.data.SQLStatement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.SqlQueryConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.model.vo.AirRequestVO;
	import tj.ttu.base.vo.SpecialityVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RetrieveSpecialitiesCommand class 
	 */
	public class RetrieveSpecialitiesCommand extends BaseAirCommand
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
		 * RetrieveSpecialitiesCommand 
		 */
		public function RetrieveSpecialitiesCommand()
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
			var statement:SQLStatement = databaseManagerProxy.getSQLStatement(SqlQueryConstants.GET_SPECIALITIES_SQL_KEY);
			statement.itemClass = SpecialityVO;
			
			
			// create our request object
			var request:AirRequestVO = new AirRequestVO();
			request.statement 	= statement;
			request.nextNote 	= CourseServiceNotification.SPECIALITIES_RETRIEVED;
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