////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.moduleUtility.model.LoadXMLProxy;
	
	/**
	 * LoadXMLCommand class 
	 */
	public class LoadXMLCommand extends SimpleCommand
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
		 * LoadXMLCommand 
		 */
		public function LoadXMLCommand()
		{
			super();
		}
		
		
		
		private var url:String;
		
		//----------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//----------------------------------------------------------------------
		
		/**
		 *  @private
		 *	Loads xml data 
		 *  @param url can be String or Array of strings.
		 */		
		override public function execute(notification:INotification):void
		{
			loadFromString(notification.getBody() as String);
		}
		
		//----------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function loadFromString(url:String):void
		{
			if (facade.retrieveProxy(LoadXMLProxy.NAME))
				facade.removeProxy(LoadXMLProxy.NAME) as LoadXMLProxy;
			
			var proxy:LoadXMLProxy = new LoadXMLProxy();
			facade.registerProxy(proxy);
			proxy.load(url);
		}
		
		
	}
}