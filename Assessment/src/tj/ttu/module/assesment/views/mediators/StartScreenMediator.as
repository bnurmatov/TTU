////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	import tj.ttu.module.assesment.views.components.StartScreenView;
	import tj.ttu.module.assesment.views.events.ActivityEvent;
	import tj.ttu.moduleUtility.view.components.ActivityModuleState;
	
	/**
	 * StartScreenMediator class 
	 */
	public class StartScreenMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'StartScreenMediator';
		
		
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
		 * StartScreenMediator 
		 */
		public function StartScreenMediator(viewComponent:StartScreenView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():StartScreenView
		{
			return viewComponent as StartScreenView;
		}
		
		private var _assesmentProxy:AssesmentPlayerProxy;
		
		public function get assesmentProxy():AssesmentPlayerProxy
		{
			if(!_assesmentProxy)
				_assesmentProxy = facade.retrieveProxy( AssesmentPlayerProxy.NAME ) as AssesmentPlayerProxy;
			return _assesmentProxy;
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
				component.addEventListener(ActivityEvent.START, onStartLesson);
				setData();
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(ActivityEvent.START, onStartLesson);
				component.resetComponent();
			}
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			switch(notification.getName())
			{
				case AssesmentNotifications.CONFIGURATION_DATA_LOADED:
					setData();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [AssesmentNotifications.CONFIGURATION_DATA_LOADED];
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
		private function setData():void
		{
			if(component && assesmentProxy)
			{
				component.activityDescription 	= assesmentProxy.moduleDescription;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onStartLesson(event:Event):void
		{
			sendNotification(AssesmentNotifications.CHANGE_MODULE_STATE, ActivityModuleState.CONTENT);
			facade.removeMediator( NAME );
		}
	}
}