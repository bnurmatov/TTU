////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.components.components.progressbar
{
	import spark.components.Label;
	import spark.components.supportClasses.Range;
	
	import tj.ttu.components.interfaces.IProgressBar;

	/**
	 * HalfCircleProgressBar.
	 * 
	 * 
	 */
	public class CircleProgressBar extends Range implements IProgressBar
	{
		
		//----------------------------------------------------------------------
		//
		//  Class constants
		//
		//----------------------------------------------------------------------
		
		protected var fullAngle:int = 360;
		
		//----------------------------------------------------------------------
		//
		//  Class methods
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Constructor
		//
		//----------------------------------------------------------------------
		
		public function CircleProgressBar()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//----------------------------------------------------------------------
		
		[SkinPart(required="false")]
		/**
		 *  Skin part for circle drawing, wich define in skin Class.
		 */		
		public var circle:Circle;
		
		[SkinPart(required="false")]
		/**
		 *  Skin part for display progress in percents, wich define in skin Class.
		 */		
		public var progressLabel:Label;
		
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------
		
		protected var angleValue:Number;
		
		protected var percentValue:Number;
		
		//----------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//----------------------------------------------------------------------
		
		override public function set value(newValue:Number):void
		{
			super.value = newValue;
			angleValue = (value * fullAngle) / 100;
			percentValue = Math.floor(newValue);
			invalidateProperties();
			invalidateDisplayList();
		}
		
		/**
		 *  Updates Progress on the Piechart.
		 * 
		 */
		public function updateProgress(correct:uint, incorrect:uint, total:uint):void
		{
			var corrrectPercents:int = int(correct / total * 100);
			var incorrrectPercents:int = int(incorrect / total * 100);
			
			value = corrrectPercents;
		}
		//----------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//----------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (progressLabel)
			{
				progressLabel.text = percentValue.toString();
			}
			if (circle)
			{
				circle.angle = angleValue;
			}
		}
		//----------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Handlers
		//
		//----------------------------------------------------------------------
		
	}
}