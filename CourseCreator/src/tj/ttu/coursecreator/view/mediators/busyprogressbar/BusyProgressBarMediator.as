////////////////////////////////////////////////////////////////////////////////
// Copyright May 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.mediators.busyprogressbar
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.components.components.progressbar.BusyProgressBar;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * BusyProgressBarMediator class 
	 */
	public class BusyProgressBarMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'BusyProgressBarMediator';
		public static const ERROR_NOTES:Array = [TTUConstants.SHOW_ERROR_WINDOW, 
			TTUConstants.FILE_LOAD_ERROR, 
			CourseServiceNotification.SHOW_ERROR_WINDOW
			
			];
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var topLevelApp:DisplayObject;
		private var busyProgressbarVO:BusyProgressbarVO;
		private  var notes:Vector.<BusyProgressbarVO>;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * BusyProgressBarMediator 
		 */
		public function BusyProgressBarMediator(viewComponent:BusyProgressBar, busyProgressbarVO:BusyProgressbarVO)
		{
			super(NAME, viewComponent);
			this.busyProgressbarVO = busyProgressbarVO;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private function get component():BusyProgressBar
		{
			return viewComponent as BusyProgressBar;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			notes = new Vector.<BusyProgressbarVO>();
			if(component)
			{
				notes.push( busyProgressbarVO );
				component.message = busyProgressbarVO.message;
				component.addEventListener(CloseEvent.CLOSE, onClosePopup);
				topLevelApp = FlexGlobals.topLevelApplication as DisplayObject;
				if(topLevelApp)
					topLevelApp.addEventListener(Event.RESIZE, onResize);
			}
		}
		
		
		/**
		 * @private
		 */		
		override public function onRemove() : void
		{
			if(component)
			{
				component.removeEventListener(CloseEvent.CLOSE, onClosePopup);
				PopUpManager.removePopUp(component as IFlexDisplayObject);
			}
			
			if(topLevelApp)
				topLevelApp.removeEventListener(Event.RESIZE, onResize);
			notes = null;
			topLevelApp = null;
			viewComponent = null;
			super.onRemove();
		}
		/**
		 * @inheritDoc 
		 */		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.SPIN_END,
				TTUConstants.SPIN_SUCCESS,
				TTUConstants.SPIN_ERROR,
				TTUConstants.SHOW_BUSY_PROGRESS_BAR,
				TTUConstants.FONT_LOADED];
		}
		
		/**
		 * @inheritDoc 
		 */			
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case TTUConstants.SPIN_SUCCESS:
					component.message = note.getBody() as String;
					component.isSuccess = true;
					break;
				case TTUConstants.SPIN_ERROR:
					component.message = note.getBody() as String;
					component.isError = true;
					break;
				case TTUConstants.FONT_LOADED:
					checkEndNote(new BusyProgressbarVO(null, TTUConstants.FONT_LOADED));
					break;
				case TTUConstants.SPIN_END:
					checkEndNote(note.getBody() as BusyProgressbarVO);
					break;
				case TTUConstants.SHOW_BUSY_PROGRESS_BAR:
					addIfNotExist(note.getBody() as BusyProgressbarVO);
					break;
				default:
					break;
			}
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
		private function checkEndNote(vo:BusyProgressbarVO):void
		{
			if(!notes)
				return;
			var shouldChangeUIMessage:Boolean;
			var item:BusyProgressbarVO;
			if(ERROR_NOTES.indexOf( vo.notification ) == -1)
			{
				for(var i:int = 0; i < notes.length; i++)
				{
					item = notes[i];
					if(item && item.notification == vo.notification)
					{
						if(component && component.message == item.message)
							shouldChangeUIMessage = true;
						notes.splice(i, 1);
						break;
					}
				}
			}
			else
				notes = null;
			
			if(notes && notes.length > 0)
			{
				if(shouldChangeUIMessage)
				{
					item = notes[0];
					component.message = item.message;
				}
			}
			else
				facade.removeMediator(NAME);
		}
		
		private function addIfNotExist(vo:BusyProgressbarVO):void
		{
			if(component && vo)
			{
				var exist:Boolean;
				var item:BusyProgressbarVO;
				for(var i:int = 0; i < notes.length; i++)
				{
					item = notes[i];
					if(item && item.notification == vo.notification)
					{
						exist = true;
						break;
					}
				}
				
				if(!exist)
				{
					notes.push( vo );
					component.message = vo.message;
				}
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
		
		/**
		 *  @private
		 */
		
		private function onClosePopup(event:Event):void
		{
			facade.removeMediator(NAME);
		}
		
		/**
		 *  @private
		 */
		private function onResize(event:Event):void
		{
			PopUpManager.centerPopUp(component as IFlexDisplayObject);
		}
	}
}