////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 25, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.popup.comment
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;
	
	import spark.components.Button;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.components.events.ChapterEvent;
	
	[Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]
	/**
	 * ChapterCommentPopup class 
	 */
	public class ChapterCommentPopup extends SkinnableComponent implements IFocusManagerContainer
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * commentTextArea
		 */
		[SkinPart(required="false")]
		public var commentTextArea:TextArea;
		
		/**
		 * buttonClose
		 */
		[SkinPart(required="true")]
		public var buttonClose:Button;
		
		/**
		 * saveButton
		 */
		[SkinPart(required="true")]
		public var saveButton:Button;
		
		/**
		 * buttonCancel
		 */
		[SkinPart(required="true")]
		public var buttonCancel:Button;
		
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
		private var latinFont:String;
		private var latinDirection:String; 
		private var cyrillicDirection:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterCommentPopup 
		 */
		public function ChapterCommentPopup()
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
		// chapter
		//-----------------------------------------
		private var _chapter:ChapterVO;

		public function get chapter():ChapterVO
		{
			return _chapter;
		}

		public function set chapter(value:ChapterVO):void
		{
			if( _chapter !== value)
			{
				_chapter = value;
				comment = _chapter ? _chapter.comment : null;
			}
		}
		//-----------------------------------------
		// comment
		//-----------------------------------------
		private var commentChanged:Boolean = false;
		private var _comment:String;

		public function get comment():String
		{
			return _comment;
		}

		public function set comment(value:String):void
		{
			if( _comment !== value)
			{
				_comment = value;
				commentChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// cyrillicFont
		//-----------------------------------------
		private var _cyrillicFont:String = "Cyrillic";
		
		public function get cyrillicFont():String
		{
			return _cyrillicFont;
		}
		
		public function set cyrillicFont(value:String):void
		{
			if(_cyrillicFont !== value)
			{
				_cyrillicFont = value;
				commentChanged = true;
				invalidateProperties();
			}
		}
		
		private var _defaultButton:IFlexDisplayObject;
		public function get defaultButton():IFlexDisplayObject
		{
			return _defaultButton;
		}
		
		public function set defaultButton(value:IFlexDisplayObject):void
		{
			_defaultButton = value;
		}
		
		override public function get systemManager():ISystemManager
		{
			return super.systemManager;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(commentChanged && commentTextArea)
			{
				commentTextArea.textFlow = _comment ? TLFUtil.createFlow( _comment, latinFont, cyrillicFont ) : null;
				commentChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == buttonClose)
				buttonClose.addEventListener(MouseEvent.CLICK, onClose);
			if(instance == buttonCancel)
				buttonCancel.addEventListener(MouseEvent.CLICK, onClose);
			if(instance == saveButton)
			{
				saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
				saveButton.enabled = false;
			}
			if(instance == commentTextArea)
			{
				commentTextArea.addEventListener(TextOperationEvent.CHANGE, onCommentTextChange);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == buttonClose)
				buttonClose.removeEventListener(MouseEvent.CLICK, onClose);
			if(instance == buttonCancel)
				buttonCancel.removeEventListener(MouseEvent.CLICK, onClose);
			if(instance == saveButton)
				saveButton.removeEventListener(MouseEvent.CLICK, onSaveClick);
			if(instance == commentTextArea)
				commentTextArea.removeEventListener(TextOperationEvent.CHANGE, onCommentTextChange);
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
			cyrillicDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_DIRECTION)||"ltr";
			latinDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_DIRECTION)||"ltr";
		}
		
		/*override public function setFocus():void
		{
			if(commentTextArea && commentTextArea.focusManager)
				commentTextArea.setFocus();
			else if(buttonCancel)
				buttonCancel.setFocus();
			else
				super.setFocus();
		}*/
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function resetComponent():void
		{
			chapter = null;
			comment = null;
			if(commentTextArea)
				commentTextArea.text = "";
			if(saveButton)
				saveButton.enabled = false;
		}
		/**
		 *  @private
		 */
		
		private function compareChanges():void
		{
			saveButton.enabled = TrimUtil.trim(chapter.comment) != TrimUtil.trim(_comment);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onCommentTextChange(event:TextOperationEvent):void
		{
			_comment = commentTextArea.text;
			compareChanges();
		}
		
		protected function onSaveClick(event:MouseEvent):void
		{
			_chapter.comment = _comment;
			dispatchEvent(new ChapterEvent(ChapterEvent.CHANGE_CHAPTER_COMMENT, _chapter));
		}
		
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
			{
				this.focusManager = FlexGlobals.topLevelApplication.focusManager;
				this.validateNow();
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}		
		
		protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if(stage)
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
				onClose(null);
			else if(event.keyCode == Keyboard.ENTER)
			{
				if(saveButton && saveButton.enabled)
					onSaveClick(null);
				else
					onClose(null);
			}
		}
		
		/** 
		 * @private
		 * Sets Direction and font of text control based on user's input
		 */
		private function formatInputText(control:TextArea, event:TextOperationEvent):void
		{
			if(event.operation is InsertInlineGraphicOperation )
			{
				event.preventDefault();
			}
			else if(event.operation is InsertTextOperation)
			{
				var operation:InsertTextOperation = event.operation as InsertTextOperation;
				var currentPosition:int = Math.max( control.selectionAnchorPosition, control.selectionActivePosition);
				var srt:String = control.text;
				if(currentPosition > srt.length)
					currentPosition = srt.length;
				
				if(operation.text == " ")
					return;
				
				var regExp:RegExp = /\S/ig;
				var format:TextLayoutFormat =  new TextLayoutFormat();
				if(regExp.test(operation.text))
					format.fontFamily =  TLFUtil.getFont(operation.text, latinFont, cyrillicFont);
				if(format.fontFamily == cyrillicFont && latinDirection == Direction.RTL && control.getStyle("direction") == Direction.LTR)
				{
					control.setStyle("direction",  Direction.RTL);
					control.setStyle("textAlign",  TextAlign.RIGHT);
				}
				else if (format.fontFamily == latinFont && cyrillicDirection == Direction.LTR && control.getStyle("direction") == Direction.RTL)
				{
					control.setStyle("direction",  Direction.LTR);
					control.setStyle("textAlign",  TextAlign.LEFT);
				}
				control.setFormatOfRange(format, currentPosition - operation.text.length, currentPosition);
			}
		}
		
		
	}
}