////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.interfaces
{
	
	/**
	 * IProgressBar.
	 * Interface for components, wich shall implement behaviour of ProgressBar.
	 */
	public interface IProgressBar
	{
		
		//----------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------
		
		function get minimum():Number;
		function set minimum(value:Number):void;
		
		function get maximum():Number;
		function set maximum(value:Number):void;
		
		function get value():Number;
		function set value(newValue:Number):void;
		
	}
}