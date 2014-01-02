////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.components
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.components.components.audio.AudioPlayer;
	import tj.ttu.components.components.progressbar.HalfCircleProgressBar;
	import tj.ttu.module.chapterPlayer.views.events.ActivityEvent;
	
	/**
	 * ChapterPlayerPanel class 
	 */
	public class ChapterPlayerPanel extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var contentViewer:RichEditableText;
		
		[SkinPart(required="true")]
		public var previouseButton:Button;
		
		[SkinPart(required="true")]
		public var nextButton:Button;
		
		[SkinPart(required="true")]
		public var progressBar:HalfCircleProgressBar;
		
		[SkinPart(required="true")]
		public var audioPlayer:AudioPlayer;
		
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
		public static const APP_FOLDER:String = "app:";
		
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
		private var soundRenderer:InlineGraphicElement;
		private var wasLearned:Boolean;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ChapterPlayerPanel 
		 */
		public function ChapterPlayerPanel()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private function get isAir():Boolean
		{
			return Capabilities.playerType == "Desktop";
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
				titleChanged = true;
				contentChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  currentChapterIndex
		//--------------------------------------
		private var _currentChapterIndex:int = 0;
		
		[Bindable(event="currentChapterIndexChanged")]
		public function get currentChapterIndex():int
		{
			return _currentChapterIndex;
		}
		
		public function set currentChapterIndex(value:int):void
		{
			if( _currentChapterIndex !== value)
			{
				_currentChapterIndex = value;
				dispatchEvent(new Event("currentChapterIndexChanged"));
			}
		}
		
		//--------------------------------------
		//  chapterCount
		//--------------------------------------
		private var _chapterCount:int = 0;
		
		[Bindable(event="chapterCountChange")]
		public function get chapterCount():int
		{
			return _chapterCount;
		}
		
		public function set chapterCount(value:int):void
		{
			if( _chapterCount !== value)
			{
				_chapterCount = value;
				dispatchEvent(new Event("chapterCountChange"));
			}
		}
		//--------------------------------------
		//  chapterProgress
		//--------------------------------------
		private var _chapterProgress:Number = 0;
		
		[Bindable(event="chapterProgressChange")]
		public function get chapterProgress():Number
		{
			return _chapterProgress;
		}
		
		public function set chapterProgress(value:Number):void
		{
			if( _chapterProgress !== value)
			{
				_chapterProgress = value;
				dispatchEvent(new Event("chapterProgressChange"));
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
				chapters 	= _lesson ? _lesson.chapters 	: null;
			}
		}
		
		//--------------------------------------
		//  chapters
		//--------------------------------------
		private var _chapters:Array
		
		public function get chapters():Array
		{
			return _chapters;
		}
		
		public function set chapters(value:Array):void
		{
			if( _chapters !== value)
			{
				_chapters = value;
				chapterCount = _chapters ? _chapters.length : 0;
				if(_chapters)
					nextChapter();
				else
					currentChapter = null;
			}
		}
		
		//--------------------------------------
		//  currentChapter
		//--------------------------------------
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
				title = _currentChapter ? _currentChapter.title : null;
				content = _currentChapter ? _currentChapter.text : null;
			}
		}
		
		//--------------------------------------
		//  title
		//--------------------------------------
		private var titleChanged:Boolean = false;
		private var _title:String;
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if( _title !== value)
			{
				_title = value;
				titleChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------
		//  content
		//--------------------------------------
		private var contentChanged:Boolean = false;
		private var _content:String;
		
		public function get content():String
		{
			return _content;
		}
		
		public function set content(value:String):void
		{
			if( _content !== value)
			{
				_content = value;
				contentChanged = true;
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
			if(contentViewer && contentChanged)
			{
				dettachTextFlowEvents();
				contentViewer.textFlow = _currentChapter ? InsertMediaUtil.createChapterFlow(_content, _currentChapter.images, _currentChapter.sounds, _currentChapter.videoList): null;
				contentChanged = false;
				attachTextFlowEvents();
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
			if(instance == contentViewer)
				dettachTextFlowEvents();
			if(instance == audioPlayer)
			{
				audioPlayer.addEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.addEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			if(instance == previouseButton)
				previouseButton.addEventListener(MouseEvent.CLICK, onPrevButtonClick);
			if(instance == nextButton)
				nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClick);
			if(instance == gr)
				gr.addEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == audioPlayer)
			{
				audioPlayer.removeEventListener(Event.SOUND_COMPLETE, onPlaySoundComplete);
				audioPlayer.removeEventListener(IOErrorEvent.IO_ERROR, onPlaySoundError);
			}
			if(instance == previouseButton)
				previouseButton.removeEventListener(MouseEvent.CLICK, onPrevButtonClick);
			if(instance == nextButton)
				nextButton.removeEventListener(MouseEvent.CLICK, onNextButtonClick);
			if(instance == gr)
				gr.removeEventListener(KeyboardEvent.KEY_DOWN, onContentTextKeyDownHandler);
			super.partRemoved(partName, instance);
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
			currentChapterIndex = 0;
			lesson = null;
			chapters = null;
			currentChapter = null;
			title = null;
			content = null;
		}
		/**
		 *  @private
		 */
		private function attachTextFlowEvents():void
		{
			if(contentViewer && contentViewer.textFlow)
			{
				var linkFormat:TextLayoutFormat = new TextLayoutFormat();
				linkFormat.textDecoration = TextDecoration.NONE;
				contentViewer.textFlow.linkNormalFormat = linkFormat;
				contentViewer.textFlow.linkActiveFormat = linkFormat;
				contentViewer.textFlow.linkHoverFormat  = linkFormat;
				contentViewer.textFlow.addEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
			}
		}
		
		private function dettachTextFlowEvents():void
		{
			if(contentViewer && contentViewer.textFlow)
			{
				contentViewer.textFlow.removeEventListener(FlowElementMouseEvent.CLICK, onFlowMouseClick);
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
		
		
		private function resetSoundIcon():void
		{
			soundRenderer.source = isAir ? APP_FOLDER + PLAY_ICON : PLAY_ICON;
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
		
		private function nextChapter():void
		{
			if(!wasLearned)
			{
				chapterProgress = ((currentChapterIndex + 1 )* 100) / chapterCount;
				wasLearned = currentChapterIndex == (chapterCount - 1);
			}
			if(_chapters && _chapters.length > currentChapterIndex)
				currentChapter = _chapters[currentChapterIndex];
		}
		
		private function prevChapter():void
		{
			currentChapterIndex -= 1;
			if(_chapters && currentChapterIndex != -1)
				currentChapter = _chapters[currentChapterIndex];
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function onContentTextKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.target == contentViewer  && (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN))
			{
				var dir :int = event.keyCode == Keyboard.UP ? -1: 1;
				gr.verticalScrollPosition += 20 * dir;
			}
		}	
		
		protected function onNextButtonClick(event:MouseEvent):void
		{
			currentChapterIndex += 1;
			if(currentChapterIndex == chapterCount)
				dispatchEvent(new ActivityEvent(ActivityEvent.SHOW_COMPLETE_POPUP));
			else
				nextChapter();
		}
		
		protected function onPrevButtonClick(event:MouseEvent):void
		{
			prevChapter();
		}
		
		/**
		 *  @protected
		 */
		
		protected function onFlowMouseClick(event:FlowElementMouseEvent):void
		{
			if(event.flowElement is LinkElement)
			{
				var link:LinkElement = event.flowElement as LinkElement;
				if(link)
				{
					var img:InlineGraphicElement = getImageElementFromLink(link);
					var playIcon:String = isAir ? APP_FOLDER + PLAY_ICON : PLAY_ICON;
					var pauseIcon:String = isAir ? APP_FOLDER + PAUSE_ICON : PAUSE_ICON;
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
								
								soundRenderer.source = playIcon;
							}
							if(String(img.source) == playIcon)
							{
								img.source = pauseIcon;
								soundRenderer = img;
								playSound( img.id );
							}
							else
							{
								img.source = playIcon;
								soundRenderer = img;
								pauseSound();
							}
						}
						else if(SupportedMediaFormat.isVideo(img.id))
							dispatchEvent(new ActivityEvent(ActivityEvent.SHOW_VIDEO_PLAYER, img.id));
						else
							dispatchEvent(new ActivityEvent(ActivityEvent.SHOW_IMAGE_FULL_SCREEN, img.source));
					}
				}
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