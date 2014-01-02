package tj.ttu.base.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.system.Capabilities;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.edit.TextFlowEdit;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	import flashx.textLayout.operations.InsertInlineGraphicOperation;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.graphics.codec.PNGEncoder;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.utils.TextFlowUtil;
	
	import tj.ttu.base.utils.ContentTextFlowUtil;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	
	public class InsertMediaUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const APP_FOLDER:String = "app:";
		
		
		private static const IMG_PATTERN:RegExp = /(<img[^>]*id=\"?([^\"]*)[^>]*>)/gi;
		private static const ANCHOR_TEMPLATE:String = "<a href='$2' target='_blank'>$1</a>";
		
		public static const PLAY_AUDIO_ICON:String = "/embed_assets/icons/play_upIcon.png";
		
		public static const VIDEO_PLAYER_ICON:String = "/embed_assets/icons/movie_icon.png";
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private static function get isAir():Boolean
		{
			return Capabilities.playerType == "Desktop";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Joins text and images and returns textflow bobject 
		 * @param text
		 * @return textFlow where  text and images are combined
		 * 
		 */		
		public static function createFlow(text:String, images:IList, imageProxyUrl:String = null):TextFlow
		{
			if(!text)
				return null;
			var gtpat:RegExp = />/igm;
			var ltpat:RegExp = /</igm;
			text = text.replace(gtpat, "&gt;"); 
			text = text.replace(ltpat, "&lt;"); 
			var flow:TextFlow = TextFlowUtil.importFromString(text, WhiteSpaceCollapse.PRESERVE);
			
			if(images)
			{
				var grformat:TextLayoutFormat = new TextLayoutFormat()
				grformat.paddingBottom = 5;	
				grformat.paddingTop = 5;	
				grformat.paddingLeft = 5;	
				grformat.paddingRight= 5;	
				var sel:SelectionState;
				flow.interactionManager = new EditManager();
				var em:EditManager = flow.interactionManager as EditManager;
				
				for each (var ui:ImageVO in images) 
				{
					if(ui.textPosition == -1)
						ui.textPosition = 0;
					sel = new SelectionState(flow,ui.textPosition, ui.textPosition , grformat );
					var elem: InlineGraphicElement =  new  InlineGraphicElement();
					if(imageProxyUrl && ui.originalImageUrl)
						elem.source = imageProxyUrl+ui.originalImageUrl;
					else if(ui.image)
						elem.source = ui.image;
					else
						elem.source = ui.imageUrl;
					elem.float = ui.location;
					
					em.selectRange(ui.textPosition, ui.textPosition);
					try
					{
						em.insertInlineGraphic( elem.source,ui.width,ui.height, ui.location, sel);
					} 
					catch(error:Error) 
					{
						
					}
					flow.flowComposer.updateAllControllers();
				}
			}
			return flow;
		}
		
		/**
		 * Joins text and images, sounds, videos and returns textflow object 
		 * @param text
		 * @return textFlow where  text and images are combined
		 * 
		 */		
		public static function createChapterFlow(text:String, images:IList = null, sounds:IList = null, videoList:IList = null, proxyUrl:String = null):TextFlow
		{
			images = sortImages(images as ICollectionView);
			if(!text)
				text = " ";
			
/*			if(!text)
				return null;
			*/
			var inlineGraphElem:InlineGraphicElement;
			var flow:TextFlow = TextFlowUtil.importFromString(text, WhiteSpaceCollapse.PRESERVE);
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			grformat.paddingBottom = 5;	
			grformat.paddingTop = 5;	
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;	
			var sel:SelectionState;
			var iconUrl:String;
			flow.interactionManager = new EditManager();
			var em:EditManager = flow.interactionManager as EditManager;
			if(images)
			{
				for each (var ui:ImageVO in images) 
				{
					if(ui.textPosition == -1)
						ui.textPosition = 0;
					if(ui.textPosition > flow.getText().length)
						ui.textPosition = flow.getText().length
					sel = new SelectionState(flow,ui.textPosition, ui.textPosition , grformat );
					var elem: InlineGraphicElement =  new  InlineGraphicElement();
					if(proxyUrl && ui.originalImageUrl)
						elem.source = proxyUrl + ui.originalImageUrl;
					else if(ui.image)
						elem.source = ui.image;
					else
						elem.source = ui.imageUrl;
					elem.float = ui.location;
					em.selectRange(ui.textPosition, ui.textPosition);
					inlineGraphElem = em.insertInlineGraphic( elem.source,ui.width,ui.height, ui.location, sel);
					inlineGraphElem.id = ui.imageUrl;
					flow.flowComposer.updateAllControllers();
				}
			}
			if(sounds)
			{
				for each (var sound:SoundVO in sounds) 
				{
					if(sound.textPosition == -1)
						sound.textPosition = 0;
					if(sound.textPosition > flow.getText().length)
						sound.textPosition = flow.getText().length
					sel = new SelectionState(flow,sound.textPosition, sound.textPosition , grformat );
					em.selectRange(sound.textPosition, sound.textPosition);
					iconUrl = isAir ? APP_FOLDER + PLAY_AUDIO_ICON : PLAY_AUDIO_ICON;
					inlineGraphElem = em.insertInlineGraphic( iconUrl, 22, 22, 'none', sel);
					inlineGraphElem.id = sound.soundUrl;
					flow.flowComposer.updateAllControllers();
				}
			}
			
			if(videoList)
			{
				for each (var video:VideoVO in videoList) 
				{
					if(video.textPosition == -1)
						video.textPosition = 0;
					if(video.textPosition > flow.getText().length)
						video.textPosition = flow.getText().length
					sel = new SelectionState(flow, video.textPosition, video.textPosition , grformat );
					em.selectRange(video.textPosition, video.textPosition);
					iconUrl = isAir ? APP_FOLDER + VIDEO_PLAYER_ICON : VIDEO_PLAYER_ICON;
					inlineGraphElem = em.insertInlineGraphic( iconUrl, 24, 24, 'none', sel);
					inlineGraphElem.id = video.videoUrl;
					flow.flowComposer.updateAllControllers();
				}
			}
			
			var divString:String = ContentTextFlowUtil.textFlowToString(flow);
			divString = divString.replace(IMG_PATTERN, ANCHOR_TEMPLATE);
			flow = ContentTextFlowUtil.stringToTextFlow( divString );
			return flow;
		}
		/**
		 * Joins text and images, sounds, videos and returns textflow object 
		 * @param text
		 * @return textFlow where  text and images are combined
		 * 
		 */		
		public static function createChapterFlowForPDF(text:String, images:IList = null):TextFlow
		{
			images = sortImages(images as ICollectionView);
			if(!text)
				text = " ";
			
			var inlineGraphElem:InlineGraphicElement;
			var flow:TextFlow = TextFlowUtil.importFromString(text, WhiteSpaceCollapse.PRESERVE);
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			grformat.paddingBottom = 5;	
			grformat.paddingTop = 5;	
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;	
			var sel:SelectionState;
			var iconUrl:String;
			flow.interactionManager = new EditManager();
			var em:EditManager = flow.interactionManager as EditManager;
			if(images)
			{
				for each (var ui:ImageVO in images) 
				{
					if(ui.textPosition == -1)
						ui.textPosition = 0;
					if(ui.textPosition > flow.getText().length)
						ui.textPosition = flow.getText().length
					sel = new SelectionState(flow,ui.textPosition, ui.textPosition , grformat );
					var elem: InlineGraphicElement =  new  InlineGraphicElement();
					if(ui.image)
						elem.source = ui.image;
					else
						elem.source = ui.imageUrl;
					elem.float = ui.location;
					em.selectRange(ui.textPosition, ui.textPosition);
					inlineGraphElem = em.insertInlineGraphic( elem.source,ui.width,ui.height, ui.location, sel);
					inlineGraphElem.id = ui.imageUrl;
					flow.flowComposer.updateAllControllers();
				}
			}
			return flow;
		}
		
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function getTextImagesAsBinary(textFlow:TextFlow, imageProxyUrl:String, images:IList = null):IList
		{
			var imageCollection:IList = new ArrayCollection();
			if(!textFlow)
				return null;
			var arr:Array = textFlow.getElementsByTypeName("img");
			var img : ImageVO;
			for each (var element:FlowElement in arr) 
			{
				if(element is InlineGraphicElement)
				{
					var ige: InlineGraphicElement = element as InlineGraphicElement;
					if(SupportedMediaFormat.isMp3(ige.id) || SupportedMediaFormat.isVideo(ige.id))
						continue;
					img = new ImageVO();
					img.image = ige.source;
					var bmp:BitmapData;
					var origUrl:String = "";
					if(ige.graphic && ige.graphic is Loader &&  Loader( ige.graphic).content &&  Loader( ige.graphic).content is Bitmap)
					{
						bmp = Bitmap( Loader(ige.graphic).content).bitmapData;
						origUrl = String(img.image).replace(imageProxyUrl, "");
					}
					else if(ige.source is Bitmap)
						bmp = Bitmap(ige.source).bitmapData;
					else if(ige.source is BitmapData)
						bmp = ige.source as BitmapData;
					
					
					img.image = null;
					if(bmp)
						img.binarySource = ImageNormalizer.normalizeAndEncode(bmp);
					else
						img.binarySource = null;
					img.width = ige.width > 0 ? ige.width.toString() : 'auto';
					img.height = ige.height > 0 ? ige.height.toString() : 'auto' ;
					img.textPosition = ige.getAbsoluteStart();
					img.originalImageUrl = getOriginalImageUrl(images, origUrl, imageProxyUrl);;
					img.imageUrl = origUrl;
					img.location = ige.float;
					imageCollection.addItem(img);
				}
			}
			return imageCollection.length > 0 ? imageCollection: null;
		}
		
		private static function getOriginalImageUrl(images:IList, imageUrl:String, imageProxyUrl:String):String
		{
			for each (var item:ImageVO in images) 
			{
				if(item.image is String && item.image == imageUrl)
					return isLocal(imageProxyUrl, String(item.originalImageUrl)) ? null : String(item.originalImageUrl);
			}
			return imageUrl;
		}
		
		public static function isLocal(imageProxyUrl:String, imageUrl:String):Boolean
		{
			var baseUrl:String = imageProxyUrl ? imageProxyUrl.substring(0, imageProxyUrl.indexOf("static/assets")):null;
			return imageUrl.search(baseUrl) != -1;
		}
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function updateTextImagesPosition(textFlow:TextFlow, existingImages:IList):IList
		{
			var images:IList = new ArrayCollection();
			if(!textFlow)
				return null;
			var arr:Array = textFlow.getElementsByTypeName("img");
			for each (var element:FlowElement in arr) 
			{
				if(element is InlineGraphicElement)
				{
					var ige: InlineGraphicElement = element as InlineGraphicElement;
					if(SupportedMediaFormat.isMp3(ige.id) || SupportedMediaFormat.isVideo(ige.id))
						continue;
					for each(var item:ImageVO in existingImages)
					{
						if(item && item.imageUrl == ige.id)
						{
							item.width = ige.width > 0 ? ige.width.toString() : 'auto';
							item.height = ige.height > 0 ? ige.height.toString() : 'auto' ;
							item.textPosition = ige.getAbsoluteStart();
							item.location = ige.float;
						}
					}
				}
			}
			return existingImages;
		}
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function getTextSoundsAsBinary(textFlow:TextFlow, existSounds:IList):IList
		{
			var sounds:IList = new ArrayCollection();
			if(!textFlow)
				return null;
			var arr:Array = textFlow.getElementsByTypeName("img");
			for each (var element:FlowElement in arr) 
			{
				if(element is InlineGraphicElement)
				{
					var ige: InlineGraphicElement = element as InlineGraphicElement;
					if(SupportedMediaFormat.isMp3(ige.id))
					{
						for each(var sound:SoundVO in existSounds)
						{
							if(sound && sound.soundUrl == ige.id)
							{
								sound.textPosition = ige.getAbsoluteStart();
								sounds.addItem(sound);
							}
						}
					}
					
				}
			}
			return sounds.length > 0 ? sounds: null;
		}
		
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function getTextVideoAsBinary(textFlow:TextFlow, existVideo:IList):IList
		{
			var videoList:IList = new ArrayCollection();
			if(!textFlow)
				return null;
			var arr:Array = textFlow.getElementsByTypeName("img");
			for each (var element:FlowElement in arr) 
			{
				if(element is InlineGraphicElement)
				{
					var ige: InlineGraphicElement = element as InlineGraphicElement;
					if(SupportedMediaFormat.isVideo(ige.id))
					{
						for each(var video:VideoVO in existVideo)
						{
							if(video && video.videoUrl == ige.id)
							{
								video.textPosition = ige.getAbsoluteStart();
								videoList.addItem(video);
							}
						}
					}
					
				}
			}
			return videoList.length > 0 ? videoList: null;
		}
		
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function getFlowImages(textFlow:TextFlow, selectionStart:int= 0):IList
		{
			var images:IList = new ArrayCollection();
			if(!textFlow)
				return null;
			var arr:Array = textFlow.getElementsByTypeName("img");
			var img : ImageVO;
			var encoder:PNGEncoder = new PNGEncoder();
			for each (var element:FlowElement in arr) 
			{
				if(element is InlineGraphicElement)
				{
					var ige: InlineGraphicElement = element as InlineGraphicElement;
					img = new ImageVO();
					img.image = ige.source;
					img.width = ige.width > 0 ? ige.width.toString() : 'auto';
					img.height = ige.height > 0 ? ige.height.toString() : 'auto' ;
					img.textPosition = ige.getAbsoluteStart() + selectionStart;
					images.addItem(img);
				}
			}
			return images.length > 0 ? images: null;
		}
		
		public static function hasImage(textFlow:TextFlow):Boolean
		{
			if(!textFlow)
				return false;
			var arr:Array = textFlow.getElementsByTypeName("img");
			if(arr && arr.length > 0)
				return true;
			else
				return false;
		}
		
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function insertTextAndImages(controlFlow:TextFlow, textFlow:TextFlow,  imageproxyUrl:String, selectionStart:int= 0):TextFlow
		{
			if(!textFlow && !controlFlow)
				return null;
			
			var images:IList = getFlowImages(textFlow, selectionStart);
			var img : ImageVO;
			if(images && images.length > 0)
			{
				var grformat:TextLayoutFormat = new TextLayoutFormat()
				grformat.paddingBottom = 5;	
				grformat.paddingTop = 5;	
				grformat.paddingLeft = 5;	
				grformat.paddingRight= 5;	
				var sel:SelectionState;
				var em:EditManager = controlFlow.interactionManager as EditManager;
				var imagesUrl:Array = [];
				for each (var ui:ImageVO in images) 
				{
					sel = new SelectionState(controlFlow,ui.textPosition, ui.textPosition , grformat );
					var elem: InlineGraphicElement =  new  InlineGraphicElement();
					elem.source = imageproxyUrl ? imageproxyUrl + ui.image: ui.image;
					elem.float = ui.location;
					em.selectRange(ui.textPosition, ui.textPosition);
					try
					{
						em.insertInlineGraphic(elem.source, ui.width, ui.height, ui.location, sel);
					} 
					catch(error:Error) {}
					controlFlow.flowComposer.updateAllControllers();
				}
			}
			return controlFlow;
		}
		
		
		public static function insertSingleImageToTextFlow(textFlow:TextFlow, img:ImageVO):void
		{
			if(!img || !textFlow)
				return;
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			grformat.paddingBottom = 5;	
			grformat.paddingTop = 5;	
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;	
			var sel:SelectionState;
			var em:EditManager = textFlow.interactionManager as EditManager;
			img.textPosition =  img.textPosition != -1 ? img.textPosition : 0;
			sel = new SelectionState(textFlow, img.textPosition, img.textPosition , grformat );
			em.selectRange(img.textPosition, img.textPosition);
			try
			{
				em.insertInlineGraphic( img.imageUrl, img.width, img.height, img.location, sel);
			}
			catch(E:Error) {}
			textFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * Converts bitmapdata of images to png and returns them
		 */
		public static function insertTextAndImagesToChapter(controlFlow:TextFlow, textFlow:TextFlow,  imageproxyUrl:String, selectionStart:int= 0):TextFlow
		{
			if(!textFlow && !controlFlow)
				return null;
			
			var images:IList = getFlowImages(textFlow, selectionStart);
			var img : ImageVO;
			if(images && images.length > 0)
			{
				var grformat:TextLayoutFormat = new TextLayoutFormat()
				grformat.paddingBottom = 5;	
				grformat.paddingTop = 5;	
				grformat.paddingLeft = 5;	
				grformat.paddingRight= 5;	
				var sel:SelectionState;
				var em:EditManager = controlFlow.interactionManager as EditManager;
				var imagesUrl:Array = [];
				for each (var ui:ImageVO in images) 
				{
					sel = new SelectionState(controlFlow,ui.textPosition, ui.textPosition , grformat );
					var elem: InlineGraphicElement =  new  InlineGraphicElement();
					elem.source = imageproxyUrl ? imageproxyUrl + ui.image: ui.image;
					elem.float = ui.location;
					em.selectRange(ui.textPosition, ui.textPosition);
					try
					{
						var inlineGraphElem:InlineGraphicElement =  em.insertInlineGraphic(elem.source, ui.width, ui.height, ui.location, sel);
						inlineGraphElem.id = elem.source as String;
						imagesUrl.push(elem.source);
					} 
					catch(error:Error) {}
					controlFlow.flowComposer.updateAllControllers();
				}
				
				if(imagesUrl && imagesUrl.length > 0)
				{
					var divString1:String = ContentTextFlowUtil.textFlowToString(controlFlow);
					for each(var url:String in imagesUrl)
					{
						if(url)
						{
							var temp:String = "<a href='"+url+"' target='_blank'>$1</a>";
							var pat:RegExp = new RegExp('(<img[^>]*id="'+url+'"*[^>]*>)', 'gi'); 
							divString1 = divString1.replace(pat, temp);
						}
					}
					
					controlFlow = ContentTextFlowUtil.stringToTextFlow( divString1 );
					controlFlow.flowComposer.updateAllControllers();
				}
			}
			return controlFlow;
		}
		
		public static function insertSingleImageToChapterTextFlow(divString:String, img:ImageVO):TextFlow
		{
			if(!img || !divString)
				return null;
			var flow:TextFlow = TextFlowUtil.importFromString(divString, WhiteSpaceCollapse.PRESERVE);
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			grformat.paddingBottom = 5;	
			grformat.paddingTop = 5;	
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;	
			var sel:SelectionState;
			flow.interactionManager = new EditManager();
			var em:EditManager = flow.interactionManager as EditManager;
			img.textPosition =  img.textPosition != -1 ? img.textPosition : 0;
			sel = new SelectionState(flow, img.textPosition, img.textPosition , grformat );
			em.selectRange(img.textPosition, img.textPosition);
			try
			{
				var inlineGraphElem:InlineGraphicElement = em.insertInlineGraphic( img.imageUrl, img.width, img.height, img.location, sel);
				inlineGraphElem.id = img.imageUrl;
			}
			catch(E:Error) {}
			flow.flowComposer.updateAllControllers();
			var temp:String = "<a href='"+img.imageUrl+"' target='_blank'>$1</a>";
			var pat:RegExp = new RegExp('(<img[^>]*id="'+img.imageUrl+'"*[^>]*>)', 'gi'); 
			
			var divString1:String = ContentTextFlowUtil.textFlowToString(flow);
			divString1 = divString1.replace(pat, temp);
			flow = ContentTextFlowUtil.stringToTextFlow( divString1 );
			flow.flowComposer.updateAllControllers();
			return flow;
		}
		
		public static function insertSingleSoundToTextFlow(divString:String, sound:SoundVO):TextFlow
		{
			if(!sound || !divString)
				return null;
			
			var flow:TextFlow = TextFlowUtil.importFromString(divString, WhiteSpaceCollapse.PRESERVE);
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;
			grformat.paddingBottom 	= 0;
			grformat.paddingTop 	= 0;
			var sel:SelectionState;
			flow.interactionManager = new EditManager();
			var em:EditManager = flow.interactionManager as EditManager;
			sound.textPosition =  sound.textPosition != -1 ? sound.textPosition : 0;
			sel = new SelectionState(flow, sound.textPosition, sound.textPosition , grformat );
			em.selectRange(sound.textPosition, sound.textPosition);
			var iconUrl:String = isAir ? APP_FOLDER + PLAY_AUDIO_ICON : PLAY_AUDIO_ICON;
			try
			{
				var inlineGraphElem:InlineGraphicElement = em.insertInlineGraphic( iconUrl, 22, 22, 'none', sel);
				inlineGraphElem.id = sound.soundUrl;
			}
			catch(E:Error) {}
			flow.flowComposer.updateAllControllers();
			var temp:String = "<a href='"+sound.soundUrl+"' target='_blank'>$1</a>";
			var pat:RegExp = new RegExp('(<img[^>]*id="'+sound.soundUrl+'"*[^>]*>)', 'gi'); 
			
			var divString1:String = ContentTextFlowUtil.textFlowToString(flow);
			divString1 = divString1.replace(pat, temp);
			flow = ContentTextFlowUtil.stringToTextFlow( divString1 );
			flow.flowComposer.updateAllControllers();
			return flow;
		}
		
		
		public static function insertSingleVideoToTextFlow(divString:String, video:VideoVO):TextFlow
		{
			if(!video || !divString)
				return null;
			
			var flow:TextFlow = TextFlowUtil.importFromString(divString, WhiteSpaceCollapse.PRESERVE);
			var grformat:TextLayoutFormat = new TextLayoutFormat()
			
			grformat.paddingLeft = 5;	
			grformat.paddingRight= 5;	
			grformat.paddingBottom 	= 0;
			grformat.paddingTop 	= 0;
			var sel:SelectionState;
			flow.interactionManager = new EditManager();
			var em:EditManager = flow.interactionManager as EditManager;
			video.textPosition =  video.textPosition != -1 ? video.textPosition : 0;
			sel = new SelectionState(flow, video.textPosition, video.textPosition , grformat );
			em.selectRange(video.textPosition, video.textPosition);
			var iconUrl:String = isAir ? APP_FOLDER + VIDEO_PLAYER_ICON : VIDEO_PLAYER_ICON;
			try
			{
				var inlineGraphElem:InlineGraphicElement = em.insertInlineGraphic( iconUrl, 24, 24, 'none', sel);
				inlineGraphElem.id = video.videoUrl;
			}
			catch(E:Error) {}
			flow.flowComposer.updateAllControllers();
			var temp:String = "<a href='"+video.videoUrl+"' target='_blank'>$1</a>";
			var pat:RegExp = new RegExp('(<img[^>]*id="'+video.videoUrl+'"*[^>]*>)', 'gi'); 
			
			var divString1:String = ContentTextFlowUtil.textFlowToString(flow);
			divString1 = divString1.replace(pat, temp);
			flow = ContentTextFlowUtil.stringToTextFlow( divString1 );
			flow.flowComposer.updateAllControllers();
			return flow;
		}
		
		
		public static function sortImages(images:ICollectionView):IList
		{
			if(!images) return null;
			var sort:Sort = new Sort();
			var field:SortField = new SortField("textPosition",false, true);
			sort.fields = [field];
			images.sort = sort;
			images.refresh();
			return images as IList;
		}
	}
}