////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.popup
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * 
	 *  Dispatched when the user presses the buttonOk button.
	 *
	 *  @eventType flash.events.Event
	 * 
	 */
	[Event(name="ok", type="flash.events.Event")]
	
	/**
	 * 
	 * Dispatched when the user presses the buttonCancel button.
	 *
	 * @eventType flash.events.Event
	 * 
	 */
	[Event(name="cancel", type="flash.events.Event")]
	
	[Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]
	/**
	 * PopupWindow class 
	 */
	public class PopupWindow extends SkinnableComponent 
	{
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * A skin part that defines the buttonClose of the component. 
		 * 
		 */
		[SkinPart(required="false")]
		public var buttonClose:Button;
		
		/**
		 * 
		 * A skin part that defines the buttonOk of the component. 
		 * 
		 */
		[SkinPart(required="false")]
		public var buttonOk:Button;
		
		/**
		 * 
		 * A skin part that defines the buttonCancel of the component.
		 * 
		 */
		[SkinPart(required="false")]
		public var buttonCancel:Button;
		
		/**
		 * 
		 * A skin part that defines the labelMessage of the component.
		 *  
		 */
		[SkinPart(required="false")]
		public var labelMessage:Label;
		
		/**
		 * 
		 * A skin part that defines the labelTitle of the component.
		 *  
		 */
		[SkinPart(required="false")]
		public var labelTitle:Label;
		
		/**
		 * 
		 * A skin part that defines the labelMessage of the component.
		 *  
		 */
		[SkinPart(required="false")]
		public var detailMessage:Label;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Storage for ok event name
		 * 
		 */
		public static const OK:String = "ok";
		
		/**
		 * 
		 * Storage for cancel event name
		 * 
		 */
		public static const CANCEL:String = "cancel";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var active:Boolean = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * PopupWindow 
		 */
		public function PopupWindow()
		{
			super();
			hasFocusableChildren = true;
			
			addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------		
		//-----------------------------------------
		// message
		//-----------------------------------------
		protected var messageChanged:Boolean = false;
		
		/**
		 * 
		 * Internal storage for message.
		 * 
		 */
		protected var _message:String;
		
		/**
		 * 
		 * Storage for message.
		 * 
		 */		
		public function get message() : String
		{
			return _message;
		}
		
		/**
		 * 
		 * @private
		 * 
		 */
		public function set message( value:String ) : void
		{
			if( _message != value )
			{
				_message = value;
				messageChanged = true;
				
				invalidateProperties();
			}
		}
		//-----------------------------------------
		// messageDetail
		//-----------------------------------------
		private var messageDetailChanged:Boolean = false;
		private var _messageDetail:String;

		public function get messageDetail():String
		{
			return _messageDetail;
		}

		public function set messageDetail(value:String):void
		{
			if( _messageDetail !== value)
			{
				_messageDetail = value;
				messageDetailChanged = true;
				invalidateProperties();
			}
		}

		//-----------------------------------------
		// title
		//-----------------------------------------
		private var titleChanged:Boolean = false;
		private var _title:String;

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			if( _title !== value)
			{
				_title = value;
				titleChanged = true;
				invalidateProperties();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------	
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		override public function parentChanged( parent:DisplayObjectContainer ) : void
		{
			if ( focusManager )
			{
				focusManager.removeEventListener( FlexEvent.FLEX_WINDOW_ACTIVATE,  activateHandler );
				focusManager.removeEventListener( FlexEvent.FLEX_WINDOW_DEACTIVATE, deactivateHandler );
			}
			
			super.parentChanged( parent );
			
			if ( focusManager )
			{
				addActivateHandlers();
			}
			else
			{
				// if no focusmanager yet, add capture phase to detect when it
				// gets added
				if ( systemManager )
				{
					systemManager.getSandboxRoot().addEventListener(
						FlexEvent.ADD_FOCUS_MANAGER, addFocusManagerHandler, true, 0, true );
				}
				else
				{
					// no systemManager yet?  Check again when added to stage
					addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
				}
			}
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		override protected function commitProperties() : void
		{
			super.commitProperties();
			
			if( messageChanged && labelMessage )
			{
				labelMessage.text = _message;
				messageChanged = false;
			}
			
			if( messageDetailChanged && detailMessage )
			{
				detailMessage.text = _messageDetail;
				messageDetailChanged = false;
			}
			
			if(titleChanged && labelTitle)
			{
				labelTitle.text = _title;
				titleChanged = false;
			}
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override public function setFocus():void
		{
			if( stage )
				stage.focus = this;
			else
				super.setFocus();
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		override protected function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
			
			if( instance == buttonOk )
			{
				buttonOk.addEventListener( MouseEvent.CLICK, onOkHandler );
			}
			else if( instance == buttonCancel )
			{
				buttonCancel.addEventListener( MouseEvent.CLICK, onCancelHandler );
			}
			else if( instance == buttonClose )
			{
				buttonClose.addEventListener( MouseEvent.CLICK, onClose );
			}
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		override protected function partRemoved( partName:String, instance:Object ) : void
		{
			if( instance == buttonOk )
			{
				buttonOk.removeEventListener( MouseEvent.CLICK, onOkHandler );
			}
			else if( instance == buttonCancel )
			{
				buttonCancel.removeEventListener( MouseEvent.CLICK, onCancelHandler );
			}
			else if( instance == buttonClose )
			{
				buttonClose.removeEventListener( MouseEvent.CLICK, onClose );
			}
			super.partRemoved( partName, instance );
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override protected function keyDownHandler( event:KeyboardEvent ) : void
		{
			super.keyDownHandler( event );
			
			if( event.keyCode == Keyboard.ENTER )
				onOkHandler();
			else if( event.keyCode == Keyboard.ESCAPE )
				onClose(null);
		}		
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Add listeners to focusManager
		 * 
		 */
		private function addActivateHandlers() : void
		{
			focusManager.addEventListener( FlexEvent.FLEX_WINDOW_ACTIVATE, 
				activateHandler, false, 0, true );
			focusManager.addEventListener( FlexEvent.FLEX_WINDOW_DEACTIVATE, 
				deactivateHandler, false, 0, true );
		}		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Handler for <code>MouseEvent.CLICK</code> event dispatched by buttonOk.
		 * 
		 * @param event The <code>MouseEvent</code> event dispatched by buttonOk.
		 * 
		 */ 
		protected function onOkHandler( event:MouseEvent = null ) : void
		{
			dispatchEvent( new Event( OK ) );
		}
		
		/**
		 * 
		 * Handler for <code>MouseEvent.CLICK</code> event dispatched by buttonCancel.
		 * 
		 * @param event The <code>MouseEvent</code> event dispatched by buttonCancel.
		 * 
		 */ 
		protected function onCancelHandler( event:MouseEvent = null ) : void
		{
			dispatchEvent( new Event( CANCEL ) );
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent( new Event(Event.CLOSE));
		}
		
		/**
		 * 
		 * Handler for <code>FlexEvent.FLEX_WINDOW_ACTIVATE</code> event dispatched by focusManager.
		 * 
		 * @param event The <code>FlexEvent</code> event dispatched by focusManager.
		 * 
		 */
		protected function activateHandler( event:Event ) : void
		{
			active = true;
			invalidateSkinState();
		}
		
		/**
		 * 
		 * Handler for <code>FlexEvent.FLEX_WINDOW_DEACTIVATE</code> event dispatched by focusManager.
		 * 
		 * @param event The <code>FlexEvent</code> event dispatched by focusManager.
		 * 
		 */
		private function deactivateHandler( event:Event ) : void
		{
			active = false;
			invalidateSkinState();
		}
		
		/**
		 *  
		 * Find the right time to listen to the focusmanager
		 * 
		 * Handler for <code>Event.ADDED_TO_STAGE</code> event dispatched by focusManager.
		 * 
		 * @param event The <code>Event</code> event dispatched by focusManager.
		 * 
		 */		
		private function addedToStageHandler( event:Event ) : void
		{
			if( event.target == this )
			{
				removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
				callLater( addActivateHandlers );
			}    
		}
		
		/**
		 *  
		 *  Called when a FocusManager is added to an IFocusManagerContainer.
		 *  We need to check that it belongs to us before listening to it.
		 *  Because we listen to sandboxroot, you cannot assume the type of
		 *  the event.
		 * 
		 */
		private function addFocusManagerHandler(event:Event):void
		{
			if (focusManager == event.target["focusManager"])
			{
				systemManager.getSandboxRoot().removeEventListener(FlexEvent.ADD_FOCUS_MANAGER, 
					addFocusManagerHandler, true);
				addActivateHandlers();
			}
		}
	}
}