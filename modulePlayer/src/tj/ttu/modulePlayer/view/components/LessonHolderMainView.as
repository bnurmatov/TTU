////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 22, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.modules.Module;
	
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.modulePlayer.view.components.background.HolderBackground;
	import tj.ttu.modulePlayer.view.components.startscreen.AssessmentStartScreen;
	import tj.ttu.modulePlayer.view.components.startscreen.StartScreen;
	import tj.ttu.modulePlayer.view.events.LessonHolderEvent;
	import tj.ttu.moduleUtility.view.components.ModuleLoader;

	use namespace mx_internal;
	/**
	 * LessonHolderMainView class 
	 */
	public class LessonHolderMainView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart]
		public var moduleList:List;
		
		[SkinPart(required="false")]
		public var holderBackground:HolderBackground;
		
		[SkinPart(required="false")]
		public var moduleLoader:ModuleLoader;
		
		[SkinPart]
		public var hideButton:ToggleButton;
		
		[SkinPart]
		public var openEffect:Parallel;
		
		[SkinPart]
		public var hideEffect:Parallel;
		
		[SkinPart(required="true")]
		
		/**
		 * The <i>Start Screens</i> .
		 */
		public var startScreen:StartScreen;
		
		
		[SkinPart(required="false")]
		
		/**
		 * The <i>Assessment Start Screens</i> .
		 */
		public var assessmentStartScreen:AssessmentStartScreen;
		
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
		 * LessonHolderMainView 
		 */
		public function LessonHolderMainView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		// selectedIndex
		//------------------------------------------------
		private var selectedIndexChanged:Boolean = false;
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
				selectedIndexChanged = true;
				invalidateProperties();
				/*if(activities && activities.length > 0 )
				{
				if(activityList && activityList.selectedIndex != _selectedIndex)
				activityList.selectedIndex = _selectedIndex;
				}*/
				dispatchEvent(new LessonHolderEvent(LessonHolderEvent.SELECTED_INDEX_CHANGE));
			}
		}
		
		//------------------------------------------------
		// modules
		//------------------------------------------------
		private var modulesChanged:Boolean = false;
		private var _modules:IList;
		
		[ArrayElementType("tj.ttu.base.vo.ModuleVO")]
		public function get modules():IList
		{
			return _modules;
		}
		
		public function set modules(value:IList):void
		{
			if( _modules !== value)
			{
				_modules = value;
				modulesChanged = true;
				invalidateProperties();
			}
		}
		
		//------------------------------------------------
		// currentModule
		//------------------------------------------------
		private var _currentModule:ModuleVO;
		
		public function get currentModule():ModuleVO
		{
			return _currentModule;
		}
		
		public function set currentModule(value:ModuleVO):void
		{
			if( _currentModule !== value)
			{
				_currentModule = value;
			}
		}
		//------------------------------------------------
		// backgroundImage
		//------------------------------------------------
		private var backgroundImageChanged:Boolean = false;
		private var _backgroundImage:String;
		
		public function get backgroundImage():String
		{
			return _backgroundImage;
		}
		
		public function set backgroundImage(value:String):void
		{
			if( _backgroundImage !== value)
			{
				_backgroundImage = value;
				/*if(holderBackground)
				{
					holderBackground.maskVisible = true;
					holderBackground.url = !StringUtil.isNullOrEmpty(value) ? value: null;
				}
				else
				{
					backgroundImageChanged = true;
					invalidateProperties();
				}*/
			}
		}
		
		//------------------------------------------------
		// menuHide
		//------------------------------------------------
		private var _menuHide:Boolean;
		
		[Bindable(event="menuHideChange")]
		public function get menuHide():Boolean
		{
			return _menuHide;
		}
		
		public function set menuHide(value:Boolean):void
		{
			if( _menuHide !== value)
			{
				_menuHide = value;
				dispatchEvent(new Event("menuHideChange"));
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
			if(modulesChanged && moduleList)
			{
				moduleList.dataProvider = _modules;
				modulesChanged = false;
				moduleList.addEventListener(FlexEvent.UPDATE_COMPLETE, onListUpdateComplete);
			}
			if(backgroundImageChanged && holderBackground)
			{
				holderBackground.maskVisible = true;
				holderBackground.url = !StringUtil.isNullOrEmpty(_backgroundImage) ? _backgroundImage: null;
				backgroundImageChanged = false;
			}
			if(selectedIndexChanged && moduleList)
			{
				if(moduleList.selectedIndex !== _selectedIndex)
					moduleList.setSelectedIndex(_selectedIndex, true);
				selectedIndexChanged = false;
			}
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == moduleList)
				moduleList.addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
			if(instance == hideButton)
				hideButton.addEventListener(MouseEvent.CLICK, onHideButtonClick);
			if(instance == openEffect)
				openEffect.addEventListener(EffectEvent.EFFECT_START, onOpenEffectStart);
			if(instance == hideEffect)
				hideEffect.addEventListener(EffectEvent.EFFECT_END, onHideEffectEnd);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == moduleList)
				moduleList.removeEventListener(IndexChangeEvent.CHANGE, onIndexChange);
			if(instance == hideButton)
				hideButton.removeEventListener(MouseEvent.CLICK, onHideButtonClick);
			if(instance == openEffect)
				openEffect.removeEventListener(EffectEvent.EFFECT_START, onOpenEffectStart);
			if(instance == hideEffect)
				hideEffect.removeEventListener(EffectEvent.EFFECT_END, onHideEffectEnd);
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
		/*if(moduleLoader && moduleLoader.module)
			Module(moduleLoader.module).inv;*/
			
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
			modules = null;
			currentModule = null;
			backgroundImage = null;
		}
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
		protected function onListUpdateComplete(event:FlexEvent):void
		{
			if(modules && modules.length > 0)
			{
				moduleList.removeEventListener(FlexEvent.UPDATE_COMPLETE, onListUpdateComplete);
				if(moduleList.selectedIndex != selectedIndex)
				{
					moduleList.selectedIndex = selectedIndex;
					currentModule = _selectedIndex != -1 ? moduleList.selectedItem as ModuleVO : null;
				}
			}
		}
		
		protected function onIndexChange(event:IndexChangeEvent):void
		{
			if(event.newIndex ==  -1 && selectedIndex != -1)
			{
				moduleList.selectedIndex = -1;
				moduleList.validateNow();
				moduleList.selectedIndex =  selectedIndex;
				if(moduleLoader && moduleLoader.module)
					moduleLoader.setFocus();
				moduleList.addEventListener(FlexEvent.UPDATE_COMPLETE, 	onListUpdateComplete);
			}
			else
			{
				selectedIndex = event.newIndex;
				currentModule = _selectedIndex != -1 ? moduleList.selectedItem as ModuleVO : null;
			}
			
			menuHide = true;
			hideEffect.play();
		}
		
	
		/**
		 *  @private
		 */
		protected function onHideEffectEnd(event:EffectEvent):void
		{
			moduleList.visible = false;
		}
		
		protected function onOpenEffectStart(event:EffectEvent):void
		{
			moduleList.visible = true
		}
		
		protected function onHideButtonClick(event:MouseEvent):void
		{
			menuHide = hideButton.selected;
			if(hideButton.selected)
				hideEffect.play();
			else
				openEffect.play();
		}		
		
		
	}
}