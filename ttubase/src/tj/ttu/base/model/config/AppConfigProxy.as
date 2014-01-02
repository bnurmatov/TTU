////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 13, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.model.config
{
	import flash.events.Event;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import tj.ttu.base.constants.AudioValues;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.model.AppBaseProxy;
	import tj.ttu.base.vo.ConfigurationVO;
	
	/**
	 * AppConfigProxy class 
	 */
	public class AppConfigProxy extends AppBaseProxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'AppConfigProxy';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var rootDataPath:String = "";
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AppConfigProxy 
		 */
		public function AppConfigProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  uiFont
		//----------------------------------
		private var _uiFont:String;

		public function get uiFont():String
		{
			return _uiFont;
		}

		public function set uiFont(value:String):void
		{
			if( _uiFont !== value)
			{
				_uiFont = value;
			}
		}
		//----------------------------------
		//  uiDirection
		//----------------------------------
		private var _uiDirection:String;

		public function get uiDirection():String
		{
			return _uiDirection;
		}

		public function set uiDirection(value:String):void
		{
			if( _uiDirection !== value)
			{
				_uiDirection = value;
			}
		}

		//----------------------------------
		//  tjLanguageFont
		//----------------------------------
		private var _tjLanguageFont:String;

		public function get tjLanguageFont():String
		{
			return _tjLanguageFont;
		}

		public function set tjLanguageFont(value:String):void
		{
			_tjLanguageFont = value;
		}

		//----------------------------------
		//  tjLanguageDirection
		//----------------------------------
		private var _tjLanguageDirection:String;

		public function get tjLanguageDirection():String
		{
			return _tjLanguageDirection;
		}

		public function set tjLanguageDirection(value:String):void
		{
			_tjLanguageDirection = value;
		}

		//----------------------------------
		//  tjLanguageName
		//----------------------------------
		private var _tjLanguageName:String;

		public function get tjLanguageName():String
		{
			return _tjLanguageName;
		}

		public function set tjLanguageName(value:String):void
		{
			_tjLanguageName = value;
		}

		//----------------------------------
		//  tjLanguageCode
		//----------------------------------
		private var _tjLanguageCode:String;

		public function get tjLanguageCode():String
		{
			return _tjLanguageCode;
		}

		public function set tjLanguageCode(value:String):void
		{
			_tjLanguageCode = value;
		}

		//----------------------------------
		//  tjTextAlign
		//----------------------------------
		private var _tjTextAlign:String;

		public function get tjTextAlign():String
		{
			return _tjTextAlign;
		}

		public function set tjTextAlign(value:String):void
		{
			_tjTextAlign = value;
		}
		
		
		//----------------------------------
		//  ruLanguageFont
		//----------------------------------
		private var _ruLanguageFont:String;

		public function get ruLanguageFont():String
		{
			return _ruLanguageFont;
		}

		public function set ruLanguageFont(value:String):void
		{
			_ruLanguageFont = value;
		}

		//----------------------------------
		//  ruLanguageDirection
		//----------------------------------
		private var _ruLanguageDirection:String;

		public function get ruLanguageDirection():String
		{
			return _ruLanguageDirection;
		}

		public function set ruLanguageDirection(value:String):void
		{
			_ruLanguageDirection = value;
		}

		//----------------------------------
		//  ruLanguageName
		//----------------------------------
		private var _ruLanguageName:String;

		public function get ruLanguageName():String
		{
			return _ruLanguageName;
		}

		public function set ruLanguageName(value:String):void
		{
			_ruLanguageName = value;
		}

		//----------------------------------
		//  ruLanguageCode
		//----------------------------------
		private var _ruLanguageCode:String;

		public function get ruLanguageCode():String
		{
			return _ruLanguageCode;
		}

		public function set ruLanguageCode(value:String):void
		{
			_ruLanguageCode = value;
		}

		//----------------------------------
		//  ruTextAlign
		//----------------------------------
		private var _ruTextAlign:String;

		public function get ruTextAlign():String
		{
			return _ruTextAlign;
		}

		public function set ruTextAlign(value:String):void
		{
			_ruTextAlign = value;
		}
		
		
		//----------------------------------
		//  enLanguageFont
		//----------------------------------
		private var _enLanguageFont:String;

		public function get enLanguageFont():String
		{
			return _enLanguageFont;
		}

		public function set enLanguageFont(value:String):void
		{
			_enLanguageFont = value;
		}

		//----------------------------------
		//  enLanguageDirection
		//----------------------------------
		private var _enLanguageDirection:String;

		public function get enLanguageDirection():String
		{
			return _enLanguageDirection;
		}

		public function set enLanguageDirection(value:String):void
		{
			_enLanguageDirection = value;
		}

		//----------------------------------
		//  enLanguageName
		//----------------------------------
		private var _enLanguageName:String;

		public function get enLanguageName():String
		{
			return _enLanguageName;
		}

		public function set enLanguageName(value:String):void
		{
			_enLanguageName = value;
		}

		//----------------------------------
		//  enLanguageCode
		//----------------------------------
		private var _enLanguageCode:String;

		public function get enLanguageCode():String
		{
			return _enLanguageCode;
		}

		public function set enLanguageCode(value:String):void
		{
			_enLanguageCode = value;
		}

		//----------------------------------
		//  enTextAlign
		//----------------------------------
		private var _enTextAlign:String;

		public function get enTextAlign():String
		{
			return _enTextAlign;
		}

		public function set enTextAlign(value:String):void
		{
			_enTextAlign = value;
		}

		//----------------------------------
		//  muted
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for muted property.
		 */
		private var _muted:Boolean;
		
		/**
		 *  An Boolean value indicating that 
		 *  the sound volume of the application is muted or not 
		 */ 
		public function get muted():Boolean
		{
			return _muted;
		}
		
		/**
		 *  @private
		 */ 
		public function set muted(value:Boolean):void
		{
			_muted = value;
		}
		//----------------------------------
		//  volume
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for application's sound volume property
		 */
		private var _volume:Number = AudioValues.VOLUME;
		
		/**
		 *  A Number (float) representing current volume of application. 
		 *  <p>Changes volume to given value and notifies interested objects about it</p>
		 *  @default 0.7
		 */
		public function get volume():Number
		{
			return _volume;
		}
		
		/**
		 * @private
		 * @param value New volume.
		 *
		 */ 
		public function set volume(value:Number):void
		{
			_volume = value;
			sendNotification(TTUConstants.VOLUME_CHANGED, value);
		}
		//----------------------------------
		// tempoEnabled
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for application's sound speed - tempo property
		 *  @default 1 
		 */
		private var _tempoEnabled:Boolean = false;
		
		/**
		 *  A Number representing current tempo of the sound
		 * 
		 */
		public function get tempoEnabled():Boolean
		{
			return _tempoEnabled;
		}
		/**
		 *  @private
		 */ 
		public function set tempoEnabled(value:Boolean):void
		{
			_tempoEnabled = value;
		}
		
		//----------------------------------
		//  isServerMode
		//----------------------------------
		private var _isServerMode:Boolean = false;
		public function get isServerMode():Boolean
		{
			return _isServerMode;
		}
		
		public function set isServerMode(value:Boolean):void
		{
			_isServerMode = value;
		}
		//----------------------------------
		//  modulePath
		//----------------------------------
		
		private var _modulePath:String = "";
		
		public function get modulePath():String
		{
			return _modulePath;
		}
		
		public function set modulePath(value:String):void
		{
			_modulePath = value;
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
		
		public function get config():ConfigurationVO
		{
			var resManager:IResourceManager = ResourceManager.getInstance();
			var configVo:ConfigurationVO 	= new ConfigurationVO();
			configVo.muted 					= muted;
			configVo.volume 				= volume;
			configVo.tempoEnabled 			= tempoEnabled;
			configVo.isServerMode 			= isServerMode;
			
			configVo.uiFont					= uiFont;
			configVo.uiDirection			= uiDirection;
			configVo.tjLanguageFont			= tjLanguageFont;
			configVo.tjLanguageDirection	= tjLanguageDirection;
			configVo.tjLanguageName			= tjLanguageName;
			configVo.tjLanguageCode			= tjLanguageCode;
			configVo.tjTextAlign			= tjTextAlign;
			configVo.ruLanguageFont			= ruLanguageFont;
			configVo.ruLanguageDirection	= ruLanguageDirection;
			configVo.ruLanguageName			= ruLanguageName;
			configVo.ruLanguageCode			= ruLanguageCode;
			configVo.ruTextAlign			= ruTextAlign;
			configVo.enLanguageFont			= enLanguageFont;
			configVo.enLanguageDirection	= enLanguageDirection;
			configVo.enLanguageName			= enLanguageName;
			configVo.enLanguageCode			= enLanguageCode;
			configVo.enTextAlign			= enTextAlign;
			return configVo;
		}
		
		
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