////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.resource
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.events.GridSelectionEvent;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.components.components.datagrid.CustomDataGrid;
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.events.ChapterEvent;
	import tj.ttu.components.events.DataGridEvent;
	import tj.ttu.components.events.ResourceEvent;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.coursecreatorbase.view.components.create.BaseCreateCourseView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;

	use namespace mx_internal;
	/**
	 * EditSubjectsView class 
	 */
	public class EditResourcesView extends BaseCreateCourseView
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		[SkinPart(required="true")]
		public var radioButtonGroup:RadioButtonGroup;
		
		[SkinPart(required="true")]
		public var addNewResourceButton:Button;
		
		[SkinPart(required="true")]
		public var uploadButton:Button;
		
		[SkinPart(required="true")]
		public var resourceList:CustomDataGrid;
		
		[SkinPart(required="true")]
		public var titleTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var urlTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var resoursePathTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var commentTextArea:TextArea;
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
		private var confirmationPopup:ConfirmationPopup;
		public  var selecetdItemIndex:int = -1;
		private var popup:PopupWindow;
		private var resourcePathWatcher:ChangeWatcher;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * EditSubjectsView 
		 */
		public function EditResourcesView()
		{
			super();
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
		private var _selectedIndex:int = -1;
		
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
				if(_resources && _resources.length > 0 && selectedIndex != -1)
					currentResource = _resources.getItemAt(_selectedIndex) as ResourceVO;
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
		// resources
		//-----------------------------------------
		private var resourcesChnaged:Boolean;
		private var _resources:IList;
		
		public function get resources():IList
		{
			return _resources;
		}
		
		public function set resources(value:IList):void
		{
			if( _resources !== value)
			{
				_resources = value;
				resourcesChnaged = true;
				invalidateProperties();
				if(_resources && _resources.length > 0 && selectedIndex == -1)
					selectedIndex = 0;
			}
		}
		
		//-----------------------------------------
		// resources
		//-----------------------------------------
		private var currentResourceChnaged:Boolean;
		private var _currentResource:ResourceVO;
		
		public function get currentResource():ResourceVO
		{
			return _currentResource;
		}
		
		public function set currentResource(value:ResourceVO):void
		{
			if( _currentResource !== value)
			{
				_currentResource = value;
				enableElements( _currentResource != null );
				resourceTitle 	= _currentResource ? _currentResource.title : null;
				comment 		= _currentResource ? _currentResource.comment : null;
				url 			= _currentResource ? _currentResource.url : null;
				resourcePath 	= _currentResource ? _currentResource.resourceNativePath : null;
				resourceType 	= _currentResource ? _currentResource.resouceType : null;
				if(_currentResource)
					resourcePathWatcher = ChangeWatcher.watch(_currentResource, "resourcePath", resourcePathChange);
				else
					resourcePathWatcher.unwatch();
			}
		}
		
		//-----------------------------------------
		// title
		//-----------------------------------------
		private var resourceTitleChanged:Boolean;
		private var _resourceTitle:String;
		
		public function get resourceTitle():String
		{
			return _resourceTitle;
		}
		
		public function set resourceTitle(value:String):void
		{
			if( _resourceTitle !== value)
			{
				_resourceTitle = value;
				resourceTitleChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// comment
		//-----------------------------------------
		private var commentChanged:Boolean;
		private var _comment:String;
		
		public function get comment():String
		{
			return _comment;
		}
		
		public function set comment(value:String):void
		{
			if(_comment != value)
			{
				_comment = value;
				commentChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// url
		//-----------------------------------------
		private var urlChanged:Boolean;
		private var _url:String;

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			if( _url !== value)
			{
				_url = value;
				urlChanged = true;
				invalidateProperties();
			}
		}

		//-----------------------------------------
		// resourcePath
		//-----------------------------------------
		private var resourcePathChanged:Boolean;
		private var _resourcePath:String;

		public function get resourcePath():String
		{
			return _resourcePath;
		}

		public function set resourcePath(value:String):void
		{
			if( _resourcePath !== value)
			{
				_resourcePath = value;
				resourcePathChanged = true;
				invalidateProperties();
			}
		}

		//-----------------------------------------
		// resourceType
		//-----------------------------------------
		private var resourceTypeChanged:Boolean;
		private var _resourceType:String;

		[Bindable(event="resourceTypeChange")]
		public function get resourceType():String
		{
			return _resourceType;
		}

		public function set resourceType(value:String):void
		{
			if( _resourceType !== value)
			{
				_resourceType = value;
				resourceTypeChanged = true;
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
			if(resourcesChnaged && resourceList)
			{
				resourceList.dataProvider = _resources;
				resourcesChnaged = false;
				if( _resources && _resources.length > 0 && _resources.length > _selectedIndex && _selectedIndex != -1 )
				{
					currentResource = _resources.getItemAt( _selectedIndex ) as ResourceVO;
					resourceList.selectedIndex = _selectedIndex;
					scrollGrid( _selectedIndex );
				}
				resourceList.validateNow();
				resourceList.setFocus();
			}
			if( selectedIndexChange && resourceList && _selectedIndex != -1)
			{
				if(_selectedIndex != -1)
				{
					resourceList.selectedIndex =_selectedIndex;
					selectedIndexChange = false;
				}
			}
			if(resourceTitleChanged && titleTextArea)
			{
				titleTextArea.textFlow = _resourceTitle ? TLFUtil.createFlow(_resourceTitle, latinFont, cyrillicFont) : null;
				resourceTitleChanged = false;
			}
			if(commentChanged && commentTextArea)
			{
				commentTextArea.textFlow = _comment ? TLFUtil.createFlow(_comment, latinFont, cyrillicFont) : null;
				commentChanged = false;
			}
			if(urlChanged && urlTextArea)
			{
				urlTextArea.textFlow = _url ? TLFUtil.createFlow(_url, latinFont, cyrillicFont) : null;
				urlChanged = false;
			}
			if(resourcePathChanged && resoursePathTextArea)
			{
				resoursePathTextArea.text = _resourcePath;
				resourcePathChanged = false;
			}
			if( resourceTypeChanged && radioButtonGroup)
			{
				radioButtonGroup.selectedValue = _resourceType;
				resourceTypeChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == resourceList)
			{
				resourceList.addEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				resourceList.addEventListener(DataGridEvent.ITEM_DELETE, onResourceDelete );
			}
			if(instance == addNewResourceButton)
			{
				addNewResourceButton.addEventListener(MouseEvent.CLICK, onAddNewResource);
			}
			if(instance == titleTextArea)
			{
				titleTextArea.addEventListener(TextOperationEvent.CHANGE, onTitleTextChange);
				titleTextArea.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				titleTextArea.addEventListener(Event.PASTE, onTitlePasteText);
				titleTextArea.enabled = false;
			}
			if(instance == urlTextArea)
			{
				urlTextArea.addEventListener(TextOperationEvent.CHANGE, onUrlTextChange);
				urlTextArea.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				urlTextArea.addEventListener(Event.PASTE, onUrlPasteText);
				urlTextArea.enabled = false;
			}
			if(instance == commentTextArea)
			{
				commentTextArea.addEventListener(TextOperationEvent.CHANGE, onDescriptionTextChange);
				commentTextArea.addEventListener(Event.PASTE, onDescriptionPasteText);
				commentTextArea.enabled = false;
			}
			if(instance == uploadButton)
			{
				uploadButton.addEventListener(MouseEvent.CLICK, onUploadButtonClick);
				uploadButton.enabled = false;
			}
			if(instance == radioButtonGroup)
			{
				radioButtonGroup.addEventListener(Event.CHANGE, onRadioButtonClick);
				radioButtonGroup.enabled = false;
			}
		}
		
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == resourceList)
			{
				resourceList.removeEventListener(GridSelectionEvent.SELECTION_CHANGE, indexChangedHandler );
				resourceList.removeEventListener(DataGridEvent.ITEM_DELETE, onResourceDelete );
			}
			if(instance == addNewResourceButton)
			{
				addNewResourceButton.removeEventListener(MouseEvent.CLICK, onAddNewResource);
			}
			if(instance == titleTextArea)
			{
				titleTextArea.removeEventListener(TextOperationEvent.CHANGE, onTitleTextChange);
				titleTextArea.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				titleTextArea.removeEventListener(Event.PASTE, onTitlePasteText);
			}
			if(instance == urlTextArea)
			{
				urlTextArea.removeEventListener(TextOperationEvent.CHANGE, onUrlTextChange);
				urlTextArea.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				urlTextArea.removeEventListener(Event.PASTE, onUrlPasteText);
			}
			if(instance == commentTextArea)
			{
				commentTextArea.removeEventListener(TextOperationEvent.CHANGE, onDescriptionTextChange);
				commentTextArea.removeEventListener(Event.PASTE, onDescriptionPasteText);
			}
			if(instance == uploadButton)
			{
				uploadButton.removeEventListener(MouseEvent.CLICK, onUploadButtonClick);
			}
			if(instance == radioButtonGroup)
			{
				radioButtonGroup.removeEventListener(Event.CHANGE, onRadioButtonClick);
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
		
		override protected function onSaveClick(event:MouseEvent):void
		{
			selecetdItemIndex =  resourceList.selectedIndex;
			pulsingSaveButton(true);
			dispatchEvent( new ResourceEvent( ResourceEvent.SAVE_RESOURCES  ) );
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
			_selectedIndex = -1;
			selecetdItemIndex = -1
			resources = null;
			currentResource = null;
			resourceTitle = null;
			comment = null;
			url = null;
			if(titleTextArea)
				titleTextArea.text = "";
			if(commentTextArea)
				commentTextArea.text = "";
			if(urlTextArea)
				urlTextArea.text = "";
			if(resoursePathTextArea)
				resoursePathTextArea.text = "";
			
		}
		
		public function saveChanges():void
		{
			onSaveClick(null);
		}
		
		public function checkOnValid():Boolean
		{
			var valid:Boolean = true;
			if(!resources || resources.length == 0)
			{
				showIncompleteItemsPopup();
				return false;
			}
			
			for each(var item:ResourceVO in resources)
			{
				if(item && (StringUtil.isNullOrEmpty(item.title)))
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
		
		/**
		 *  @public
		 */
		private function enableElements(enable:Boolean):void
		{
			titleTextArea.enabled 		= enable;
			commentTextArea.enabled 	= enable;
			radioButtonGroup.enabled 	= enable;
		}
		
		private function compareChanges():void
		{
			hasChange = true;
			/*if(currentChapter)
			{
				if(!ContentTextFlowUtil.compareTwoTextFlows(originalTextFlow, contentEditor.textFlow ))
					hasChange = true;
				else if(TrimUtil.trim(titleTextArea.text) != TrimUtil.trim(currentChapter.title))
					hasChange = true;
				else
					hasChange = false;
			}*/
		}		
		
		/**
		 *  @private
		 */
		private function scrollGrid(itemIndex:int):void
		{
			resourceList.ensureCellIsVisible(itemIndex, 1);
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
		
		
		private function dispatchColectionEvent():void
		{
			if(resourceList)
				resourceList.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
		}
		
		private function checkOnEmptyText():void
		{
			if(titleTextArea)
				titleTextArea.errorString = StringUtil.isNullOrEmpty(titleTextArea.text) ? resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyChapterTitleError') || 'Chapter title text is missing.' : '';
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		private function resourcePathChange(event:Event):void
		{
			if(event is PropertyChangeEvent)
			{
				var propertyChangeEvent:PropertyChangeEvent = event as PropertyChangeEvent;
				switch(propertyChangeEvent.property)
				{
					case "resourcePath":
					{
						resourcePath = _currentResource ? _currentResource.resourcePath : null;
						break;
					}
				}
			}
		}
		
		protected function onPopupHandler(event:Event):void
		{
			popup.removeEventListener(Event.CLOSE, onPopupHandler);
			popup.removeEventListener(PopupWindow.OK, onPopupHandler);
			PopUpManager.removePopUp( popup );
			popup = null;
			dispatchEvent(new CourseEvent(CourseEvent.CANCEL_PREVIOUSE_ACTION))
		}
		/**
		 *  @protected
		 */
		protected function onResourceDelete(event:DataGridEvent):void
		{
			showDeleteConfirmPopup();			
		}
		
		private function onDeleteWarningPromptHandler(event:Event):void
		{
			if( event.type == ConfirmationPopup.YES )
			{
				if(resourceList.selectedItem)
				{
					var item:ResourceVO = resourceList.selectedItem as ResourceVO;
					dispatchEvent(new ResourceEvent(ResourceEvent.DELETE_RESOURCE, item));
				}
			}
			confirmationPopup = null;
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
			if( resourceList.selectedItem is ResourceVO )
			{
				currentResource = resourceList.selectedItem as ResourceVO;
				selectedIndex  = resourceList.selectedIndex;
			}
		}
		
		protected function onTitleTextChange(event:TextOperationEvent):void
		{
			if(currentResource)
				currentResource.title = TrimUtil.trim(titleTextArea.text);
			_resourceTitle = titleTextArea.text;
			formatInputText(titleTextArea, event );
			dispatchColectionEvent();
			compareChanges();
			checkOnEmptyText();
		}
		
		protected function onTitlePasteText(event:Event):void
		{
			applyPasteText(titleTextArea);
			if(currentResource)
				currentResource.title = TrimUtil.trim(titleTextArea.text);
			_resourceTitle = titleTextArea.text;
			compareChanges();
			checkOnEmptyText();
		}
		
		protected function onDescriptionPasteText(event:Event):void
		{
			applyPasteText(commentTextArea);
			if(currentResource)
				currentResource.comment = TrimUtil.trim(commentTextArea.text);
			_comment = commentTextArea.text;
			compareChanges(); 
		}
		
		protected function onDescriptionTextChange(event:TextOperationEvent):void
		{
			if(currentResource)
				currentResource.comment = TrimUtil.trim(commentTextArea.text);
			_comment = commentTextArea.text;
			formatInputText(commentTextArea, event );
			compareChanges();
		}
		
		protected function onUrlPasteText(event:Event):void
		{
			applyPasteText(urlTextArea);
			if(currentResource)
				currentResource.url = TrimUtil.trim(urlTextArea.text);
			_url = urlTextArea.text;
			compareChanges(); 
		}
		
		protected function onUrlTextChange(event:TextOperationEvent):void
		{
			if(currentResource)
				currentResource.url = TrimUtil.trim(urlTextArea.text);
			_url = urlTextArea.text;
			formatInputText(urlTextArea, event );
			compareChanges();
			
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
		
		protected function onRadioButtonClick(event:Event):void
		{
			resourceType = radioButtonGroup.selectedValue as String;
			if(currentResource)
				currentResource.resouceType = resourceType;
			if(_resourceType == ResourceVO.BOOK)
			{
				url = null;
				_resourcePath = currentResource.resourcePath;
				resoursePathTextArea.text = currentResource.resourcePath;
			}
			else
			{
				resourcePath = null; 
				_url = null;
				url = currentResource.url;
			}
			compareChanges();
		}
		
		protected function onUploadButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new ResourceEvent(ResourceEvent.UPLOAD_BOOK, currentResource));
		}
		
		protected function onAddNewResource(event:MouseEvent):void
		{
			selecetdItemIndex =  resourceList.selectedIndex == -1? selecetdItemIndex : resourceList.selectedIndex;
			dispatchEvent(new ResourceEvent(ResourceEvent.ADD_NEW_RESOURCE));
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
		
		private function applyPasteText(control:TextArea):void
		{
			if(!control) return;
			
			var em:EditManager = control.textFlow.interactionManager as EditManager;
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
				if(clipboardFormat == ClipboardFormats.TEXT_FORMAT)
					textFlow = TLFUtil.createFlow(decodeURI(removeUnsupportedTags(String(Clipboard.generalClipboard.getData(clipboardFormat)))), latinFont, cyrillicFont);
				else
					textFlow = TextConverter.importToFlow(decodeURI(removeUnsupportedTags(String(Clipboard.generalClipboard.getData(clipboardFormat)))), textConvertFormat);
			}
			catch(e:Error)
			{
				
			}
			
			if(textFlow)
			{
				var start:int = em.absoluteStart;
				try
				{
					//em.overwriteText(textFlow.getText(0), sel);
					var pasteText:String = textFlow.getText(0);
					var crlf:String = String.fromCharCode(13, 10);
					var regEx:RegExp = new RegExp(crlf, "g");
					pasteText = pasteText.replace(regEx, "\\n");
					var selectionAnchorPos:int = control.selectionAnchorPosition;
					var selectionActivePos:int = selectionAnchorPos + pasteText.length;
					control.insertText(pasteText);
				}
				catch(e:TypeError)
				{
					
				}
			}
			control.setFocus();
		}
		
		private function removeUnsupportedTags(str:String):String
		{
			var pat:RegExp = /class=\"\w+\"/ig;
			return str.replace(pat, "");
		}	
	}
}