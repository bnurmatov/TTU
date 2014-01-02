////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.controller.data
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.ModuleData;
	import tj.ttu.lessonplayer.controller.BaseCommand;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	
	/**
	 * SetModuleDataCommand class 
	 */
	public class SetModuleDataCommand extends BaseCommand
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		private static const ACT_URL				:	String = "CourseCreator";
		
		private static const SORT_FIELD				:	String = "title";
		
		
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
		 * SetModuleDataCommand 
		 */
		public function SetModuleDataCommand()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(note:INotification):void
		{
			if(facade.hasProxy(ModuleProxy.NAME))
				facade.removeProxy(ModuleProxy.NAME);
			
			facade.registerProxy( new ModuleProxy());
			
			var lesson:LessonVO = note.getBody() as LessonVO;
			
			// sort chapters by alphabetical order
			if(lesson.chapters && !lesson.isOrdered)
				lesson.chapters.sortOn(SORT_FIELD, Array.CASEINSENSITIVE);
			
			moduleProxy.lesson = lesson;
			//lesson.url = ACT_URL;
			moduleProxy.modules = ModuleData.getInstance().moduleList;
			sendNotification(TTUConstants.MODULE_DATA_LOADED);
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