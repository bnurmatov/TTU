package tj.ttu.components.components.slider
{
	import spark.components.Button;
	import flash.events.Event;
	
	public class ThumbButton extends Button
	{
		public function ThumbButton()
		{
			super();
		}
		
		
		private var _value:Number = 0; 

		[Bindable(event="valueChange")]
		public function get sliderValue():Number
		{
			return _value;
		}

		public function set sliderValue(value:Number):void
		{
			if( _value !== value)
			{
				_value = value;
				dispatchEvent(new Event("valueChange"));
			}
		}

	}
}