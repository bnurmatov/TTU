////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.components.popup
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.view.skins.popup.ErrorWindowSkin;
	
	[Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]
	/**
	 * ErrorWindow class 
	 */
	public class ErrorWindow extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * errorMessage
		 */
		[SkinPart(required="true")]
		public var errorMessageLabel:Label;
		
		/**
		 * buttonClose
		 */
		[SkinPart(required="true")]
		public var buttonClose:Button;
		
		/**
		 * buttonOk
		 */
		[SkinPart(required="true")]
		public var buttonOk:Button;
		
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
		 * ErrorWindow 
		 */
		public function ErrorWindow()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// errorText
		//-----------------------------------------
		private var _errorText:String;

		public function get errorText():String
		{
			return _errorText;
		}

		public function set errorText(value:String):void
		{
			if( _errorText !== value)
			{
				_errorText = value;
				if(errorMessageLabel)
					errorMessageLabel.text = _errorText ? errorMessageLabel.text +  "\n" + _errorText : null;
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
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == buttonClose)
				buttonClose.addEventListener(MouseEvent.CLICK, onClose);
			if(instance == buttonOk)
				buttonOk.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == buttonClose)
				buttonClose.removeEventListener(MouseEvent.CLICK, onClose);
			if(instance == buttonOk)
				buttonOk.removeEventListener(MouseEvent.CLICK, onClose);
			super.partRemoved(partName, instance);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function detachSkin() : void
		{
			setStyle( "skinClass", null );
			super.detachSkin();
		}
		
		override public function setFocus():void
		{
			if(buttonOk)
				buttonOk.setFocus();
			else
				super.setFocus();
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
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if(stage)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}		
		
		protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if(stage)
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.ENTER)
				onClose(null);
		}
		
		
	}
}