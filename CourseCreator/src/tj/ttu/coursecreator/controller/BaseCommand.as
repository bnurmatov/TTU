////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 5, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.controller
{
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.model.font.FontManagerProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	
	/**
	 * BaseCommand class 
	 */
	public class BaseCommand extends SimpleCommand
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
		 * BaseCommand 
		 */
		public function BaseCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _resourceProxy:ResourceProxy;

		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy = facade.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
			return _resourceProxy;
		}
		
		private var _fontManagerProxy:FontManagerProxy;

		public function get fontManagerProxy():FontManagerProxy
		{
			if(!_fontManagerProxy)
				_fontManagerProxy = facade.retrieveProxy( FontManagerProxy.NAME ) as FontManagerProxy;
			return _fontManagerProxy;
		}

		private var _configProxy:AppConfigProxy;

		public function get configProxy():AppConfigProxy
		{
			if(!_configProxy)
				_configProxy = facade.retrieveProxy( AppConfigProxy.NAME ) as AppConfigProxy;
			return _configProxy;
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