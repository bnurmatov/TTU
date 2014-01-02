////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.popup
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Fade;
	
	import tj.ttu.components.events.LessonEvent;
	
	/**
	 * UnsavedPopup class 
	 */
	public class UnsavedPopup extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var buttonBlink:Fade;
		
		[SkinPart(required="true")]
		public var closeButton:Button;
		
		[SkinPart(required="true")]
		public var discardChangesButton:Button;
		
		[SkinPart(required="true")]
		public var saveChangesButton:Button;
		
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
		 * UnsavedPopup 
		 */
		public function UnsavedPopup()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == closeButton)
				closeButton.addEventListener(MouseEvent.CLICK, onClose);
			else if(instance == discardChangesButton)
				discardChangesButton.addEventListener(MouseEvent.CLICK, onDiscardChanges);
			else if(instance == saveChangesButton)
				saveChangesButton.addEventListener(MouseEvent.CLICK, onSaveChanges);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == closeButton)
				closeButton.removeEventListener(MouseEvent.CLICK, onClose);
			else if(instance == discardChangesButton)
				discardChangesButton.removeEventListener(MouseEvent.CLICK, onDiscardChanges);
			else if(instance == saveChangesButton)
				saveChangesButton.removeEventListener(MouseEvent.CLICK, onSaveChanges);
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onSaveChanges(event:MouseEvent):void
		{
			dispatchEvent(new LessonEvent(LessonEvent.SAVE_CHANGES));
		}
		
		protected function onDiscardChanges(event:MouseEvent):void
		{
			dispatchEvent(new LessonEvent(LessonEvent.DISCARD_CHANGES));
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
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
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}		
		
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
				onClose(null);
			else if(event.keyCode == Keyboard.ENTER)
				onSaveChanges(null);
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}
		
	}
}