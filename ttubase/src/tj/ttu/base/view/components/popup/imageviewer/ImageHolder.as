////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 8, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.components.popup.imageviewer
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.events.TweenEvent;
	
	import tj.ttu.base.view.components.popup.imageviewer.panzoom.PanZoomCommandMode;
	import tj.ttu.base.view.interfaces.IZoomComponent;
	
	/**
	 * ImageHolder class 
	 */
	public class ImageHolder extends UIComponent implements IZoomComponent
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
		[Bindable]
		public var loadingImage:Boolean = false;
		private var _panZoomCommandMode:PanZoomCommandMode;
		
		private var _animateProperty:AnimateProperty;
		private var _loader:Loader;
		private var _contentRectangle:ContentRectangle;
		private var _progressSWF:SWFLoader;	
		private var _percentLoadedLabel:Label;
		// preloader assets
		[Embed(source="/embed_assets/swf/iconography.swf", symbol="ProgressThrobber")] 
		private var _progressThrobber:Class;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageHolder 
		 */
		public function ImageHolder()
		{
			super();
			viewRect = new Rectangle();
			_contentRectangle = new ContentRectangle(0,0,0,0,viewRect);
			
			addEventListener(ResizeEvent.RESIZE, handleResize);
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// viewRect
		//-----------------------------------------
		private var _viewRect:Rectangle;
		
		public function get viewRect():Rectangle
		{
			return _viewRect;
		}
		
		public function set viewRect(value:Rectangle):void
		{
			if( _viewRect !== value)
			{
				_viewRect = value;
			}
		}
		
		//-----------------------------------------
		// imageURL
		//-----------------------------------------
		private var _imageURL:String;
		/**
		 * 
		 * Setting the imageURL triggers the loading of the image and extraction 
		 * and assignment of it's bitmapData. 
		 *
		 */ 		
		
		[Bindable]
		public function get imageURL():String
		{
			return _imageURL;
		}
		public function set imageURL(value:String):void
		{
			// setting imageURL triggers loading sequence		
			if (value == _imageURL)
				return;
			initLoader();
			_loader.load(new URLRequest(value));
			loadingImage = true;            
			
			formatUI();
			if(_percentLoadedLabel)
				_percentLoadedLabel.text = "";		
			invalidateDisplayList();            
			
			
		}
		
		//-----------------------------------------
		// bitmap
		//-----------------------------------------
		private var _bitmap:Bitmap;
		/**			
		 * Setting the ImageViewer's bitmap triggers the activation of the PanZoomCommandMode.
		 * 
		 * <p>The PanZoomCommandMode acts as the 'invoker' element in the Command Pattern.
		 * It's constructor requires that you assoiciate it with a 'client' and a 'reciever'. 
		 * In this implementation the 'client' is the ImageView (this) and the 
		 * reciever is the bitmapData transform matrix.</p> 
		 */
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		public function set bitmap(value:Bitmap):void
		{
			if (value == _bitmap)
				return;
			
			_bitmap = value;
			
			_contentRectangle = new ContentRectangle(0,0,_bitmap.width, _bitmap.height, viewRect);		
			
			//_contentRectangle.viewAll(viewRect);
			
			_panZoomCommandMode = new  PanZoomCommandMode(this, _contentRectangle)			
			_panZoomCommandMode.activate();
			
			invalidateDisplayList();
			
		}
		
		//-----------------------------------------
		// bitmapScaleFactorMin
		//-----------------------------------------
		private var _bitmapScaleFactorMin:Number = .125;		
		
		[Bindable(event="bitmapScaleFactorMinChange")]
		public function get bitmapScaleFactorMin():Number
		{
			return _bitmapScaleFactorMin;
		}
		
		public function set bitmapScaleFactorMin(value:Number):void
		{
			if( _bitmapScaleFactorMin !== value)
			{
				_bitmapScaleFactorMin = value;
				dispatchEvent(new Event("bitmapScaleFactorMinChange"));
			}
		}
		
		//-----------------------------------------
		// bitmapScaleFactorMax
		//-----------------------------------------
		private var _bitmapScaleFactorMax:Number = 5;
		
		[Bindable(event="bitmapScaleFactorMaxChange")]
		public function get bitmapScaleFactorMax():Number
		{
			return _bitmapScaleFactorMax;
		}
		
		public function set bitmapScaleFactorMax(value:Number):void
		{
			if( _bitmapScaleFactorMax !== value)
			{
				_bitmapScaleFactorMax = value;
				dispatchEvent(new Event("bitmapScaleFactorMaxChange"));
			}
		}
		
		
		//-----------------------------------------
		// bitmapScaleFactor
		//-----------------------------------------
		private var _bitmapScaleFactor:Number;
		/**
		 * Tracks the scale of the bitmap being displayed.
		 * Setting the bitmapScale factor invalidates the displayList since any
		 * change will requite an update.
		 */ 	
		
		[Bindable]
		public function get bitmapScaleFactor():Number
		{
			return _bitmapScaleFactor;
			
		}
		public function set bitmapScaleFactor(value:Number):void
		{
			if (value == bitmapScaleFactor )
				return;
			
			if (value < bitmapScaleFactorMin)
				return;
			
			if (value > bitmapScaleFactorMax)
				return;
			
			_bitmapScaleFactor = value;								
			invalidateDisplayList();				
		}
		
		//-----------------------------------------
		// bitmapScaleFactor
		//-----------------------------------------
		private var _smoothBitmap:Boolean = false;
		/**
		 * setting smoothBitmap to true hurts performance slightly
		 */
		
		[Bindable]
		public function get smoothBitmap():Boolean
		{
			return _smoothBitmap;
		}
		public function set smoothBitmap(value:Boolean):void
		{
			if (value == _smoothBitmap)
				return;
			
			_smoothBitmap = value;
			invalidateDisplayList();	
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * When the display list is updated the bitmap is drawn via a bitmapFill
		 * applied to the UIComponents graphics layer. The size and position of the bitmap 
		 * are determined by the bitmapData's transform matrix, which is derived by parsing
		 * the _contentRectangle's properties.   
		 * 
		 */
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			viewRect.width = width;
			viewRect.height = height;
			
			if (_bitmap == null)
			{
				// if there's no bitmapData fill the component with black
				graphics.beginFill(0x000000, 1)
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);								
				
			} else if (viewRect != null)
			{	
				
				var __bitmapTransform:Matrix = new Matrix(_contentRectangle.width / _bitmap.width,
					0,
					0,
					_contentRectangle.height / _bitmap.height,
					_contentRectangle.topLeft.x,
					_contentRectangle.topLeft.y
				);
				
				// fill the component with the bitmap.
				graphics.clear()
				graphics.beginBitmapFill(_bitmap.bitmapData,  // bitmapData
					__bitmapTransform,   // matrix
					false,                // tile?
					_smoothBitmap		  // smooth?
				)					 
				
				graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				
				
				// if the edge of the bitmap transition into view 
				// we paint in the negative area.
				
				if (_contentRectangle.left > viewRect.topLeft.x)
				{
					graphics.beginFill(0x000000, 1)
					graphics.drawRect(0,0, _contentRectangle.x, unscaledHeight);				
				}
				if (_contentRectangle.top > viewRect.topLeft.y)
				{
					graphics.beginFill(0x000000, 1)
					graphics.drawRect(0,0,unscaledWidth, _contentRectangle.y);				
				}
				if (_contentRectangle.right < viewRect.width)
				{
					graphics.beginFill(0x000000, 1)
					graphics.drawRect(_contentRectangle.right,0, viewRect.width - _contentRectangle.right , viewRect.height );				
				}			
				
				if (_contentRectangle.bottom < viewRect.height)
				{
					graphics.beginFill(0x000000, 1)
					graphics.drawRect(0,_contentRectangle.bottom, viewRect.width , viewRect.height - _contentRectangle.bottom  );				
				}			
				
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function initLoader():void
		{
			if(!_loader)
			{
				// load events 
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadIOError);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);		
			}
		}
		
		private function destroyLoader():void
		{
			if(_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadIOError);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);	
				_loader = null;
			}
		}
		private function initAnimateProperty():void
		{
			if(!_animateProperty)
			{
				_animateProperty = new AnimateProperty(this);		
				_animateProperty.property = "bitmapScaleFactor";
				_animateProperty.addEventListener(TweenEvent.TWEEN_UPDATE, handleTween);
				_animateProperty.addEventListener(TweenEvent.TWEEN_END, handleTween);
			}
		}
		
		private function destroyAnimateProperty():void
		{
			if(_animateProperty)
			{
				_animateProperty.removeEventListener(TweenEvent.TWEEN_END, handleTween);	
				_animateProperty.removeEventListener(TweenEvent.TWEEN_UPDATE, handleTween);
				_animateProperty = null;
			}
		}
		/**
		 *  @public
		 */
		/**
		 * The zoom function requires a direction to be assigned when the function 
		 * is triggerd.  "in" zooms in and conversly "out" zooms out.
		 */
		
		public function zoom(direction:String):void
		{
			initAnimateProperty();
			switch (direction)
			{
				case Zoom.ZOOM_IN:
					if (_bitmapScaleFactor * 2 > bitmapScaleFactorMax)
						_animateProperty.toValue = bitmapScaleFactorMax;
					else
						_animateProperty.toValue = _bitmapScaleFactor * 2;				
					break;
				case Zoom.ZOOM_OUT:
					if (_bitmapScaleFactor / 2 > bitmapScaleFactorMax)
						_animateProperty.toValue = bitmapScaleFactorMax;
					else
						_animateProperty.toValue = _bitmapScaleFactor / 2;				
					break;					
			}
			_animateProperty.play();
		}
		/**
		 *  @private
		 */
		
		public function setZoom(scale:Number):void
		{
			_contentRectangle.zoom = scale;
			bitmapScaleFactor = scale;
		}
		
		public function centerView():void
		{
			_contentRectangle.viewAll(viewRect);
			bitmapScaleFactor = _contentRectangle.scaleX;
		}
		
		private function formatUI():void
		{
			_progressSWF = new SWFLoader();
			_progressSWF.source = _progressThrobber;
			_progressSWF.width = 16;
			_progressSWF.height = 16;
			_progressSWF.x = 40;
			_progressSWF.y = 15;
			addChild(_progressSWF);
			
			_percentLoadedLabel = new Label();				
			_percentLoadedLabel.width = 300;
			_percentLoadedLabel.height = 32;
			_percentLoadedLabel.x = 55;
			_percentLoadedLabel.y = 15;
			_percentLoadedLabel.blendMode = BlendMode.INVERT;	
			addChild(_percentLoadedLabel);
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		private function handleTween(e:TweenEvent):void
		{
			switch (e.type)
			{
				case TweenEvent.TWEEN_UPDATE:
					_contentRectangle.zoom = bitmapScaleFactor;						
					break;
				case TweenEvent.TWEEN_END:
					_contentRectangle.zoom = bitmapScaleFactor;
					destroyAnimateProperty();
					break;
			}
		}	 
		/**
		 *  @private
		 */
		private function handleCreationComplete(e:FlexEvent):void
		{
			invalidateDisplayList();
			_contentRectangle.zoom = 1;	
			bitmapScaleFactor = _contentRectangle.zoom;
		}
		
		/**
		 *  @private
		 */
		
		private function handleResize(e:ResizeEvent):void
		{
			if (_contentRectangle == null)
				return;
			
			_contentRectangle.centerToPoint(new Point(this.width/2, this.height/2));	
		}
		
		/**
		 *  @private
		 */
		
		// load handlers
		private function handleLoadComplete(e:Event):void
		{
			bitmap = Bitmap(_loader.content);
			loadingImage = false;
			_percentLoadedLabel.text = "Complete";
			removeChild(_progressSWF);
			removeChild(_percentLoadedLabel);
			destroyLoader();
			handleResize(null);
		}
		
		/**
		 *  @private
		 */
		
		private function handleLoadIOError(e:Event):void
		{
			loadingImage = false;
			_percentLoadedLabel.text = "failed to load image";
			removeChild(_progressSWF);
			destroyLoader();
		}
		
		/**
		 *  @private
		 */
		
		private function handleLoadProgress(e:ProgressEvent):void
		{
			if(_percentLoadedLabel)
				_percentLoadedLabel.text = String(Math.round(e.bytesLoaded / e.bytesTotal * 100	) + "%"	);					
		}				
	}
}