////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 2, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.mediators.main
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.coursecreator.view.components.CCHeader;
	import tj.ttu.coursecreator.view.events.AppHeaderEvent;
	
	/**
	 * CCHeaderMediator class 
	 */
	public class CCHeaderMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CCHeaderMediator';
		
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
		 * CCHeaderMediator 
		 */
		public function CCHeaderMediator(viewComponent:CCHeader)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CCHeader
		{
			return viewComponent as CCHeader;
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
				component.addEventListener(AppHeaderEvent.GET_HELP, onShowHelp);
				component.addEventListener(AppHeaderEvent.LANGUAGE_CHANGE, onLanguageChange);
				if(component.language)
					sendNotification( TTUConstants.LANGUAGE_CHANGE, component.language );
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				component.removeEventListener(AppHeaderEvent.GET_HELP, onShowHelp);
				component.removeEventListener(AppHeaderEvent.LANGUAGE_CHANGE, onLanguageChange);
				component.language = null;
			}
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return super.listNotificationInterests();
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
		protected function onLanguageChange(event:AppHeaderEvent):void
		{
			sendNotification( TTUConstants.LANGUAGE_CHANGE, event.data );
		}
		
		protected function onShowHelp(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		
		
	}
}