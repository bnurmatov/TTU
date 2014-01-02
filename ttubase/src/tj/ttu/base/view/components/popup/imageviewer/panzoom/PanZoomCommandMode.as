package tj.ttu.base.view.components.popup.imageviewer.panzoom
{
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	import tj.ttu.base.events.PanZoomEvent;
	import tj.ttu.base.view.components.popup.imageviewer.ContentRectangle;
	import tj.ttu.base.view.components.popup.imageviewer.Zoom;
	import tj.ttu.base.view.interfaces.IZoomComponent;
	
	public class PanZoomCommandMode
	{
		
		private static var CLICK_DEADZONE_RADIUS:int = 4;
		private static var CENTERVIEW_DEADZONE_RADIUS:int = 30;
		
		private var _client:UIComponent;		
		private var _reciever:ContentRectangle;
		private var _isActivated:Boolean;
		private var _mouseDownPosition:Point;
		
		// commands
		private var _panMouseCommand:PanMouseCommand;
		private var _panToPointCommand:PanToPointCommand;
		private var _zoomCommand:ZoomCommand;
		
		// cursor assets
		private var cursorID:Number = 0;
		[Embed(source="/embed_assets/swf/iconography.swf", symbol="IconHandOpen")] 
		private var _iconHandOpen:Class;		
		[Embed(source="/embed_assets/swf/iconography.swf", symbol="IconHandClosed")] 
		private var _iconHandClosed:Class;	
		
		
		/////////////////////////////////////////////////////////
		//
		// constructor
		//
		/////////////////////////////////////////////////////////
		
		/**
		 * the PanZoomCmmandMode encapsulates all the command functionality into a 
		 * single mode that can be disabled. 
		 */
		
		public function PanZoomCommandMode(client:UIComponent, reciever:ContentRectangle)
		{
			_isActivated = false;
			_reciever = reciever;
			_client = client;
		}
		
		
		/////////////////////////////////////////////////////////
		//
		// interface
		//
		/////////////////////////////////////////////////////////
		
		/**
		 *  Returns the state of the mode.
		 */		
		
		public function isActivated():Boolean
		{
			return _isActivated;
		}
		
		/**
		 * Activates the mode and creates the command objects, and sets up 
		 * the mouse event listeners.
		 */
		
		public function activate():void
		{
			// interface
			_isActivated = true;
			
			// check to make sure the client can 
			// recieve  double-click mouse events.
			if (!_client.doubleClickEnabled)
				_client.doubleClickEnabled = true;			
			
			
			// objects
			if (_panMouseCommand == null)
			{
				_panMouseCommand = new PanMouseCommand(_client, _reciever);
			}				
			if (_panToPointCommand == null)
			{
				_panToPointCommand = new PanToPointCommand(_client as IZoomComponent, _reciever);
			}	
			if (_zoomCommand == null)
			{
				_zoomCommand = new ZoomCommand(_client as IZoomComponent, _reciever);
			}
			
			// events
			_client.addEventListener(MouseEvent.MOUSE_DOWN  , handleMouse);			
			_client.addEventListener(MouseEvent.MOUSE_OUT   , handleMouse);
			_client.addEventListener(MouseEvent.MOUSE_OVER  , handleMouse);			
			
		}
		/**
		 * Deactivates the mode by removing the mouse event listeners.
		 */
		
		public function deactivate():void
		{
			_isActivated = false;
			
			// events
			_client.removeEventListener(MouseEvent.MOUSE_DOWN  , handleMouse);			
			_client.removeEventListener(MouseEvent.MOUSE_OUT   , handleMouse);
			_client.removeEventListener(MouseEvent.MOUSE_OVER  , handleMouse);						
		}
		
		
		/////////////////////////////////////////////////////////
		//
		// events
		//
		/////////////////////////////////////////////////////////
		
		/**
		 *  @private
		 */
		
		private function handleMouse(e:MouseEvent):void
		{							
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					// add listeners
					_client.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouse);					
					_client.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouse);					
					// remove listeners
					_client.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouse);					
					// commands / actions
					_mouseDownPosition = new Point(e.localX, e.localY);
					
					// only allow a pan if the view is smaller than the content.
					if (!IZoomComponent(_client).viewRect.containsRect(_reciever))
					{	
						_panMouseCommand.execute();
						
						CursorManager.removeAllCursors();  
						cursorID = CursorManager.setCursor(_iconHandClosed);						
					}
					break;
				case MouseEvent.MOUSE_UP:
					// add listeners
					_client.addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);	
					_client.addEventListener(MouseEvent.CLICK, handleMouse);	
					_client.addEventListener(MouseEvent.DOUBLE_CLICK, handleMouse)
					// remove listeners
					_client.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouse);					
					// commands/actions	
					CursorManager.removeAllCursors();  
					cursorID = CursorManager.setCursor(_iconHandOpen);	
					break;
				case MouseEvent.CLICK:
					// add listeners
					_client.addEventListener(MouseEvent.DOUBLE_CLICK, handleMouse);
					// remove listeners
					_client.removeEventListener(MouseEvent.CLICK, handleMouse);						
					// commands / actions
					var __dist:Number = Point.distance(_mouseDownPosition, new Point(e.localX, e.localY));
					
					// only fire center view command if the click comes 
					// within the CLICK_DEADZONE_RADIUS && if view is smaller than the content.
					if (__dist < CLICK_DEADZONE_RADIUS && !IZoomComponent(_client).viewRect.containsRect(_reciever))
					{
						_panToPointCommand.fromPoint = new Point(e.localX , e.localY);
						_panToPointCommand.toPoint = new Point(_client.width/2 , _client.height/2);
						_panToPointCommand.execute();
					}
					break;
				case MouseEvent.DOUBLE_CLICK:
					// remove listeners
					_client.removeEventListener(MouseEvent.DOUBLE_CLICK, handleMouse);						
					// commands / actions
					if(e.shiftKey)
						_zoomCommand.direction = Zoom.ZOOM_OUT;						
					else 
						_zoomCommand.direction = Zoom.ZOOM_IN;							
					
					if (IZoomComponent(_client).viewRect.containsRect(_reciever))
					{
						_zoomCommand.execute();
						
					} else 
					{
						// zoom is triggerd when center-view command is complete
						_panToPointCommand.addEventListener(PanZoomEvent.COMMAND_COMPLETE, handleCenterView)				
					}
					
					break;
				
				case MouseEvent.MOUSE_MOVE:
					// remove listeners
					_client.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouse);		
					break;
				case MouseEvent.MOUSE_OUT:
					CursorManager.removeAllCursors();  
					break;
				
				case MouseEvent.MOUSE_OVER:
					// cursors
					if (IZoomComponent(_client).viewRect.containsRect(_reciever))
					{
						CursorManager.removeAllCursors();  
					} else
					{					
						CursorManager.removeAllCursors();  
						cursorID = CursorManager.setCursor(_iconHandOpen);						
					}
					break;
			}
			
		}
		
		/**
		 *  @private
		 */
		
		private function handleCenterView(e:PanZoomEvent):void
		{
			switch(e.type)
			{
				case "commandComplete":
					
					_panToPointCommand.removeEventListener(PanZoomEvent.COMMAND_COMPLETE, handleCenterView)
					
					if (!IZoomComponent(_client).viewRect.containsRect(_reciever))
					{
						_zoomCommand.execute();
					}
					
					_client.invalidateDisplayList();					
					
					break;
			}	
		}
	}
}