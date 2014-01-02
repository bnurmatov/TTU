////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.popup
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Fade;
	
	import tj.ttu.components.skins.popup.OkCancelConfirmationPopupSkin;
	import tj.ttu.components.skins.popup.YesNoConfirmationPopupSkin;
	
	[Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]
	/**
	 * ConfirmationPopup class 
	 */
	public class ConfirmationPopup extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var confirmTextLabel:Label;
		
		[SkinPart(required="true")]
		public var titleControl:RichText;
		
		[SkinPart(required="false")]
		public var buttonOk:Button;
		
		[SkinPart(required="false")]
		public var buttonCancel:Button;
		
		[SkinPart(required="false")]
		public var buttonYes:Button;
		
		[SkinPart(required="false")]
		public var buttonNo:Button;
		
		[SkinPart(required="true")]
		public var closeButton:Button;
		
		[SkinPart(required="false")]
		public var buttonBlink:Fade;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const OK		:String = 'ok';
		public static const CANCEL	:String = 'cancel';
		public static const YES		:String = 'yes';
		public static const NO		:String = 'no';
		
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
		 * ConfirmationPopup 
		 */
		public function ConfirmationPopup()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromSatge);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  title
		//----------------------------------
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
		
		//----------------------------------
		//  message
		//----------------------------------
		private var messageChanged:Boolean = false;
		private var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			if( _message !== value)
			{
				_message = value;
				messageChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(messageChanged && confirmTextLabel)
			{
				confirmTextLabel.text = message;
				messageChanged = false;
			}
			if(titleChanged && titleControl)
			{
				titleControl.text = title;
				titleChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == buttonOk)
				buttonOk.addEventListener(MouseEvent.CLICK, onOkClick);
			if(instance == buttonCancel)
				buttonCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
			if(instance == buttonYes)
				buttonYes.addEventListener(MouseEvent.CLICK, onYesClick);
			if(instance == buttonNo)
				buttonNo.addEventListener(MouseEvent.CLICK, onNoClick);
			if(instance == closeButton)
				closeButton.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == buttonOk)
				buttonOk.removeEventListener(MouseEvent.CLICK, onOkClick);
			if(instance == buttonCancel)
				buttonCancel.removeEventListener(MouseEvent.CLICK, onCancelClick);
			if(instance == buttonYes)
				buttonYes.removeEventListener(MouseEvent.CLICK, onYesClick);
			if(instance == buttonNo)
				buttonNo.removeEventListener(MouseEvent.CLICK, onNoClick);
			if(instance == closeButton)
				closeButton.removeEventListener(MouseEvent.CLICK, onClose);
			super.partRemoved(partName, instance);
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
		private function removePopup():void
		{
			PopUpManager.removePopUp(this);
		}
		
		
		public static function show(title:String, message:String,
									isYesNoPopup:Boolean = false):ConfirmationPopup
		{
			var parent:Sprite;
			var skin:Class;
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			// no types so no dependencies
			var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			var popup:ConfirmationPopup = new ConfirmationPopup();
			if(isYesNoPopup)
				skin = YesNoConfirmationPopupSkin;
			else
				skin = OkCancelConfirmationPopupSkin;
			popup.setStyle('skinClass', skin );
			popup.title 				= title;
			popup.message 				= message;
			
			
			// Setting a module factory allows the correct embedded font to be found.
			if (parent is UIComponent)
				popup.moduleFactory = UIComponent(parent).moduleFactory;
			else
			{
				popup.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				// also set document is parent isn't a UIComponent
				popup.document = FlexGlobals.topLevelApplication.document;
			}
			
			PopUpManager.addPopUp(popup, parent, true);
			PopUpManager.centerPopUp(popup);
			popup.setFocus();
			
			return popup;
		}
		//--------------------------------------------------------------------------
		//
		// Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		protected function onOkClick(event:MouseEvent):void
		{
			dispatchEvent( new Event(OK));
			removePopup();
		}
		
		
		protected function onNoClick(event:MouseEvent):void
		{
			dispatchEvent( new Event(NO));
			removePopup();
		}
		
		protected function onYesClick(event:MouseEvent):void
		{
			dispatchEvent( new Event(YES));
			removePopup();
		}
		
		protected function onCancelClick(event:MouseEvent):void
		{
			dispatchEvent( new Event(CANCEL));
			removePopup();
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent( new Event(Event.CLOSE));
			removePopup();
		}
		
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				if(buttonCancel)
					onCancelClick(null);
				else if(buttonNo)
					onNoClick(null); 
			}
		}
		
		protected function onCreationComplete(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			if(buttonBlink)
				buttonBlink.play();
		}		
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if(stage)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onRemovedFromSatge(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromSatge);
			if(stage)
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
	}
}