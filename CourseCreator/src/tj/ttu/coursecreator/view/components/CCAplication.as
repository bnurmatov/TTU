////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.components
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
	import mx.events.AIREvent;
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
	import tj.ttu.coursecreator.ApplicationFacade;
	import tj.ttu.coursecreator.view.components.window.CCStatusBar;
	import tj.ttu.coursecreator.view.interfaces.ICourseCreator;
	import tj.ttu.coursecreator.view.interfaces.IHolder;
	
	/**
	 * CCAplication class 
	 */
	public class CCAplication extends WindowedApplication implements ICourseCreator,IFocusManagerContainer
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart]
		public var holder:CCHolder;
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CCAplication';
		
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
		public function CCAplication()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
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
		
		public function get iholder():IHolder
		{
			return holder;
		}
		
		public function get istatus():CCStatusBar
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
			removeEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
			
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
		
		/**
		 *  @private
		 */
		private function preinitializeHandler(event:Event = null):void
		{
			// For the edge case, e.g. visible is set to true in
			// AIR xml file, we fabricate an activate event, since Flex 
			// comes in late to the show.
			systemManager.stage.nativeWindow.addEventListener(
				"activate", nativeWindow_activateHandler, false, int.MAX_VALUE, true);
			
		}
		
		/**
		 * @private
		 */
		private function nativeWindow_activateHandler(event:Event):void
		{
			if(this.focusManager)
				dispatchEvent(new AIREvent(AIREvent.WINDOW_ACTIVATE));
			
			invalidateSkinState();
		}
		
	}
}