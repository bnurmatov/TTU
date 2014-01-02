////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.tlf_internal;
	
	import mx.core.mx_internal;

	use namespace tlf_internal;
	use namespace mx_internal;
	/**
	 * ScrollerUtil class 
	 */
	public class ScrollerUtil
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
		 * ScrollerUtil 
		 */
		public function ScrollerUtil()
		{
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getCurrentTextLine(textFlow:TextFlow, activePosition:int, anchorPosition:int):TextFlowLine
		{
			// return if we're not scrolling, or if it's not the last controller
			if ( !textFlow || !textFlow.flowComposer )
				return null;
			// clamp values to range absoluteStart,absoluteStart+_textLength
			var dir:int = activePosition >= anchorPosition ? 1: -1 
			var controllerStart:int = 0;
			var lastPosition:int =  textFlow.textLength - 1;
			activePosition = Math.max(controllerStart,Math.min(activePosition,lastPosition));
			anchorPosition = Math.max(controllerStart,Math.min(anchorPosition,lastPosition));
			
			var verticalText:Boolean = textFlow.blockProgression == BlockProgression.RL;
			var begPos:int = Math.min(activePosition,anchorPosition);
			var endPos:int = Math.max(activePosition,anchorPosition);
			
			// is part of the selection in view?
			var begLineIndex:int = textFlow.flowComposer.findLineIndexAtPosition(begPos,(begPos == textFlow.textLength));
			var endLineIndex:int = textFlow.flowComposer.findLineIndexAtPosition(endPos,(endPos == textFlow.textLength));
			
			
			if (textFlow.flowComposer.damageAbsoluteStart <= endPos)
			{
				endPos = Math.min(begPos + 100, endPos + 1);
				textFlow.flowComposer.composeToPosition(endPos);
				begLineIndex = textFlow.flowComposer.findLineIndexAtPosition(begPos,(begPos == textFlow.textLength));
				endLineIndex = textFlow.flowComposer.findLineIndexAtPosition(endPos,(endPos == textFlow.textLength));
			}
			if(endLineIndex > begLineIndex && dir == 1)
				return textFlow.flowComposer.getLineAt(endLineIndex);
			return  textFlow.flowComposer.getLineAt(begLineIndex);
		}		
		
	}
}