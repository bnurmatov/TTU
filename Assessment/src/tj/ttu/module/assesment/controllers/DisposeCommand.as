////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.controllers
{
	import flash.system.System;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tj.ttu.module.assesment.AssesmentFacade;
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	import tj.ttu.module.assesment.views.mediators.AssesmentMediator;
	import tj.ttu.module.assesment.views.mediators.AssesmentPlayerMediator;
	import tj.ttu.module.assesment.views.mediators.StartScreenMediator;
	import tj.ttu.module.assesment.views.mediators.junction.AssesmentJunctionMediator;
	
	/**
	 * DisposeCommand class 
	 */
	public class DisposeCommand extends SimpleCommand
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
		 * DisposeCommand 
		 */
		public function DisposeCommand()
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
			//commands
			facade.removeCommand(AssesmentNotifications.STARTUP);
			facade.removeCommand(AssesmentNotifications.DISPOSE);
			facade.removeCommand(AssesmentNotifications.GENERATE_TEST_CONFIGURATION_DATA);
			facade.removeCommand(AssesmentNotifications.READ_CONFIGURATION_DATA);
			
			//mediators
			facade.removeMediator(AssesmentMediator.NAME);
			facade.removeMediator(AssesmentPlayerMediator.NAME);
			facade.removeMediator(StartScreenMediator.NAME);
			facade.removeMediator(AssesmentJunctionMediator.NAME);
			
			//models
			facade.removeProxy(AssesmentPlayerProxy.NAME);
			
			Facade.removeCore(AssesmentFacade.FACADE_NAME);
			
			try
			{
				System.gc();
			} 
			catch(error:Error) 
			{
				
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