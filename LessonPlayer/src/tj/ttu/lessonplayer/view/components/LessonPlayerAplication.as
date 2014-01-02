////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.components
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.elements.GlobalSettings;
	
	import mx.core.IToolTip;
	import mx.core.Singleton;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ISystemManager;
	import mx.managers.ToolTipManager;
	
	import spark.components.WindowedApplication;
	import spark.utils.TextUtil;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.font.FontManager;
	import tj.ttu.base.utils.MemoryLeakImport;
	import tj.ttu.base.view.interfaces.IAudioController;
	import tj.ttu.lessonplayer.ApplicationFacade;
	import tj.ttu.lessonplayer.view.components.window.LessonPlayerStatusBar;
	import tj.ttu.lessonplayer.view.interfaces.ILessonPlayer;
	
	/**
	 * CCAplication class 
	 */
	public class LessonPlayerAplication extends WindowedApplication implements ILessonPlayer,IFocusManagerContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart]
		public var mainView:LessonPlayerMainView;
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'LessonPlayerAplication';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var facade:ApplicationFacade;
		
		private var fontManager:FontManager;
		
		private var imports:MemoryLeakImport;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * CCAplication 
		 */
		public function LessonPlayerAplication()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get iaudioPlayer():IAudioController
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get iMainView():LessonPlayerMainView
		{
			return mainView;
		}
		
		public function get istatus():LessonPlayerStatusBar
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function set version(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set versionVisible(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
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
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			var fontName:String = resourceManager.getString(ResourceConstants.FONT, FontConstants.UI_FONT);
			if(fontName && String(getStyle("fontFamily")) !=  fontName)
				setStyle("fontFamily", fontName);
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		protected function onCreationComplete(event:FlexEvent):void
		{
			GlobalSettings.resolveFontLookupFunction = TextUtil.resolveFontLookup; 
			Singleton.registerClass("tj.ttu.base.font::IFontManager",	
				Class(getDefinitionByName("tj.ttu.base.font::FontManager")));
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if(nativeWindow)
				nativeWindow.addEventListener(Event.CLOSING, onClosing);
			facade = ApplicationFacade.getInstance(NAME) as ApplicationFacade;
			
			if(facade)
			{
				facade.startup(this);
			}
		}
		
		
		protected function onAddedToStage(event:Event):void
		{
			stage.showDefaultContextMenu=false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChange)
		}		
		
		protected function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(Event.ADDED_TO_STAGE, 		onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, 	onRemovedFromStage);
			
			if(facade)
				facade.dispose(NAME);
		}
		
		protected function onClosing(event:Event):void
		{
			nativeWindow.removeEventListener(Event.CLOSING, onClosing);
			for (var i:int = NativeApplication.nativeApplication.openedWindows.length - 1; i >= 0; --i)
				NativeWindow(NativeApplication.nativeApplication.openedWindows[i]).close();
		}		
		
		/**
		 * 
		 * @private
		 * 
		 * Handler for application <code>KeyboardEvent.KEY_DOWN</code> event.
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			var toolTip:DisplayObject = ToolTipManager.currentToolTip as DisplayObject;
			if(toolTip && systemManager.toolTipChildren.contains(toolTip))
			{
				ToolTipManager.destroyToolTip(toolTip as IToolTip);
				ToolTipManager.currentToolTip = null;
				ToolTipManager.currentTarget = null;
			}
		}
		
		protected function onFullScreenChange(event:FullScreenEvent):void
		{
			if(event.fullScreen)
			{
				this.tabChildren = false;
				this.tabEnabled = false;
			}
			else
			{
				this.tabChildren = true;
				this.tabEnabled = true;
			}
			
		}
		
	}
}