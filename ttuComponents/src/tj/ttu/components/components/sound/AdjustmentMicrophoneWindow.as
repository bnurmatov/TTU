////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.sound
{
	import tj.ttu.components.components.sound.AdjustmentMicrophoneWindowState;
	import tj.ttu.components.events.AdjustmentMicrophoneEvent;
	import tj.ttu.components.skins.sound.adjustmentMicrophoneWindow.AdjustmentMicrophoneWindowSkin;
	import tj.ttu.components.skins.sound.adjustmentMicrophoneWindow.MicLevelMaxSkin;
	import tj.ttu.components.skins.sound.adjustmentMicrophoneWindow.MicLevelSkin;
	import tj.ttu.components.components.sound.SoundRecorder;
	import tj.ttu.components.events.NewSoundRecorderEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Microphone;
	import flash.media.scanHardware;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.ui.Keyboard;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.StateChangeEvent;
	import mx.managers.IFocusManagerContainer;
	import mx.states.State;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.components.skins.sound.adjustmentMicrophoneWindow.MicLevelSkin;
	
	//----------------------------------
	//  Events
	//----------------------------------
	
	/**
	 * Event for start activity, dispatched after or instead of adjustment mic. 
	 */	
	[Event(name="start", 
		type="com.transparent.activities.multiplechoice2.events.ActivityEvent")]
	
	/**
	 * Event for skipping activity, dispatched if mic is unplugged or missing. 
	 */	
	[Event(name="skip", 
		type="com.transparent.activities.multiplechoice2.events.ActivityEvent")]
	
	/**
	 * Event for proceed adjustment. 
	 */	
	[Event(name="proceed", 
		type="com.transparent.activities.multiplechoice2.events.AdjustmentMicrophoneEvent")]
	
	/**
	 * Event for detecting microphone. 
	 */	
	[Event(name="detect", 
		type="com.transparent.activities.multiplechoice2.events.AdjustmentMicrophoneEvent")]
	
	/**
	 * Event for adjusting microphone. 
	 */	
	[Event(name="adjustment", 
		type="com.transparent.activities.multiplechoice2.events.AdjustmentMicrophoneEvent")]
	
	/**
	 *  AdjustmentMicrophoneWindow class define a component wich visualise
	 *  adjustment procedure.
	 */
	public class AdjustmentMicrophoneWindow extends SkinnableComponent 
		implements IFocusManagerContainer
	{
		//----------------------------------------------------------------------
		//
		//	Static constants
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// constant
		//----------------------------------
		public static const FINISH_SETTINGS:String = 'finishSettings';
		/**
		 * TODO: asdoc
		 */
		
		//----------------------------------------------------------------------
		//
		//	Static variables
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// variable
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */
		
		//----------------------------------------------------------------------
		//
		//	Static properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// property
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */
		
		//----------------------------------------------------------------------
		//
		//	Static methods
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// method
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */  
		
		/**
		 * Constructor.
		 */ 
		public function AdjustmentMicrophoneWindow()
		{
			super();
			setStyle("skinClass", AdjustmentMicrophoneWindowSkin);
			addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, 
				stateChangeHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		//----------------------------------------------------------------------
		//
		//	Constants
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// constant
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */
		
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Public variables
		//
		//--------------------------------------------------
		
		[Bindable]
		public var activityName:String;
		
		
		public var isPaused:Boolean = false;
		
		private var isMicrophoneDetected:Boolean = false;
		
		private var isMicrophoneUnmuted:Boolean = false;
		
		private var soundRecorder:SoundRecorder;
		
		/**
		 * @private
		 */
		private var maxVolumeLevel:uint;
		
		
		//----------------------------------------
		//
		//	SkinParts
		//
		//----------------------------------------
		
		//----------------------------------
		// dragRect
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for dragging.
		 */
		public var dragRect:Group;
		
		//----------------------------------
		// startActivityButton
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for start button.
		 */
		public var finishButton:Button;
		
		//----------------------------------
		// proceedButton
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for procced button.
		 */
		public var proceedButton:Button;
		
		//----------------------------------
		// detectButton
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for detect mic button.
		 */
		public var detectButton:Button;
		
		//----------------------------------
		// optionalButton
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for optional button, wich provide skip activity
		 * or adjust system settings.
		 */
		public var optionalButton:Button;
		
		//----------------------------------
		// volumeIndicator
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for indicate microphone volume level.
		 */
		public var volumeIndicator:MicLevelSkin;
		
		//----------------------------------
		// maxLevelIndicator
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for indicate max volume level
		 */
		public var maxLevelIndicator:MicLevelMaxSkin;
		
		//----------------------------------
		// percentLabel
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for indicate volume level as number.
		 */
		public var percentLabel:Label;
		
		//----------------------------------
		// closeButton
		//----------------------------------
		
		[SkinPart(required="false")]
		/**
		 * Skin part for indicate volume level as number.
		 */
		public var closeButton:Button;
		
		//----------------------------------------------------------------------
		//
		//	Overriden properties
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Overriden UIComponent properties
		//
		//--------------------------------------------------
		
		//----------------------------------
		// overriden property states
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get states():Array
		{
			return [
				new State({name:AdjustmentMicrophoneWindowState.NORMAL_STATE}),
				new State({name:AdjustmentMicrophoneWindowState.DETECTED_MIC_STATE}),
				new State({name:AdjustmentMicrophoneWindowState.NO_DETECTED_MIC_STATE}),
				new State({name:AdjustmentMicrophoneWindowState.TEST_MIC_STATE}),
				new State({name:AdjustmentMicrophoneWindowState.CORRECT_FEEDBACK_MIC_STATE}),
				new State({name:AdjustmentMicrophoneWindowState.INCORRECT_FEEDBACK_MIC_STATE})
			];
		}
		
		//----------------------------------------------------------------------
		//
		//	Properties
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Implimentation of IFocusManagerContainer
		//
		//--------------------------------------------------
		
		//----------------------------------
		// defaultButton
		//----------------------------------
		
		/**
		 * @private
		 */
		public function get defaultButton():IFlexDisplayObject
		{
			return null;
		}
		
		/**
		 * @private
		 */		
		public function set defaultButton(value:IFlexDisplayObject):void {}
		
		//----------------------------------
		// gain
		//----------------------------------
		private var _gain:uint;
		
		public function get gain():uint
		{
			return _gain;
		}
		
		public function set gain(value:uint):void
		{
			if( _gain !== value)
			{
				_gain = value;
			}
		}
		
		//----------------------------------------------------------------------
		//
		//	Overriden methods
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------------------
		//
		//	Overriden SkinnableComponent methods
		//
		//--------------------------------------------------
		
		//----------------------------------
		// overriden getCurrentSkinState
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */	
		override protected function getCurrentSkinState():String
		{
			return currentState;
		}
		
		//----------------------------------
		// overriden partAdded
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */	
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == dragRect)
			{
				dragRect.addEventListener(MouseEvent.MOUSE_DOWN, dragRect_mouseDownHandler);
				dragRect.addEventListener(MouseEvent.MOUSE_UP, dragRect_mouseUpHandler);
			}
			if (instance == finishButton)
			{
				finishButton.addEventListener(MouseEvent.CLICK, finishButton_clickHandler);
			}
			if (instance == proceedButton)
			{
				proceedButton.addEventListener(MouseEvent.CLICK, proceedButton_clickHandler);
			}
			if (instance == detectButton)
			{
				detectButton.addEventListener(MouseEvent.CLICK, detectButton_clickHandler);
			}
			if (instance == optionalButton)
			{
				optionalButton.addEventListener(MouseEvent.CLICK, optionalButton_clickHandler);
			}
			if (instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			}
		}
		
		//----------------------------------
		// overriden partRemoved
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */	
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == dragRect)
			{
				dragRect.removeEventListener(MouseEvent.MOUSE_DOWN, dragRect_mouseDownHandler);
				dragRect.removeEventListener(MouseEvent.MOUSE_UP, dragRect_mouseUpHandler);
			}
			if (instance == finishButton)
			{
				finishButton.removeEventListener(MouseEvent.CLICK, finishButton_clickHandler);
			}
			if (instance == proceedButton)
			{
				proceedButton.removeEventListener(MouseEvent.CLICK, proceedButton_clickHandler);
			}
			if (instance == detectButton)
			{
				detectButton.removeEventListener(MouseEvent.CLICK, detectButton_clickHandler);
			}
			if (instance == optionalButton)
			{
				optionalButton.removeEventListener(MouseEvent.CLICK, optionalButton_clickHandler);
			}
			if (instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			}
			super.partRemoved(partName, instance);
		}
		
		//----------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// method
		//----------------------------------
		
		/**
		 * TODO: asdoc
		 */
		
		//----------------------------------------------------------------------
		//
		//	Overriden eventHandler's
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// overriden eventHandler
		//----------------------------------
		
		/**
		 * @inheritDoc
		 */  
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (isPaused)
				return;
			
			if (event.keyCode == Keyboard.ENTER)
			{
				if (!this.visible)
					return;
				
				if (currentState == AdjustmentMicrophoneWindowState.DETECTED_MIC_STATE || currentState == AdjustmentMicrophoneWindowState.INCORRECT_FEEDBACK_MIC_STATE)
				{
					proceedButton_clickHandler(null);
				} 
				else if (currentState == AdjustmentMicrophoneWindowState.NO_DETECTED_MIC_STATE)
				{
					detectButton_clickHandler(null);
				}
				else if (currentState == AdjustmentMicrophoneWindowState.TEST_MIC_STATE || currentState == AdjustmentMicrophoneWindowState.CORRECT_FEEDBACK_MIC_STATE)
				{
					finishButton_clickHandler(null);
				}
			}
		}
		
		//----------------------------------------------------------------------
		//
		//	EventHandler's
		//
		//----------------------------------------------------------------------
		
		//----------------------------------
		// stateChangeHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function stateChangeHandler(event:StateChangeEvent):void
		{
			invalidateSkinState();
		}	
		
		//----------------------------------
		// titleGroup_mouseDownHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function dragRect_mouseDownHandler(event:MouseEvent):void
		{
			trace("dragRect_mouseDownHandler");
			this.startDrag();
		}
		
		//----------------------------------
		// titleGroup_mouseUpHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function dragRect_mouseUpHandler(event:MouseEvent):void
		{
			this.stopDrag();
		}
		
		//----------------------------------
		// startActivityButton_clickHandler
		//----------------------------------
		
		private var isStarted:Boolean = false;
		
		/**
		 * @private
		 */
		private function finishButton_clickHandler(event:MouseEvent):void
		{
			if (isStarted)
				return;
			
			isStarted = true;
			if(soundRecorder)
			{
				soundRecorder.disable();
				gain = soundRecorder.microphone ? soundRecorder.microphone.gain : _gain;
				soundRecorder = null;
			}
			this.dispatchEvent(new Event( FINISH_SETTINGS ) );
		}
		
		//----------------------------------
		// proceedButton_clickHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function proceedButton_clickHandler(event:MouseEvent):void
		{
			scanHardware();
			if (checkMicrophoneAvailability())
			{
				initSoundRecorder();
			}
			
			this.dispatchEvent(
				new AdjustmentMicrophoneEvent(AdjustmentMicrophoneEvent.PROCEED));
		}
		
		//----------------------------------
		// detectButton_clickHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function detectButton_clickHandler(event:MouseEvent):void
		{
			scanHardware();
			checkMicrophoneAvailability();
			this.dispatchEvent(
				new AdjustmentMicrophoneEvent(AdjustmentMicrophoneEvent.DETECT));
		}
		
		//----------------------------------
		// optionalButton_clickHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function optionalButton_clickHandler(event:MouseEvent):void
		{
			Security.showSettings(SecurityPanel.MICROPHONE);
		}
		
		
		//----------------------------------
		// closeButton_clickHandler
		//----------------------------------
		
		/**
		 * @private
		 */
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			if(soundRecorder)
				soundRecorder.disable();
			dispatchEvent( new Event( Event.CLOSE ) );
		}
		
		private function addedToStageHandler(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			scanHardware();
			checkMicrophoneAvailability();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		//----------------------------------
		// updateAdjustmentWindow
		//----------------------------------
		
		private function updateAdjustmentWindow():void
		{
			if (isMicrophoneDetected)
			{
				setCurrentState(AdjustmentMicrophoneWindowState.DETECTED_MIC_STATE);
				
				if (isMicrophoneUnmuted)
				{
					setCurrentState(AdjustmentMicrophoneWindowState.TEST_MIC_STATE);
				}
			}
			else
			{
				setCurrentState(AdjustmentMicrophoneWindowState.NO_DETECTED_MIC_STATE);
			}
		}
		
		
		//----------------------------------
		// checkMicrophoneAvailability
		//----------------------------------
		
		/**
		 * @private
		 */
		private function checkMicrophoneAvailability():Boolean
		{
			var mic:Microphone = Microphone.getMicrophone();
			var mics:Array = Microphone.names;
			isMicrophoneDetected = mic ? true : false;
			updateAdjustmentWindow();
			return mic ? true : false;
		}
		
		//----------------------------------
		// initSoundRecorder
		//----------------------------------
		
		/**
		 * @private
		 */
		private function initSoundRecorder():void
		{
			soundRecorder = new SoundRecorder();
			soundRecorder.addEventListener(
				NewSoundRecorderEvent.MICROPHONE_UNMUTED, soundRecorder_microphoneUnmutedHandler);
			soundRecorder.addEventListener(
				NewSoundRecorderEvent.ACTIVITY_LEVEL_CHANGE, soundRecorder_activityLevelChangeHandler);
			soundRecorder.addEventListener(
				NewSoundRecorderEvent.SILENCE_DETECTION, soundRecorder_silenceDetectionHandler);
			//soundRecorder.useAutomationGainControl = true;
			soundRecorder.useVoiceDetection = true;
			
			soundRecorder.init(1, 0, true);
			if(soundRecorder.microphone && soundRecorder.microphone.gain != _gain)
				soundRecorder.microphone.gain = _gain;
			
			isMicrophoneUnmuted = !soundRecorder.microphone.muted;
			updateAdjustmentWindow();
		}
		
		//----------------------------------
		// soundRecorder_microphoneUnmutedHandler
		//----------------------------------
		
		/**
		 * @private
		 */ 
		private function soundRecorder_microphoneUnmutedHandler(event:NewSoundRecorderEvent):void
		{
			isMicrophoneUnmuted = true;
			updateAdjustmentWindow();
		}
		
		//----------------------------------
		// soundRecorder_activityLevelChangeHandler
		//----------------------------------
		
		/**
		 * @private
		 */ 
		private function soundRecorder_activityLevelChangeHandler(event:NewSoundRecorderEvent):void
		{
			if (!soundRecorder) return;
			
			var currentLevel:uint = uint(soundRecorder.microphone.activityLevel);
			if (currentLevel > maxVolumeLevel)
			{
				maxVolumeLevel = currentLevel;
			}
			this.maxLevelIndicator.setCurrentState("s" + uint(currentLevel/5));
			this.volumeIndicator.setCurrentState("s" + uint(currentLevel/5));
			
			
			this.percentLabel.text = currentLevel.toString();
		}
		
		//----------------------------------
		// soundRecorder_silenceDetectionHandler
		//----------------------------------
		
		/**
		 * @private
		 */ 
		private function soundRecorder_silenceDetectionHandler(event:NewSoundRecorderEvent):void
		{
			this.maxLevelIndicator.setCurrentState("s0");
			this.volumeIndicator.setCurrentState("s0");
			this.percentLabel.text = "0";
		}
	}
}