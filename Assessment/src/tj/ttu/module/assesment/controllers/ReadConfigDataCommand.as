////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.controllers
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ConfigurationVO;
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.module.assesment.models.AssesmentPlayerProxy;
	
	/**
	 * ReadConfigDataCommand class 
	 */
	public class ReadConfigDataCommand extends SimpleCommand
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
		 * ReadConfigDataCommand 
		 */
		public function ReadConfigDataCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _assesmentPlayerProxy:AssesmentPlayerProxy;
		
		public function get assesmentPlayerProxy():AssesmentPlayerProxy
		{
			if(!_assesmentPlayerProxy)
				_assesmentPlayerProxy = facade.retrieveProxy( AssesmentPlayerProxy.NAME ) as AssesmentPlayerProxy;
			return _assesmentPlayerProxy;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(notification:INotification):void
		{
			var config:ConfigurationVO = notification.getBody() as ConfigurationVO;
			if(config && assesmentPlayerProxy)
			{
				assesmentPlayerProxy.cleanUp();
				assesmentPlayerProxy.config 			= config;
				assesmentPlayerProxy.moduleDescription 	= config.activityDescription;
				if(config.data && config.data is Array)
				{
					assesmentPlayerProxy.questions 		= new ArrayCollection(config.data as Array);
					sendNotification(AssesmentNotifications.CONFIGURATION_DATA_LOADED);
				}
				else if(config.dataURLs[0] is String)
				{
					sendNotification(TTUConstants.LOAD_XML, config.dataURLs[0]); 
				}
			}
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