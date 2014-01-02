////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 30, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * TabBarItemVo class 
	 */
	public class TabBarItemVo extends EventDispatcher
	{
		
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
		 * TabBarItemVo 
		 */
		public function TabBarItemVo()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		// id
		//--------------------------------------------------------------------------
		private var _id:int;
		
		public function get tabId():int
		{
			return _id;
		}
		
		public function set tabId(value:int):void
		{
			_id = value;
		}
		
		//--------------------------------------------------------------------------
		// enabled
		//--------------------------------------------------------------------------
		private var _enabled:Boolean = true;

		[Bindable(event="tabBarItemEnabledChange")]
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if( _enabled !== value)
			{
				_enabled = value;
				dispatchEvent(new Event("tabBarItemEnabledChange"));
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		// label
		//--------------------------------------------------------------------------
		private var _label:String;

		[Bindable(event="tabBarItemLabelChange")]
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if( _label !== value)
			{
				_label = value;
				dispatchEvent(new Event("tabBarItemLabelChange"));
			}
		}

		
		//--------------------------------------------------------------------------
		// toolTip
		//--------------------------------------------------------------------------
		private var _toolTip:String;

		[Bindable(event="tabBarItemToolTipChange")]
		public function get toolTip():String
		{
			return _toolTip;
		}

		public function set toolTip(value:String):void
		{
			if( _toolTip !== value)
			{
				_toolTip = value;
				dispatchEvent(new Event("tabBarItemToolTipChange"));
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
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
		
		
	}
}