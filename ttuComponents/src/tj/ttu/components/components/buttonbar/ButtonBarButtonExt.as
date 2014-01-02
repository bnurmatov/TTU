////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.buttonbar
{
	import flash.events.Event;
	
	import spark.components.ButtonBarButton;
	
	/**
	 * ButtonBarButtonExt class 
	 */
	public class ButtonBarButtonExt extends ButtonBarButton
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		private static const MAX_LENGTH:uint = 4;
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
		 * ButtonBarButtonExt 
		 */
		public function ButtonBarButtonExt()
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
		override protected function mouseEventHandler(event:Event) : void
		{
			if(_enabled)
				super.mouseEventHandler(event);
			else
			{
				event.preventDefault();
				event.stopImmediatePropagation();
			}
		}
		
		
		private var _enabled:Boolean = true;
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		[Bindable]
		override public function get enabled():Boolean
		{
			return _enabled
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if(value)
				super.enabled = value;
			else
			{
				invalidateSkinState();
				// If enabled, reset the mouseChildren, mouseEnabled to the previously
				// set explicit value, otherwise disable mouse interaction.
				super.buttonMode 	= value;
				super.mouseChildren = value;
			}
		}
		
		
		override public function set depth(value:Number):void
		{
			if(itemIndexChanged)
				super.depth = value == 1 || selected ? MAX_LENGTH + 1 : MAX_LENGTH - itemIndex;
			else
				super.depth = value;
		}
		
		private var itemIndexChanged:Boolean = false;
		override public function set itemIndex(value:int):void
		{
			super.itemIndex = value;
			super.depth 	= MAX_LENGTH - itemIndex;
			itemIndexChanged = true;
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