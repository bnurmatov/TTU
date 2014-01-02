package tj.ttu.base.view.components.popup.imageviewer.panzoom
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	import mx.events.TweenEvent;
	
	import tj.ttu.base.events.PanZoomEvent;
	import tj.ttu.base.view.components.popup.imageviewer.ContentRectangle;
	import tj.ttu.base.view.interfaces.IZoomComponent;


	public class PanToPointCommand extends EventDispatcher
	{
		private static var TRANSLATE_TOLERANCE:Number = .5;
		
		private var _client:IZoomComponent;
		private var _reciever:Rectangle;

		private var _toPoint:Point;
		private var _recieverToPoint:Point;
		
		private var _fromPoint:Point;
		private var _recieverFromPoint:Point;
		
		private var _animatePropertyX:AnimateProperty;		
		private var _animatePropertyY:AnimateProperty;	
				
		private var _animationSpeed:Number = .125;		
		private var _isExecuting:Boolean;

				
		/**
	    *  Sets the point to pan to in the view rectangles space.
	    */
		public function set toPoint(value:Point):void
		{
			if (value == _toPoint)
				return;
				
			_toPoint = value;
		}
		public function get toPoint():Point
		{
			return _toPoint;
		}
		
		/**
	    *  Sets the from point in the view rectangles space.
	    */		
	    
		public function set fromPoint(value:Point):void
		{
			if (value == _fromPoint)
				return;
				
			_fromPoint = value;
		}
		public function get fromPoint():Point
		{
			return _fromPoint;
		}
				
		
		/////////////////////////////////////////////////////////
		//
		// constructor
		//
		/////////////////////////////////////////////////////////
	
		/**
		 * the PanToPoint command moves the Content Rectangle (_reciever) to a 
		 * point in the Image Viewer (_client) view rectangles space.
		 */
		 		
		public function PanToPointCommand(client:IZoomComponent, reciever:ContentRectangle):void
		{
			_client = client;
			_reciever = reciever;
		}
		
		
		/////////////////////////////////////////////////////////
		//
		// interface
		//
		/////////////////////////////////////////////////////////\
	
		/**
		 * executing the panToPoint command animates the transition of the content
		 * rectangle position from one point to another.
		 */
		 	
		public function execute():void
		{
			// interface
			_isExecuting = true;
			
			_recieverToPoint = new Point (_reciever.topLeft.x + (_toPoint.x - _fromPoint.x),
										  _reciever.topLeft.y + (_toPoint.y - _fromPoint.y)
										   );
			if (_recieverToPoint.x > 0)
				_recieverToPoint.x = 0;
			if (_recieverToPoint.x < _client.viewRect.width - _reciever.width)
				_recieverToPoint.x = _client.viewRect.width - _reciever.width;
				
			if (_recieverToPoint.y > 0)
				_recieverToPoint.y = 0;
			if (_recieverToPoint.y < _client.viewRect.height - _reciever.height)
				_recieverToPoint.y = _client.viewRect.height - _reciever.height;

			_animatePropertyX = new AnimateProperty(_reciever);
			_animatePropertyY = new AnimateProperty(_reciever);
			
			_animatePropertyX.addEventListener(TweenEvent.TWEEN_UPDATE, handleTween);
			_animatePropertyX.addEventListener(TweenEvent.TWEEN_END, handleTween);


		
			_animatePropertyX.property = "x"
			_animatePropertyX.toValue =  _recieverToPoint.x;
			_animatePropertyX.play();

			_animatePropertyY.property = "y"				
			_animatePropertyY.toValue =  _recieverToPoint.y;
			_animatePropertyY.play();
			// events

		}

		public function cancel():void
		{		
			_isExecuting = false;
			_animatePropertyX.pause();	
			_animatePropertyY.pause();			

		}
		
		public function isExecuting():Boolean
		{
			return _isExecuting;
		}
		
		
		/////////////////////////////////////////////////////////
		//
		// events
		//
		/////////////////////////////////////////////////////////
		
		/**
	    *  @private
	    */	
	 		
		private function handleTween(e:TweenEvent):void
		{
			switch (e.type)
			{
				case TweenEvent.TWEEN_UPDATE:
					UIComponent(_client).invalidateDisplayList();
					break;
				case TweenEvent.TWEEN_END:
					cancel();
					dispatchEvent(new PanZoomEvent(PanZoomEvent.COMMAND_COMPLETE, _recieverToPoint));
					break;	
			}		
		}
	}
}