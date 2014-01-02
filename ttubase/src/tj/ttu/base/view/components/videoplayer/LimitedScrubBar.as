////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 16, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.base.view.components.videoplayer
{
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import spark.components.mediaClasses.ScrubBar;
	
	/**
	 * @inheritDoc
	 */
	public class LimitedScrubBar extends ScrubBar
	{
		public function LimitedScrubBar()
		{
			super();
			addEventListener(MouseEvent.ROLL_OUT, rollOut_Handler);
			addEventListener(MouseEvent.ROLL_OVER, rollOver_Handler);
		}
		
		/**
		 * @private
		 */
		private var timerId:uint;
		
		/**
		 * @private
		 */
		private var showTimerId:uint;
		
		/**
		 * @private
		 */
		private var isRollOver:Boolean = false;
		
		/**
		 * Use Limit property
		 */
		public var isLimited:Boolean = true;
		
		/**
		 * Limit
		 */
		public var limit:Number = -1;
		
		[Bindable]
		/**
		 * Indicates that Unwatched video attempt occurs.
		 */
		public var isUnwatched:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function set value(newValue:Number):void
		{
			limit = Math.max(limit, newValue);
			super.value = newValue;
		}

		/**
		 * @inheritDoc
		 */		
		override protected function setValue(value:Number):void
		{
			if ( isLimited && (limit - value < -0.5))
			{
				clearTimeout(showTimerId);
				showTimerId = setTimeout(showToolTip, 200); //isRollOver;
			}
			
			if (isLimited)
				value = Math.min(limit, value);

			super.setValue(value);
		}

		/**
		 * @private
		 */
		private function showToolTip():void
		{
			isUnwatched = isRollOver;
			if (isUnwatched)
			{
				clearTimeout(timerId);
				timerId = setTimeout(hideToolTip, 2000);
			}			
		}
		
		/**
		 * @private
		 */
		private function hideToolTip():void
		{
			isUnwatched = false;
		}
		
		/**
		 * @private
		 */
		private function rollOut_Handler(event:MouseEvent):void
		{
			isRollOver = false;
			//isUnwatched = false;
		}
		
		/**
		 * 
		 */
		private function rollOver_Handler(event:MouseEvent):void
		{
			isRollOver = true;
		}
	}
}