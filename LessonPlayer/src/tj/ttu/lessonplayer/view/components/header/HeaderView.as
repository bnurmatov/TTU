////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.components.header
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.RichText;
	import spark.components.mediaClasses.VolumeBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.constants.AudioValues;
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.components.events.AudioSettingEvent;
	import tj.ttu.lessonplayer.view.events.HeaderEvent;
	import tj.ttu.lessonplayer.view.skins.AboutDialog;
	
	/**
	 * HeaderView class 
	 */
	public class HeaderView extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var helpMenu:DropDownList;
		
		[SkinPart]
		public var reloadButton:Button;
		
		[SkinPart]
		public var lessonNameLabel:RichText;
		
		[SkinPart]
		public var volumeBar:VolumeBar;
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
		private var cyrillicFont:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * HeaderView 
		 */
		public function HeaderView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		// lessonName
		//------------------------------------------------
		private var lessonNameChanged:Boolean = false;
		private var _lessonName:String;
		
		public function get lessonName():String
		{
			return _lessonName;
		}
		
		public function set lessonName(value:String):void
		{
			if( _lessonName !== value)
			{
				_lessonName = value;
				lessonNameChanged = true;
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
			if(lessonNameChanged && lessonNameLabel)
			{
				lessonNameLabel.textFlow = _lessonName ? TLFUtil.createFlow(_lessonName, latinFont, cyrillicFont) : null;
				lessonNameChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == helpMenu)
				helpMenu.addEventListener(IndexChangeEvent.CHANGE, onHelpIndexChange);
			
			if(instance == volumeBar)
			{
				volumeBar.addEventListener(FlexEvent.CHANGE_END, onAudioVolumeChange);
				volumeBar.addEventListener(FlexEvent.MUTED_CHANGE, onAudioVolumeChange);
				volumeBar.minimum 		= AudioValues.VOLUME_MIN;
				volumeBar.maximum 		= AudioValues.VOLUME_MAX;
				volumeBar.snapInterval 	= AudioValues.VOLUME_SNAP_INTERVAL;
				volumeBar.value 		= AudioValues.VOLUME;
			}
			if(instance == reloadButton)
				reloadButton.addEventListener(MouseEvent.CLICK, onReloadButtonClick);
			
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == helpMenu)
				helpMenu.removeEventListener(IndexChangeEvent.CHANGE, onHelpIndexChange);
			if(instance == volumeBar)
			{
				volumeBar.removeEventListener(FlexEvent.CHANGE_END, onAudioVolumeChange);
				volumeBar.removeEventListener(FlexEvent.MUTED_CHANGE, onAudioVolumeChange);
			}
			if(instance == reloadButton)
				reloadButton.removeEventListener(MouseEvent.CLICK, onReloadButtonClick);
			
			super.partRemoved(partName, instance);
		}
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
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
			lessonName = null;
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
		
		/**
		 *  @private
		 */
		
		protected function onHelpIndexChange(event:IndexChangeEvent):void
		{
			if(event.newIndex == 0)
			{
				dispatchEvent(new HeaderEvent(HeaderEvent.GET_HELP));
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
		
		protected function onReloadButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new HeaderEvent(HeaderEvent.RELOAD_MODULE));
		}
		
		protected function onAudioVolumeChange(event:FlexEvent):void
		{
			dispatchEvent(new AudioSettingEvent(AudioSettingEvent.AUDIO_SETTING_CHANGE,
				volumeBar ? volumeBar.value : 0, 0,
				volumeBar ? volumeBar.muted : false, false));
		}	
		
	}
}