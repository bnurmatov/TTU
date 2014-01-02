////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 14, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.model.config.AppConfigProxy;
	import tj.ttu.base.model.font.FontManagerProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	
	/**
	 * AppBaseProxy class 
	 */
	public class AppBaseProxy extends Proxy
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
		 * AppBaseProxy 
		 */
		public function AppBaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  resourseProxy
		//--------------------------------------------------------------------------
		/**
		 *  Instance of mainapplication's resource proxy
		 */ 
		private var _resourceProxy:ResourceProxy;
		
		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy  = facade.retrieveProxy(ResourceProxy.NAME) as ResourceProxy;
			return _resourceProxy;
		}
		
		//--------------------------------------------------------------------------
		//  configProxy
		//--------------------------------------------------------------------------
		/**
		 *  Instance of configProxy wich manages Application configs
		 */ 
		private var _configProxy:AppConfigProxy;
		
		public function get configProxy():AppConfigProxy
		{
			if(!_configProxy)
				_configProxy  = facade.retrieveProxy(AppConfigProxy.NAME) as AppConfigProxy;
			return _configProxy;
		}
		
		//--------------------------------------------------------------------------
		//  fontProxy
		//--------------------------------------------------------------------------
		/**
		 *  Instance of configProxy wich manages Application configs
		 */ 
		private var _fontProxy:FontManagerProxy;
		
		public function get fontProxy():FontManagerProxy
		{
			if(!_fontProxy)
				_fontProxy  = facade.retrieveProxy(FontManagerProxy.NAME) as FontManagerProxy;
			return _fontProxy;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_resourceProxy = null;
			_configProxy = null;
			_fontProxy = null;
			data = null;
			super.onRemove();
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