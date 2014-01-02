////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.components
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.RichEditableText;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.module.assesment.views.events.ActivityEvent;
	
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
		[SkinPart(required="true")]
		public var aboutModuleTextArea:RichEditableText;
		
		[SkinPart(required="true")]
		public var startButton:Button;
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
				invalidateProperties();
			}
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
		
	
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(activityDescriptionChanged && aboutModuleTextArea)
			{
				aboutModuleTextArea.textFlow = _activityDescription ? TLFUtil.createFlow( _activityDescription, latinFont, cyrillicFont ) : null;
				activityDescriptionChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == startButton)
				startButton.addEventListener(MouseEvent.CLICK, onStartButtonClick);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == startButton)
				startButton.removeEventListener(MouseEvent.CLICK, onStartButtonClick);
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
			activityDescription = null;
		}
		/**
		 *  @private
		 */
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		
		protected function onStartButtonClick(event:MouseEvent):void
		{
			dispatchEvent(new ActivityEvent(ActivityEvent.START));
		}
	}
}