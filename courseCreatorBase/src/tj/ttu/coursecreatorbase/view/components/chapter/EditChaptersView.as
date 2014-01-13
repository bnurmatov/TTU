////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.chapter
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.RichText;
	import spark.components.TextArea;
	import spark.components.gridClasses.CellPosition;
	import spark.effects.Move;
	import spark.events.GridSelectionEvent;
	import spark.events.TextOperationEvent;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.utils.ContentTextFlowUtil;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	import tj.ttu.components.components.editor.ChapterContentEditor;
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.events.ChapterEvent;
	import tj.ttu.components.events.DataGridEvent;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.coursecreatorbase.view.components.create.BaseCreateCourseView;
	import tj.ttu.coursecreatorbase.view.components.question.EditQuestionsView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	/**
	 * EditChaptersView class 
	 */
	public class EditChaptersView extends BaseCreateCourseView
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var chapterList:DataGrid;
		
		[SkinPart(required="true")]
		public var addItemButton:Button;
		
		[SkinPart(required="true")]
		public var titleTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var contentEditor:ChapterContentEditor;
		
		[SkinPart(required="true")]
		public var commentButton:Button;
		
		[SkinPart(required="true")]
		public var questionsButton:Button;
		
		[SkinPart(required="false")]
		public var moveUp:Move;
		
		[SkinPart(required="false")]
		public var moveDown:Move;
		
		[SkinPart(required="true")]
		public var editMask:Group;
		
		[SkinPart(required="true")]
		public var questionsView:EditQuestionsView;
		
		RichText
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
		
		/**
		 *
		 */
		private var clonedChapter:ChapterVO;
		private var isStartEditor:Boolean = false;
		private var cellPosition:CellPosition;
		private var originalTextFlow:TextFlow;
		private var popup:PopupWindow;
		
		private var confirmationPopup:ConfirmationPopup;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * EditChaptersView 
		 */
		public function EditChaptersView()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// selectedIndex
		//-----------------------------------------
		private var selectedIndexChange:Boolean = false;
		private var _selectedIndex:int = 0;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if( _selectedIndex !== value)
			{
				_selectedIndex = value;
				selectedIndexChange = true;
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
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// chapters
		//-----------------------------------------
		private var chaptersChanged:Boolean = false;
		private var _chapters:IList;
		
		[ArrayElementType("tj.ttu.base.coretypes.ChapterVO")]
		public function get chapters():IList
		{
			return _chapters;
		}
		
		public function set chapters(value:IList):void
		{
			if( _chapters !== value)
			{
				_chapters = value;
				chaptersChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// originalChapters
		//-----------------------------------------
		private var _originalChapters:IList;
		
		[ArrayElementType("tj.ttu.base.coretypes.ChapterVO")]
		public function get originalChapters():IList
		{
			return _originalChapters;
		}
		
		public function set originalChapters(value:IList):void
		{
			if( _originalChapters !== value)
			{
				_originalChapters = value;
			}
		}
		
		//-----------------------------------------
		// currentChapters
		//-----------------------------------------
		private var currentChapterTitleChanged:Boolean = false;
		private var currentChapterChanged:Boolean = false;
		private var _currentChapter:ChapterVO;
		
		public function get currentChapter():ChapterVO
		{
			return _currentChapter;
		}
		
		public function set currentChapter(value:ChapterVO):void
		{
			if( _currentChapter !== value)
			{
				_currentChapter = value;
				enableElements( _currentChapter != null );
				currentChapterTitleChanged = true;
				currentChapterChanged = true;
				invalidateProperties();
				dispatchEvent(new ChapterEvent(ChapterEvent.CURRENT_CHAPTER_CHANGE, _currentChapter));
			}
		}
		//-----------------------------------
		// changedChapters
		//-----------------------------------		
		
		private var _changedChapters:IList;
		
		public function get changedChapters():IList
		{
			return _changedChapters;
		}
		
		public function set changedChapters(value:IList):void
		{
			_changedChapters = value;
		}
		
		//-----------------------------------
		// isAssesmentVisible
		//-----------------------------------		
		private var _isAssesmentVisible:Boolean;
		
		public function get isAssesmentVisible():Boolean
		{
			return _isAssesmentVisible;
		}
		
		public function set isAssesmentVisible(value:Boolean):void
		{
			if( _isAssesmentVisible !== value)
			{
				_isAssesmentVisible = value;
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
			if(chaptersChanged && chapterList)
			{
				chapterList.dataProvider = _chapters;
				chaptersChanged = false;
				if( _chapters && _chapters.length > 0 && _chapters.length > _selectedIndex && _selectedIndex != -1 )
				{
					currentChapter = _chapters.getItemAt( _selectedIndex ) as ChapterVO;
					chapterList.selectedIndex = _selectedIndex;
					scrollGrid( _selectedIndex );
				}
				else
					_changedChapters = null;
				chapterList.validateNow();
				chapterList.setFocus();
				if( isStartEditor )
					callLater(startEditor);
			}
			if(currentChapterTitleChanged && titleTextArea)
			{
				titleTextArea.textFlow = _currentChapter ? TLFUtil.createFlow( _currentChapter.title, latinFont, _cyrillicFont ) : null;
				_currentChapter ? checkOnEmptyText() : titleTextArea.errorString = "";
				currentChapterTitleChanged = false;
			}
			if(currentChapterChanged &&  contentEditor)
			{
				contentEditor.chapter = _currentChapter;
				currentChapterChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == chapterList)
			{
				chapterList.addEventListener(ChapterEvent.CHAPTER_TITLE_TEXT_BINDING, onTitleTextBinding);
				chapterList.addEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				chapterList.addEventListener(DataGridEvent.ITEM_DELETE, onChapterDelete );
			}
			if(instance == addItemButton)
			{
				addItemButton.addEventListener(MouseEvent.CLICK, onAddNewChapter);
			}
			if(instance == titleTextArea)
			{
				titleTextArea.addEventListener(TextOperationEvent.CHANGE, onTitleTextChange);
				titleTextArea.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				titleTextArea.addEventListener(Event.PASTE, onTitlePasteText);
				titleTextArea.enabled = false;
			}
			if(instance == contentEditor)
			{
				contentEditor.addEventListener(ChapterEvent.ORIGINAL_TEXT_FLOW, onCloneTextFlowChange);
				contentEditor.addEventListener(ChapterEvent.TEXT_FLOW_CHANGE, onContentTextFlowChange);
				contentEditor.addEventListener(ChapterEvent.RECORD_CHAPTER_AUDIO, onRecordAudioClick);
				contentEditor.addEventListener(ChapterEvent.UPLOAD_CHAPTER_AUDIO, onUploadAudioClick);
				contentEditor.addEventListener(ChapterEvent.UPLOAD_CHAPTER_VIDEO, onUploadVideoClick);
				contentEditor.addEventListener(ChapterEvent.INSERT_CHAPTER_IMAGE, onInsertImageClick);
				contentEditor.addEventListener(ChapterEvent.EDIT_IMAGE, onEditChapterImage);
				contentEditor.addEventListener(ChapterEvent.SHOW_IMAGE_FULL_SCREEN, onShowImageClick);
				contentEditor.addEventListener(ChapterEvent.SHOW_VIDEO_PLAYER, onShowVideoPlayer);
				contentEditor.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				contentEditor.enabled = false;
			}
			
			if(instance == commentButton)
			{
				commentButton.addEventListener(MouseEvent.CLICK, onChapterCommentClick);
				commentButton.enabled = false;
			}
			if(instance == questionsButton)
			{
				questionsButton.addEventListener(MouseEvent.CLICK, onAssesmentClick);
				questionsButton.enabled = false;
			}
			if(instance == moveDown)
			{
				moveDown.addEventListener(EffectEvent.EFFECT_END, onMoveDownEffectEnd);
			}
			if(instance == questionsView)
			{
			}
			
			
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == chapterList)
			{
				chapterList.removeEventListener(ChapterEvent.CHAPTER_TITLE_TEXT_BINDING, onTitleTextBinding);
				chapterList.removeEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				chapterList.removeEventListener(DataGridEvent.ITEM_DELETE, onChapterDelete );
			}
			if(instance == addItemButton)
			{
				addItemButton.removeEventListener(MouseEvent.CLICK, onAddNewChapter);
			}
			if(instance == titleTextArea)
			{
				titleTextArea.removeEventListener(TextOperationEvent.CHANGE, onTitleTextChange);
				titleTextArea.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				titleTextArea.removeEventListener(Event.PASTE, onTitlePasteText);
			}
			if(instance == contentEditor)
			{
				contentEditor.removeEventListener(ChapterEvent.ORIGINAL_TEXT_FLOW, onCloneTextFlowChange);
				contentEditor.removeEventListener(ChapterEvent.TEXT_FLOW_CHANGE, onContentTextFlowChange);
				contentEditor.removeEventListener(ChapterEvent.RECORD_CHAPTER_AUDIO, onRecordAudioClick);
				contentEditor.removeEventListener(ChapterEvent.UPLOAD_CHAPTER_AUDIO, onUploadAudioClick);
				contentEditor.removeEventListener(ChapterEvent.UPLOAD_CHAPTER_VIDEO, onUploadVideoClick);
				contentEditor.removeEventListener(ChapterEvent.INSERT_CHAPTER_IMAGE, onInsertImageClick);
				contentEditor.removeEventListener(ChapterEvent.EDIT_IMAGE, onEditChapterImage);
				contentEditor.removeEventListener(ChapterEvent.SHOW_IMAGE_FULL_SCREEN, onShowImageClick);
				contentEditor.removeEventListener(ChapterEvent.SHOW_VIDEO_PLAYER, onShowVideoPlayer);
				contentEditor.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			
			if(instance == commentButton)
			{
				commentButton.removeEventListener(MouseEvent.CLICK, onChapterCommentClick);
			}
			if(instance == questionsButton)
			{
				questionsButton.removeEventListener(MouseEvent.CLICK, onAssesmentClick);
			}
			if(instance == moveDown)
			{
				moveDown.removeEventListener(EffectEvent.EFFECT_END, onMoveDownEffectEnd);
			}
			if(instance == questionsView)
			{
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
			moveDownHolder();
			clonedChapter = null;
			cellPosition = null;
			_selectedIndex = 0;
			chapters = null;
			currentChapter = null;
			changedChapters = null;
			isStartEditor = false;
			originalTextFlow = null;
			if(titleTextArea)
				titleTextArea.text = "";
			if(contentEditor)
				contentEditor.resetComponent();
		}
		
		public function moveDownHolder():void
		{
			if(moveDown)
			{
				moveDown.yFrom = 0;
				moveDown.yTo = this.height;
				moveDown.play();
			}
		}
		
		/**
		 *  @public
		 */
		public function insertSelectedaImage(img:ImageVO):void
		{
			if(!img || !contentEditor)
				return;
			contentEditor.insertSelectedaImage(img);
		}
		
		
		/**
		 * @public 
		 * Remove selected image
		 */
		public function removeSelectedImage(img:InlineGraphicElement):void
		{
			if(!img || !contentEditor)
				return;
			contentEditor.removeSelectedImage(img);
		}
		/**
		 * @public 
		 * Remove selected image
		 */
		public function updateImage(img:ImageVO):void
		{
			if(!img || !contentEditor)
				return;
			contentEditor.updateImage(img);
		}
		
		/**
		 *  @public
		 */
		public function insertSelectedaSound(sound:SoundVO):void
		{
			if(!sound || !contentEditor)
				return;
			contentEditor.insertSelectedSound(sound);
		}
		
		/**
		 *  @public
		 */
		public function insertSelectedVideo(video:VideoVO):void
		{
			if(!video || !contentEditor)
				return;
			contentEditor.insertSelectedVideo(video);
		}
		
		/**
		 *  @private
		 */
		private function enableElements(enable:Boolean):void
		{
			titleTextArea.enabled 		= enable;
			contentEditor.enabled 		= enable;
			commentButton.enabled 		= enable;
			questionsButton.enabled 	= enable;
		}
		
		private function compareChanges():void
		{
			if(currentChapter)
			{
				if(!ContentTextFlowUtil.compareTwoTextFlows(originalTextFlow, contentEditor.textFlow ))
					hasChange = true;
				else if(TrimUtil.trim(titleTextArea.text) != TrimUtil.trim(currentChapter.title))
					hasChange = true;
				else
					hasChange = false;
			}
		}		
		
		private function checkOnEmptyText():void
		{
			if(titleTextArea)
				titleTextArea.errorString = StringUtil.isNullOrEmpty(titleTextArea.text) ? resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyChapterTitleError') || 'Chapter title text is missing.' : '';
		}
		
		private function scrollGrid(itemIndex:int):void
		{
			chapterList.ensureCellIsVisible(itemIndex, 1);
		}
		
		/**
		 * 
		 * Starts an editor session on a selected cell in the grid. This method  
		 * by-passes checks of the editable property on the DataGrid and GridColumn
		 * that prevent the user interface from starting an editor session.
		 * 
		 */	
		public function startEditor() : void
		{
			isStartEditor = true;
			
			if( chapterList.dataProvider && chapters && !chaptersChanged )
			{
				isStartEditor = false;
				if( chapterList )
				{
					cellPosition = new CellPosition(chapters.length - 1, 1 );
					chapterList.ensureCellIsVisible(cellPosition.rowIndex, cellPosition.columnIndex);
					chapterList.selectedCell = cellPosition;
					chapterList.startItemEditorSession(cellPosition.rowIndex, cellPosition.columnIndex);
				}
			}
		}	
		
		public function checkOnValid():Boolean
		{
			var valid:Boolean = true;
			if(!chapters || chapters.length == 0)
			{
				showIncompleteItemsPopup();
				return false;
			}
			
			for each(var item:ChapterVO in chapters)
			{
				if(item && (StringUtil.isNullOrEmpty(item.title) || StringUtil.isNullOrEmpty(item.text)))
				{
					valid = false;
					break;
				}
			}
			
			if(!valid)
				showIncompleteItemsPopup();
			
			return valid;
		}
		
		public function showIncompleteItemsPopup():void
		{
			var titleText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "warningPopupTitleText") || "WARNING";
			var messageText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "incompleteChaptersWarningMessage") || "Some of the chapters in this list are missing text or content.  Complete or remove these items before proceeding."
			popup = new PopupWindow();
			popup.setStyle("skinClass", InfoWindowSkin);
			popup.title = titleText;
			popup.message = messageText;
			popup.addEventListener(Event.CLOSE, onPopupHandler);
			popup.addEventListener(PopupWindow.OK, onPopupHandler);
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			PopUpManager.addPopUp(popup, rootApp, true);
			PopUpManager.centerPopUp(popup);
			popup.setFocus();
		}
		
		public function saveChanges():void
		{
			onSaveClick(null);
		}
		
		private function dispatchColectionEvent():void
		{
			if(chapterList)
				chapterList.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
		}
		
		private function setOriginalChapters():void
		{
			originalChapters = null;
			if(!chapters)
				return;
			
			if(!originalChapters) originalChapters = new ArrayCollection();
			
			for each(var item:ChapterVO in chapters)
			{
				if(item)
					originalChapters.addItem(clone( item ));
			}
		}
		
		private function clone(item:ChapterVO):ChapterVO
		{
			var clonedChapter:ChapterVO = new ChapterVO();
			clonedChapter.chapterUuid 		= item.chapterUuid;
			clonedChapter.comment 			= item.comment;
			clonedChapter.creationDate 		= item.creationDate;
			clonedChapter.id 				= item.id;
			clonedChapter.images 			= item.images;
			clonedChapter.isPublished 		= item.isPublished;
			clonedChapter.lastModifiedDate 	= item.lastModifiedDate;
			clonedChapter.lessonUuid 		= item.lessonUuid;
			clonedChapter.position 			= item.position;
			clonedChapter.questions 		= item.questions;
			clonedChapter.sounds 			= item.sounds;
			clonedChapter.text 				= item.text;
			clonedChapter.textFlow 			= item.textFlow;
			clonedChapter.title 			= item.title;
			clonedChapter.version 			= item.version;
			clonedChapter.videoList 		= item.videoList;
			return clonedChapter;
		}
		
		private function showDeleteConfirmPopup():void
		{
			var deleteChapterWarn:String 	= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, "deleteItemWarnMessage" ) || "Are you sure to delete this item?";
			var deleteTitle:String 		= resourceManager.getString( ResourceConstants.TTU_COMPONENTS, "deleteItemWarnTitle" ) || "DELETE ITEM";
			confirmationPopup = ConfirmationPopup.show( deleteTitle, deleteChapterWarn, true );
			
			confirmationPopup.addEventListener( ConfirmationPopup.YES, onDeleteWarningPromptHandler );
			confirmationPopup.addEventListener( ConfirmationPopup.NO, onDeleteWarningPromptHandler );
			confirmationPopup.addEventListener( Event.CLOSE,  onDeleteWarningPromptHandler);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		protected function onPopupHandler(event:Event):void
		{
			popup.removeEventListener(Event.CLOSE, onPopupHandler);
			popup.removeEventListener(PopupWindow.OK, onPopupHandler);
			PopUpManager.removePopUp( popup );
			popup = null;
			dispatchEvent(new CourseEvent(CourseEvent.CANCEL_PREVIOUSE_ACTION))
		}
		
		private function onDeleteWarningPromptHandler(event:Event):void
		{
			if( event.type == ConfirmationPopup.YES )
			{
				if(chapterList.selectedItem)
				{
					var item:ChapterVO = chapterList.selectedItem as ChapterVO;
					dispatchEvent(new ChapterEvent(ChapterEvent.DELETE_CHAPTER, item));
				}
			}
			confirmationPopup = null;
		}
		
		protected function onChapterDelete(event:DataGridEvent):void
		{
			showDeleteConfirmPopup();			
		}
		
		/**
		 * 
		 * Handler for <code>GridSelectionEvent.SELECTION_CHANGE</code> event dispatched by listNoun.
		 * 
		 * @param event The <code>GridSelectionEvent</code> event dispatched by listNoun.
		 * 
		 */		
		private function indexChangedHandler( event:GridSelectionEvent ) : void
		{
			if( chapterList.selectedItem is ChapterVO )
			{
				currentChapter = chapterList.selectedItem as ChapterVO;
				selectedIndex  = chapterList.selectedIndex;
				cellPosition = null;
			}
		}
		/**
		 *  @protected
		 */
		protected function onAssesmentClick(event:MouseEvent):void
		{
			if(moveUp)
			{
				questionsView.visible = isAssesmentVisible = true;
				questionsView.y =  this.height;
				moveUp.yFrom = this.height;
				moveUp.yTo = 0;
				moveUp.play();
			}
			dispatchEvent(new ChapterEvent(ChapterEvent.EDIT_CHAPTER_QUESTIONS));
		}
		
		private function onMoveDownEffectEnd(event:EffectEvent):void
		{
			questionsView.visible = isAssesmentVisible = false;
			dispatchEvent(new ChapterEvent(ChapterEvent.QUESTION_VIEW_HIDE));
		}
		
		protected function onChapterCommentClick(event:MouseEvent):void
		{
			dispatchEvent(new ChapterEvent(ChapterEvent.CHANGE_CHAPTER_COMMENT));
		}
		
		protected function onShowImageClick(event:ChapterEvent):void
		{
			dispatchEvent(event.clone());			
		}
		
		protected function onShowVideoPlayer(event:ChapterEvent):void
		{
			dispatchEvent( event.clone());
		}		
		
		protected function onInsertImageClick(event:ChapterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		
		protected function onEditChapterImage(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function onUploadAudioClick(event:ChapterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function onUploadVideoClick(event:ChapterEvent):void
		{
			dispatchEvent(event.clone());
		}		
		
		protected function onRecordAudioClick(event:ChapterEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}		
		
		protected function onAddNewChapter(event:MouseEvent):void
		{
			dispatchEvent(new ChapterEvent(ChapterEvent.ADD_NEW_CHAPTER));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onPreventPasteOperation(event:TextOperationEvent):void
		{
			if(event.operation is PasteOperation)
				event.preventDefault();
		}
		
		protected function onTitleTextChange(event:TextOperationEvent):void
		{
			if(currentChapter)
				currentChapter.title = TrimUtil.trim(titleTextArea.text);
			formatInputText(titleTextArea, event );
			dispatchColectionEvent();
			compareChanges();
			checkOnEmptyText();
		}
		
		
		protected function onTitleTextBinding(event:ChapterEvent):void
		{
			if(titleTextArea)
				titleTextArea.textFlow = TLFUtil.createFlow( event.data as String, latinFont, cyrillicFont );
			if(currentChapter)
				currentChapter.title = TrimUtil.trim(titleTextArea.text);
			compareChanges();
			checkOnEmptyText();
		}
		
		protected function onCloneTextFlowChange(event:ChapterEvent):void
		{
			originalTextFlow = event.data as TextFlow;
		}
		
		
		protected function onContentTextFlowChange(event:ChapterEvent):void
		{
			compareChanges();
		}
		
		
		protected function onTitlePasteText(event:Event):void
		{
			var em:EditManager = titleTextArea.textFlow.interactionManager as EditManager;
			var sel:SelectionState = em.getSelectionState();
			
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
				textFlow = TextConverter.importToFlow(String(Clipboard.generalClipboard.getData(clipboardFormat)), textConvertFormat);
			}
			catch(e:Error)
			{
				
			}
			
			if(textFlow)
			{
				var start:int = em.absoluteStart;
				try
				{
					titleTextArea.insertText(textFlow.getText(0));
				}
				catch(e:TypeError)
				{
					
				}
			}
			
			titleTextArea.setFocus();
			dispatchColectionEvent();
			//compareChanges();
			checkOnEmptyText();
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
		
		private function updateChapters():void
		{
			for each(var chapter:ChapterVO in chapters)
			{
				if(chapter && chapter.textFlow)
				{
					if(chapter.images)
						chapter.images = InsertMediaUtil.updateTextImagesPosition(chapter.textFlow, chapter.images);
					chapter.sounds = InsertMediaUtil.getTextSoundsAsBinary(chapter.textFlow, chapter.sounds);
					chapter.videoList = InsertMediaUtil.getTextVideoAsBinary(chapter.textFlow, chapter.videoList);
				}
			}
			
			dispatchEvent( new ChapterEvent(ChapterEvent.SAVE_CHAPTERS, chapters));
		}
		
		override protected function onNextClick(event:MouseEvent):void
		{
			if(isSaveInProcess)
				return;
			
			if(!chapters)
				return;
			
			if(!checkOnValid())
				return;
			
			if(hasChange)
			{
				if(event)
					nextClicked = true;
				isSaveInProcess = true;
				updateChapters();
			}
			else
				super.onNextClick(event);
		}
		
		override protected function onSaveClick(event:MouseEvent):void
		{
			if(isSaveInProcess)
				return;
			
			if(!chapters)
				return;
			
			if(!checkOnValid())
				return;
			
			isSaveInProcess = true;
			updateChapters();
			
			super.onSaveClick(event);
		}
		
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			if(questionsView)
				questionsView.mask = editMask;
		}
		
	}
}