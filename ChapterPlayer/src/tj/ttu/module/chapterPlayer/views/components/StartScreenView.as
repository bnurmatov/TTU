////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.components
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.core.mx_internal;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.TabBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.constants.AudioValues;
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.components.components.audio.TTUAudioPlayer;
	import tj.ttu.module.chapterPlayer.states.StartScreenStates;
	import tj.ttu.module.chapterPlayer.views.events.ActivityEvent;
	
	use namespace mx_internal;
	
	[SkinState("aboutModule")]
	[SkinState("aboutLesson")]
	[SkinState("aboutAuthor")]
	/**
	 * StartScreenView class 
	 */
	public class StartScreenView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="false")]
		public var aboutModuleTextArea:RichEditableText;
		
		[SkinPart(required="false")]
		public var aboutLessonTextArea:RichEditableText;
		
		[SkinPart(required="false")]
		public var audioPlayer:TTUAudioPlayer;
		
		[SkinPart(required="false")]
		public var aboutAuthorTextArea:RichEditableText;
		
		[SkinPart(required="true")]
		public var stateTabbar:TabBar;
		
		[SkinPart(required="true")]
		public var startButton:Button;
		
		[SkinPart(required="true")]
		public var previouseButton:Button;
		
		[SkinPart(required="true")]
		public var nextButton:Button;
		
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * StartScreenView 
		 */
		public function StartScreenView()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
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
				activityDescriptionChanged = true;
				lessonDescriptionChanged = true;
				aboutAuthorChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  isAboutModule
		//--------------------------------------
		private var _isAboutModule:Boolean;
		
		public function get isAboutModule():Boolean
		{
			return _isAboutModule;
		}
		
		public function set isAboutModule(value:Boolean):void
		{
			if( _isAboutModule !== value)
			{
				resetStates();
				_isAboutModule = value;
				invalidateSkinState();
			}
		}
		
		//--------------------------------------
		//  isAboutLesson
		//--------------------------------------
		private var _isAboutLesson:Boolean;
		
		public function get isAboutLesson():Boolean
		{
			return _isAboutLesson;
		}
		
		public function set isAboutLesson(value:Boolean):void
		{
			if( _isAboutLesson !== value)
			{
				resetStates();
				_isAboutLesson = value;
				invalidateSkinState();
			}
		}
		//--------------------------------------
		//  isAboutLesson
		//--------------------------------------
		private var _isAboutAuthor:Boolean;
		
		public function get isAboutAuthor():Boolean
		{
			return _isAboutAuthor;
		}
		
		public function set isAboutAuthor(value:Boolean):void
		{
			if( _isAboutAuthor !== value)
			{
				resetStates();
				_isAboutAuthor = value;
				invalidateSkinState();
			}
		}
		
		//--------------------------------------
		//  currentViewIndex
		//--------------------------------------
		private var currentViewIndexChanged:Boolean = false;
		private var _currentViewIndex:int = 0;
		
		[Bindable(event="currentViewIndexChange")]
		public function get currentViewIndex():int
		{
			return _currentViewIndex;
		}
		
		public function set currentViewIndex(value:int):void
		{
			_currentViewIndex = value;
			currentViewIndexChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("currentViewIndexChange"));
		}
		
		//--------------------------------------
		//  activityDescription
		//--------------------------------------
		private var activityDescriptionChanged:Boolean = false;
		private var _activityDescription:String;
		
		public function get activityDescription():String
		{
			return _activityDescription;
		}
		
		public function set activityDescription(value:String):void
		{
			if( _activityDescription !== value)
			{
				_activityDescription = value;
				activityDescriptionChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  lessonVO
		//--------------------------------------
		private var _lesson:LessonVO;
		
		public function get lesson():LessonVO
		{
			return _lesson;
		}
		
		public function set lesson(value:LessonVO):void
		{
			if( _lesson !== value)
			{
				_lesson = value;
				lessonDescription 	= _lesson ? _lesson.description 	: null;
				aboutAuthor 		= _lesson ? _lesson.aboutCreator 	: null;
				lessonSound 		= _lesson ? _lesson.sound 			: null;
			}
		}
		
		//--------------------------------------
		//  lessonDescription
		//--------------------------------------
		private var lessonDescriptionChanged:Boolean = false;
		private var _lessonDescription:String;
		
		public function get lessonDescription():String
		{
			return _lessonDescription;
		}
		
		public function set lessonDescription(value:String):void
		{
			if( _lessonDescription !== value)
			{
				_lessonDescription = value;
				lessonDescriptionChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  lessonSound
		//--------------------------------------
		private var lessonSoundChange:Boolean = false;
		private var _lessonSound:SoundVO;
		
		[Bindable(event="lessonSoundChange")]
		public function get lessonSound():SoundVO
		{
			return _lessonSound;
		}
		
		public function set lessonSound(value:SoundVO):void
		{
			if( _lessonSound !== value)
			{
				_lessonSound = value;
				lessonSoundChange = true;
				invalidateProperties();
				dispatchEvent(new Event("lessonSoundChange"));
			}
		}
		
		
		//--------------------------------------
		//  aboutAuthor
		//--------------------------------------
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
		
		//--------------------------------------
		//  muted
		//--------------------------------------
		private var mutedChange:Boolean = false;
		private var _muted:Boolean;
		
		public function get muted():Boolean
		{
			return _muted;
		}
		
		public function set muted(value:Boolean):void
		{
			if( _muted !== value)
			{
				_muted = value;
				mutedChange = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  tempoEnabled
		//--------------------------------------
		private var tempoEnabledChange:Boolean = false;
		private var _tempoEnabled:Boolean;
		
		public function get tempoEnabled():Boolean
		{
			return _tempoEnabled;
		}
		
		public function set tempoEnabled(value:Boolean):void
		{
			if( _tempoEnabled !== value)
			{
				_tempoEnabled = value;
				tempoEnabledChange = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  volume
		//--------------------------------------
		private var volumeChange:Boolean = false;
		private var _volume:Number;
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			if( _volume !== value)
			{
				_volume = value;
				volumeChange = true;
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
			if(currentViewIndexChanged && stateTabbar)
			{
				if(stateTabbar.selectedIndex != _currentViewIndex)
					stateTabbar.setSelectedIndex(_currentViewIndex, true);
				currentViewIndexChanged = false;
			}
			if(aboutAuthorChanged && aboutAuthorTextArea)
			{
				dettachTextFlowEvents();
				aboutAuthorTextArea.textFlow = _lesson ? InsertMediaUtil.createChapterFlow( _aboutAuthor, lesson.aboutCreatorImages, null ) : null;
				aboutAuthorChanged = false;
				attachTextFlowEvents();
			}
			if(lessonDescriptionChanged && aboutLessonTextArea)
			{
				aboutLessonTextArea.textFlow = _lessonDescription ? TLFUtil.createFlow( _lessonDescription, latinFont, cyrillicFont ) : null;
				lessonDescriptionChanged = false;
				validateNow();	
			}
			if(activityDescriptionChanged && aboutModuleTextArea)
			{
				aboutModuleTextArea.textFlow = _activityDescription ? TLFUtil.createFlow( _activityDescription, latinFont, cyrillicFont ) : null;
				activityDescriptionChanged = false;
			}
			if(lessonSoundChange && audioPlayer)
			{
				audioPlayer.soundUrl = _lessonSound ? _lessonSound.soundUrl : null;
				lessonSoundChange = false;
			}
			if(mutedChange && audioPlayer)
			{
				audioPlayer.muted = _muted;
				mutedChange = false;
			}
			if(volumeChange && audioPlayer)
			{
				audioPlayer.volume = _volume;
				volumeChange = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == stateTabbar)
				stateTabbar.addEventListener(IndexChangeEvent.CHANGE, onTabbarIndexChange);
			if(instance == startButton)
				startButton.addEventListener(MouseEvent.CLICK, onStartButtonClick);
			if(instance == previouseButton)
				previouseButton.addEventListener(MouseEvent.CLICK, onPreviouseButtonClick);
			if(instance == nextButton)
				nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClick);
			if(instance == audioPlayer)
				invalidateProperties();
			if(instance == aboutModuleTextArea)
				invalidateProperties();
			if(instance == aboutAuthorTextArea)
				invalidateProperties();
			if(instance == aboutLessonTextArea)
				invalidateProperties();
			if(instance == gr)
				gr.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == stateTabbar)
				stateTabbar.removeEventListener(IndexChangeEvent.CHANGE, onTabbarIndexChange);
			if(instance == startButton)
				startButton.removeEventListener(MouseEvent.CLICK, onStartButtonClick);
			if(instance == previouseButton)
				previouseButton.removeEventListener(MouseEvent.CLICK, onPreviouseButtonClick);
			if(instance == nextButton)
				nextButton.removeEventListener(MouseEvent.CLICK, onNextButtonClick);
			if(instance == aboutAuthorTextArea)
			{
				dettachTextFlowEvents();
			}
			if(instance == gr)
				gr.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			super.partRemoved(partName, instance);
		}
		
		
		override protected function getCurrentSkinState():String
		{
			if(isAboutAuthor)
				return StartScreenStates.ABOUT_AUTHOR;
			if(isAboutLesson)
				return StartScreenStates.ABOUT_LESSON;
			return StartScreenStates.ABOUT_MODULE;
		}
		
		override protected function resourcesChanged():void
		{
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
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
			currentViewIndex = 0;
			lesson = null;
			activityDescription = null;
			muted = false;
			tempoEnabled = false;
			volume = AudioValues.VOLUME;
			resetStates();
			if(audioPlayer)
				audioPlayer.resetComponent();
		}
		/**
		 *  @private
		 */
		private function resetStates():void
		{
			if(audioPlayer)
				audioPlayer.stop()
			_isAboutModule = false;
			_isAboutAuthor = false;
			_isAboutLesson = false;
		}
		
		private function attachTextFlowEvents():void
		{
			if(aboutAuthorTextArea && aboutAuthorTextArea.textFlow)
			{
				var linkFormat:TextLayoutFormat = new TextLayoutFormat();
				linkFormat.textDecoration = TextDecoration.NONE;
				aboutAuthorTextArea.textFlow.linkNormalFormat = linkFormat;
				aboutAuthorTextArea.textFlow.linkActiveFormat = linkFormat;
				aboutAuthorTextArea.textFlow.linkHoverFormat  = linkFormat;
				aboutAuthorTextArea.textFlow.addEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
			}
		}
		
		private function dettachTextFlowEvents():void
		{
			if(aboutAuthorTextArea && aboutAuthorTextArea.textFlow)
			{
				aboutAuthorTextArea.textFlow.removeEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
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
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onTabbarIndexChange(event:IndexChangeEvent):void
		{
			currentViewIndex = event.newIndex;
			switch(event.newIndex)
			{
				case 0:
					isAboutModule=true;
					break;
				case 1:
					isAboutLesson=true;
					break;
				case 2:
					isAboutAuthor=true;
					break;
			}
		}
		
		protected function onNextButtonClick(event:MouseEvent):void
		{
			currentViewIndex = _currentViewIndex + 1;
		}
		
		protected function onPreviouseButtonClick(event:Event):void
		{
			currentViewIndex = _currentViewIndex - 1;
		}
		
		protected function onStartButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new ActivityEvent(ActivityEvent.START));
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
						dispatchEvent(new ActivityEvent(ActivityEvent.SHOW_IMAGE_FULL_SCREEN, img.source));
					}
				}
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
	}
}