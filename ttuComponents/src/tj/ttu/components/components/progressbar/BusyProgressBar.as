////////////////////////////////////////////////////////////////////////////////
// Copyright Sep 21, 2012, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.progressbar
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.IFocusManagerContainer;
	
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IDisplayText;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.TLFUtil;
	
	/**
	 * ConfigurationProgressPopup class 
	 */
	public class BusyProgressBar extends SkinnableComponent implements IFocusManagerContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * A skin part that defines the messageLabel of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var messageLabel:IDisplayText;
		
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
		 * ConfigurationProgressPopup 
		 */
		public function BusyProgressBar()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			setStyle("modalTransparency", 0.5);
			setStyle("modalTransparencyColor", "black");
			setStyle("modalTransparencyDuration", 500);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _defaultButton:IFlexDisplayObject;
		public function get defaultButton():IFlexDisplayObject
		{
			// TODO Auto Generated method stub
			return _defaultButton;
		}
		
		public function set defaultButton(value:IFlexDisplayObject):void
		{
			_defaultButton = value;
			
		}
		
		
		private var _isError:Boolean = false;
		
		public function get isError():Boolean
		{
			return _isError;
		}
		
		public function set isError(value:Boolean):void
		{
				resetState();
				_isError = value;
				invalidateSkinState();
		}
		
		private var messageChanged:Boolean = false;
		private var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			if(_message !== value)
			{
				_message = value;
				messageChanged = true;
				invalidateProperties();
			}
		}
		
		
		private var _isSuccess:Boolean = false;
		
		public function get isSuccess():Boolean
		{
			return _isSuccess;
		}
		
		public function set isSuccess(value:Boolean):void
		{
			if( _isSuccess !== value)
			{
				resetState();
				_isSuccess = value;
				invalidateSkinState();
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
			
			if(messageChanged && messageLabel)
			{
				if(messageLabel is RichText)
					(messageLabel as RichText).textFlow = createTextFlow(_message);
				else
					messageLabel.text = _message;
				messageChanged = false;
			}
		}
		
		
		override protected function getCurrentSkinState():String
		{
			if(isSuccess)
				return "success";
			else if(isError)
				return "error";
			return "progress";
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function createTextFlow(text:String):TextFlow
		{
			var latinFont:String = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			var cyrillicFont:String = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
			if(!text || !latinFont || !cyrillicFont)
				return null;
			
			return  TLFUtil.createFlow(text, latinFont, cyrillicFont);
		}
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		private function resetState():void
		{
			_isError = false;
			_isSuccess = false;
		}
		
		/**
		 *  @private
		 */
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
			callLater(onAddListener);
		}		
		
		/**
		 *  @private
		 */
		protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if(stage)
			{
				stage.removeEventListener(MouseEvent.CLICK, onStageClose);
			}
		}
		
		/**
		 *  @private
		 */
		protected function onAddListener():void
		{
			if(stage)
				stage.addEventListener(MouseEvent.CLICK, onStageClose);
		}
		
		/**
		 *  @private
		 */
		protected function onStageClose(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, onStageClose);
			if(isError || isSuccess)
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
	}
}