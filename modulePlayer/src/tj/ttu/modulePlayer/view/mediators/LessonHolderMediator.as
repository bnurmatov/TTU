////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.SkinPartEvent;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.ModuleData;
	import tj.ttu.components.events.AudioSettingEvent;
	import tj.ttu.modulePlayer.controller.HandleModuleMessageCommand;
	import tj.ttu.modulePlayer.controller.HideModuleCommand;
	import tj.ttu.modulePlayer.controller.ModuleRemovedCommand;
	import tj.ttu.modulePlayer.controller.SendModuleSettingsCommand;
	import tj.ttu.modulePlayer.controller.popup.ShowLearningPopup;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.view.components.LessonHolder;
	import tj.ttu.modulePlayer.view.events.LessonHolderEvent;
	
	/**
	 * LessonHolderMediator class 
	 */
	public class LessonHolderMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'LessonHolderMediator';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var notReady:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonHolderMediator 
		 */
		public function LessonHolderMediator(viewComponent:LessonHolder)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():LessonHolder
		{
			return viewComponent as LessonHolder;	
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
			if(component)
			{
				if(facade.hasMediator(LessonHolderHeaderMediator.NAME))
					facade.removeMediator(LessonHolderHeaderMediator.NAME);
				facade.registerMediator(new LessonHolderHeaderMediator(component.lessonHolderHeader));
				
				if(facade.hasMediator(LessonHolderMainViewMediator.NAME))
					facade.removeMediator(LessonHolderMainViewMediator.NAME);
				facade.registerMediator(new LessonHolderMainViewMediator(component.lessonHolderMainView));
				
			}
		}
		
		
		override public function onRemove():void
		{
			if(component)
			{
				facade.removeMediator(LessonHolderHeaderMediator.NAME);
				facade.removeMediator(LessonHolderMainViewMediator.NAME);
				component.resetComponent();
			}
			
			viewComponent = null;
			super.onRemove();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
	}
}