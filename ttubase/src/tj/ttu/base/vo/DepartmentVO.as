////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * DepartmentVO class 
	 */
	public class DepartmentVO extends EventDispatcher
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
		 * DepartmentVO 
		 */
		public function DepartmentVO()
		{
			super(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//	departmentCode
		//-----------------------------------
		private var _departmentCode:int;	

		public function get departmentCode():int
		{
			return _departmentCode;
		}

		public function set departmentCode(value:int):void
		{
			if( _departmentCode !== value)
			{
				_departmentCode = value;
			}
		}

		//-----------------------------------
		//	facultyCode
		//-----------------------------------
		private var _facultyCode:int;

		public function get facultyCode():int
		{
			return _facultyCode;
		}

		public function set facultyCode(value:int):void
		{
			if( _facultyCode !== value)
			{
				_facultyCode = value;
			}
		}

		//-----------------------------------
		//	departmentTjName
		//-----------------------------------
		private var _departmentTjName:String;

		public function get departmentTjName():String
		{
			return _departmentTjName;
		}

		public function set departmentTjName(value:String):void
		{
			_departmentTjName = value;
		}

		//-----------------------------------
		//	departmentRuName
		//-----------------------------------
		private var _departmentRuName:String;

		public function get departmentRuName():String
		{
			return _departmentRuName;
		}

		public function set departmentRuName(value:String):void
		{
			_departmentRuName = value;
		}

		//-----------------------------------
		//	departmentEnName
		private var _departmentEnName:String;

		public function get departmentEnName():String
		{
			return _departmentEnName;
		}

		public function set departmentEnName(value:String):void
		{
			if( _departmentEnName !== value)
			{
				_departmentEnName = value;
			}
		}

		//-----------------------------------
		//-----------------------------------
		//	departmentTjShortName
		//-----------------------------------
		private var _departmentTjShortName:String;

		public function get departmentTjShortName():String
		{
			return _departmentTjShortName;
		}

		public function set departmentTjShortName(value:String):void
		{
			_departmentTjShortName = value;
		}

		//-----------------------------------
		//	departmentRuShortName
		//-----------------------------------
		private var _departmentRuShortName:String;

		public function get departmentRuShortName():String
		{
			return _departmentRuShortName;
		}

		public function set departmentRuShortName(value:String):void
		{
			_departmentRuShortName = value;
		}
		//-----------------------------------
		//	departmentEnShortName
		//-----------------------------------
		private var _departmentEnShortName:String;

		public function get departmentEnShortName():String
		{
			return _departmentEnShortName;
		}

		public function set departmentEnShortName(value:String):void
		{
			_departmentEnShortName = value;
		}

		//-----------------------------------
		//	departmentManager
		//-----------------------------------
		private var _departmentManager:String;

		public function get departmentManager():String
		{
			return _departmentManager;
		}

		public function set departmentManager(value:String):void
		{
			_departmentManager = value;
		}

		//-----------------------------------
		//	orderNumber
		//-----------------------------------
		private var _orderNumber:int;

		public function get orderNumber():int
		{
			return _orderNumber;
		}

		public function set orderNumber(value:int):void
		{
			_orderNumber = value;
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
		
		
	}
}