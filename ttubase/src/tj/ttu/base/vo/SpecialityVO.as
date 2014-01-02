////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * SpecialityVO class 
	 */
	public class SpecialityVO extends EventDispatcher
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
		 * SpecialityVO 
		 */
		public function SpecialityVO()
		{
			super(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//-----------------------------------
		//	id
		//-----------------------------------
		private var _id:int;	

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
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
			_facultyCode = value;
		}

		//-----------------------------------
		//	specialityTjName
		//-----------------------------------
		private var _specialityTjName:String;	

		public function get specialityTjName():String
		{
			return _specialityTjName;
		}

		public function set specialityTjName(value:String):void
		{
			_specialityTjName = value;
		}

		//-----------------------------------
		//	specialityRuName
		//-----------------------------------
		private var _specialityRuName:String;	

		public function get specialityRuName():String
		{
			return _specialityRuName;
		}

		public function set specialityRuName(value:String):void
		{
			_specialityRuName = value;
		}
		//-----------------------------------
		//	specialityEnName
		//-----------------------------------
		private var _specialityEnName:String;	

		public function get specialityEnName():String
		{
			return _specialityEnName;
		}

		public function set specialityEnName(value:String):void
		{
			_specialityEnName = value;
		}

		//-----------------------------------
		//	specialityTjShortName
		//-----------------------------------
		private var _specialityTjShortName:String;	

		public function get specialityTjShortName():String
		{
			return _specialityTjShortName;
		}

		public function set specialityTjShortName(value:String):void
		{
			_specialityTjShortName = value;
		}

		//-----------------------------------
		//	specialityRuShortName
		//-----------------------------------
		private var _specialityRuShortName:String;	

		public function get specialityRuShortName():String
		{
			return _specialityRuShortName;
		}

		public function set specialityRuShortName(value:String):void
		{
			_specialityRuShortName = value;
		}
		//-----------------------------------
		//	specialityEnShortName
		//-----------------------------------
		private var _specialityEnShortName:String;	

		public function get specialityEnShortName():String
		{
			return _specialityEnShortName;
		}

		public function set specialityEnShortName(value:String):void
		{
			_specialityEnShortName = value;
		}

		//-----------------------------------
		//	specialityCode
		//-----------------------------------
		private var _specialityCode:int;	

		public function get specialityCode():int
		{
			return _specialityCode;
		}

		public function set specialityCode(value:int):void
		{
			_specialityCode = value;
		}

		
		
	}
}