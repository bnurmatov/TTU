////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 5, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.model.font.FontManagerProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.coursecreator.view.interfaces.ICourseCreator;
	import tj.ttu.coursecreator.view.mediators.CCAplicationMediator;
	import tj.ttu.coursecreator.view.mediators.main.CCHolderMediator;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	
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
		override public function execute(note:INotification):void
		{
			var app:ICourseCreator = note.getBody() as ICourseCreator;
			if(app)
			{
				//proxies
				facade.registerProxy( new AppConfigProxy());
				facade.registerProxy( new FontManagerProxy());
				facade.registerProxy( new ResourceProxy());
				facade.registerProxy( new DatabaseManagerProxy());
				facade.registerProxy( new ModuleProxy());
				facade.registerProxy( new AssessmentProxy());
				
				
				//mediators
				facade.registerMediator( new CCAplicationMediator(app));
				facade.registerMediator( new CCHolderMediator(app.iholder));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
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