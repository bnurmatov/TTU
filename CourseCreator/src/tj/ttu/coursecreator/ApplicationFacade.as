////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator
{
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.controller.popup.ShowErrorWindowCommand;
	import tj.ttu.base.controller.popup.ShowImageViewWindowCommand;
	import tj.ttu.base.controller.popup.ShowVideoPlayerWindowCommand;
	import tj.ttu.coursecreator.controller.busyProgressBar.ShowBusyProgressBarCommand;
	import tj.ttu.coursecreator.controller.common.DisposeCommand;
	import tj.ttu.coursecreator.controller.common.StartupCommand;
	import tj.ttu.coursecreator.controller.data.SetModuleDataCommand;
	import tj.ttu.coursecreator.controller.locale.LanguageChangeCommand;
	import tj.ttu.coursecreator.view.interfaces.ICourseCreator;
	
	/**
	 * ApplicationFacade class 
	 */
	public class ApplicationFacade extends Facade implements IFacade
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
		 * ApplicationFacade 
		 */
		public function ApplicationFacade(key:String)
		{
			super(key);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance( key:String ) : ApplicationFacade 
		{
			if ( instanceMap[ key ] == null ) 
				instanceMap[ key ]  = new ApplicationFacade( key );
			
			return instanceMap[ key ] as ApplicationFacade;
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Register Commands with the Controller 
		 */
		override protected function initializeController(): void 
		{
			super.initializeController();
			
			//common
			registerCommand(TTUConstants.STARTUP, StartupCommand);
			registerCommand(TTUConstants.DISPOSE, DisposeCommand);
			
			registerCommand(TTUConstants.LANGUAGE_CHANGE, LanguageChangeCommand);
			registerCommand(TTUConstants.SHOW_IMAGE_FULL_SCREEN_WINDOW, ShowImageViewWindowCommand);
			registerCommand(TTUConstants.SHOW_VIDEO_PLAYER, ShowVideoPlayerWindowCommand);
			registerCommand(TTUConstants.SHOW_ERROR_WINDOW, ShowErrorWindowCommand);
			registerCommand(TTUConstants.SET_MODULE_DATA, SetModuleDataCommand);
			registerCommand(TTUConstants.SHOW_BUSY_PROGRESS_BAR, ShowBusyProgressBarCommand);
			
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
		 * Starts the application
		 */
		public function startup(app:ICourseCreator):void
		{
			sendNotification( TTUConstants.STARTUP, app );
		}		
		
		/**  
		 *  Sends <code>CourseAplicationFacade.DISPOSE</code> notification,
		 *  which executes <code>DisposeCommand</code>
		 * 	@see tj.ttu.controller.DisposeCommand;
		 */ 
		public function dispose(key:String):void
		{
			sendNotification(TTUConstants.DISPOSE,key );
		}
		
		
	}
}