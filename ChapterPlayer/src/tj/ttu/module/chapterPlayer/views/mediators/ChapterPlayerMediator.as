////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.mediators
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.events.ElementExistenceEvent;
	
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.module.chapterPlayer.views.components.ChapterPlayerPanel;
	import tj.ttu.module.chapterPlayer.views.components.StartScreenView;
	
	/**
	 * ChapterPlayerMediator class 
	 */
	public class ChapterPlayerMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterPlayerMediator';
		
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
		 * ChapterPlayerMediator 
		 */
		public function ChapterPlayerMediator(viewComponent:ChapterPlayer)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get application():ChapterPlayer
		{
			return viewComponent as ChapterPlayer;
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
				application.addEventListener(ChapterPlayerNotifications.DISPOSE, onAplicationDispose);
				application.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, onElementRemove);
				application.addEventListener(ElementExistenceEvent.ELEMENT_ADD, onElementAdd);
				
				if(application.startScreen)
				{
					if(!facade.hasMediator(StartScreenMediator.NAME))
						facade.registerMediator(new StartScreenMediator(application.startScreen as StartScreenView));
				}
				
				if(application.content)
				{
					if(!facade.hasMediator(ChapterPlayerPanelMediator.NAME))
						facade.registerMediator(new ChapterPlayerPanelMediator(application.content as ChapterPlayerPanel));
				}
			}
		}
		
		override public function onRemove():void
		{
			if(application)
			{
				application.removeEventListener(ChapterPlayerNotifications.DISPOSE, onAplicationDispose);
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
				case ChapterPlayerNotifications.CHANGE_MODULE_STATE:
				{
					if(application)
						application.currentState = note.getBody() as String;
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [ChapterPlayerNotifications.CHANGE_MODULE_STATE];
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
			sendNotification(ChapterPlayerNotifications.DISPOSE);
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
				if(!facade.hasMediator(ChapterPlayerPanelMediator.NAME))
					facade.registerMediator(new ChapterPlayerPanelMediator(element as ChapterPlayerPanel));
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
				if(facade.hasMediator(ChapterPlayerPanelMediator.NAME))
					facade.removeMediator(ChapterPlayerPanelMediator.NAME);
			}
		}
		
	}
}