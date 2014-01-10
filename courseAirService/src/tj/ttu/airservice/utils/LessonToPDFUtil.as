////////////////////////////////////////////////////////////////////////////////
// Copyright May 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.FontStyle;
	import flash.text.engine.FontWeight;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.elements.DivElement;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.formats.Float;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextDecoration;
	
	import mx.collections.IList;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Chunk;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.SimpleCell;
	import org.purepdf.elements.SimpleTable;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.events.PageEvent;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfChunk;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.PdfViewPreferences;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;
	
	import spark.components.RichText;
	
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.font.TTFFontManager;
	import tj.ttu.base.utils.InsertMediaUtil;
	import tj.ttu.base.utils.LanguageInfoUtil;
	import tj.ttu.base.vo.QuestionVo;
	
	/**
	 * LessonToPDFUtil class 
	 */
	public class LessonToPDFUtil extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		protected const MAX_TEXT_LENGTH:int = 6000;
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * The fonts used by purePdf.
		 */
		protected var pdfFonts:Array;
		protected var defaultFont:Font;
		protected var headerFont:Font;
		/**
		 * Storage for generated pdf
		 */
		public var result:ByteArray = new ByteArray();
		
		protected var writer:PdfWriter;
		protected var document:PdfDocument;
		
		protected var elements:Array;
		protected var errors:Array;
		
		protected var errorParagraph:Paragraph;
		
		protected var paragraph:Paragraph;
		protected var leading:int;
		protected var alignment:int;
		
		//chunk
		protected var chunkBackground:RGBColor;
		
		
		
		//fontloader
		/**
		 * 
		 * <code>fontLoader</code> Manage loading and registering fonts in an application. 
		 * 
		 */		
		private var fontLoader:TTFFontManager;
		/**
		 * 
		 * <code>isFontLoaded</code> Flag for definig font is loaded. 
		 * 
		 * @default <code>false</code>
		 * 
		 */				
		private var isFontLoaded:Boolean = false;
		/**
		 * 
		 * <code>isFontLoaded</code> Flag for definig images is loaded. 
		 * 
		 * @default <code>false</code>
		 * 
		 */				
		private var isImagesLoaded:Boolean = false;
		
		private var headerText:String;
		
		
		/**
		 * 
		 * <code>line</code> line of the custom header. 
		 * 
		 */		
		private var line:SimpleTable;
		
		private var documentImages:Array = [];
		private var loadImagesUtil:LoadImagesUtil;
		private var startBodyElementIndex:int;
		
		
		private var lesson:LessonVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonToPDFUtil 
		 */
		public function LessonToPDFUtil()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _fonts:Array;
		
		
		/**
		 * The list of the fonts for exoprt;
		 */
		public function get fonts():Array
		{
			return _fonts;
		}
		
		/**
		 * @private
		 */
		public function set fonts(value:Array):void
		{
			pdfFonts = [];
			_fonts = value;
			for (var clsName:String in value) 
			{
				var baseFont:BaseFont;
				var cls:Class = _fonts[clsName];
				FontsResourceFactory.getInstance().registerFont( clsName+".ttf", new cls() );
				baseFont = BaseFont.createFont( clsName+".ttf", BaseFont.IDENTITY_H, true);
				pdfFonts[clsName] = new Font( -1, 24, -1, null, baseFont );
			}
			FontsResourceFactory.getInstance().registerFont( BaseFont.TIMES_ITALIC, new BuiltinFonts.TIMES_ITALIC() );
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, new BuiltinFonts.HELVETICA() );
			FontsResourceFactory.getInstance().registerFont( BaseFont.CP1252, new BuiltinFonts.TIMES_ROMAN() );
			FontsResourceFactory.getInstance().registerFont( BaseFont.COURIER, new BuiltinFonts.COURIER() );
			defaultFont = pdfFonts[1]; 
			defaultFont = defaultFont || new Font(Font.HELVETICA,14,Font.NORMAL,RGBColor.WHITE) as Font;
			headerFont = new Font( Font.HELVETICA, 16, Font.NORMAL, new RGBColor( 0x00, 0x00, 0x00 ) );
		}
		
		
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
		
		/**
		 *  @public
		 */
		protected function createDocument( subject: String=null, author:String=null, creator:String=null, rect: RectangleElement=null ): void
		{
			if ( rect == null )
				rect = PageSize.A4;
			leading = 8;
			startBodyElementIndex = 0;
			elements = [];
			errors = [];
			errorParagraph = new Paragraph("");
			
			line = getLine();
			
			writer = PdfWriter.create( result, rect );
			document = writer.pdfDocument;
			if(author)
				document.addAuthor( author );
			document.addTitle( "TTU Course Creator" );
			if(creator)
				document.addCreator( creator );
			if( subject ) 
				document.addSubject( subject );
			document.addKeywords( "ttu,lesson" );
			document.setViewerPreferences( PdfViewPreferences.FitWindow );
			document.addEventListener( PageEvent.PAGE_END, onEndPage );
			document.addEventListener( PageEvent.PAGE_START, onStartPage );
			document.open();
		}
		
		
		/**
		 * Closes pdf document.
		 */
		protected function closeDocument():void
		{
			document.add(errorParagraph);
			document.close();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		/**
		 * Init continer for RTL text
		 */
		protected function initContainer():void
		{
			paragraph = new Paragraph("");
		}
		
		/**
		 * Puts continer to pdf document (used for RTL text)
		 */
		protected function addContainer():void
		{
			var errorString:String;
			
			try
			{
				elements.push(paragraph);
			}
			catch (e:Error)
			{
				errorString = e.toString();
			}			
		}
		
		/**
		 * 
		 * Creates the empty table
		 * 
		 * @return Returns the created table. 
		 *
		 * @see org.purepdf.elements.SimpleTable
		 * @see org.purepdf.elements.SimpleCell
		 * @see org.purepdf.elements.RectangleElement
		 * @see org.purepdf.colors.RGBColor
		 * 
		 */		
		private function getLine() : SimpleTable
		{
			var table:SimpleTable = new SimpleTable();
			table.widthPercentage = 100;
			
			var row:SimpleCell = new SimpleCell( SimpleCell.ROW );
			
			var cell:SimpleCell = new SimpleCell( SimpleCell.CELL );
			cell.add( new Paragraph( "\n" ) );
			cell.border = RectangleElement.NO_BORDER;
			row.add( cell );
			table.add( row );
			
			table.border = RectangleElement.TOP;
			table.borderWidth = 1.5;
			
			table.borderColor = new RGBColor( 0x64, 0x65, 0x63 );
			
			return table;
		}
		
		/**
		 * Prepares data for pdf generation process
		 */
		protected function fromMxmlChildren(mxmlChildren:Array):void
		{
			var children:FlowElement;
			
			for (var i:int = 0; i < mxmlChildren.length; i++)
			{
				var obj:Object = mxmlChildren[i];
				children =obj as FlowElement;
				if (children is DivElement)
				{
					var divFormat:ITextLayoutFormat = children.computedFormat;
					fromMxmlChildren(DivElement(children).mxmlChildren)
				}
				else if (children is ParagraphElement)
				{
					var paragraphFormat:ITextLayoutFormat = children.computedFormat;
					
					initContainer();
					
					fromMxmlChildren(ParagraphElement(children).mxmlChildren);
					paragraph.leading = leading;
					
					paragraph.spacingBefore = parseInteger(paragraphFormat.paddingTop);
					paragraph.spacingAfter = parseInteger(paragraphFormat.paddingBottom);
					paragraph.indentationLeft = parseInteger(paragraphFormat.paddingLeft);
					paragraph.indentationRight = parseInteger(paragraphFormat.paddingRight);
					
					// not implemented in exeption
					paragraph.alignment = Element.ALIGN_LEFT
					addContainer();
				}
				else if (children is InlineGraphicElement)
				{
					var ige:InlineGraphicElement = children as InlineGraphicElement;
					var alignment:int;
					const _maxWidth:Number 	= 320;
					const _maxHeight:Number = 240;
					var image: ImageElement = ImageElement.getBitmapDataInstance( ige.source as BitmapData );
					var newWidth:Number = ige.width == "auto" ? Math.min(image.width, _maxWidth) : ige.width;
					var newHeight:Number = ige.height == "auto" ? Math.min(image.height, _maxHeight) : ige.height;
					image.scaleAbsolute(newWidth, newHeight);
					if(ige.float == Float.LEFT)
						alignment = ImageElement.LEFT;
					else if(ige.float == Float.RIGHT)
						alignment = ImageElement.RIGHT;
					if(ige.float == Float.NONE)
						alignment = ImageElement.MIDDLE;
					image.alignment = alignment;
					elements.push( image );
					
				}
				else if (children is FlowLeafElement)
				{
					var childText:String = FlowLeafElement(children).text;
					childText = childText.replace(/\u2028/ig, "\n");	// <br/> -> u2028 -> \n
					var spanFormat:ITextLayoutFormat = children.computedFormat;
					var pdfFontFamilyName:String = spanFormat.fontFamily;
					var font:Font = getFont(spanFormat);
					var backgroundColor:Number = getBackgroundColor(spanFormat);
					var lineHeightString:String = spanFormat.getStyle("initLineHeight");
					lineHeightString = lineHeightString ? lineHeightString+"%" : spanFormat.lineHeight;
					if (lineHeightString.indexOf("%")>0)
					{
						leading = Math.max(leading, font.getCalculatedLeading( parseInt(lineHeightString)/100 ));
					}
					else
					{
						leading =  Math.max(leading, parseInt(lineHeightString));
					}
					
					chunkBackground = RGBColor.fromARGB(backgroundColor)
					
					var parts:Array = splitText(childText);
					var len:int = parts.length
					for (var j:int = 0; j < len ; j++) 
					{
						childText = parts[j];
						var chunk:Chunk = new Chunk("", font);
						if (spanFormat.textAlpha==0)
							chunk.setTextRenderMode(PdfContentByte.TEXT_RENDER_MODE_INVISIBLE, PdfContentByte.TEXT_RENDER_MODE_STROKE, null);
						chunk.setBackground(chunkBackground);
						chunk.append(childText);
						
						var pdfChunk:PdfChunk;
						var errorString:String;
						
						try
						{
							pdfChunk = PdfChunk.fromChunk(chunk, null);
						}
						catch (e:Error)
						{
							errorString = "Unsupported:" + e.toString();
						}
						
						if (errorString)
						{
							trace(errorString);
							childText = errorString;
							chunk =  getErrorChunk(childText);
							errorParagraph.add(chunk);
							errors.push(errorParagraph);
							errorParagraph = new Paragraph("");
						}
						else
						{
							// put
							paragraph.leading = leading;
							paragraph.add(chunk);						
						}
						
						addContainer();
						initContainer();
					}
				}
			}
		}
		
		
		private function splitText(text:String):Array
		{
			var index:int = 0;
			var parts:Array = [];
			const LEN:int = text.length;
			
			do 
			{
				parts.push(text.substr(index, MAX_TEXT_LENGTH));
				index+=MAX_TEXT_LENGTH;
			} while(index, index<LEN);
			return parts;
		}
		
		private function addLongTextToParagraph(str:String, font:Font):Paragraph
		{
			var par:Paragraph = new Paragraph("");
			var parts:Array = splitText(str);
			var len:int = parts.length;
			var partStr:String;
			for (var i:int = 0; i < len ; i++) 
			{
				partStr = parts[i];
				var chunk:Chunk = new Chunk("", font);
				chunk.append(partStr);
				
				var pdfChunk:PdfChunk;
				var errorString:String;
				
				try
				{
					pdfChunk = PdfChunk.fromChunk(chunk, null);
				}
				catch (e:Error)
				{
					errorString = "Unsupported:" + e.toString();
				}
				
				if (errorString)
				{
					trace(errorString);
					partStr = errorString;
					chunk =  getErrorChunk(partStr);
					errorParagraph.add(chunk);
					errors.push(errorParagraph);
					errorParagraph = new Paragraph("");
				}
				else
				{
					// put
					par.leading = font.size * 1.2;
					par.add(chunk);
					par.add( new Chunk( "\n", font ) );
				}
			}
			return par;	
		}
		
		private function getErrorChunk(value:String):Chunk
		{
			defaultFont.style = 0;
			defaultFont.size = 12;
			
			return new Chunk(value, defaultFont);
		}
		
		private function getFont(spanFormat:ITextLayoutFormat):Font
		{
			var newStyle:int = 0;
			var fontWeight:String = spanFormat.fontWeight == FontWeight.BOLD?FontWeight.BOLD:"";
			var fontStyle:String = spanFormat.fontStyle == FontStyle.ITALIC?FontStyle.ITALIC:"";
			var font:Font = pdfFonts[spanFormat.fontFamily+fontWeight+fontStyle]||defaultFont;
			var fontSize:Number = spanFormat.getStyle("initFontSize");
			
			newStyle += String(spanFormat.fontWeight) == FontWeight.BOLD?Font.BOLD:0;
			newStyle += String(spanFormat.fontStyle) == FontStyle.ITALIC?Font.ITALIC:0;
			newStyle += String(spanFormat.textDecoration) == TextDecoration.UNDERLINE?Font.UNDERLINE:0;
			newStyle += spanFormat.lineThrough?Font.STRIKETHRU:0;
			font.style &= ~15;
			font.style |= newStyle;
			var color:Number = spanFormat.textAlpha == 0 ? 
				getBackgroundColor(spanFormat):
				spanFormat.color;
			
			font.color = RGBColor.fromARGB(color);
			fontSize = isNaN(fontSize) ? spanFormat.fontSize : fontSize;
			font.size = fontSize;
			return font;
		}
		
		private function getBackgroundColor(spanFormat:ITextLayoutFormat):Number
		{
			return spanFormat.backgroundColor==BackgroundColor.TRANSPARENT?0xFFFFFF:spanFormat.backgroundColor as int;
		}
		
		private function parseInteger(value:String, init:int = 0):int
		{
			var parseIntResult:Number = parseInt(value);
			return isNaN(parseIntResult) ? init: parseIntResult;
		}		
		
		private function startProcess():void
		{
			var richText:RichText = new RichText();
			if(isFontLoaded && isImagesLoaded && lesson)
			{
				var paragraph:Paragraph;
				headerText = lesson.name;
				createDocument(lesson.name, lesson.creator, lesson.creatorURL);
				addBookTitlePage()
				addAboutAuthorPages();
				addAboutLessonPages();
				startBodyElementIndex = elements.length - 1;
				for each(var item:ChapterVO in lesson.chapters)
				{
					if(item)
					{
						var titleFont:Font = defaultFont.clone() as Font;
						titleFont.size = 16;
						titleFont.style = 1;
						paragraph =  new Paragraph(item.title , titleFont);
						elements.push(paragraph);
						elements.push(Paragraph.fromChunk(Chunk.NEWLINE));
						richText.textFlow = InsertMediaUtil.createChapterFlowForPDF(item.text, item.images);
						if(richText.textFlow)
							fromMxmlChildren( richText.textFlow.mxmlChildren );
						
						elements.push(Paragraph.fromChunk( Chunk.NEWLINE));
						addChapterQuestionsPage(item.questions);
					}
				}
				addElementsToDocument();
			}
		}
		
		private function get resourceManager():IResourceManager
		{
			return ResourceManager.getInstance();
		}
		private function addBookTitlePage():void
		{
			var titlePageFont:Font = defaultFont.clone() as Font;
			titlePageFont.size = 22;
			titlePageFont.style = 1;
			if(lesson)
			{
				var ttuTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'ttuLabelText');
				var ttuParagraph:Paragraph =  addLongTextToParagraph(ttuTitle , titlePageFont);
				ttuParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(ttuParagraph);
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				var departmentTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'depatrmentTitleLabelText', [lesson.departmentName]);
				var departmentParagraph:Paragraph =  addLongTextToParagraph(departmentTitle , titlePageFont);
				departmentParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(departmentParagraph);
				
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				var specilaityTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'specialityTitleLabelText', [lesson.specialityName]);
				var specilaityParagraph:Paragraph =  addLongTextToParagraph(specilaityTitle , titlePageFont);
				specilaityParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(specilaityParagraph);
				
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				var disciplineTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'diciplineTitleLabelText', [lesson.discipline]);
				var disciplineParagraph:Paragraph =  addLongTextToParagraph(disciplineTitle , titlePageFont);
				disciplineParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(disciplineParagraph);
				
				
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				var bookNameFont:Font = defaultFont.clone() as Font;
				bookNameFont.size = 36;
				bookNameFont.style = 1;
				var titleParagraph:Paragraph =  new Paragraph(lesson.name , bookNameFont);
				titleParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(titleParagraph);
				
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				var dushanbeTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'dushanbeTitleLabelText', [new Date().fullYear]);
				var dushanbeParagraph:Paragraph =  new Paragraph(dushanbeTitle , titlePageFont);
				dushanbeParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(dushanbeParagraph);
			}
		}
		
		private function addChapterQuestionsPage(questions:IList):void
		{
			var questionsNameFont:Font = defaultFont.clone() as Font;
			questionsNameFont.size = 22;
			questionsNameFont.style = 1;
			if(lesson && questions && questions.length > 0)
			{
				var richText:RichText = new RichText();
				elements.push(Paragraph.fromChunk( Chunk.NEXTPAGE));
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				var questionTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'chapterQuestionsLabelText');
				var paragraph:Paragraph =  new Paragraph(questionTitle , questionsNameFont);
				paragraph.alignment = Element.ALIGN_CENTER;
				elements.push(paragraph);
				var i:int = 1;
				for each(var item:QuestionVo in questions)
				{
					elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
					richText.textFlow = InsertMediaUtil.createChapterFlowForPDF( i + ". " + item.text);
					if(richText.textFlow)
						fromMxmlChildren( richText.textFlow.mxmlChildren );
					i++;
				}
				elements.push(Paragraph.fromChunk( Chunk.NEXTPAGE));
			}
		}
		
		private function addAboutAuthorPages():void
		{
			var richText:RichText = new RichText();
			var tableOfContents:String = "";
			var count:int = 1;
			if(lesson)
			{
				var titlePageFont:Font = defaultFont.clone() as Font;
				titlePageFont.size = 22;
				titlePageFont.style = 1;
				
				var authorTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'aboutAuthorTitleLabelText');
				var authorParagraph:Paragraph =  new Paragraph(authorTitle , titlePageFont);
				authorParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(authorParagraph);
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				richText.textFlow = InsertMediaUtil.createChapterFlowForPDF(lesson.aboutCreator, lesson.aboutCreatorImages);
				if(richText.textFlow)
					fromMxmlChildren( richText.textFlow.mxmlChildren );
				elements.push(Paragraph.fromChunk( Chunk.NEXTPAGE));
			}
		}
		
		private function addAboutLessonPages():void
		{
			if(lesson)
			{
				var titlePageFont:Font = defaultFont.clone() as Font;
				titlePageFont.size = 22;
				titlePageFont.style = 1;
				
				var lessonTitle:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'aboutLessonTitleLabelText');
				var aboutLessonParagraph:Paragraph =  new Paragraph(lessonTitle , titlePageFont);
				aboutLessonParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(aboutLessonParagraph);
				elements.push( Paragraph.fromChunk( Chunk.NEWLINE));
				
				var descParagraph:Paragraph =  addLongTextToParagraph(lesson.description , defaultFont);
				descParagraph.alignment = Element.ALIGN_CENTER;
				elements.push(descParagraph);
				
				elements.push(Paragraph.fromChunk( Chunk.NEXTPAGE));
			}
		}
		
		private function prepareImages():void
		{
			if(lesson)
			{
				if(lesson.aboutCreatorImages)
					documentImages = documentImages.concat(lesson.aboutCreatorImages.toArray()); 
				for each(var item:ChapterVO in lesson.chapters)
				{
					if(item.images)
						documentImages = documentImages.concat( item.images.toArray());
				}
			}
			
			if(documentImages.length > 0)
			{
				loadImagesUtil = new LoadImagesUtil();
				loadImagesUtil.addEventListener(UtilEvent.IMAGES_LOADED_COMPLETE, onLoadedImages);
				loadImagesUtil.load( documentImages );
			}
			else
			{
				isImagesLoaded = true;
				startProcess();
			}
			
		}
		
		
		public function convertToPDF(lesson:LessonVO):void
		{
			this.lesson = lesson;
			prepareImages();
		}
		
		
		protected function addElementsToDocument():void
		{
			var loopCount:int = elements.length;
			for (var i:int = 0; i < loopCount; i++)
			{
				document.add(elements[i]);
			}
			
			closeDocument();
		}
		
		private function addHeaderText( text:String, pageNumber:int) : void
		{
			var paragraph:Paragraph;
			var headerTable:PdfPTable = new PdfPTable(2);
			headerTable.widthPercentage = 100;
			paragraph = new Paragraph( text, headerFont );
			
			var lessonNameCell:PdfPCell = new PdfPCell();
			lessonNameCell.phrase = paragraph;
			lessonNameCell.border = 0;
			lessonNameCell.borderWidth = 0;
			lessonNameCell.paddingBottom = 5;
			
			if( paragraph.leading != 0 )
				lessonNameCell.setLeading( paragraph.leading, 0 );
			headerTable.addCell( lessonNameCell );
			
			paragraph = new Paragraph( pageNumber.toString(), headerFont );
			var rowData1:PdfPCell = new PdfPCell();
			rowData1.phrase = paragraph;
			rowData1.border = 0;
			rowData1.borderWidth = 0;
			rowData1.paddingBottom = 5;
			rowData1.horizontalAlignment = 2;
			
			if( paragraph.leading != 0 )
				rowData1.setLeading( paragraph.leading, 0 );
			headerTable.addCell( rowData1 );
			
			document.add( headerTable );
		}
		/**
		 * 
		 * Set fonts for loading TTF fonts
		 * 
		 * @param <code>l1Code</code> First language code.
		 * @param <code>l2Code</code> Second language code.
		 * 
		 * @see com.transparent.pdf.utils.font.TTFFontManager
		 * @see com.transparent.utils.language.LanguageInfoManager
		 * 
		 */		
		public function setFonts():void
		{
			var fonts:Array = LanguageInfoUtil.getInstance().getFonts();
			var pdfFontsToLoad:Array = [];
			for each(var fontName:String in fonts)
			{
				pdfFontsToLoad.push('fonts/ttfForPdf/' + fontName + "TTF.swf");
			}
			
			isFontLoaded = false;
			fontLoader = new TTFFontManager();
			fontLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorEventHandler );
			fontLoader.addEventListener( Event.COMPLETE, onFontsLoadComplete );
			fontLoader.addEventListener( ProgressEvent.PROGRESS, onProgressEventHandler );
			fontLoader.load( pdfFontsToLoad );
		}
		
		/**
		 * 
		 * Handler for <code>PageEvent.PAGE_START</code> event dispatched by PdfDocument.
		 * 
		 * @param event The <code>PageEvent</code> event dispatched by PdfDocument.
		 * 
		 */			
		private function onStartPage( event:PageEvent ) : void
		{
			//addHeaderText( headerText, document.pageNumber );
			//document.add( line );
		}
		
		/**
		 * 
		 * Handler for <code>PageEvent.PAGE_END</code> event dispatched by PdfDocument.
		 * 
		 * @param event The <code>PageEvent</code> event dispatched by PdfDocument.
		 * 
		 */		
		private function onEndPage( event:PageEvent ) : void
		{
			var cb:PdfContentByte = writer.getDirectContent();
			//headerTbl.writeSelectedRows2( 0, -1, doc.left(), doc.top(), cb  );		
		}
		
		/**
		 * 
		 * Handler for <code>Event.COMPLETE</code> event dispatched by fontLoader.
		 * 
		 * @param event The <code>Event</code> event dispatched by fontLoader.
		 * 
		 */				
		private function onFontsLoadComplete( event:Event ) : void
		{
			fontLoader.removeEventListener( Event.COMPLETE, onFontsLoadComplete );
			fontLoader.removeEventListener( IOErrorEvent.IO_ERROR, onIOErrorEventHandler );
			fontLoader.removeEventListener( ProgressEvent.PROGRESS, onProgressEventHandler );
			var loadedFonts:Array = [];
			var fontsArray:Array = LanguageInfoUtil.getInstance().getFonts();
			for each(var fontName:String in fontsArray)
			{
				loadedFonts.push(fontLoader.getFont(fontName + "TTF"));
			}
			fonts = loadedFonts;
			isFontLoaded = true;
			startProcess();
		}
		
		/**
		 * 
		 * Handler for <code>IOErrorEvent.IO_ERROR</code> event dispatched by fontLoader and BykiListParser.
		 * 
		 * @param event The <code>IOErrorEvent</code> event dispatched by fontLoader and BykiListParser.
		 * 
		 */		
		private function onIOErrorEventHandler( event:IOErrorEvent ) : void
		{
			dispatchEvent( event.clone() );
		}
		/**
		 * 
		 * Handler for <code>ProgressEvent.PROGRESS</code> event dispatched by BykiListParser.
		 * 
		 * @param event The <code>ProgressEvent</code> event dispatched by BykiListParser.
		 * 
		 */		
		private function onProgressEventHandler( event:ProgressEvent ) : void
		{
			// TODO Auto-generated method stub
			var msg:String;
			if( event.target == fontLoader )
			{	
				msg = 'fontLoad';
			}
			else
			{	
				msg = 'listLoad';
			}
			
		}
		
		protected function onLoadedImages(event:UtilEvent):void
		{
			documentImages = event.data as Array;
			loadImagesUtil.removeEventListener(UtilEvent.IMAGES_LOADED_COMPLETE, onLoadedImages);
			loadImagesUtil = null;
			isImagesLoaded = true;
			startProcess();
		}
		
	}
}