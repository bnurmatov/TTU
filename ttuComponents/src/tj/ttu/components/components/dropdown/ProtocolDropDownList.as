////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 16, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.dropdown
{
	
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.supportClasses.ButtonBase;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	public class ProtocolDropDownList extends DropDownList
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ProtocolDropDownList()
		{
			super();
			
			addEventListener(MouseEvent.CLICK, clickHandler );
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if( event.target != commandButton )
			{
				event.stopImmediatePropagation();
				event.preventDefault();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------    
		
		//----------------------------------
		//  commandButton
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  An optional skin part that holds the prompt or the text of the selected item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var commandButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  baselinePosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return getBaselinePositionForPart(commandButton as IVisualElement);
		}
		
		//----------------------------------
		//  prompt
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _prompt:String = "";
		
		private var promptChanged:Boolean = false;
		
		/**
		 *  @private
		 */
		override public function set prompt(value:String):void
		{
			if (_prompt == value)
				return;
			
			_prompt = value;
			promptChanged = true;
			invalidateProperties();
		}		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( promptChanged && commandButton )
			{
				ButtonBase( commandButton ).label = _prompt;
				promptChanged = false;
			}
		}
		
		/**
		 *  @private
		 */ 
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == commandButton)
			{
				commandButton.addEventListener(MouseEvent.CLICK, click_commandButtonHandler );
			}
		}
		
		/**
		 *  @private
		 */ 
		override protected function partRemoved(partName:String, instance:Object):void
		{
			
			if (instance == commandButton)
			{
				commandButton.removeEventListener(MouseEvent.CLICK, click_commandButtonHandler );
			}
			super.partRemoved(partName, instance);
		}
		

		private function click_commandButtonHandler( event:MouseEvent ):void
		{
			// TODO Auto Generated method stub
			dispatchEvent( event.clone() );
		}
		
	}
	
}
