////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.datagrid
{
	
	import mx.core.mx_internal;
	
	import spark.components.DataGrid;
	
	use namespace mx_internal;
	
	import spark.components.gridClasses.DataGridEditor;
	import spark.components.gridClasses.GridColumn;
	import spark.events.GridEvent;
	
	/**
	 * MyDataGrid class 
	 */
	public class CustomDataGrid extends DataGrid
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * MyDataGrid 
		 */
		public function CustomDataGrid()
		{
			super();
		
		}
	
		
		override mx_internal function createEditor():DataGridEditor
		{
			return new CustomDataGridEditor(this);
		}
	}
}