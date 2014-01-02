////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.resource.remove
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.constants.CourseAirConstants;
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.courseservice.model.vo.ResourceServiceVO;
	
	/**
	 * RemoveLocalResourceCommand class 
	 */
	public class RemoveLocalResourceCommand extends BaseAirCommand
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
		 * RemoveLocalResourceCommand 
		 */
		public function RemoveLocalResourceCommand()
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
		override public function execute(note:INotification):void
		{
			var resourceServiceVo:ResourceServiceVO = note.getBody() as ResourceServiceVO;
			if(resourceServiceVo && resourceAdapterProxy)
			{
				resourceAdapterProxy.serviceVO = resourceServiceVo;
				resourceAdapterProxy.removeExistingResource( resourceServiceVo.resource, CourseAirConstants.DELETE_RESOURCE_ASSETS_FROM_DISK, true ); 
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