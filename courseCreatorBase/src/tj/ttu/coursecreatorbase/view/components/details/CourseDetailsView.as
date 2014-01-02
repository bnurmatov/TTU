////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.details
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.InlineGraphicElementStatus;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.TextRange;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.formats.Direction;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColorStroke;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.TextArea;
	import spark.events.TextOperationEvent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.ImageNormalizer;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.ScrollerUtil;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.components.components.audio.AudioPlayer;
	import tj.ttu.components.components.audio.ManageAudioBar;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.events.AudioEvent;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.coursecreatorbase.view.components.create.BaseCreateCourseView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	/**
	 * CourseDetailsView class 
	 */
	public class CourseDetailsView extends BaseCreateCourseView
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var descriptionTextArea:TextArea;
		
		[SkinPart(required="true")]
		public var creatorTextField:TextArea;
		
		[SkinPart(required="true")]
		public var urlTextField:TextArea;
		
		[SkinPart(required="true")]
		public var aboutAuthorTextArea:RichEditableText;
		
		[SkinPart(required="true")]
		public var manageAudioBar:ManageAudioBar;
		
		[SkinPart(required="true")]
		public var insertImage:Button;
		
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
		
		private var audioPlayer:AudioPlayer;
		
		private var urlpattern:RegExp = /^http|https/i;
		private var popup:PopupWindow;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CourseDetailsView 
		 */
		public function CourseDetailsView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------
		// lesson
		//------------------------------------------
		public function get isAir():Boolean
		{
			return Capabilities.playerType == 'Desktop';
		}
		//------------------------------------------
		// lesson
		//------------------------------------------
		override public function set lesson(value:LessonVO):void
		{
			super.lesson = value;
			description = value ? value.description : null;
			author		= value ? value.creator : null;
			authorSite  = value ? value.creatorURL : null;
			aboutAuthor = value ? value.aboutCreator : null;
			sound		= value ? value.sound : null;
		}
		
		//------------------------------------------
		// description
		//------------------------------------------
		private var descriptionChanged:Boolean = false;
		private var _description:String;
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description(value:String):void
		{
			if( _description !== value)
			{
				_description = value;
				descriptionChanged = true;
				invalidateProperties()
			}
		}
		
		//------------------------------------------
		// author
		//------------------------------------------
		private var authorChanged:Boolean = false;
		private var _author:String;
		
		public function get author():String
		{
			return _author;
		}
		
		public function set author(value:String):void
		{
			if( _author !== value)
			{
				_author = value;
				authorChanged = true;
				invalidateProperties();
			}
		}
		
		//------------------------------------------
		// authorSite
		//------------------------------------------
		private var authorSiteChanged:Boolean = false;
		private var _authorSite:String;
		
		public function get authorSite():String
		{
			return _authorSite;
		}
		
		public function set authorSite(value:String):void
		{
			if( _authorSite !== value)
			{
				_authorSite = value;
				authorSiteChanged = true;
				invalidateProperties();
			}
		}
		
		//------------------------------------------
		// aboutAuthor
		//------------------------------------------
		private var aboutAuthorChanged:Boolean = false;
		private var _aboutAuthor:String;
		
		public function get aboutAuthor():String
		{
			return _aboutAuthor;
		}
		
		public function set aboutAuthor(value:String):void
		{
			if( _aboutAuthor !== value)
			{
				_aboutAuthor = value;
				aboutAuthorChanged = true;
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
				descriptionChanged = true;
				authorChanged = true;
				authorSiteChanged = true;
				aboutAuthorChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// soundUrl
		//-----------------------------------------
		private var soundUrlChanged:Boolean = false;
		private var _sound:SoundVO;
		
		public function get sound():SoundVO
		{
			return _sound;
		}
		
		public function set sound(value:SoundVO):void
		{
			if( _sound !== value)
			{
				_sound = value;
				soundUrlChanged = true;
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
			if(descriptionChanged && descriptionTextArea)
			{
				descriptionTextArea.textFlow = TLFUtil.createFlow( _description, latinFont, cyrillicFont );
				descriptionChanged = false;
			}
			if(authorChanged && creatorTextField)
			{
				creatorTextField.textFlow = TLFUtil.createFlow( _author, latinFont, cyrillicFont );
				authorChanged = false;
			}
			if(authorSiteChanged && urlTextField)
			{
				urlTextField.textFlow = TLFUtil.createFlow( _authorSite, latinFont, cyrillicFont );
				authorSiteChanged = false;
			}
			if(aboutAuthorChanged && aboutAuthorTextArea)
			{
				detachTextFlowEvents();
				aboutAuthorTextArea.textFlow = lesson ? InsertMediaUtil.createFlow( _aboutAuthor, lesson.aboutCreatorImages, null ) : null;
				aboutAuthorTextArea.textFlow.flowComposer.updateAllControllers();
				attachTextFlowEvents();
				aboutAuthorChanged = false;
			}
			if(soundUrlChanged && manageAudioBar)
			{
				manageAudioBar.hasAudioUrl = (_sound && _sound.soundUrl != null);
				if(audioPlayer) 
					audioPlayer.changeUrl = _sound ? _sound.soundUrl : null;
				soundUrlChanged = false;
			}
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == descriptionTextArea)
			{
				descriptionTextArea.addEventListener(TextOperationEvent.CHANGE, onDescriptionTextChange);
				descriptionTextArea.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				descriptionTextArea.addEventListener(Event.PASTE, onDescriptionTextPaste);
			}
			if(instance == creatorTextField)
			{
				creatorTextField.addEventListener(TextOperationEvent.CHANGE, onAuthorTextChange);
				creatorTextField.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				creatorTextField.addEventListener(Event.PASTE, onAuthorTextPaste);
			}
			if(instance == urlTextField)
			{
				urlTextField.addEventListener(TextOperationEvent.CHANGE, onAuthorSiteTextChange);
				urlTextField.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				urlTextField.addEventListener(Event.PASTE, onAuthorSiteTextPaste);
			}
			if(instance == aboutAuthorTextArea)
			{
				aboutAuthorTextArea.addEventListener(FocusEvent.FOCUS_IN, onAboutAuthorFocusInOut);
				aboutAuthorTextArea.addEventListener(FocusEvent.FOCUS_OUT, onAboutAuthorFocusInOut);
				aboutAuthorTextArea.addEventListener(TextOperationEvent.CHANGE, onAboutAthorTextChange);
				aboutAuthorTextArea.addEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				aboutAuthorTextArea.addEventListener(Event.PASTE, onAboutAthorTextPaste);
				aboutAuthorTextArea.addEventListener(MouseEvent.MOUSE_OVER, onDispClick);
				aboutAuthorTextArea.addEventListener(MouseEvent.MOUSE_OUT, onDispClick);
				aboutAuthorTextArea.addEventListener(MouseEvent.CLICK, onDispClick);
				aboutAuthorTextArea.addEventListener(FlexEvent.SELECTION_CHANGE, onSelectionChange);
				aboutAuthorTextArea.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextAreaKeyDown);
			}
			if(instance == manageAudioBar)
			{
				manageAudioBar.addEventListener(AudioEvent.PAUSE_AUDIO, onPauseAudio);
				manageAudioBar.addEventListener(AudioEvent.PLAY_AUDIO, onPlayAudio);
				manageAudioBar.addEventListener(AudioEvent.RECORD_AUDIO, onRecordAudio);
				manageAudioBar.addEventListener(AudioEvent.REMOVE_AUDIO, onRemoveAudio);
				manageAudioBar.addEventListener(AudioEvent.STOP_AUDIO, onStopAudio);
				manageAudioBar.addEventListener(AudioEvent.UPLOAD_AUDIO, onUploadAudio);
				audioPlayer = new AudioPlayer();
				audioPlayer.addEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.addEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			if(instance == insertImage)
			{
				insertImage.addEventListener(MouseEvent.CLICK, onInsertImage);
			}
			if(instance == gr)
			{
				gr.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == descriptionTextArea)
			{
				descriptionTextArea.removeEventListener(TextOperationEvent.CHANGE, onDescriptionTextChange);
				descriptionTextArea.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				descriptionTextArea.removeEventListener(Event.PASTE, onDescriptionTextPaste);
			}
			if(instance == creatorTextField)
			{
				creatorTextField.removeEventListener(TextOperationEvent.CHANGE, onAuthorTextChange);
				creatorTextField.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				creatorTextField.removeEventListener(Event.PASTE, onAuthorTextPaste);
			}
			if(instance == urlTextField)
			{
				urlTextField.removeEventListener(TextOperationEvent.CHANGE, onAuthorSiteTextChange);
				urlTextField.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				urlTextField.removeEventListener(Event.PASTE, onAuthorSiteTextPaste);
			}
			if(instance == aboutAuthorTextArea)
			{
				aboutAuthorTextArea.removeEventListener(FocusEvent.FOCUS_IN, onAboutAuthorFocusInOut);
				aboutAuthorTextArea.removeEventListener(FocusEvent.FOCUS_OUT, onAboutAuthorFocusInOut);
				aboutAuthorTextArea.removeEventListener(TextOperationEvent.CHANGE, onAboutAthorTextChange);
				aboutAuthorTextArea.removeEventListener(TextOperationEvent.CHANGING, onPreventPasteOperation);
				aboutAuthorTextArea.removeEventListener(Event.PASTE, onAboutAthorTextPaste);
				aboutAuthorTextArea.removeEventListener(MouseEvent.MOUSE_OVER, onDispClick);
				aboutAuthorTextArea.removeEventListener(MouseEvent.MOUSE_OUT, onDispClick);
				aboutAuthorTextArea.removeEventListener(MouseEvent.CLICK, onDispClick);
				aboutAuthorTextArea.removeEventListener(FlexEvent.SELECTION_CHANGE, onSelectionChange);
				aboutAuthorTextArea.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextAreaKeyDown);
			}
			if(instance == manageAudioBar)
			{
				manageAudioBar.removeEventListener(AudioEvent.PAUSE_AUDIO, onPauseAudio);
				manageAudioBar.removeEventListener(AudioEvent.PLAY_AUDIO, onPlayAudio);
				manageAudioBar.removeEventListener(AudioEvent.RECORD_AUDIO, onRecordAudio);
				manageAudioBar.removeEventListener(AudioEvent.REMOVE_AUDIO, onRemoveAudio);
				manageAudioBar.removeEventListener(AudioEvent.STOP_AUDIO, onStopAudio);
				manageAudioBar.removeEventListener(AudioEvent.UPLOAD_AUDIO, onUploadAudio);
			}
			if(instance == insertImage)
			{
				insertImage.removeEventListener(MouseEvent.CLICK, onInsertImage);
			}
			if(instance == gr)
			{
				gr.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			}
			if(audioPlayer)
			{
				audioPlayer.removeEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.removeEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
				audioPlayer = null;
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
			resetAudioComponent();
			lesson = null;
			sound = null;
			aboutAuthor = null;
			authorSite = null;
			author = null;
			description = null;
			if(descriptionTextArea)
				descriptionTextArea.text = "";
			if(creatorTextField)
			{
				creatorTextField.text = "";
				creatorTextField.errorString = "";
			}
			if(urlTextField)
			{
				urlTextField.text = "";
				urlTextField.errorString = "";
			}
			if(aboutAuthorTextArea)
			{
				aboutAuthorTextArea.text = "";
				aboutAuthorTextArea.errorString = "";
			}
		}
		/**
		 *  @public
		 */
		public function saveChanges():void
		{
			onSaveClick(null);
		}
		
		public function checkRequiredFields():Boolean
		{
			if(!lesson)
				return true;
			var valid:Boolean = true;
			if(aboutAuthorTextArea.text.length == 0)
			{
				aboutAuthorTextArea.errorString = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyFieldErrorText') || 'This field should not be empty.';
				valid = false;
			}
			
			if(creatorTextField.text.length == 0)
			{
				creatorTextField.errorString =  resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'emptyFieldErrorText') || 'This field should not be empty.';
				valid = false;
			}
			if(!valid)
				showInfoPopup();
			
			return valid;
		}
		/**
		 *  @public
		 */
		public function insertSelectedaImage(img:ImageVO):void
		{
			if(!img)
				return;
			InsertMediaUtil.insertSingleImageToTextFlow( aboutAuthorTextArea.textFlow, img );
			aboutAuthorTextArea.setFocus();
			
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
			aboutAuthorTextArea.textFlow.flowComposer.updateAllControllers();
			compareChanges();
			var picStr:String 		= String.fromCharCode(0xFDEF);
			var imgPat:RegExp 		= new RegExp(picStr, "ig");
			if(lesson)
			{
				lesson.aboutCreator = TrimUtil.trim(aboutAuthorTextArea.text);
				lesson.aboutCreator = lesson.aboutCreator.replace(imgPat, "");
				lesson.aboutCreatorImages = InsertMediaUtil.getTextImagesAsBinary(aboutAuthorTextArea.textFlow, null, lesson.aboutCreatorImages);
			}
		}
		/**
		 * @public 
		 * Remove selected image
		 */
		public function updateImage(img:ImageVO):void
		{
			var picStr:String 		= String.fromCharCode(0xFDEF);
			var imgPat:RegExp 		= new RegExp(picStr, "ig");
			aboutAuthorTextArea.textFlow.flowComposer.updateAllControllers();
			compareChanges();
			if(lesson)
			{
				lesson.aboutCreator = TrimUtil.trim(aboutAuthorTextArea.text);
				lesson.aboutCreator = lesson.aboutCreator.replace(imgPat, "");
				lesson.aboutCreatorImages = InsertMediaUtil.getTextImagesAsBinary(aboutAuthorTextArea.textFlow, null,  lesson.aboutCreatorImages);
			}
		}
		
		/**
		 *  @private
		 */
		private function compareChanges():void
		{
			if(!lesson) return;
			
			hasChange = (lesson.description != nullOrEmpty(_description) ||
				lesson.creator 		!= nullOrEmpty(_author) ||
				lesson.creatorURL 		!= nullOrEmpty(_authorSite) ||
				lesson.aboutCreator		!= nullOrEmpty(_aboutAuthor));
		}
		
		private function nullOrEmpty(str:String):String
		{
			str = TrimUtil.trim( str );
			if(!str || str =="") return null;
			else return str;
		}
		
		private function resetAudioComponent():void
		{
			if(audioPlayer)
			{
				audioPlayer.stop();
			}
			if(manageAudioBar)
				manageAudioBar.playPauseSelected = false;
		}
		
		protected function setEditMenu():void
		{
			var root:InteractiveObject = FlexGlobals.topLevelApplication as InteractiveObject;
			var editMenu: ContextMenu = root.contextMenu.clone();
			editMenu.hideBuiltInItems();
			editMenu.clipboardMenu = true;
			editMenu.clipboardItems.paste = chekClipboard();
			if (aboutAuthorTextArea.selectionActivePosition != aboutAuthorTextArea.selectionAnchorPosition)
			{
				editMenu.clipboardItems.clear = true;
				editMenu.clipboardItems.copy = true;
				editMenu.clipboardItems.cut = true;
			}
			aboutAuthorTextArea['contextMenu'] = editMenu;
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
			var arr:Array = aboutAuthorTextArea.textFlow.getElementsByTypeName("img");
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
			var arr:Array = aboutAuthorTextArea.textFlow.getElementsByTypeName("img");
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
		private function removeUnsupportedTags(str:String):String
		{
			var pat:RegExp = /class=\"\w+\"/ig;
			return str.replace(pat, "");
		}
		
		/** 
		 * 
		 */		
		private function attachTextFlowEvents():void
		{
			if(aboutAuthorTextArea.textFlow)
				aboutAuthorTextArea.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, onImageStatusChanged);
		}
		private function detachTextFlowEvents():void
		{
			if(aboutAuthorTextArea.textFlow)
			{
				if( aboutAuthorTextArea.textFlow.hasEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE))
					aboutAuthorTextArea.textFlow.removeEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, onImageStatusChanged);
			}
		}
		
		public function showInfoPopup():void
		{
			var titleText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "warningPopupTitleText") || "WARNING";
			var messageText:String = resourceManager.getString(ResourceConstants.COURSE_CREATOR, "requiredFieldEmptyWarningMessage") || "Some of the required fields in this view are empty.  Please fill in the fields before proceeding."
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
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onImageStatusChanged(event:StatusChangeEvent):void
		{
			if(event.status == InlineGraphicElementStatus.READY)
			{
				var element:InlineGraphicElement = event.element as InlineGraphicElement;
				if(element.graphic && element.source is String && element.source.indexOf("/proxy/?url") != -1)
				{
					var bitmap:Bitmap = (element.graphic as Loader).content as Bitmap;
					var bitmapData:BitmapData = ImageNormalizer.normalizeForText(bitmap.bitmapData.clone());
					element.width = bitmapData.width;
					element.height = bitmapData.height;
					bitmapData.dispose();
				}
			}
		}
		/**
		 *  @protected
		 */
		protected function onInsertImage(event:MouseEvent):void
		{
			var imageVo:ImageVO = new ImageVO();
			imageVo.textPosition = Math.max( aboutAuthorTextArea.selectionAnchorPosition, aboutAuthorTextArea.selectionActivePosition);
			dispatchEvent( new CourseEvent(CourseEvent.INSERT_IMAGE, imageVo));
		}
		/**
		 *  @protected
		 */
		protected function onUploadAudio(event:AudioEvent):void
		{
			resetAudioComponent();
			dispatchEvent(event.clone());			
		}
		/**
		 *  @protected
		 */
		protected function onRemoveAudio(event:AudioEvent):void
		{
			resetAudioComponent();
			dispatchEvent(event.clone());			
		}
		/**
		 *  @protected
		 */
		protected function onRecordAudio(event:AudioEvent):void
		{
			resetAudioComponent();
			dispatchEvent(event.clone());			
		}
		/**
		 *  @protected
		 */
		protected function onStopAudio(event:AudioEvent):void
		{
			resetAudioComponent();
		}
		/**
		 *  @protected
		 */
		protected function onPlayAudio(event:AudioEvent):void
		{
			if( audioPlayer.position != 0)
			{
				audioPlayer.play( true );
				return;
			}
			/*audioPlayer.sndURL = null;
			audioPlayer.sndURL = soundUrl;*/
			audioPlayer.play();
			
		}
		/**
		 *  @protected
		 */
		protected function onPauseAudio(event:AudioEvent):void
		{
			if(audioPlayer && audioPlayer.playing)
				audioPlayer.pause();
		}
		
		
		/**
		 * @private
		 * Used for handling IOError events.
		 */
		protected function onPlaySoundError(event:IOErrorEvent):void
		{
			if(manageAudioBar)
				manageAudioBar.playPauseSelected = false;
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
			if(manageAudioBar)
				manageAudioBar.playPauseSelected = false;
		}
		
		protected function onPreventPasteOperation(event:TextOperationEvent):void
		{
			if(event.operation is PasteOperation)
				event.preventDefault();
		}
		
		/**
		 *  @protected
		 */
		
		protected function onAboutAthorTextChange(event:TextOperationEvent):void
		{
			formatInputText( aboutAuthorTextArea, event );
			_aboutAuthor = aboutAuthorTextArea.text;
			aboutAuthorTextArea.errorString = "";
			compareChanges();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onAboutAuthorFocusInOut(event:FocusEvent):void
		{
			if(aboutAuthorTextArea.errorString=="")
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
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onDispClick(event:MouseEvent):void
		{
			if(event.type == MouseEvent.CLICK)
			{
				if(aboutAuthorTextArea.errorString=="")
					stroke.color = 0x70b2ee;
				stroke.weight = 3;
			}
			
			if(event.type ==  MouseEvent.MOUSE_OVER)
				setEditMenu();
			var disp:DisplayObject = event.target as Loader;
			if( !disp)
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
					var ilge:InlineGraphicElement = getImageElementByLoader(disp)
					if(ilge)
						dispatchEvent( new CourseEvent(CourseEvent.EDIT_IMAGE, ilge));
					break
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onSelectionChange(event:FlexEvent):void
		{
			var line:TextFlowLine = ScrollerUtil.getCurrentTextLine( aboutAuthorTextArea.textFlow, aboutAuthorTextArea.selectionActivePosition, aboutAuthorTextArea.selectionAnchorPosition);
			if(!line)
				return;
			const topPadding:Number = Number(aboutAuthorTextArea.getStyle("paddingTop"));
			const bottomPadding:Number = Number(aboutAuthorTextArea.getStyle("paddingBottom"));
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
		
		
		protected function onContentTextAreaKeyDown(event:KeyboardEvent):void
		{
			// how to manipulate tab
			if(event.keyCode == Keyboard.TAB && event.shiftKey)
			{
				if(aboutAuthorTextArea.errorString=="")
					stroke.color = 0xCCCCCC;
				stroke.weight = 0;
			}
			// how to manipulate cursor position
			if(event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				if(event.keyCode == Keyboard.LEFT && aboutAuthorTextArea.selectionActivePosition>0)
				{
					aboutAuthorTextArea.selectRange( event.shiftKey?aboutAuthorTextArea.selectionAnchorPosition:aboutAuthorTextArea.selectionActivePosition-1,aboutAuthorTextArea.selectionActivePosition-1);
				}
				else if(event.keyCode == Keyboard.RIGHT && aboutAuthorTextArea.selectionActivePosition<aboutAuthorTextArea.text.length)
				{
					aboutAuthorTextArea.selectRange( event.shiftKey?aboutAuthorTextArea.selectionAnchorPosition:aboutAuthorTextArea.selectionActivePosition+1,aboutAuthorTextArea.selectionActivePosition+1);
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
			if(event.target == aboutAuthorTextArea && !aboutAuthorTextArea.editable &&(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN))
			{
				var dir :int = event.keyCode == Keyboard.UP ? -1: 1;
				gr.verticalScrollPosition += 20 * dir;
			}
		}		
		
		protected function onAboutAthorTextPaste(event:Event):void
		{
			var em:EditManager = aboutAuthorTextArea.textFlow.interactionManager as EditManager;
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
				textFlow = TextConverter.importToFlow(removeUnsupportedTags(String(Clipboard.generalClipboard.getData(clipboardFormat))), textConvertFormat);
			}
			catch(e:Error)
			{
				
			}
			
			if(textFlow)
			{
				var start:int = em.absoluteStart;
				try
				{
					var pasteText:String = textFlow.getText(0);
					var crlf:String = String.fromCharCode(13, 10);
					var regEx:RegExp = new RegExp(crlf, "g");
					pasteText = pasteText.replace(regEx, "\\n");
					var selectionAnchorPos:int = aboutAuthorTextArea.selectionAnchorPosition;
					var selectionActivePos:int = selectionAnchorPos + pasteText.length;
					aboutAuthorTextArea.insertText(pasteText);
					const range:TextRange = new TextRange(aboutAuthorTextArea.textFlow, selectionAnchorPos, selectionActivePos);
					const selState:SelectionState = new SelectionState(aboutAuthorTextArea.textFlow, selectionAnchorPos, selectionActivePos)
					var format:TextLayoutFormat = em.getCommonCharacterFormat( range );
					em.clearFormat(format, null, null, selState );
					detachTextFlowEvents();
					aboutAuthorTextArea.textFlow = InsertMediaUtil.insertTextAndImages(aboutAuthorTextArea.textFlow, textFlow, null, start);
					aboutAuthorTextArea.textFlow.fontFamily = resourceManager.getString( ResourceConstants.FONT, FontConstants.UI_FONT );
					aboutAuthorTextArea.textFlow.flowComposer.updateLengths(0, aboutAuthorTextArea.textFlow.textLength);
					attachTextFlowEvents();
				}
				catch(e:TypeError)
				{
					
				}
			}
			
			
			
			aboutAuthorTextArea.setFocus();
			_aboutAuthor = aboutAuthorTextArea.text;
			aboutAuthorTextArea.errorString = "";
			compareChanges();
		}
		
		
		
		protected function onAuthorTextChange(event:TextOperationEvent):void
		{
			formatInputText( creatorTextField.textDisplay as RichEditableText, event );
			_author = creatorTextField.text;
			creatorTextField.errorString = "";
			compareChanges();
		}
		
		
		protected function onAuthorTextPaste(event:Event):void
		{
			applyPasteText(creatorTextField);
			_author = creatorTextField.text;
			creatorTextField.errorString = "";
			compareChanges(); 
			creatorTextField.setFocus();
		}
		
		
		protected function onAuthorSiteTextChange(event:TextOperationEvent):void
		{
			formatInputText( urlTextField.textDisplay as RichEditableText, event );
			_authorSite = urlTextField.text;
			urlTextField.errorString = "";
			compareChanges();
		}
		
		protected function onAuthorSiteTextPaste(event:Event):void
		{
			applyPasteText( urlTextField );
			_authorSite = urlTextField.text;
			urlTextField.errorString = "";
			compareChanges();
			urlTextField.setFocus();
		}
		
		protected function onDescriptionTextChange(event:TextOperationEvent):void
		{
			formatInputText( descriptionTextArea.textDisplay as RichEditableText, event );
			_description = descriptionTextArea.text;
			compareChanges();
		}
		
		
		protected function onDescriptionTextPaste(event:Event):void
		{
			applyPasteText( descriptionTextArea);
			_description = descriptionTextArea.text;
			compareChanges();
			descriptionTextArea.setFocus();
		}		
		
		private function updateLesson():void
		{
			var picStr:String 		= String.fromCharCode(0xFDEF);
			var imgPat:RegExp 		= new RegExp(picStr, "ig");
			
			lesson.description 	= _description;
			lesson.creator 		= _author;
			lesson.creatorURL	= _authorSite;
			lesson.aboutCreator = _aboutAuthor ? _aboutAuthor.replace(imgPat, "") : null;
			lesson.aboutCreatorImages = InsertMediaUtil.getTextImagesAsBinary(aboutAuthorTextArea.textFlow, null);
			lesson.sound		= _sound;
			dispatchEvent( new CourseEvent(CourseEvent.SAVE_LESSON, lesson));
		}
		
		override protected function onNextClick(event:MouseEvent):void
		{
			if(isSaveInProcess)
				return;
			if(!checkRequiredFields())
				return;
			
			if(!lesson)
				return;
			
			if(!StringUtil.isNullOrEmpty(urlTextField.text) && !urlpattern.test(urlTextField.text))
			{
				urlTextField.errorString = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'invalidUrlErrorText') || 'Invalid URL: Please type correct URL with protocol.';
				return;
			}
			
			resetAudioComponent();
			
			if(hasChange)
			{
				if(event)
					nextClicked = true;
				isSaveInProcess = true;
				updateLesson();
			}
			else
				super.onNextClick(event);
		}
		
		override protected function onSaveClick(event:MouseEvent):void
		{
			if(isSaveInProcess)
				return;
			if(!checkRequiredFields())
				return;
			
			if(!lesson)
				return;
			
			if(!StringUtil.isNullOrEmpty(urlTextField.text) && !urlpattern.test(urlTextField.text))
			{
				urlTextField.errorString = resourceManager.getString(ResourceConstants.COURSE_CREATOR, 'invalidUrlErrorText') || 'Invalid URL: Please type correct URL with protocol.';
				return;
			}
			
			isSaveInProcess = true;
			
			updateLesson();
			
			super.onSaveClick(event);
		}
		
		/**
		 *  @private
		 */
		/**
		 * 
		 * @param control
		 * 
		 */		
		private function applyPasteText(control:TextArea):void
		{
			if(!control) return;
			
			var anchorPosition:int = control.selectionAnchorPosition;
			var activePosition:int = control.selectionActivePosition;
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
				try
				{
					var pasteText:String = textFlow.getText(0);
					var charLenght:int = control.text.length > 0 ? control.maxChars - control.text.length : control.maxChars;
					if(pasteText && charLenght != -1)
						pasteText = pasteText.substr(0, charLenght );
					var crlf:String = String.fromCharCode(13, 10);
					var regEx:RegExp = new RegExp(crlf, "g");
					if(control == descriptionTextArea)
						pasteText = pasteText.replace(regEx, "\\n");
					else
						pasteText = TLFUtil.removeNewLineSymboles(pasteText);
				}
				catch(e:TypeError)
				{
					
				}
				
				var selState:SelectionState = new SelectionState( control.textFlow, anchorPosition, activePosition );
				var op:InsertTextOperation = new InsertTextOperation(selState, pasteText);
				var success:Boolean = false;
				try
				{
					success = op.doOperation();
				}
				catch(e:Error)
				{
					trace(e.message.toString());
				}
				
				if(success)
				{
					anchorPosition = Math.max( anchorPosition, activePosition ) + pasteText.length;
					activePosition = Math.max( anchorPosition, activePosition ) + pasteText.length;
					control.selectRange( anchorPosition, anchorPosition );
				}
			}
			control.setFocus();
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
		
	}
}