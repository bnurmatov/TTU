////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 18, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.state
{
	import mx.events.StateChangeEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	
	/**
	 * MainViewStateChangeCommand class 
	 */
	public class MainViewStateChangeCommand extends SimpleCommand
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
		 * MainViewStateChangeCommand 
		 */
		public function MainViewStateChangeCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _courseProxy:CourseProxy;
		
		private function get courseProxy():CourseProxy
		{
			if(!_courseProxy)
				_courseProxy = facade.retrieveProxy(CourseProxy.NAME) as CourseProxy;
			return _courseProxy;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute( note:INotification ) : void
		{
			var event:StateChangeEvent = note.getBody() as StateChangeEvent;
			if(courseProxy)
			{
				courseProxy.currentMainViewState = event.newState; 
				if(courseProxy.hasNotification)
					courseProxy.sendQueueNotification();
			}
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