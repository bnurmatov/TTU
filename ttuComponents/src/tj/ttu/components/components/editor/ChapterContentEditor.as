////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 24, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.editor
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.FontStyle;
	import flash.text.engine.FontWeight;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.DivElement;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.TextRange;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.LeadingModel;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	
	import mx.core.EmbeddedFont;
	import mx.core.FlexGlobals;
	import mx.core.IEmbeddedFontRegistry;
	import mx.core.Singleton;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.DropDownList;
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.ContentTextFlowUtil;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.ScrollerUtil;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.components.components.audio.AudioPlayer;
	import tj.ttu.components.events.ChapterEvent;
	import tj.ttu.components.vo.InsertContentVO;
	
	[Event(name="textFlowChange", 		type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="recordChapterAudio", 	type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="uploadChapterAudio", 	type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="uploadChapterVideo", 	type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="insertChapterImage", 	type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="showImageFullScreen", 	type="tj.ttu.components.events.ChapterEvent")]
	[Event(name="showVideoPlayer", 		type="tj.ttu.components.events.ChapterEvent")]
	/**
	 * ChapterContentEditor class 
	 */
	public class ChapterContentEditor extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var contentText:RichEditableText;
		
		[SkinPart(required="true")]
		public var boldButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var italicButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var underlineButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var leftAlignButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var centerAlignButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var rightAlignButton:ToggleButton;
		
		[SkinPart(required="true")]
		public var fontFamilyDDList:DropDownList;
		
		[SkinPart(required="true")]
		public var fontSizeDDList:DropDownList;
		
		
		[SkinPart(required="true")]
		public var insertDDList:DropDownList;
		
		[SkinPart(required="true")]
		public var audioPlayer:AudioPlayer;
		
		[SkinPart(required="false")]
		public var stroke:SolidColorStroke;
		
		[SkinPart(required="false")]
		public var gr:Group;
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const PLAY_ICON:String = "/embed_assets/icons/play_upIcon.png";
		
		public static const PAUSE_ICON:String = "/embed_assets/icons/pause_upIcon.png";
		
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
		private var cyrillicFont:String;
		private var cyrillicDirection:String;
		
		private var editManager:EditManager;
		
		private var soundRenderer:InlineGraphicElement;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterContentEditor 
		 */
		public function ChapterContentEditor()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------
		//  initialTextColor
		//--------------------------------------
		
		private var _initialTextColor:uint = 0x000000;
		
		/**
		 * The initial text color selected when the editor is first loaded.
		 */
		public function get initialTextColor():uint 
		{
			return _initialTextColor;
		}
		
		public function set initialTextColor(value:uint):void 
		{
			if (_initialTextColor == value)
				return;
			
			if (editManager) 
			{
				var colorStyle:TextLayoutFormat = new TextLayoutFormat();
				colorStyle.color = value;
				editManager.applyLeafFormat(colorStyle);
			}
			
			_initialTextColor = value;
		}
		
		//--------------------------------------
		//  lineHeight
		//--------------------------------------
		
		private var _lineHeight:Object;
		
		/**
		 * The lineHeight for the generated TextFlow object.
		 */
		public function get lineHeight():Object 
		{
			return _lineHeight;
		}
		
		public function set lineHeight(value:Object):void 
		{
			if (_lineHeight == value)
				return;
			
			if (editManager) 
			{
				var containerStyle:TextLayoutFormat = new TextLayoutFormat();
				containerStyle.lineHeight = value;
				editManager.applyContainerFormat(containerStyle);
			}
			_lineHeight = value;
		}
		
		//--------------------------------------
		//  textAreaBackgroundColor
		//--------------------------------------
		
		/**
		 * This sets the editor text area background color.  It will not update
		 * the TextFlow with any background colors.
		 *
		 * This is useful if you are using the editor in a CMS and you want the editor
		 * to match the content pages.
		 */
		public function get textAreaBackgroundColor():uint 
		{
			return contentText ? contentText.getStyle("backgroundColor") : 0;
		}
		
		public function set textAreaBackgroundColor(value:uint):void 
		{
			if(contentText)
				contentText.setStyle("backgroundColor", value);
		}
		
		//--------------------------------------
		//  textFlow
		//--------------------------------------
		public function get textFlow():TextFlow 
		{
			return contentText ? contentText.textFlow : null;
		}
		
		//--------------------------------------
		//  textFlowXML
		//--------------------------------------
		
		[Bindable(event="textFlowChanged")]
		
		/**
		 * The generated TextFlow in XML format.  This is updated whenever the
		 * user makes a change to the editor text.
		 *
		 * This can also be used to set the initial TextFlow data when the editor first
		 * loads.
		 *
		 * When this changes, it will dispatch the "textFlowChanged" event.
		 */
		public function get textFlowXML():String 
		{
			if(!contentText || !contentText.textFlow)
				return null;
			if(StringUtil.isNullOrEmpty(contentText.textFlow.getText()))
				return null;
			
			if(InsertMediaUtil.hasImage(contentText.textFlow))
			{
				return ContentTextFlowUtil.textFlowToString( contentText.textFlow, true );
			}
			return ContentTextFlowUtil.textFlowToString( contentText.textFlow );
		}
		
		public function set textFlowXML(value:String):void 
		{
			if(!contentText)
				return;
			
			var flow:TextFlow = ContentTextFlowUtil.stringToTextFlow( value );
			
			if(!flow)
				flow = TextConverter.importToFlow(value,TextConverter.PLAIN_TEXT_FORMAT);
			
			
			if (contentText.textFlow == flow)
				return;
			
			contentText.textFlow = flow;
			attachTextFlowEvents();
			updateEditManager();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		//--------------------------------------
		//  cahpter
		//--------------------------------------
		private var chapterChanged:Boolean = false;
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
				enableElements(_chapter != null );
				chapterChanged = true;
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
			if(chapterChanged && contentText)
			{
				contentText.textFlow = _chapter ? InsertMediaUtil.createChapterFlow(_chapter.text, _chapter.images, _chapter.sounds, _chapter.videoList): null;
				if(_chapter)
				{
					updateEditManager();
					_chapter.textFlow = contentText.textFlow;
					if(_chapter.textFlow)
						updateAlignButtons(_chapter.textFlow.mxmlChildren);
					checkOnEmpty();
				}
				else
				{
					contentText.errorString = "";
				}
				attachTextFlowEvents();
				
				var clone:TextFlow = contentText.textFlow ? contentText.textFlow.deepCopy() as TextFlow : null;
				dispatchEvent(new ChapterEvent(ChapterEvent.ORIGINAL_TEXT_FLOW, clone));
				chapterChanged = false;
			}
		}
		
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(instance == boldButton)
			{
				boldButton.addEventListener(MouseEvent.CLICK, onBoldButtonClick);
				boldButton.enabled = false;
			}
			if(instance == italicButton)
			{
				italicButton.addEventListener(MouseEvent.CLICK, onItalicButtonClick);
				italicButton.enabled = false;
			}
			if(instance == underlineButton)
			{
				underlineButton.addEventListener(MouseEvent.CLICK, onUnderlineButtonClick);
				underlineButton.enabled = false;
			}
			if(instance == contentText)
			{
				addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				contentText.addEventListener(FlexEvent.CREATION_COMPLETE, onTextDisplayCreationComplete);
				contentText.addEventListener(FocusEvent.FOCUS_IN, onTextDisplayFocusInOut);
				contentText.addEventListener(FocusEvent.FOCUS_OUT, onTextDisplayFocusInOut);
				contentText.addEventListener(TextOperationEvent.CHANGE, onTextDisplayChange);
				contentText.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				contentText.addEventListener(Event.PASTE, onContentPasteText);
				contentText.addEventListener(FlexEvent.SELECTION_CHANGE, onTextDisplaySelectionChange);
				contentText.addEventListener(MouseEvent.MOUSE_OVER, onDispClick);
				contentText.addEventListener(MouseEvent.MOUSE_OUT, onDispClick);
				contentText.addEventListener(MouseEvent.CLICK, onDispClick);
				contentText.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextAreaKeyDown);
				contentText.enabled = false;
			}
			if(instance == audioPlayer)
			{
				audioPlayer.addEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.addEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			if(instance == leftAlignButton)
			{
				leftAlignButton.addEventListener(MouseEvent.CLICK, onAlignButtonClick);
				leftAlignButton.enabled = false;
			}
			if(instance == rightAlignButton)
			{
				rightAlignButton.addEventListener(MouseEvent.CLICK, onAlignButtonClick);
				rightAlignButton.enabled = false;
			}
			if(instance == centerAlignButton)
			{
				centerAlignButton.addEventListener(MouseEvent.CLICK, onAlignButtonClick);
				centerAlignButton.enabled = false;
			}
			
			if(instance == insertDDList)
			{
				insertDDList.addEventListener(DropDownEvent.CLOSE, onChangeInsertDDList);
				//insertDDList.addEventListener(IndexChangeEvent.CHANGE, onChangeInsertDDList);
				insertDDList.enabled = false;
			}
			if(instance == fontSizeDDList)
			{
				fontSizeDDList.addEventListener(DropDownEvent.CLOSE, onCloseDropDownList);
				fontSizeDDList.addEventListener(IndexChangeEvent.CHANGE, onChangeFontSizeDDList);
				fontSizeDDList.enabled = false;
			}
			if(instance == fontFamilyDDList)
			{
				fontFamilyDDList.addEventListener(DropDownEvent.CLOSE, onCloseDropDownList);
				fontFamilyDDList.addEventListener(IndexChangeEvent.CHANGE, onChangeFontFamilyDDList);
				fontFamilyDDList.addEventListener(FlexEvent.CREATION_COMPLETE, onFontFamilyDDListCreationCompleted);
				fontFamilyDDList.enabled = false;
			}
			if(instance == gr)
			{
				gr.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			if(instance == boldButton)
			{
				boldButton.removeEventListener(MouseEvent.CLICK, onBoldButtonClick);
			}
			if(instance == italicButton)
			{
				italicButton.removeEventListener(MouseEvent.CLICK, onItalicButtonClick);
			}
			if(instance == underlineButton)
			{
				underlineButton.removeEventListener(MouseEvent.CLICK, onUnderlineButtonClick);
			}
			if(instance == contentText)
			{
				removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				contentText.removeEventListener(FlexEvent.CREATION_COMPLETE, onTextDisplayCreationComplete);
				contentText.removeEventListener(FocusEvent.FOCUS_IN, onTextDisplayFocusInOut);
				contentText.removeEventListener(FocusEvent.FOCUS_OUT, onTextDisplayFocusInOut);
				contentText.removeEventListener(TextOperationEvent.CHANGE, onTextDisplayChange);
				contentText.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				contentText.removeEventListener(Event.PASTE, onContentPasteText);
				contentText.removeEventListener(FlexEvent.SELECTION_CHANGE, onTextDisplaySelectionChange);
				contentText.removeEventListener(MouseEvent.MOUSE_OVER, onDispClick);
				contentText.removeEventListener(MouseEvent.MOUSE_OUT, onDispClick);
				contentText.removeEventListener(MouseEvent.CLICK, onDispClick);
				contentText.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextAreaKeyDown);
				dettachTextFlowEvents();
			}
			if(instance == leftAlignButton)
			{
				leftAlignButton.removeEventListener(MouseEvent.CLICK, onAlignButtonClick);
			}
			if(instance == rightAlignButton)
			{
				rightAlignButton.removeEventListener(MouseEvent.CLICK, onAlignButtonClick);
			}
			if(instance == centerAlignButton)
			{
				centerAlignButton.removeEventListener(MouseEvent.CLICK, onAlignButtonClick);
			}
			
			if(instance == insertDDList)
			{
				insertDDList.removeEventListener(DropDownEvent.CLOSE, onCloseDropDownList);
				insertDDList.removeEventListener(IndexChangeEvent.CHANGE, onChangeInsertDDList);
			}
			if(instance == fontSizeDDList)
			{
				fontSizeDDList.removeEventListener(DropDownEvent.CLOSE, onCloseDropDownList);
				fontSizeDDList.removeEventListener(IndexChangeEvent.CHANGE, onChangeFontSizeDDList);
			}
			if(instance == fontFamilyDDList)
			{
				fontFamilyDDList.removeEventListener(DropDownEvent.CLOSE, onCloseDropDownList);
				fontFamilyDDList.removeEventListener(IndexChangeEvent.CHANGE, onChangeFontFamilyDDList);
				fontFamilyDDList.removeEventListener(FlexEvent.CREATION_COMPLETE, onFontFamilyDDListCreationCompleted);
			}
			if(instance == audioPlayer)
			{
				audioPlayer.removeEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.removeEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			if(instance == gr)
			{
				gr.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			}
			super.partRemoved(partName, instance);
			
		}
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
			cyrillicDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_DIRECTION)||"ltr";
			latinDirection = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_DIRECTION)||"ltr";
		}
		
		override public function setFocus():void
		{
			if(contentText)
				contentText.setFocus();
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
		
		public function insertSelectedaImage(img:ImageVO):void
		{
			if(!img)
				return;
			contentText.textFlow = InsertMediaUtil.insertSingleImageToChapterTextFlow( ContentTextFlowUtil.textFlowToString(contentText.textFlow), img );
			if(_chapter)
				_chapter.textFlow = contentText.textFlow;
			attachTextFlowEvents();
			contentText.setFocus();
		}
		
		/**
		 *  @public
		 */
		public function insertSelectedSound(sound:SoundVO):void
		{
			if(!sound || !contentText)
				return;
			contentText.textFlow = InsertMediaUtil.insertSingleSoundToTextFlow( ContentTextFlowUtil.textFlowToString(contentText.textFlow), sound );
			if(_chapter)
				_chapter.textFlow = contentText.textFlow;
			attachTextFlowEvents();
			contentText.setFocus();
		}
		
		/**
		 *  @public
		 */
		public function insertSelectedVideo(video:VideoVO):void
		{
			if(!video || !contentText)
				return;
			contentText.textFlow = InsertMediaUtil.insertSingleVideoToTextFlow( ContentTextFlowUtil.textFlowToString(contentText.textFlow), video );
			if(_chapter)
				_chapter.textFlow = contentText.textFlow;
			attachTextFlowEvents();
			contentText.setFocus();
		}
		
		private function attachTextFlowEvents():void
		{
			if(contentText && contentText.textFlow)
			{
				var linkFormat:TextLayoutFormat = new TextLayoutFormat();
				linkFormat.textDecoration = TextDecoration.NONE;
				contentText.textFlow.linkNormalFormat = linkFormat;
				contentText.textFlow.linkActiveFormat = linkFormat;
				contentText.textFlow.linkHoverFormat  = linkFormat;
				contentText.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, onImageStatusChanged);
				contentText.textFlow.addEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
			}
		}
		
		private function dettachTextFlowEvents():void
		{
			if(contentText && contentText.textFlow)
			{
				contentText.textFlow.removeEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, onImageStatusChanged);
				contentText.textFlow.removeEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
			}
		}
		
		/**
		 *  @private
		 */
		private function enableElements(enable:Boolean):void
		{
			boldButton.enabled 			= enable;
			italicButton.enabled 		= enable;
			underlineButton.enabled 	= enable;
			contentText.enabled 		= enable;
			leftAlignButton.enabled 	= enable;
			rightAlignButton.enabled 	= enable;
			centerAlignButton.enabled 	= enable;
			insertDDList.enabled 		= enable;
			fontSizeDDList.enabled 		= enable;
			fontFamilyDDList.enabled 	= enable;
		}
		/**
		 * @private
		 */	
		
		private function getFont(name:String):EmbeddedFont
		{
			var registry:IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
			var fonts:Array = registry.getFonts();
			var bold:Boolean = false;
			var italic:Boolean = false;
			
			for each (var font:EmbeddedFont in fonts) 
			{
				if(font.fontName == name)
				{
					if(!bold)
						bold =  font.bold;
					if(!italic)
						italic =  font.italic;
				}
			}
			return new EmbeddedFont(name, bold, italic);
		}
		
		public function resetComponent():void
		{
			textFlowXML = null;
			chapter = null;
			if(audioPlayer)
				audioPlayer.stop();
			boldButton.selected 		= false;
			italicButton.selected 		= false;
			underlineButton.selected 	= false;
			leftAlignButton.selected 	= false;
			rightAlignButton.selected 	= false;
			centerAlignButton.selected 	= false;
			soundRenderer = null;
		}
		
		private function resetSoundIcon():void
		{
			soundRenderer.source = PLAY_ICON;
		}
		
		
		protected function playSound( soundUrl:String ) : void
		{
			if(audioPlayer.position != 0 && audioPlayer.sndURL == soundUrl)
			{
				audioPlayer.play( true );
				return;
			}
			
			audioPlayer.sndURL = null;
			audioPlayer.sndURL = soundUrl;
			audioPlayer.play();
		}
		
		protected function pauseSound( ) : void
		{
			if(audioPlayer && audioPlayer.playing)
				audioPlayer.pause();
		}
		
				
		private function updateEditManager():void
		{
			if(!contentText)
				return;
			editManager = contentText.textFlow.interactionManager as EditManager;
			if(editManager)
			{
				// reset initial text color
				var colorStyle:TextLayoutFormat = new TextLayoutFormat();
				colorStyle.color = initialTextColor;
				editManager.applyLeafFormat(colorStyle);
				
				// reset line height
				var containerStyle:TextLayoutFormat = new TextLayoutFormat();
				containerStyle.lineHeight = lineHeight;
				editManager.applyParagraphFormat(containerStyle);
			}
		}
		
		private function updateAlignButtons( mxmlChildren:Array):void
		{
			if(!mxmlChildren)
				return;
			
			var children:FlowElement;
			for (var i:int = 0; i < mxmlChildren.length; i++)
			{
				var obj:Object = mxmlChildren[i];
				children = obj as FlowElement;
				if (children is DivElement)
				{
					updateAlignButtons(DivElement(children).mxmlChildren)
				}
				else if (children is ParagraphElement)
				{
					var align:String = children.textAlign;
					
					// if paragraph element does not contain a textAlign, default to left
					if (!align && children.computedFormat)
						align = children.computedFormat.textAlign;
					align = align ? align : TextAlign.LEFT;
					
					leftAlignButton.selected = align == TextAlign.LEFT;
					centerAlignButton.selected = align == TextAlign.CENTER;
					rightAlignButton.selected = align == TextAlign.RIGHT;
					break;
				}
			}
			
		}
		
		private function resetAlignButtons():void {
			var paragraphs:Array = getSelectedParagraphElements();
			
			if(!paragraphs)
				return;
			
			var align:String = paragraphs[0].textAlign;
			
			// if paragraph element does not contain a textAlign, default to left
			if (!align)
				align = TextAlign.LEFT;
			
			for (var i:int = 1; i < paragraphs.length; i++) {
				var curAlign:String = paragraphs[i].textAlign;
				if (curAlign && curAlign != align) {
					align = null;
					break;
				}
			}
			
			leftAlignButton.selected = align == TextAlign.LEFT;
			centerAlignButton.selected = align == TextAlign.CENTER;
			rightAlignButton.selected = align == TextAlign.RIGHT;
		}
		
		private function getSelectedParagraphElements():Array 
		{
			
			var paragraphs:Array = new Array();
			if(!editManager || !editManager.hasSelection())
				return null;
			var start:int = editManager.getSelectionState().absoluteStart;
			var end:int = editManager.getSelectionState().absoluteEnd;
			var firstElement:FlowElement = editManager.textFlow.findLeaf(start);
			var firstElementParagraph:ParagraphElement = firstElement.getParagraph();
			var lastElement:FlowElement = editManager.textFlow.findLeaf(end);
			var lastElementParagraph:ParagraphElement = lastElement.getParagraph();
			
			paragraphs.push(firstElementParagraph);
			
			var currentElementParagraph:ParagraphElement = firstElementParagraph;
			while (currentElementParagraph != lastElementParagraph) {
				currentElementParagraph = currentElementParagraph.getNextParagraph();
				paragraphs.push(currentElementParagraph);
			}
			
			return paragraphs;
		}
		
		private function checkOnEmpty():void
		{
			if(contentText)
				contentText.errorString = StringUtil.isNullOrEmpty(contentText.text) ? resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyChapterContentError') || 'Chapter content is missing.' : '';
		}
		
		protected function setEditMenu():void
		{
			var root:InteractiveObject = FlexGlobals.topLevelApplication as InteractiveObject;
			var editMenu: ContextMenu = root.contextMenu.clone();
			editMenu.hideBuiltInItems();
			editMenu.clipboardMenu = true;
			editMenu.clipboardItems.paste = chekClipboard();
			if (contentText.selectionActivePosition != contentText.selectionAnchorPosition)
			{
				editMenu.clipboardItems.clear = true;
				editMenu.clipboardItems.copy = true;
				editMenu.clipboardItems.cut = true;
			}
			contentText['contextMenu'] = editMenu;
		}
		
		protected function chekClipboard():Boolean
		{
			if((Clipboard.generalClipboard.hasFormat(ClipboardFormats.HTML_FORMAT)) || (Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)))
				return true;
			return false;
		}
		
		/**
		 * 
		 * @param loader
		 * @return 
		 * 
		 */		
		private function getImageElementByLoader(loader:DisplayObject):InlineGraphicElement
		{
			if(!loader)
				return null;
			var arr:Array = contentText.textFlow.getElementsByTypeName("img");
			var len:int = arr ? arr.length: 0;
			for (var j:int = 0; j < len; j++) 
			{
				var elmnt:InlineGraphicElement = arr[j] as InlineGraphicElement;
				if(elmnt && loader &&  elmnt.graphic ==  loader)
				{
					return elmnt;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param loader
		 * @return 
		 * 
		 */		
		private function getImageElementByImage(loader:InlineGraphicElement):InlineGraphicElement
		{
			if(!loader)
				return null;
			var arr:Array = contentText.textFlow.getElementsByTypeName("img");
			var len:int = arr ? arr.length: 0;
			for (var j:int = 0; j < len; j++) 
			{
				var elmnt:InlineGraphicElement = arr[j] as InlineGraphicElement;
				if(elmnt && loader &&  elmnt.source ==  loader.source)
				{
					return elmnt;
				}
			}
			return null;
		}
		
		/**
		 * @public 
		 * Remove selected image
		 */
		public function removeSelectedImage(img:InlineGraphicElement):void
		{
			var element:InlineGraphicElement = getImageElementByImage(img);
			if(element)
			{
				var group:FlowGroupElement = element.parent;
				group.removeChild(element);
			}
			contentText.textFlow.flowComposer.updateAllControllers();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
			if(chapter)
			{
				chapter.text		= textFlowXML;
				chapter.images 		= InsertMediaUtil.getTextImagesAsBinary(contentText.textFlow, null, chapter.images);
			}
		}
		/**
		 * @public 
		 * Remove selected image
		 */
		public function updateImage(img:ImageVO):void
		{
			contentText.textFlow.flowComposer.updateAllControllers();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
			if(chapter)
			{
				chapter.text		= textFlowXML;
				chapter.images 		= InsertMediaUtil.getTextImagesAsBinary(contentText.textFlow, null, chapter.images);
			}
		}
		
		private function removeUnsupportedTags(str:String):String
		{
			var pat:RegExp = /class=\"\w+\"/ig;
			return str.replace(pat, "");
		}
		
		private function checkScrollPosition():void
		{
			var line:TextFlowLine = ScrollerUtil.getCurrentTextLine( contentText.textFlow, contentText.selectionActivePosition, contentText.selectionAnchorPosition);
			if(!line)
				return;
			const topPadding:Number = Number(contentText.getStyle("paddingTop"));
			const bottomPadding:Number = Number(contentText.getStyle("paddingBottom"));
			var sRect:Rectangle = gr.scrollRect;
			var rectPos:Number = sRect.y + sRect.height + bottomPadding;
			var lh:Number = line.y + line.height;
			// If line y smaller than scroll rectangle y position 
			//or line y position and line height smaller than scroll rectangle y postion 
			// and scroll rectangle height and padding top line is visible and we do not need to scroll 	
			if(line.y > sRect.y &&  lh < rectPos)
				return;
			// if line height plus line y bigger than scroll rect y plus height we need to increase scrol position and set it to the difference 		
			var pos:Number = lh > rectPos ?  sRect.y + (lh - rectPos) + bottomPadding : line.y - topPadding;
			gr.verticalScrollPosition = pos;
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:Event):void 
		{
			updateEditManager();
			resourcesChanged();
			//dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		private function onCloseDropDownList(event:DropDownEvent):void
		{
			setFocus();
		}
		
		private function onChangeFontSizeDDList(event:IndexChangeEvent):void
		{
			var item:Object = event.currentTarget.selectedItem;
			var fontStyle:TextLayoutFormat = new TextLayoutFormat();
			fontStyle.fontSize = item;
			contentText.textFlow.leadingModel = LeadingModel.BOX;
			editManager.applyLeafFormat(fontStyle);
		}
		
		private function onFontFamilyDDListCreationCompleted(event:Event):void
		{
			fontFamilyDDList.selectedIndex = 0;
			
			var font:EmbeddedFont = getFont(fontFamilyDDList.selectedItem as String);
			if(boldButton)
				boldButton.enabled = font.bold;
			if(italicButton)
				italicButton.enabled = font.italic;
		}
		
		private function onChangeFontFamilyDDList(event:IndexChangeEvent):void
		{
			var selFromat:TextLayoutFormat = editManager.getCommonCharacterFormat() as TextLayoutFormat;
			if (!selFromat)
			{
				contentText.setFocus();
				selFromat = editManager.getCommonCharacterFormat() as TextLayoutFormat;
			}
			var item:Object = event.currentTarget.selectedItem;
			var fontStyle:TextLayoutFormat = new TextLayoutFormat();
			fontStyle.fontFamily = item;
			fontStyle.fontSize = selFromat.fontSize;
			editManager.applyLeafFormat(fontStyle);
			
			var font:EmbeddedFont = getFont(item as String);
			if(boldButton)
				boldButton.enabled = font.bold;
			if(italicButton)
				italicButton.enabled = font.italic;
		}
		
		private function onChangeInsertDDList(event:DropDownEvent):void
		{
			if(insertDDList.selectedItem)
			{
				var item:InsertContentVO = insertDDList.selectedItem as InsertContentVO;
				var textPosition:int = Math.max( contentText.selectionAnchorPosition, contentText.selectionActivePosition);
				var soundVo:SoundVO;
				insertDDList.selectedIndex = -1;
				switch(item.command)
				{
					case InsertContentVO.RECORD_SOUND:
					{
						soundVo = new SoundVO();
						soundVo.textPosition = textPosition;
						dispatchEvent(new ChapterEvent(ChapterEvent.RECORD_CHAPTER_AUDIO, soundVo));
						break;
					}
					case InsertContentVO.UPLOAD_SOUND:
					{
						soundVo = new SoundVO();
						soundVo.textPosition = textPosition;
						dispatchEvent(new ChapterEvent(ChapterEvent.UPLOAD_CHAPTER_AUDIO, soundVo));
						break;
					}
					case InsertContentVO.UPLOAD_IMAGE:
					{
						var imageVo:ImageVO = new ImageVO();
						imageVo.textPosition = textPosition;
						dispatchEvent(new ChapterEvent(ChapterEvent.INSERT_CHAPTER_IMAGE, imageVo));
						break;
					}
					case InsertContentVO.UPLOAD_VIDEO:
					{
						var videoVO:VideoVO = new VideoVO();
						videoVO.textPosition = textPosition;
						dispatchEvent(new ChapterEvent(ChapterEvent.UPLOAD_CHAPTER_VIDEO, videoVO));
						break;
					}
						
				}
			}
			setFocus();
		}
		
		
		
		
		private function onAlignButtonClick(event:MouseEvent):void
		{
			var align:String;
			if (event.currentTarget == leftAlignButton)
				align = TextAlign.LEFT;
			if (event.currentTarget == centerAlignButton)
				align = TextAlign.CENTER;
			if (event.currentTarget == rightAlignButton)
				align = TextAlign.RIGHT;
			
			var paragraphs:Array = getSelectedParagraphElements();
			
			for each (var paragraph:ParagraphElement in paragraphs) {
				paragraph.textAlign = align;
			}
			
			if(!editManager.hasSelection())
			{
				leftAlignButton.selected = align == TextAlign.LEFT;
				centerAlignButton.selected = align == TextAlign.CENTER;
				rightAlignButton.selected = align == TextAlign.RIGHT;
			}
			else
				resetAlignButtons();
			
			
			setFocus();			
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		private function onBoldButtonClick(event:MouseEvent):void 
		{
			contentText.setFocus();
			var selFromat:TextLayoutFormat = editManager.getCommonCharacterFormat() as TextLayoutFormat;
			var boldFormat:TextLayoutFormat = new TextLayoutFormat();
			boldFormat.fontWeight = boldButton.selected ? FontWeight.BOLD : FontWeight.NORMAL;
			boldFormat.fontSize = selFromat.fontSize;
			boldFormat.fontFamily = selFromat.fontFamily;
			editManager.applyLeafFormat(boldFormat);
			setFocus();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		private function onItalicButtonClick(event:MouseEvent):void 
		{
			contentText.setFocus();
			var selFromat:TextLayoutFormat = editManager.getCommonCharacterFormat() as TextLayoutFormat;
			var italicFormat:TextLayoutFormat = new TextLayoutFormat();
			italicFormat.fontStyle = italicButton.selected ? FontStyle.ITALIC : FontWeight.NORMAL;
			italicFormat.fontSize = selFromat.fontSize;
			italicFormat.fontFamily = selFromat.fontFamily;
			editManager.applyLeafFormat(italicFormat);
			setFocus();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		private function onUnderlineButtonClick(event:MouseEvent):void 
		{
			contentText.setFocus();
			var selFromat:TextLayoutFormat = editManager.getCommonCharacterFormat() as TextLayoutFormat;
			var underlineFormat:TextLayoutFormat = new TextLayoutFormat();
			underlineFormat.textDecoration = underlineButton.selected ? TextDecoration.UNDERLINE : TextDecoration.NONE;
			underlineFormat.fontSize = selFromat.fontSize;
			underlineFormat.fontFamily = selFromat.fontFamily;
			editManager.applyLeafFormat(underlineFormat);
			setFocus();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		/**
		 *  @protected
		 */
		
		
		private function onTextDisplaySelectionChange(event:FlexEvent):void 
		{
			if (!editManager)
				return;
			
			var format:ITextLayoutFormat = editManager.getCommonCharacterFormat();
			if(!format)
				return;
			
			// align
			resetAlignButtons();
			
			// font size
			var size:* = format.fontSize;
			if (size == undefined)
				fontSizeDDList.selectedIndex = -1;
			else
				fontSizeDDList.selectedItem = format.fontSize;
			
			// font family
			var family:* = format.fontFamily;
			if (family == undefined)
				fontFamilyDDList.selectedIndex = -1;
			else
				fontFamilyDDList.selectedItem = format.fontFamily;
			
			// bold, italic, underline
			var boldFormat:* = format.fontWeight;
			boldButton.selected = boldFormat == FontWeight.BOLD;
			var italicFormat:* = format.fontStyle;
			italicButton.selected = italicFormat == FontStyle.ITALIC;
			var underlineFormat:* = format.textDecoration;
			underlineButton.selected = underlineFormat == TextDecoration.UNDERLINE;
		}
		
		private function onTextDisplayCreationComplete(event:FlexEvent):void
		{
			setFocus();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onTextDisplayFocusInOut(event:FocusEvent):void
		{
			if(contentText.errorString=="")
			{
				if(event.type == FocusEvent.FOCUS_IN)
				{
					stroke.color = 0x70b2ee;
					stroke.weight = 3;
				}
				else if(event.type == FocusEvent.FOCUS_OUT)
				{
					stroke.color = 0xCCCCCC;
					stroke.weight = 0;
				}
			}
		}
		
		protected function onPreventPasteOperation(event:TextOperationEvent):void
		{
			if(event.operation is PasteOperation)
				event.preventDefault();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onDispClick(event:MouseEvent):void
		{
			if(event.type == MouseEvent.CLICK)
			{
				if(contentText.errorString=="")
					stroke.color = 0x70b2ee;
				stroke.weight = 3;
			}
			
			if(event.type ==  MouseEvent.MOUSE_OVER)
				setEditMenu();
			var disp:DisplayObject = event.target as Loader;
			if( !disp)
				return;
			var ilge:InlineGraphicElement = getImageElementByLoader(disp)
			if(ilge && (SupportedMediaFormat.isMp3(ilge.id) || SupportedMediaFormat.isVideo(ilge.id)))
				return;
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					disp.filters = [new GlowFilter(0x00FF66)]
					break;
				case MouseEvent.MOUSE_OUT:
					disp.filters = null;
					break
				case MouseEvent.CLICK:
					if(ilge)
						dispatchEvent( new ChapterEvent(ChapterEvent.EDIT_IMAGE, ilge));
					break
			}
		}
		
		protected function onFlowMouseClick(event:FlowElementMouseEvent):void
		{
			if(event.flowElement is LinkElement)
			{
				var link:LinkElement = event.flowElement as LinkElement;
				if(link)
				{
					var img:InlineGraphicElement = getImageElementFromLink(link);
					if(img)
					{
						event.preventDefault();
						event.stopPropagation();
						event.stopImmediatePropagation();
						if(SupportedMediaFormat.isMp3(img.id))
						{
							if(soundRenderer && soundRenderer.id != img.id)
							{
								if(audioPlayer)
									audioPlayer.stop();
								
								soundRenderer.source = PLAY_ICON;
							}
							if(String(img.source) == PLAY_ICON)
							{
								img.source = PAUSE_ICON;
								soundRenderer = img;
								playSound( img.id );
							}
							else
							{
								img.source = PLAY_ICON;
								soundRenderer = img;
								pauseSound();
							}
						}
						else if(SupportedMediaFormat.isVideo(img.id))
							dispatchEvent(new ChapterEvent(ChapterEvent.SHOW_VIDEO_PLAYER, img.id));
						else
							dispatchEvent(new ChapterEvent(ChapterEvent.SHOW_IMAGE_FULL_SCREEN, img.source));
					}
				}
			}
		}
		protected function onContentTextAreaKeyDown(event:KeyboardEvent):void
		{
			// how to manipulate tab
			if(event.keyCode == Keyboard.TAB && event.shiftKey)
			{
				if(contentText.errorString=="")
					stroke.color = 0xCCCCCC;
				stroke.weight = 0;
			}
			// how to manipulate cursor position
			if(event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				if(event.keyCode == Keyboard.LEFT && contentText.selectionActivePosition>0)
				{
					contentText.selectRange( event.shiftKey?contentText.selectionAnchorPosition:contentText.selectionActivePosition-1,contentText.selectionActivePosition-1);
				}
				else if(event.keyCode == Keyboard.RIGHT && contentText.selectionActivePosition<contentText.text.length)
				{
					contentText.selectRange( event.shiftKey?contentText.selectionAnchorPosition:contentText.selectionActivePosition+1,contentText.selectionActivePosition+1);
				}
				event.preventDefault(); 
			}    
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onContentTextKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.target == contentText && !contentText.editable &&(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN))
			{
				var dir :int = event.keyCode == Keyboard.UP ? -1: 1;
				gr.verticalScrollPosition += 20 * dir;
			}
		}		
		
		protected function onImageStatusChanged(event:StatusChangeEvent):void
		{
			if(event.status == "ready")
			{
				if(chapter)
				{
					chapter.images = InsertMediaUtil.getTextImagesAsBinary(contentText.textFlow, null, _chapter.images);
				}
			}
		}	
		
		private function getImageElementFromLink(link:LinkElement):InlineGraphicElement
		{
			if(!link) return null;
			for each(var item:InlineGraphicElement in link.mxmlChildren)
			{
				if(item)
					return item;
			}
			return null;
		}
		private function onTextDisplayChange(event:TextOperationEvent):void
		{
			if(chapter && !StringUtil.isNullOrEmpty(contentText.text))
				chapter.text = textFlowXML;
			formatInputText(contentText, event);
			checkOnEmpty();
			dispatchEvent(new ChapterEvent(ChapterEvent.TEXT_FLOW_CHANGE));
		}
		
		protected function onContentPasteText(event:Event):void
		{
			var sel:SelectionState = editManager.getSelectionState();
			
			var textFlow:TextFlow;
			var clipboardFormat:String;
			var textConvertFormat:String;
			if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.HTML_FORMAT))
			{
				clipboardFormat = ClipboardFormats.HTML_FORMAT;
				textConvertFormat = TextConverter.TEXT_FIELD_HTML_FORMAT;
			}
			else if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
			{
				clipboardFormat = ClipboardFormats.TEXT_FORMAT;
				textConvertFormat = TextConverter.PLAIN_TEXT_FORMAT;
			}
			else
				return ;
			
			try
			{
				textFlow = TextConverter.importToFlow(removeUnsupportedTags(String(Clipboard.generalClipboard.getData(clipboardFormat))), textConvertFormat);
			}
			catch(e:Error)
			{
				
			}
			
			if(textFlow)
			{
				var start:int = editManager.absoluteStart;
				try
				{
					var pasteText:String = textFlow.getText(0);
					var crlf:String = String.fromCharCode(13, 10);
					var regEx:RegExp = new RegExp(crlf, "g");
					pasteText = pasteText.replace(regEx, "\\n");
					var selectionAnchorPos:int = contentText.selectionAnchorPosition;
					var selectionActivePos:int = selectionAnchorPos + pasteText.length;
					contentText.insertText(pasteText);
					const range:TextRange = new TextRange(contentText.textFlow, selectionAnchorPos, selectionActivePos);
					const selState:SelectionState = new SelectionState(contentText.textFlow, selectionAnchorPos, selectionActivePos)
					var format:TextLayoutFormat = editManager.getCommonCharacterFormat( range );
					editManager.clearFormat(format, null, null, selState );
					dettachTextFlowEvents();
					contentText.textFlow = InsertMediaUtil.insertTextAndImages(contentText.textFlow, textFlow, null, start);
					contentText.textFlow.fontFamily = resourceManager.getString( ResourceConstants.FONT, FontConstants.UI_FONT );
					contentText.textFlow.flowComposer.updateLengths(0, contentText.textFlow.textLength);
					if(_chapter)
						_chapter.textFlow = contentText.textFlow;
					attachTextFlowEvents();
				}
				catch(e:TypeError)
				{
					
				}
			}
			
			contentText.setFocus();
		}
		
		
		/** 
		 * @private
		 * Sets Direction and font of text control based on user's input
		 */
		private function formatInputText(control:RichEditableText, event:TextOperationEvent):void
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
		
		/**
		 * @private
		 * Used for handling IOError events.
		 */
		protected function onPlaySoundError(event:IOErrorEvent):void
		{
			resetSoundIcon();
			dispatchEvent(event);
		}
		
		/**
		 * 
		 * Handler for <code>Event.SOUND_COMPLETE</code> event dispatched by player.
		 * 
		 * @param event The <code>Event</code> event dispatched by player.
		 * 
		 */		
		protected function onPlaySoundComplete(event:Event):void
		{
			resetSoundIcon();
		}
		
	}
}