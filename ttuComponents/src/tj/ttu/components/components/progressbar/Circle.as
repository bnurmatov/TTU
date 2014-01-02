////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.components.components.progressbar 
{
	import spark.components.supportClasses.GroupBase;
	
	/**
	 * Circle.
	 * Class for drawing circle, or segment of circle.
	 * 
	 */
	public class Circle extends GroupBase
	{
		
		//----------------------------------------------------------------------
		//
		//  Class constants
		//
		//----------------------------------------------------------------------
		
		public const DIRECTION_CLOCKWISE:String = "clockwise";
		
		public const DIRECTION_COUNTERCLOCKWISE:String = "counterclockwise";
		
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
		
		public function Circle()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Storage for <code>radius</code> property. 
		 */		
		private var _radius:Number;

		[Inspectable(category="Common", defaultValue="50", minValue="0", maxValue="100")]
		/**
		 *  Radius property for circle.
		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 *  @private
		 */		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		private var _startingAngle:int = 0;
		
		/**
		 * Base angle offset from -180 degrees 
		 */		
		public function get startingAngle():int
		{
			return _startingAngle;
		}
		
		/**
		 * @private 
		 */		
		public function set startingAngle(value:int):void
		{
			_startingAngle = value;
		}
		
		private var _direction:String = DIRECTION_CLOCKWISE;

		[Inspectable(category="Common",enumeration="clockwise,counterclockwise", defaultValue="clockwise")]
		/**
		 * Direction in which the circle segment is increasing 
		 */		
		public function get direction():String
		{
			return _direction;
		}

		/**
		 * @private 
		 */		
		public function set direction(value:String):void
		{
			if (value != DIRECTION_CLOCKWISE && value != DIRECTION_COUNTERCLOCKWISE)
				throw new ArgumentError("Invalid direction value");
			_direction = value;
		}

		
		/**
		 *  @private
		 *  Storage for <code>color</code> property. 
		 */		
		private var _color:Number;
		
		[Inspectable(category="Styles")]
		/**
		 *  Color property for circle fill.
		 */
		public function get color():Number
		{
			return _color;
		}
		
		/**
		 *  @private
		 */		
		public function set color(value:Number):void
		{
			_color = value;
		}
		
		/**
		 *  @private
		 *  Storage for <code>angle</code> property. 
		 */		
		private var _angle:Number;
		
		[Inspectable(category="Common", minValue="0", maxValue="180")]
		/**
		 *  Angle property for circle sercle segment drawing.
		 */
		public function get angle():Number
		{
			return _angle;
		}
		
		/**
		 *  @private
		 */		
		public function set angle(value:Number):void
		{
			_angle = value;
			invalidateDisplayList();
		}
		
		//----------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//----------------------------------------------------------------------
		
		/**
		 *  @inheritDoc 
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			drawCircleSegment(angle);
		}
		
		//----------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Draw circle segment accordance to angle.
		 * 
		 *  @param angle Angle in degrees, with describe segment.
		 */		
		private function drawCircleSegment(angle:Number):void {
			this.graphics.clear();
			this.graphics.lineStyle(1,color, 0);
			this.graphics.moveTo(radius, radius);
			this.graphics.beginFill(color);
			
			var radianAngle:Number;
			if (direction == DIRECTION_CLOCKWISE)
			{
				for (var i:int=-180+startingAngle; i<=(-180+startingAngle + angle); i++) 
				{
					radianAngle = i*Math.PI/180.0;
					this.graphics.lineTo(radius + radius*Math.cos(radianAngle), radius + radius*Math.sin(radianAngle) );
				}
			}
			else
			{
				for (i=-180+startingAngle; i>=(-180+startingAngle - angle); i--) 
				{
					radianAngle = i*Math.PI/180.0;
					this.graphics.lineTo(radius + radius*Math.cos(radianAngle), radius + radius*Math.sin(radianAngle) );
				}
			}
			this.graphics.lineTo(radius, radius);
			
			this.graphics.endFill();
		}
		
		//----------------------------------------------------------------------
		//
		//  Handlers
		//
		//----------------------------------------------------------------------
		
	}
}