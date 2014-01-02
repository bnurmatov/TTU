////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * PublishOptionVO class 
	 */
	[Bindable]
	public class PublishOptionVO extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const PDF					:String = 'PDF';
		public static const WINDOWS_INSTALLER	:String = 'WINDOWS_INSTALLER';
		public static const DVD_CONTENT			:String = 'DVD_CONTENT';
		public static const B4X_CONTENT			:String = 'B4X_CONTENT';
		
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
		 * PublishOptionVO 
		 */
		public function PublishOptionVO()
		{
			super(null);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//---------------------------
		//icon
		//---------------------------
		
		private var _icon:Object;
		public function get icon():Object
		{
			return _icon;
		}
		public function set icon(value:Object):void
		{
			_icon = value;
		}
		
		
		//---------------------------
		//_title
		//---------------------------
		/**
		 * 
		 * @return String The Name of the Lesson 
		 * 
		 */
		
		private var _title:String;
		public function get title():String
		{
			return _title;
		}		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		//---------------------------
		//_title  Enum: PDF, WINDOWS_INSTALLER, DVD_CONTENT, B4X_CONTENT
		//---------------------------
		private var _publishType:String;

		public function get publishType():String
		{
			return _publishType;
		}

		public function set publishType(value:String):void
		{
			if( _publishType !== value)
			{
				_publishType = value;
			}
		}

		//-------------------------------------------------------------------------------
		// enabled
		//-------------------------------------------------------------------------------
		
		private var _enabled:Boolean = false;
		
		[Bindable(event="activityEnabledChnage")]
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if( _enabled !== value)
			{
				_enabled = value;
				dispatchEvent(new Event("activityEnabledChnage"));
			}
		}
		
		
		//-------------------------------
		// selected
		//-------------------------------
		
		private var _selected:Boolean = false;
		[Bindable("selectedChange")]
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			dispatchEvent(new Event("selectedChange"));
		}
		
	}
}