////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * RemoveAirCommand class 
	 */
	public class RemoveAirCommand extends SimpleCommand
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
		 * RemoveAirCommand 
		 */
		public function RemoveAirCommand()
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
			facade.removeCommand(CourseAirConstants.CREATE_DB_SCHEMA);
			facade.removeCommand(CourseAirConstants.INSERT_DB_DATA);
			
			//default user
			facade.removeCommand(CourseAirConstants.ADD_DEFAULT_USER);
			
			//lesson
			facade.removeCommand(CourseServiceNotification.CREATE_LESSON);
			facade.removeCommand(CourseAirConstants.CREATE_LOCAL_LESSON_COMPLETE);
			facade.removeCommand(CourseServiceNotification.UPDATE_LESSON);
			facade.removeCommand(CourseAirConstants.UPDATE_LOCAL_LESSON_COMPLETE);
			facade.removeCommand(CourseServiceNotification.VALIDATE_LESSON_NAME);
			facade.removeCommand(CourseAirConstants.PARSE_LOCAL_LESSONS);
			facade.removeCommand(CourseServiceNotification.RETRIEVE_LESSONS_BY_DEPARTMENT);
			facade.removeCommand(CourseServiceNotification.ASSOCIATE_LESSON_AUDIO);
			facade.removeCommand(CourseServiceNotification.ASSOCIATE_CHAPTER_AUDIO);
			facade.removeCommand(CourseAirConstants.LESSON_SOUND_DATA_LOADED);
			facade.removeCommand(CourseAirConstants.SAVE_LOCAL_SOUND_COMPLETE);
			facade.removeCommand(CourseServiceNotification.ASSOCIATE_IMAGE);
			facade.removeCommand(CourseAirConstants.SAVE_LOCAL_IMAGE_COMPLETE);
			
			//Chapter
			facade.removeCommand(CourseServiceNotification.ADD_NEW_CHAPTER);
			facade.removeCommand(CourseAirConstants.ADD_NEW_LOCAL_CAHPTER);
			facade.removeCommand(CourseAirConstants.ADD_NEW_LOCAL_CAHPTER_COMPLETE);
			
			//resource
			facade.removeCommand(CourseServiceNotification.ADD_NEW_RESOURCE);
			facade.removeCommand(CourseServiceNotification.RETRIEVE_RESOURCES);
			facade.removeCommand(CourseServiceNotification.REMOVE_RESOURCE);
			facade.removeCommand(CourseAirConstants.ADD_NEW_LOCAL_RESOURCE);
			facade.removeCommand(CourseAirConstants.ADD_NEW_LOCAL_RESOURCE_COMPLETE);
			facade.removeCommand(CourseAirConstants.RETRIEVE_LESSON_RESOURCES_COMPLETE);
			facade.removeCommand(CourseServiceNotification.UPDATE_RESOURCES);
			facade.removeCommand(CourseAirConstants.UPDATE_LOCAL_LESSON_RESOURCES_COMPLETE);
			facade.removeCommand(CourseAirConstants.PARSE_LOCAL_LESSON_RESOURCES);
			facade.removeCommand(CourseAirConstants.DELETE_RESOURCE_ASSETS_FROM_DISK);
			
			
			//department
			facade.removeCommand(CourseServiceNotification.RETRIEVE_DEPARTMENTS);
			
			//speciality
			facade.removeCommand(CourseServiceNotification.RETRIEVE_SPECIALITIES);
			
			//user settings
			facade.removeCommand(CourseServiceNotification.UPDATE_USER_SETTINGS);
			facade.removeCommand(CourseAirConstants.UPDATE_USER_SETTINGS_COMPLETE);
			facade.removeCommand(CourseServiceNotification.RETRIEVE_USER_SETTINGS);
			
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