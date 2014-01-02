////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.datagrid
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.core.IChildList;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.SandboxMouseEvent;
	
	import spark.components.DataGrid;
	import spark.components.gridClasses.*;
	import spark.events.GridItemEditorEvent;
	
	use namespace mx_internal;
	/**
	 * MyDataGridEditor class 
	 */
	public class CustomDataGridEditor extends DataGridEditor
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var isEditSessionEnd:Boolean = false;
		
		private var editor:IEventDispatcher;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * MyDataGridEditor 
		 */
		public function CustomDataGridEditor(dataGrid:DataGrid)
		{
			super(dataGrid);
			
			dataGrid.addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START, onItemEditorSessionStart); 
			dataGrid.addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, onItemEditorSessionEnd); 
		}
		
		protected function onItemEditorSessionEnd(event:GridItemEditorEvent):void
		{
			editor.removeEventListener(KeyboardEvent.KEY_DOWN, editor_keyDownHandler);
			editor.removeEventListener(KeyboardEvent.KEY_DOWN, editor_keyDownHandler, true);
			dataGrid.grid.systemManager.getSandboxRoot().
				removeEventListener(MouseEvent.MOUSE_DOWN, sandBoxRoot_mouseDownHandler);
			dataGrid.grid.systemManager.getSandboxRoot().
				removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, sandBoxRoot_mouseDownHandler);
			
			editor = null;
		}
		
		protected function onItemEditorSessionStart(event:GridItemEditorEvent):void
		{
			isEditSessionEnd = false;
			if (dataGrid.editor)
				 dataGrid.editor.startItemEditorSession(event.rowIndex, event.columnIndex);
			
			if (itemEditorInstance || editedItemRenderer)
			{
				editor = itemEditorInstance ? itemEditorInstance : editedItemRenderer;
				
				editor.addEventListener(KeyboardEvent.KEY_DOWN, editor_keyDownHandler, true, int.MAX_VALUE);
				
				dataGrid.grid.systemManager.getSandboxRoot().
					addEventListener(MouseEvent.MOUSE_DOWN, sandBoxRoot_mouseDownHandler);
				dataGrid.grid.systemManager.getSandboxRoot().
					addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, sandBoxRoot_mouseDownHandler);
				UIComponent(editor).setFocus();
			}
		}

		private function editor_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.TAB)
			{
				isEditSessionEnd = true;
				if (!dataGrid.endItemEditorSession())
				{
					dataGrid.endItemEditorSession(true);
				}
				dataGrid.setFocus();
				return;
			}
		}
		
		
		override public function endItemEditorSession(cancel:Boolean=false):Boolean
		{
			if(!isEditSessionEnd)
				return false;
			
			return super.endItemEditorSession( cancel );
		}
		
		protected function sandBoxRoot_mouseDownHandler(event:Event):void
		{
			if(isEditSessionEnd)
				return ;
			
			if (editorOwnsClick(event))
			{
				return;
			}
			
			// If clicked on the scroll bars then keep the editor up
			if (dataGrid.scroller && 
				dataGrid.scroller.contains(DisplayObject(event.target)) &&
				!grid.contains(DisplayObject(event.target)))
			{
				return;
			}
					
			isEditSessionEnd = true;
			if (!dataGrid.endItemEditorSession())
			{
				dataGrid.endItemEditorSession(true);
			}
			dataGrid.setFocus();
		}		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		
		
		private function editorOwnsClick(event:Event):Boolean
		{
			if (event is MouseEvent)
			{
				var target:IUIComponent = getIUIComponent(DisplayObject(event.target));
				if (target)
					return editorOwns(target);
			}
			
			return false;
		}
		
		private function getIUIComponent(displayObject:DisplayObject):IUIComponent
		{
			if (displayObject is IUIComponent)
				return IUIComponent(displayObject);
			
			var current:DisplayObject = displayObject.parent;
			while (current)
			{
				if (current is IUIComponent)
					return IUIComponent(current);
				
				current = current.parent;
			}
			
			return null;
		}
		
		
		private function editorOwns(child:IUIComponent):Boolean
		{
			return (itemEditorInstance &&
				(itemEditorInstance == child || 
					IUIComponent(itemEditorInstance).owns(DisplayObject(child))) ||
				(editedItemRenderer &&
					(editedItemRenderer == child || 
						IUIComponent(editedItemRenderer).owns(DisplayObject(child)))));
		}
		
		public static function getAllPopups(applicationInstance:Object = null, onlyVisible:Boolean = false): ArrayCollection
		{
			var result: ArrayCollection = new ArrayCollection();
			if (applicationInstance == null)
			{
				// NOTE: use this line for Flex 4.x and higher
				applicationInstance = FlexGlobals.topLevelApplication;
				// NOTE: use this line for Flex 3.x and lower
			}
			var rawChildren: IChildList = applicationInstance.systemManager.rawChildren;
			for (var i: int = 0; i < rawChildren.numChildren; i++)
			{
				var currRawChild: DisplayObject = rawChildren.getChildAt(i);
				if ((currRawChild is UIComponent) && UIComponent(currRawChild).isPopUp)
				{
					if (!onlyVisible || UIComponent(currRawChild).visible)
					{
						result.addItem(currRawChild);
					}
				}
			}
			return result;
		}
	}
}