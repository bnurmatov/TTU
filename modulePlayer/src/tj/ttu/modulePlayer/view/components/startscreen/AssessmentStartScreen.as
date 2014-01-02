////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components.startscreen
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.utils.TextFlowUtil;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.modulePlayer.view.components.progressbar.AssessmentProgressBar;
	import tj.ttu.modulePlayer.view.interfaces.IAssessmentStartScreen;
	
	/**
	 * StartScreen class 
	 */
	public class AssessmentStartScreen extends SkinnableComponent implements IAssessmentStartScreen
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var titleLabel:Label;
		
		[SkinPart(required="false")]
		public var infoTextArea:TextArea;
		
		[SkinPart(required="false")]
		public var startButton:Button;
		
		/**
		 * Skin parts
		 */ 
		[SkinPart(required="fasle")]
		public var progressBar:AssessmentProgressBar;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//----------------------
		// START_LEARNING
		//----------------------		
		public static const START_LEARNING:String = "startLearning";
		public static const ASSESSMENT_HELP:String = "assessmentHelp";
		private const SCROLL_STEP:uint = 1;
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * StartScreen 
		 */
		public function AssessmentStartScreen()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//-------------------------------------
		//	stageWidth
		//-------------------------------------
		public function get stageWidth():Number
		{
			return stage ? stage.width : FlexGlobals.topLevelApplication.width;
		}
		//-------------------------------------
		//	activityState
		//-------------------------------------
		private var activityStateChanged:Boolean = false;
		/**
		 * @private
		 */
		private var _activityState:String = ModuleStatus.NOT_ATTEMPTED;
		
		/**
		 * Total amount of answered questions
		 */
		public function get activityState():String
		{
			return _activityState;
		}
		
		/**
		 * @private
		 */
		public function set activityState(value:String):void
		{
			if(_activityState != value)
			{
				_activityState = value;
				activityStateChanged = true;
				invalidateProperties();
				invalidateSkinState();
			}
		}
		
		
		
		//----------------------
		// score
		//----------------------
		private var scoreChanged:Boolean;
		private var _score:Number = 0;
		[Bindable(event="scoreChanged")]
		public function get score() : Number
		{
			return _score;
		}
		
		public function set score( value:Number ) : void
		{
			_score = value;
			scoreChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("scoreChanged"));
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

		//----------------------
		// isResume
		//----------------------
		private var isResumeChanged:Boolean = false;
		private var _isResume:Boolean = false;
		
		public function get isResume() : Boolean
		{
			return _isResume;
		}
		
		public function set isResume( value:Boolean ) : void
		{
			if(value == _isResume)
				return;
			
			_isResume = value;
			isResumeChanged = true;
			invalidateProperties();
		}
		
		//----------------------
		// title
		//----------------------
		private var titleChanged:Boolean = false;
		private var _title:String;
		
		public function get title() : String
		{
			return _title;
		}
		
		public function set title( value:String ) : void
		{
			if( _title != value )
			{
				_title = value;
				titleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------
		// description
		//----------------------		
		private var descriptionChanged:Boolean = false;
		private var _description:String
		
		public function get description() : String
		{
			return _description;
		}
		
		public function set description( value:String ) : void
		{
			if(value != _description)
			{
				_description = value;
				descriptionChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 */
		override protected function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
			
			if( instance == startButton )
			{
				startButton.addEventListener( MouseEvent.CLICK, onStartButtonHandler );
				addEventListener(Event.ADDED_TO_STAGE, onAddedTOStage);
			}
			if(instance == infoTextArea)
				setTextFlow();
		}
		
		
		
		/**
		 *  @inheritDoc
		 */
		
		override protected function partRemoved( partName:String, instance:Object ) : void
		{
			super.partRemoved( partName, instance );
			
			if( instance == startButton )
			{
				startButton.removeEventListener( MouseEvent.CLICK, onStartButtonHandler );
				removeEventListener(Event.ADDED_TO_STAGE, onAddedTOStage);
				if(stage)
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
			
			
		}
		/**
		 *  @inheritDoc
		 */
		
		override protected function getCurrentSkinState():String
		{
			if(activityState == ModuleStatus.PASSED || activityState == ModuleStatus.FAILED)
				return activityState;
			return "normal";
		}
		
		/**
		 *  @inheritDoc
		 */
		override protected function commitProperties() : void
		{
			super.commitProperties();
			
			if(scoreChanged && progressBar)
			{
				progressBar.value = _score;
				scoreChanged = false;
			}
			if(activityStateChanged && progressBar)
			{
				progressBar.isPassed = _activityState == ModuleStatus.PASSED;
				activityStateChanged = false;
			}
			if( titleChanged && titleLabel )
			{
				titleLabel.text = _title;
				titleChanged = false;
			}
			
			if( infoTextArea && descriptionChanged )
			{
				infoTextArea.text = description;
				descriptionChanged = false;
			}
		}
	
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			setTextFlow();
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function setTextFlow():void
		{
			var flowString:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'assessmentDescription');
			if(infoTextArea && flowString)
			{
				infoTextArea.textFlow = TextFlowUtil.importFromString(flowString, WhiteSpaceCollapse.PRESERVE);
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * Handler for <code>MouseEvent.CLICK</code> event dispatched by startButton.
		 * 
		 * @param event The <code>MouseEvent</code> event dispatched by startButton.
		 * 
		 */		
		private function onStartButtonHandler( event:MouseEvent ) : void
		{
			dispatchEvent( new Event( AssessmentStartScreen.START_LEARNING ) );
		}
		/**
		 * 
		 * Handler for <code>MouseEvent.CLICK</code> event dispatched by startButton.
		 * 
		 * @param event The <code>MouseEvent</code> event dispatched by startButton.
		 * 
		 */		
		private function onHelpClick( event:MouseEvent ) : void
		{
			dispatchEvent( new Event( AssessmentStartScreen.ASSESSMENT_HELP ) );
		}
		
		
		/**
		 * 
		 * Handler for <code>KeyboardEvent.KEY_DOWN</code> and 
		 * <code>KeyboardEvent.KEY_UP</code>  events dispatched by application.
		 * 
		 * @param event The <code>KeyboardEvent</code> event dispatched by application.
		 * 
		 */		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if(this.alpha == 0 || this.x < 0 || !this.enabled)
				return;
			
			super.keyDownHandler(event);
			if( event && event.keyCode == Keyboard.ENTER )
				dispatchEvent( new Event(AssessmentStartScreen.START_LEARNING));
		}
		
		protected function onAddedTOStage(event:Event):void
		{
			if(stage)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
	}
}
