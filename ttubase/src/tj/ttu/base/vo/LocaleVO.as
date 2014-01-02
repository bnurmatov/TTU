////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 16, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * LocaleVO class 
	 */
	public class LocaleVO extends EventDispatcher
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
		private var _languageName:String;

		[Bindable(event="languageNameChange")]
		/**
		 * Language Name
		 */
		public function get languageName():String
		{
			return _languageName;
		}

		/**
		 * @private
		 */
		public function set languageName(value:String):void
		{
			if( _languageName !== value)
			{
				_languageName = value;
				dispatchEvent(new Event("languageNameChange"));
			}
		}

		
		private var _locale:String;

		[Bindable(event="localeChange")]
		/**
		 * Language Locale
		 */
		public function get locale():String
		{
			return _locale;
		}

		/**
		 * @private
		 */
		public function set locale(value:String):void
		{
			if( _locale !== value)
			{
				_locale = value;
				dispatchEvent(new Event("localeChange"));
			}
		}

		
		private var _image:Object;

		[Bindable(event="imageChange")]
		/**
		 * Language flag
		 */
		public function get image():Object
		{
			return _image;
		}

		/**
		 * @private
		 */
		public function set image(value:Object):void
		{
			if( _image !== value)
			{
				_image = value;
				dispatchEvent(new Event("imageChange"));
			}
		}

		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LocaleVO 
		 */
		public function LocaleVO()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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