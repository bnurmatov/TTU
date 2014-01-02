////////////////////////////////////////////////////////////////////////////////
// Copyright Aug 28, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.mediators
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.ElementExistenceEvent;
	
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.views.components.AssesmentPlayer;
	import tj.ttu.module.assesment.views.components.StartScreenView;
	
	/**
	 * AssesmentMediator class 
	 */
	public class AssesmentMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'AssesmentMediator';
		
		
		
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
		 * AssesmentMediator 
		 */
		public function AssesmentMediator(viewComponent:Assessment)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get application():Assessment
		{
			return viewComponent as Assessment;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
			if(application)
			{
				application.addEventListener(AssesmentNotifications.DISPOSE, onAplicationDispose);
				application.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, onElementRemove);
				application.addEventListener(ElementExistenceEvent.ELEMENT_ADD, onElementAdd);
				
				if(application.startScreen)
				{
					if(!facade.hasMediator(StartScreenMediator.NAME))
						facade.registerMediator(new StartScreenMediator(application.startScreen as StartScreenView));
				}
				
				if(application.content)
				{
					if(!facade.hasMediator(AssesmentPlayerMediator.NAME))
						facade.registerMediator(new AssesmentPlayerMediator(application.content as AssesmentPlayer));
				}
			}
		}
		
		override public function onRemove():void
		{
			if(application)
			{
				application.removeEventListener(AssesmentNotifications.DISPOSE, onAplicationDispose);
				application.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, onElementRemove);
				application.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, onElementAdd);
			}
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case AssesmentNotifications.CHANGE_MODULE_STATE:
				{
					if(application)
						application.currentState = note.getBody() as String;
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [AssesmentNotifications.CHANGE_MODULE_STATE];
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
		
		protected function onAplicationDispose(event:Event):void
		{
			sendNotification(AssesmentNotifications.DISPOSE);
		}
		
		/**
		 * @private
		 */
		private function onElementAdd(event:ElementExistenceEvent):void
		{
			var element:IVisualElement = event.element;
			if(element["id"] == "startScreen")
			{
				if(!facade.hasMediator(StartScreenMediator.NAME))
					facade.registerMediator(new StartScreenMediator(element as StartScreenView));
			}
			else if(element["id"] == "content")
			{
				if(!facade.hasMediator(AssesmentPlayerMediator.NAME))
					facade.registerMediator(new AssesmentPlayerMediator(element as AssesmentPlayer));
			}
		}
		
		/**
		 * @private
		 */		
		private function onElementRemove(event:ElementExistenceEvent):void
		{
			var element:IVisualElement = event.element
			if(element["id"] == "startScreen")
			{
				if(facade.hasMediator(StartScreenMediator.NAME))
					facade.removeMediator(StartScreenMediator.NAME);
			}
			else if(element["id"] == "content")
			{
				if(facade.hasMediator(AssesmentPlayerMediator.NAME))
					facade.removeMediator(AssesmentPlayerMediator.NAME);
			}
		}
		
	}
}