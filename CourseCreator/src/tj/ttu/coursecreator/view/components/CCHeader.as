////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 24, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.components
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.vo.LocaleVO;
	import tj.ttu.components.components.dropdown.LanguageDropDownList;
	import tj.ttu.coursecreator.view.events.AppHeaderEvent;
	import tj.ttu.coursecreator.view.skins.AboutDialog;
	
	use namespace mx_internal;
	
	/**
	 * CCHeader class 
	 */
	public class CCHeader extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var helpMenu:DropDownList;
		
		[SkinPart(required="true")]
		public var languageSelector:LanguageDropDownList;
		
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
		 * CCHeader 
		 */
		public function CCHeader()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _language:LocaleVO;

		public function get language():LocaleVO
		{
			return _language;
		}

		public function set language(value:LocaleVO):void
		{
			if( _language !== value)
			{
				_language = value;
				dispatchEvent(new AppHeaderEvent(AppHeaderEvent.LANGUAGE_CHANGE, _language));
			}
		}

		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == helpMenu)
				helpMenu.addEventListener(IndexChangeEvent.CHANGE, onHelpIndexChange);
			
			if(instance == languageSelector)
			{
				languageSelector.addEventListener(DropDownEvent.CLOSE, onLanguageChange);
				languageSelector.addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
			}
			
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == helpMenu)
				helpMenu.removeEventListener(IndexChangeEvent.CHANGE, onHelpIndexChange);
			if(instance == languageSelector)
			{
				languageSelector.removeEventListener(DropDownEvent.CLOSE, onLanguageChange);
				languageSelector.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
			}
			
			super.partRemoved(partName, instance);
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
		
		protected function onHelpIndexChange(event:IndexChangeEvent):void
		{
			if(event.newIndex == 0)
			{
				dispatchEvent(new AppHeaderEvent(AppHeaderEvent.GET_HELP));
			}
			else if(event.newIndex == 1)
			{
				var view:AboutDialog = new AboutDialog();
				var topApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
				PopUpManager.addPopUp( view, topApp, true );
				PopUpManager.centerPopUp( view );
			}
			helpMenu.selectedIndex = -1;
		}
		
		protected function onUpdateComplete(event:FlexEvent):void
		{
			languageSelector.setSelectedIndex(0, true );
			language = languageSelector.selectedItem as LocaleVO;
			languageSelector.removeEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
		}
		
		protected function onLanguageChange(event:DropDownEvent):void
		{
			if(languageSelector && languageSelector.selectedItem)
				language = languageSelector.selectedItem as LocaleVO;
		}
		
	}
}