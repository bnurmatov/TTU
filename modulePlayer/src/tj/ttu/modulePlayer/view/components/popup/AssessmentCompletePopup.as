////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 3, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components.popup
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexDisplayObject;
	import mx.managers.IFocusManagerContainer;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.modulePlayer.view.events.LearningPopupEvent;
	
	/**
	 * AssessmentCompletePopup class 
	 */
	public class AssessmentCompletePopup extends SkinnableComponent implements IFocusManagerContainer
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
		public var homeButton:Button;
		
		/**
		 * 
		 * A skin part that defines the stayHereButton of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var userAnswerGrid:DataGrid;
		
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
		 * AssessmentCompletePopup 
		 */
		public function AssessmentCompletePopup()
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
		
		private var userAnswersChanged:Boolean;
		private var _userAnswers:Array;

		public function get userAnswers():Array
		{
			return _userAnswers;
		}

		public function set userAnswers(value:Array):void
		{
			if( _userAnswers !== value)
			{
				_userAnswers = value;
				userAnswersChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
		//  score
		//----------------------------------
		private var _score:Number;

		[Bindable(event="scoreChange")]
		public function get score():Number
		{
			return _score;
		}

		public function set score(value:Number):void
		{
			if( _score !== value)
			{
				_score = value;
				dispatchEvent(new Event("scoreChange"));
			}
		}

		//----------------------------------
		//  correct
		//----------------------------------
		private var _correct:Number = 0;
		
		[Bindable(event="correctChanged")]
		public function get correct():Number
		{
			return _correct;
		}
		
		public function set correct(value:Number):void
		{
			if( _correct !== value)
			{
				_correct = value;
				dispatchEvent(new Event("correctChanged"));
			}
		}
		
		//----------------------------------
		//  incorrect
		//----------------------------------
		private var _incorrect:Number = 0;
		
		[Bindable(event="incorrectChanged")]
		public function get incorrect():Number
		{
			return _incorrect;
		}
		
		public function set incorrect(value:Number):void
		{
			if( _incorrect !== value)
			{
				_incorrect = value;
				dispatchEvent(new Event("incorrectChanged"));
			}
		}
		//----------------------------------
		//  staleCount
		//----------------------------------
		private var _total:Number = 0;
		
		[Bindable(event="totalChanged")]
		public function get total():Number
		{
			return _total;
		}
		
		public function set total(value:Number):void
		{
			if( _total !== value)
			{
				_total = value;
				dispatchEvent(new Event("totalChanged"));
			}
		}
		
		//----------------------
		// isPassed
		//----------------------
		private var _isPassed:Boolean;
		
		[Bindable(event="isPassedChange")]
		public function get isPassed():Boolean
		{
			return _isPassed;
		}
		
		public function set isPassed(value:Boolean):void
		{
			if( _isPassed !== value)
			{
				_isPassed = value;
				dispatchEvent(new Event("isPassedChange"));
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
			if(userAnswersChanged && userAnswerGrid)
			{
				userAnswerGrid.dataProvider = _userAnswers ? new ArrayCollection(_userAnswers) : null;
				userAnswersChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == retakeButton)
				retakeButton.addEventListener(MouseEvent.CLICK, onRetakeClick);
			if(instance == homeButton)
				homeButton.addEventListener(MouseEvent.CLICK, onHomeButtonClick);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == retakeButton)
				retakeButton.removeEventListener(MouseEvent.CLICK, onRetakeClick);
			if(instance == homeButton)
				homeButton.removeEventListener(MouseEvent.CLICK, onHomeButtonClick);
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
		
		
		protected function onHomeButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new LearningPopupEvent(LearningPopupEvent.HOME));	
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
				if(retakeButton && retakeButton.visible)
					onRetakeClick(null);
			}
			
		}
		
	}
}