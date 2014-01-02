////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.category
{
	import flash.events.Event;
	
	import spark.components.Button;
	import spark.components.RichText;
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.vo.DepartmentVO;
	
	/**
	 * DepartmentItemView class 
	 */
	public class DepartmentItemView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * A skin part that defines the lessonNameLabel of the component. 
		 * 
		 */		
		[SkinPart(required="true")]
		public var departmentNameLabel:RichText;
		
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
		private var latinFont:String;
		private var cyrillicFont:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * DepartmentItemView 
		 */
		public function DepartmentItemView()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var currentDepartmentChanged:Boolean = false;
		private var _currentDepartment:DepartmentVO;

		public function get currentDepartment():DepartmentVO
		{
			return _currentDepartment;
		}

		public function set currentDepartment(value:DepartmentVO):void
		{
			if( _currentDepartment !== value)
			{
				_currentDepartment = value;
				currentDepartmentChanged = true;
				invalidateProperties();
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(currentDepartmentChanged && departmentNameLabel)
			{
				departmentNameLabel.textFlow = currentDepartment.departmentRuName ? TLFUtil.createFlow( currentDepartment.departmentRuName, latinFont, cyrillicFont ) : null;
				currentDepartmentChanged = false;
			}
		}
		
		
		override protected function resourcesChanged():void
		{
			latinFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.EN_FONT)||"Latin";
			cyrillicFont = resourceManager.getString(ResourceConstants.FONT, FontConstants.TJ_FONT)||"Cyrillic";
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