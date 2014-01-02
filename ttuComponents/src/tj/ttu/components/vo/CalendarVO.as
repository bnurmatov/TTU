////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * CalendarVO class 
	 */
	public class CalendarVO extends EventDispatcher
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
		 * CalendarVO 
		 */
		public function CalendarVO()
		{
			super(null);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//  the date to display
		//-----------------------------------
		private var _date:Date;
		
		[Bindable(event="__NoChangeEvent__")]
		public function get date():Date
		{
			return _date;
		}
		
		public function set date(value:Date):void
		{
			if( _date !== value)
			{
				_date = value;
			}
		}
		
		//-----------------------------------
		//  whether that date is in the current month;
		//-----------------------------------
		private var _currentMonth:Boolean;
		
		[Bindable("__NoChangeEvent__")]
		// whether that date is in the current month;
		public function get currentMonth():Boolean
		{
			return _currentMonth;
		}
		public function set currentMonth(value:Boolean):void
		{
			_currentMonth = value;
		}
		
		//-----------------------------------
		//  isWeekend
		//-----------------------------------
		private var _currentDay:Boolean = false;

		[Bindable(event="currentDayChange")]
		public function get currentDay():Boolean
		{
			return _currentDay;
		}

		public function set currentDay(value:Boolean):void
		{
			if( _currentDay !== value)
			{
				_currentDay = value;
				dispatchEvent(new Event("currentDayChange"));
			}
		}

		//-----------------------------------
		//  dateLabel
		//-----------------------------------
		[Bindable("__NoChangeEvent__")]
		public function get dateLabel():String
		{
			return date.date.toString();
		}
		
		//-----------------------------------
		//  selected
		//-----------------------------------
		private var _selected:Boolean = false;

		[Bindable(event="selectedChange")]
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if( _selected !== value)
			{
				_selected = value;
				dispatchEvent(new Event("selectedChange"));
			}
		}
		
		//-----------------------------------
		//  isWeekend
		//-----------------------------------
		private var _isWeekend:Boolean = false;

		[Bindable(event="isWeekendChange")]
		public function get isWeekend():Boolean
		{
			return _isWeekend;
		}

		public function set isWeekend(value:Boolean):void
		{
			if( _isWeekend !== value)
			{
				_isWeekend = value;
				dispatchEvent(new Event("isWeekendChange"));
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