////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 3, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.events
{
	import flash.events.Event;
	
	import spark.components.IItemRenderer;
	
	/**
	 * DataGridEvent class 
	 */
	public class DataGridEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		public static const ITEM_EXPAND 	: String	= 'itemExpand';
		public static const GRID_DOUBLE_CLICK : String	= 'tlGridDoubleClick';
		public static const ITEM_TRASH:String = "itemTrash";
		public static const ITEM_COLLAPSE 	: String	= 'itemCollapse';
		public static const ITEM_EDIT:String = "itemEdit";
		public static const ITEM_CLONE:String = "itemClone";
		public static const ITEM_PUBLISH:String = "itemPublish";
		public static const ITEM_RESTORE:String = "itemRestore";
		public static const ITEM_DELETE:String = "itemDelete";
		public static const PLAY_SOUND 		: String	= 'playSound';
		public static const CHANGE_VISIBILITY_ITEM:String = "changeVisibilityItem";
		public static const CHECK_ALL 	: String	= 'checkAll';
		public static const HEADER_CHECKBOX 	: String	= 'headerCheckbox';
		public static const UNCHECK_ALL 	: String	= 'uncheckAll';
		public static const CHECK_CHANGED 	: String	= 'checkChanged';
		public static const CHILD_EXPAND:String = "childExpand";
		public static const CHILD_COLLAPSE:String = "childCollapse";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  item
		//----------------------------------
		
		/**
		 *  The data provider item the item renderer is displaying.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public var item:Object;
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		
		/**
		 *  The item renderer that is displaying the item.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public var itemRenderer:IItemRenderer;
		
		//----------------------------------
		//  itemIndex
		//----------------------------------
		
		/**
		 *  The index of the data item the item renderer is displaying.
		 *  You can access the data provider item using this property. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public var itemIndex:int;
		
		
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
		 * DataGridEvent 
		 */
		public function DataGridEvent(type:String, itemIndex:int = -1, item:Object=null, 
									  itemRenderer:IItemRenderer = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.itemIndex = itemIndex;
			this.item = item;
			this.itemRenderer = itemRenderer;
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
		override public function clone():Event
		{
			return new DataGridEvent(type, itemIndex,item, itemRenderer, bubbles, cancelable);
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