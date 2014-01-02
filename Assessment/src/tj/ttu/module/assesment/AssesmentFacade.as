////////////////////////////////////////////////////////////////////////////////
// Copyright Aug 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.controllers.DisposeCommand;
	import tj.ttu.module.assesment.controllers.GenerateTestDataCommand;
	import tj.ttu.module.assesment.controllers.ParseLessonXMLCommand;
	import tj.ttu.module.assesment.controllers.ReadConfigDataCommand;
	import tj.ttu.module.assesment.controllers.StartupCommand;
	import tj.ttu.moduleUtility.controller.LoadXMLCommand;
	
	/**
	 * AssesmentFacade class 
	 */
	public class AssesmentFacade extends Facade
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const FACADE_NAME:String = "Assesment";
		
		
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
		 * AssesmentFacade 
		 */
		public function AssesmentFacade(key:String)
		{
			super(key);
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
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(AssesmentNotifications.STARTUP, StartupCommand);
			registerCommand(AssesmentNotifications.DISPOSE, DisposeCommand);
			registerCommand(AssesmentNotifications.GENERATE_TEST_CONFIGURATION_DATA, GenerateTestDataCommand);
			registerCommand(AssesmentNotifications.READ_CONFIGURATION_DATA, ReadConfigDataCommand);
			registerCommand(TTUConstants.LOAD_XML, LoadXMLCommand);
			registerCommand(TTUConstants.XML_LOADED, ParseLessonXMLCommand);
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
		 * ApplicationFacade Factory Method
		 */
		public static function getInstance(key:String):AssesmentFacade
		{
			if (instanceMap[key] == null)
				instanceMap[key] = new AssesmentFacade(key);
			
			return instanceMap[key];
		}
		
		public function startup(application:Assessment, test:Boolean = false):void
		{
			this.sendNotification(AssesmentNotifications.STARTUP, application);
			
			if (test)
				sendNotification( AssesmentNotifications.GENERATE_TEST_CONFIGURATION_DATA );			
		}
		
		
		
	}
}