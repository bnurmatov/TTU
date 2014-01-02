////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.datefield
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.SandboxMouseEvent;
	
	import spark.components.Button;
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.PopUpAnchor;
	import spark.components.RichEditableText;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.formatters.DateTimeFormatter;
	
	import tj.ttu.components.vo.CalendarVO;

	
	[SkinState("normal")]
	[SkinState("open")]
	[SkinState("disabled")]
	/**
	 * CustomDateField class 
	 */
	public class DateField extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var textField:RichEditableText;
		
		[SkinPart(required="false")]
		public var openButton:ToggleButton;
		
		[SkinPart(required="false")]
		public var popUp:PopUpAnchor;
		
		[SkinPart(required="false")]
		public var prevMonthButton:Button;
		
		[SkinPart(required="false")]
		public var nextMonthButton:Button;
		
		[SkinPart(required="false")]
		public var currentMonthLabel:Label;
		
		[SkinPart(required="false")]
		public var headerDataGroup:DataGroup;
		
		[SkinPart(required="false")]
		public var dataGroup:DataGroup;
		
		[SkinPart(required="false")]
		public var popupHolder:Group;
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private const DAY_OF_WEEK:Array = ["S",  "M", "T", "W", "Th", "F", "S"];
		
		// number of milliseconds in a day
		public static const DAY_OF_MILISECONDS:Number = 1000 * 60 * 60 * 24;
		
		
		private static const MONTH_NAMES:Vector.<String> = 
			Vector.<String>([
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December"
			]);
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 *  @private 
		 */
		private var mouseIsDown:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * CustomDateField 
		 */
		public function DateField()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  isOpen
		//----------------------------------
		
		private var _isOpen:Boolean = false;
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			if( _isOpen !== value)
			{
				_isOpen = value;
				if(value)
				{
					setCalendarData();
					addCloseTriggers();
				}
				else
				{
					removeCloseTriggers();
				}
				invalidateSkinState();
			}
		}
		
		//----------------------------------
		//  rollOverOpenDelay
		//----------------------------------
		
		private var _rollOverOpenDelay:Number = Number.NaN;
		private var rollOverOpenDelayTimer:Timer;
		
		/**
		 *  Specifies the delay, in milliseconds, to wait for opening the drop down 
		 *  when the anchor button is rolled over.  
		 *  If set to <code>NaN</code>, then the drop down opens on a click, not a rollover.
		 * 
		 *  @default NaN
		 *         
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get rollOverOpenDelay():Number
		{
			return _rollOverOpenDelay;
		}
		
		//----------------------------------
		//  currentMonth
		//----------------------------------
		private var currentMonthChanged:Boolean = false;
		private var _currentMonth:String;
		
		public function get currentMonth():String
		{
			return _currentMonth;
		}
		
		public function set currentMonth(value:String):void
		{
				_currentMonth = value;
				currentMonthChanged = true;
		}
		//----------------------------------
		//  dataProvider
		//----------------------------------
		private var dataProviderChanged:Boolean = false;
		private var _dataProvider:IList;
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			if( _dataProvider !== value)
			{
				_dataProvider = value;
				dataProviderChanged = true;
				invalidateProperties();
			}
		}
		//----------------------------------
		//  dayNames
		//----------------------------------
		private var dayNamesChanged:Boolean = false;
		private var _dayNames:IList;
		
		public function get dayNames():IList
		{
			return _dayNames;
		}
		
		public function set dayNames(value:IList):void
		{
			if( _dayNames !== value)
			{
				_dayNames = value;
				dayNamesChanged = true;
				invalidateProperties();
			}
		}
		

		//----------------------------------
		//  month
		//----------------------------------
		private var _month:int;
		
		[Bindable("collectionChange")]
		public function get month():int
		{
			return _month;
		}
		
		//----------------------------------
		//  year
		//----------------------------------
		private var _year:int;
		
		[Bindable("collectionChange")]
		public function get year():int
		{
			return _year;
		}
		
		//----------------------------------
		//  getDate
		//----------------------------------
		public function get date():String
		{
			return textField ? textField.text : null;
		}
		//----------------------------------
		//  selectedIndex
		//----------------------------------
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
			}
		}
		
		//----------------------------------
		//  currentDate
		//----------------------------------
		private var currentDateChanged:Boolean = false;
		private var _currentDate:Date;
		
		public function get currentDate():Date
		{
			return _currentDate;
		}
		
		public function set currentDate(value:Date):void
		{
			if( _currentDate !== value)
			{
				_currentDate = value;
				currentDateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
		//  formater
		//----------------------------------
		private var _dateFormater:DateTimeFormatter;

		public function get dateFormater():DateTimeFormatter
		{
			return _dateFormater;
		}

		public function set dateFormater(value:DateTimeFormatter):void
		{
			if( _dateFormater !== value)
			{
				_dateFormater = value;
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
			
			if(instance == dataGroup)
			{
				dataGroup.addEventListener(IndexChangeEvent.CHANGE, onCalendarIndexChange);
			}
			if(instance == openButton)
			{
				openButton.addEventListener(MouseEvent.CLICK, onOpenButtonClick);
			}
			if(instance == prevMonthButton)
			{
				prevMonthButton.addEventListener(MouseEvent.CLICK, onPrevMonthButtonClick);
			}
			
			if(instance == nextMonthButton)
			{
				nextMonthButton.addEventListener(MouseEvent.CLICK, onNextMonthButtonClick);
			}
			
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == dataGroup)
			{
				dataGroup.removeEventListener(IndexChangeEvent.CHANGE, onCalendarIndexChange);
			}
			if(instance == openButton)
			{
				openButton.removeEventListener(MouseEvent.CLICK, onOpenButtonClick);
			}
			if(instance == prevMonthButton)
			{
				prevMonthButton.removeEventListener(MouseEvent.CLICK, onPrevMonthButtonClick);
			}
			
			if(instance == nextMonthButton)
			{
				nextMonthButton.removeEventListener(MouseEvent.CLICK, onNextMonthButtonClick);
			}
			super.partRemoved(partName, instance);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(currentMonthLabel && currentMonthChanged)
			{
				currentMonthLabel.text = _currentMonth;
				currentMonthChanged = false;
			}
			
			if(dataGroup && dataProviderChanged)
			{
				dataGroup.dataProvider = _dataProvider;
				dataProviderChanged = false;
			}
			
			if(dataGroup && selectedIndexChanged)
			{
				setSelectedItem(_selectedIndex);
				selectedIndexChanged = false;
			}
			
			if(headerDataGroup && dayNamesChanged)
			{
				headerDataGroup.dataProvider = _dayNames;
				dayNamesChanged = false;
			}
			
			if(textField && currentDateChanged)
			{
				textField.text = getFormatedDate(_currentDate);
				currentDateChanged = false;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if(isOpen)
				return "open"
			return "normal";
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
		 *  Close the drop down and dispatch a <code>DropDownEvent.CLOSE</code> event.  
		 *   
		 *  @param commit If <code>true</code>, commit the selected
		 *  data item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function closeCalendar():void
		{
			isOpen = false;
			if(openButton.selected)
				openButton.selected = false;
		}   
		
		
		/**
		 *  @private
		 */
		private function setCalendarData():void
		{
			dayNames = new ArrayCollection(DAY_OF_WEEK);
			var date:Date = new Date();
			setMonthAndYear(date.month, date.fullYear);
		}
		
		private function setSelectedItem(selectedIndex:int):void
		{
			if(!dataProvider || selectedIndex == -1)
				return;
			for(var i:int = 0; i < dataProvider.length; i++)
			{
				var item:CalendarVO = dataProvider.getItemAt( i ) as CalendarVO;
				if(item && i == selectedIndex)
					item.selected = true;
				else if(item)
					item.selected = false;
			}
		}
		
		/**
		 *  Set the month and year.
		 *  @param month 0-based index of month (0 = January)
		 *  @param year The year to display (2009)
		 */
		private function setMonthAndYear(month:int, year:int):void
		{
			_month = month;
			_year = year;
			
			currentMonth = MONTH_NAMES[month] + " " + year.toString(); 
			var today:Date = new Date();
			// choose noon on the first to try to avoid DST issues
			var date:Date = new Date(year, month, 1, 12);
			// get day of week (0 = Sunday)
			var dayOfWeek:Number = date.day;
			
			// back up to Sunday
			var value:Number = date.time;
			while (dayOfWeek > 0)
			{
				value -= DAY_OF_MILISECONDS;
				dayOfWeek--;
			}
			
			var calendarData:IList = new ArrayCollection();
			
			for (var i:int = 0; i < 42; i++)
			{
				var dt:Date = new Date(value);
				var data:CalendarVO = new CalendarVO();
				if(dt.month == month)
				{
					data.date = dt;
					data.currentMonth = true;
					data.isWeekend = (dt.day == 0 || dt.day == 6);
					data.currentDay = (dt.getDate() == today.getDate() && dt.month == today.month);
				}
				calendarData.addItem(data);
				value += DAY_OF_MILISECONDS;
			}
			dataProvider = calendarData;
		}
		
		
		private function getFormatedDate(date:Date):String
		{
			if(!date)
				return null;
			if(!dateFormater)
			{
				dateFormater = new DateTimeFormatter();
				dateFormater.dateTimePattern = "MM/dd/yyyy";
			}
			return dateFormater.format( date );
		}
		
		private function onOpenButtonClick(event:MouseEvent):void
		{
			isOpen = !isOpen;
		}
		
		
		private function onCalendarIndexChange(event:IndexChangeEvent):void
		{
			if(!dataProvider)
				return;
			var selectedItem:CalendarVO = dataProvider.getItemAt( event.newIndex ) as CalendarVO;
			if(selectedItem)
			{
				currentDate = selectedItem.date;
				popUp.displayPopUp = false;
				closeCalendar() ;
			}
			
		}
		
		protected function onNextMonthButtonClick(event:MouseEvent):void
		{
			if (month == 11)
			{
				setMonthAndYear(0, year + 1);
			}
			else
			{
				setMonthAndYear(month + 1, year);
			}
		}
		
		protected function onPrevMonthButtonClick(event:MouseEvent):void
		{
			if (month == 0)
			{
				setMonthAndYear(11, year - 1);
			}
			else
			{
				setMonthAndYear(month - 1, year);
			}
		}
		
		/**
		 *  @private
		 *  Adds event triggers close the popup.
		 * 
		 *  <p>This is called when the drop down is popped up.</p>
		 */ 
		private function addCloseTriggers():void
		{
			if (systemManager)
			{
				if (isNaN(rollOverOpenDelay))
				{
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().addEventListener(Event.RESIZE, systemManager_resizeHandler, false, 0, true);
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay);
					systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, systemManager_keyDownHandler, false, 0, true);
				}
				else
				{
					systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().addEventListener(Event.RESIZE, systemManager_resizeHandler, false, 0, true);
					systemManager.getSandboxRoot().addEventListener(KeyboardEvent.KEY_DOWN, systemManager_keyDownHandler, false, 0, true);
				}
				
				if (openButton && openButton.systemManager)
					openButton.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL, systemManager_mouseWheelHandler);
			}
		}
		
		/**
		 *  @private
		 *  Adds event triggers close the popup.
		 * 
		 *  <p>This is called when the drop down is closed.</p>
		 */ 
		private function removeCloseTriggers():void
		{
			if (systemManager)
			{
				if (isNaN(rollOverOpenDelay))
				{
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler);
					systemManager.getSandboxRoot().removeEventListener(Event.RESIZE, systemManager_resizeHandler, false);
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler_noRollOverOpenDelay);
					systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, systemManager_keyDownHandler);
				}
				else
				{
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, systemManager_mouseMoveHandler);
					systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
					systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
					systemManager.getSandboxRoot().removeEventListener(Event.RESIZE, systemManager_resizeHandler);
					systemManager.getSandboxRoot().removeEventListener(KeyboardEvent.KEY_DOWN, systemManager_keyDownHandler);
				}
				
				if (openButton && openButton.systemManager)
					openButton.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL, systemManager_mouseWheelHandler);
			}
		} 
		
		/**
		 *  @private
		 *  Helper method for the mouseMove and mouseUp handlers to see if 
		 *  the mouse is over a "valid" region.  This is used to help determine 
		 *  when the dropdown should be closed.
		 */ 
		private function isTargetOverDropDownOrOpenButton(target:DisplayObject):Boolean
		{
			if (target)
			{
				// check if the target is the openButton or contained within the openButton
				if (openButton && openButton.contains(target))
					return true;
				
				if (popupHolder is DisplayObjectContainer)
				{
					if (DisplayObjectContainer(popupHolder).contains(target))
						return true;
				}
				else
				{
					if (target == popupHolder)
						return true;
				}
			}
			
			return false;
		}
		
		private function systemManager_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.ENTER)
				event.preventDefault();
			if(stage)
				stage.focus = this;
		}
		/**
		 *  @private
		 *  Called when the systemManager receives a mouseDown event. This closes
		 *  the dropDown if the target is outside of the dropDown. 
		 */     
		protected function systemManager_mouseDownHandler(event:Event):void
		{
			if(isTargetOverDropDownOrOpenButton(event.target as DisplayObject))
				return;
			// stop here if mouse was down from being down on the open button
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
			
			if (!popupHolder || 
				(popupHolder && 
					(event.target == popupHolder 
						|| (popupHolder is DisplayObjectContainer && 
							!DisplayObjectContainer(popupHolder).contains(DisplayObject(event.target))))))
			{
				
				closeCalendar();
			} 
		}
		
		/**
		 *  @private
		 *  Called when the dropdown is popped up from a rollover and the mouse moves 
		 *  anywhere on the screen.  If the mouse moves over the openButton or the dropdown, 
		 *  the popup will stay open.  Otherwise, the popup will close.
		 */ 
		protected function systemManager_mouseMoveHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			
			if (containedTarget)
				return;
			
			// if the mouse is down, wait until it's released to close the drop down
			if ((event is MouseEvent && MouseEvent(event).buttonDown) ||
				(event is SandboxMouseEvent && SandboxMouseEvent(event).buttonDown))
			{
				systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
				systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				return;
			}
			
			closeCalendar();
		}
		
		/**
		 *  @private
		 *  Debounce the mouse
		 */
		protected function systemManager_mouseUpHandler_noRollOverOpenDelay(event:Event):void
		{
			// stop here if mouse was down from being down on the open button
			if (mouseIsDown)
			{
				mouseIsDown = false;
				return;
			}
		}
		
		/**
		 *  @private
		 *  Called when the dropdown is popped up from a rollover and the mouse is released 
		 *  anywhere on the screen.  This will close the popup.
		 */ 
		protected function systemManager_mouseUpHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			
			// if we're back over the target area, remove this event listener
			// and do nothing.  we handle this in mouseMoveHandler()
			if (containedTarget)
			{
				systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler);
				systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, systemManager_mouseUpHandler);
				return;
			}
			
			closeCalendar();
		}
		
		/**
		 *  @private
		 *  Close the dropDown if the stage has been resized.
		 */
		protected function systemManager_resizeHandler(event:Event):void
		{
			closeCalendar();
		}       
		
		/**
		 *  @private
		 *  Called when the mouseWheel is used
		 */
		private function systemManager_mouseWheelHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.preventDefault();
			// Close the dropDown unless we scrolled over the dropdown and the dropdown handled the event
			/*if (popupHolder && !(DisplayObjectContainer(popupHolder).contains(DisplayObject(event.target)) && event.isDefaultPrevented()))
			closeDropDown(false);*/
		}
		
	}
}