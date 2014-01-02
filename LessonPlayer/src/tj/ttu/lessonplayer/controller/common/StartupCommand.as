////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 5, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.model.font.FontManagerProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.lessonplayer.model.LessonPlayerProxy;
	import tj.ttu.lessonplayer.view.interfaces.ILessonPlayer;
	import tj.ttu.lessonplayer.view.mediators.LessonPlayerAplicationMediator;
	import tj.ttu.lessonplayer.view.mediators.main.LessonPlayerMainViewMediator;
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
			var app:ILessonPlayer = note.getBody() as ILessonPlayer;
			if(app)
			{
				//proxies
				var confProxy:AppConfigProxy = new AppConfigProxy();
				confProxy.rootDataPath = LessonPlayerProxy.CONTENT_PATH;
				facade.registerProxy( confProxy );
				facade.registerProxy( new FontManagerProxy());
				facade.registerProxy( new ResourceProxy());
				facade.registerProxy( new ModuleProxy());
				facade.registerProxy( new AssessmentProxy());
				facade.registerProxy( new LessonPlayerProxy());
				
				//mediators
				facade.registerMediator( new LessonPlayerAplicationMediator(app));
				facade.registerMediator( new LessonPlayerMainViewMediator(app.iMainView));
				
				sendNotification(TTUConstants.LOAD_XML, LessonPlayerProxy.UNIT_URL);
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