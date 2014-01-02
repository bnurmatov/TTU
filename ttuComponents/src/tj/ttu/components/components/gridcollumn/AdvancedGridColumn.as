////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.gridcollumn
{
	import flash.events.Event;
	
	import spark.components.RadioButtonGroup;
	import spark.components.gridClasses.GridColumn;
	
	/**
	 * AdvancedGridColumn class 
	 */
	public class AdvancedGridColumn extends GridColumn
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
		 * AdvancedGridColumn 
		 */
		public function AdvancedGridColumn(columnName:String=null)
		{
			super(columnName);
			
			if (columnName)
				headerToolTip = columnName;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  headerToolTip
		//----------------------------------
		
		private var _headerToolTip:String;
		
		[Bindable("headerToolTipChanged")]
		
		/**
		 *  ToolTip for the header of this column. 
		 *  By default, the associated grid control uses the value of 
		 *  the <code>headerText</code> property  as the header tooltip.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get headerToolTip():String
		{
			return (_headerToolTip != null) ? _headerToolTip : ((headerText) ? headerText : "");
		}
		
		/**
		 *  @private
		 */
		public function set headerToolTip(value:String):void
		{
			_headerToolTip = value;
			
			if (grid)
				grid.invalidateDisplayList();
			
			dispatchChangeEvent("headerToolTipChanged");
		}
		
		
		//----------------------------------
		//  showHeaderTip
		//----------------------------------
		
		private var _showHeaderTip:Boolean = false;
		
		[Bindable("showHeaderTipChanged")]  
		
		/**
		 *  Indicates whether the headertip are shown in the column's header.
		 *  If <code>true</code>, headertip are displayed for text in the column's header. 
		 *  If <code>false</code>, the dedault, headertip aren't displayed. 
		 * 
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get showHeaderTip():Boolean
		{
			return _showHeaderTip;
		}
		
		/**
		 *  @private
		 */
		public function set showHeaderTip(value:Boolean):void
		{
			if (_showHeaderTip === value)
				return;
			
			_showHeaderTip = value;
			
			if (grid)
				grid.invalidateDisplayList();
			
			dispatchChangeEvent("showHeaderTipChanged");        
		}
		
		private var _radioButtonGroup:RadioButtonGroup;

		[Bindable(event="radioButtonGroupChange")]
		public function get radioButtonGroup():RadioButtonGroup
		{
			return _radioButtonGroup;
		}

		public function set radioButtonGroup(value:RadioButtonGroup):void
		{
			if( _radioButtonGroup !== value)
			{
				_radioButtonGroup = value;
				dispatchEvent(new Event("radioButtonGroupChange"));
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		private function dispatchChangeEvent(type:String):void
		{
			if (hasEventListener(type))
				dispatchEvent(new Event(type));
		}
		
	}
}