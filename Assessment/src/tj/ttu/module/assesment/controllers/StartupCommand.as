////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.controllers
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	import tj.ttu.module.assesment.views.mediators.AssesmentMediator;
	import tj.ttu.module.assesment.views.mediators.junction.AssesmentJunctionMediator;
	
	/**
	 * StartupCommand class 
	 */
	public class StartupCommand extends SimpleCommand
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
		 * StartupCommand 
		 */
		public function StartupCommand()
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
			var app:Assessment = notification.getBody() as Assessment;
			facade.registerProxy(new AssesmentPlayerProxy());
			facade.registerMediator(new AssesmentMediator(app));
			facade.registerMediator(new AssesmentJunctionMediator());
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