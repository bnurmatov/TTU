////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 3, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components.popup
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.IFocusManagerContainer;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.modulePlayer.view.events.LearningPopupEvent;
	
	/**
	 * LearningPopup class 
	 */
	public class LearningPopup extends SkinnableComponent implements IFocusManagerContainer
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * A skin part that defines the retakeButton of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var retakeButton:Button;
		
		/**
		 * 
		 * A skin part that defines the nextStepButton of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var nextStepButton:Button;
		
		/**
		 * 
		 * A skin part that defines the stayHereButton of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var stayHereButton:Button;
		
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
		 * LearningPopup 
		 */
		public function LearningPopup()
		{
			super();
			
			setStyle("modalTransparency", 0.5);
			setStyle("modalTransparencyColor", "black");
			setStyle("modalTransparencyDuration", 500);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  Current step for list mode
		//----------------------------------
		private var _step:Number
		
		[Bindable(event="stepChanged")]
		public function get step():Number
		{
			return _step;
		}
		
		public function set step(value:Number):void
		{
			if( _step !== value)
			{
				_step = value;
				dispatchEvent(new Event("stepChanged"));
			}
		}
		
		//----------------------------------
		//  defaultButton
		//----------------------------------
		private var _defaultButton:IFlexDisplayObject;
		/**
		 *  The Button control designated as the default button
		 *  for the container.
		 *  When controls in the container have focus, pressing the
		 *  Enter key is the same as clicking this Button control.
		 */
		public function get defaultButton():IFlexDisplayObject
		{
			return _defaultButton;
		}
		
		/**
		 *  @private
		 */
		public function set defaultButton(value:IFlexDisplayObject):void
		{
			_defaultButton = value;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == retakeButton)
				retakeButton.addEventListener(MouseEvent.CLICK, onRetakeClick);
			if(instance == nextStepButton)
				nextStepButton.addEventListener(MouseEvent.CLICK, onNextStepButtonClick);
			if(instance == stayHereButton)
				stayHereButton.addEventListener(MouseEvent.CLICK, onStayHereButtonClick);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == retakeButton)
				retakeButton.removeEventListener(MouseEvent.CLICK, onRetakeClick);
			if(instance == nextStepButton)
				nextStepButton.removeEventListener(MouseEvent.CLICK, onNextStepButtonClick);
			if(instance == stayHereButton)
				stayHereButton.removeEventListener(MouseEvent.CLICK, onStayHereButtonClick);
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
		
		protected function onStayHereButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new LearningPopupEvent(LearningPopupEvent.STAY_HERE));	
		}
		
		protected function onNextStepButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new LearningPopupEvent(LearningPopupEvent.NEXT_STEP));	
		}
		
		protected function onRetakeClick(event:MouseEvent):void
		{
			dispatchEvent(new LearningPopupEvent(LearningPopupEvent.RETAKE));	
		}
		
		/**
		 *  @private
		 */
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			setFocus();
			if(systemManager.getSandboxRoot().stage)
				systemManager.getSandboxRoot().stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}	
		
		
		
		protected function onRemovedFromStage(event:Event):void
		{
			if(systemManager.getSandboxRoot().stage)
				systemManager.getSandboxRoot().stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(!this.focusManager)
				return;
			
			if(event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.SPACE)
			{
				if(nextStepButton && nextStepButton.visible)
					dispatchEvent(new LearningPopupEvent(LearningPopupEvent.NEXT_STEP));
			}
			
		}
	
	}
}