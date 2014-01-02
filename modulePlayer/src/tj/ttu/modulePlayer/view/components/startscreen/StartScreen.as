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
	
	import mx.core.FlexGlobals;
	import mx.managers.IFocusManagerComponent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.RichText;
	import spark.components.TextArea;
	import spark.components.VScrollBar;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.modulePlayer.view.interfaces.IStartScreen;
	
	/**
	 * StartScreen class 
	 */
	public class StartScreen extends SkinnableComponent implements IStartScreen, IFocusManagerComponent   
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var titleLabel:RichText;
		
		[SkinPart(required="false")]
		public var infoTextArea:TextArea;
		
		[SkinPart(required="false")]
		public var startButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		public static const START_LEARNING:String = "startLearning";
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
		public function StartScreen()
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
		private var _description:String;
		
		public function get description() : String
		{
			return _description;
		}
		
		public function set description( value:String ) : void
		{
			if(value == _description)
				return;
			_description = value;
			descriptionChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded( partName:String, instance:Object ) : void
		{
			super.partAdded( partName, instance );
			
			if( instance == startButton )
			{
				startButton.addEventListener( MouseEvent.CLICK, onStartButtonHandler );
			}
		}
		
		
		
		override protected function partRemoved( partName:String, instance:Object ) : void
		{
			super.partRemoved( partName, instance );
			
			if( instance == startButton )
			{
				startButton.removeEventListener( MouseEvent.CLICK, onStartButtonHandler );
			}
		}
		
		
		
		override protected function commitProperties() : void
		{
			super.commitProperties();
			if( titleChanged && titleLabel )
			{
				titleLabel.text = title;
				titleChanged = false;
			}
			
			if( descriptionChanged && infoTextArea)
			{
				infoTextArea.text = _description;
				descriptionChanged = false;
			}
		}
		
		override protected function resourcesChanged() : void
		{
			titleChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
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
			dispatchEvent( new Event( StartScreen.START_LEARNING ) );
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
			super.keyDownHandler(event);
			if( visible && event && event.keyCode == Keyboard.ENTER )
				dispatchEvent( new Event(StartScreen.START_LEARNING));
		}
		
	}
}