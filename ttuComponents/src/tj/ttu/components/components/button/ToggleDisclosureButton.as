////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.button
{
	import flash.events.Event;
	
	import spark.components.ToggleButton;
	
	/**
	 * ToggleDisclosureButton class 
	 */
	public class ToggleDisclosureButton extends ToggleButton
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
		 * ToggleDisclosureButton 
		 */
		public function ToggleDisclosureButton()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _isProgress:Boolean = false;
		
		[Bindable(event="isProgressChange")]
		public function get isProgress():Boolean
		{
			return _isProgress;
		}
		
		public function set isProgress(value:Boolean):void
		{
			if( _isProgress !== value)
			{
				_isProgress = value;
				dispatchEvent(new Event("isProgressChange"));
			}
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