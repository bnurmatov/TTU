////////////////////////////////////////////////////////////////////////////////
// Copyright May 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.purepdf.Font;
	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.HeaderFooter;
	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.Phrase;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.elements.SimpleCell;
	import org.purepdf.elements.SimpleTable;
	import org.purepdf.elements.images.ImageElement;
	import org.purepdf.events.PageEvent;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.PdfWriter;
	import org.purepdf.pdf.fonts.BaseFont;
	import org.purepdf.pdf.fonts.FontsResourceFactory;
	import org.purepdf.resources.BuiltinFonts;
	
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.font.TTFFontManager;
	import tj.ttu.base.utils.LanguageInfoUtil;
	
	/**
	 * 
	 * VocabularyBuilder class 
	 * 
	 * Create Vocabulary Table in PDF format.
	 * 
	 */
	public class VocabularyBuilder extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables : private
		//
		//--------------------------------------------------------------------------
		[Embed(source="/embed_assets/images/logo.png")]
		/**
		 * 
		 * The logo for PDF header.
		 *  
		 */		
		private var TTULogo:Class;
		
		/**
		 * 
		 * <code>pdf</code> Manipulation of the PDF document
		 * 
		 */		
		private var pdf:PdfWriter;
		
		/**
		 * 
		 * <code>buffer</code> Defines a buffering is PDF document.
		 * 
		 * @example The following code initializes PDF documents. 
		 * <listing version="3.0"> 
		 * PdfWriter.create( buffer, PageSize.A4 );
		 * </listing> 
		 * 
		 */ 		
		private var buffer:ByteArray;
		
		/**
		 * 
		 * <code>document</code> Defines a PDF document.
		 * 
		 * @example The following code get the document from <code>PdfWriter</code> 
		 * and <code>PdfReader</code> for your pdf document.:
		 * <listing version="3.0"> 
		 * document = pdf.pdfDocument;
		 * document.addEventListener( PageEvent.PAGE_END, onPageEventHandler );
		 * </listing> 
		 * 
		 */ 		
		private var document:PdfDocument;
		
		/**
		 * 
		 * <code>_l1Code</code> First language code.
		 * 
		 */ 
		private var _l1Code:String;
		
		/**
		 * 
		 * <code>_l2Code</code> Second language code.
		 * 
		 */ 
		private var _l2Code:String;
		
		/**
		 * 
		 * <code>l1Font</code>First font for first language code.
		 * 
		 */		
		private var l1Font:Font;
		
		/**
		 * 
		 * <code>l2Font</code>Second font for second language code.
		 * 
		 */		
		private var l2Font:Font;
		
		/**
		 * 
		 * <code>l1FontName</code>First font's name for the first loaded font.
		 * 
		 */		
		private var l1FontName:String;
		
		/**
		 * 
		 * <code>l2FontName</code>Second font's name for the second loaded font.
		 * 
		 */		
		private var l2FontName:String;
		

		/**
		 * 
		 * <code>footerText</code> Defines the text to the footer, the PDF document.
		 * 
		 * @default Copyright © ${year} Transparent Language Inc. - All rights reserved.
		 *
		 */  
		private var footerText:String = 'Copyright © ${year} Transparent Language Inc. - All rights reserved.';
		
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
		 * <code>isListLoaded</code> Flag for defining Byki lists is loaded. 
		 * 
		 * @default <code>false</code>
		 * 
		 */				
		private var isListLoaded:Boolean = false;
		
		/**
		 * 
		 * <code>isTransliterationShown</code> Flag to show the column 'Transliteration'. 
		 * 
		 * @default <code>false</code>
		 * 
		 */		
		//private var isTransliterationShown:Boolean = false;
		
		/**
		 * 
		 * <code>header</code> Header in PDF document. 
		 * 
		 */		
		private var header:HeaderFooter;
		
		/**
		 * 
		 * <code>header</code> Header text's PDF document. 
		 * 
		 */		
		private var headerText:String;
		
		/**
		 * 
		 * <code>headerTbl</code> logo at the header of a PDF document. 
		 * 
		 */		
		private var headerTbl:PdfPTable;
		
		/**
		 * 
		 * <code>headerFont</code> Header's Font. 
		 * 
		 */		
		private var headerFont:Font;
		
		/**
		 * 
		 * <code>headerTblFont</code> Font of the custom header. 
		 * 
		 */		
		private var headerTblFont:Font;
		
		/**
		 * 
		 * <code>line</code> line of the custom header. 
		 * 
		 */		
		private var line:SimpleTable;
		
		/**
		 * 
		 * <code>fontLoader</code> Manage loading and registering fonts in an application. 
		 * 
		 */		
		private var fontLoader:TTFFontManager;
		
		/**
		 * 
		 * <code>bykiLists</code> holding populated bykiLists. 
		 * 
		 */		
		private var lesson:LessonVO;
		
		/**
		 * 
		 * <code>header1Title</code> Header title of the first language. 
		 * 
		 */		
		private var header1Title:String;
		
		/**
		 * 
		 * <code>header2Title</code> Header title of the second language. 
		 * 
		 */		
		private var header2Title:String;		
		
		/**
		 * 
		 * <code>countCards</code> The total number of cards. 
		 * 
		 */				
		private var countChapters:uint = 0;
		
		/**
		 * 
		 * <code>generatedCard</code> The generated number of cards. 
		 * 
		 */				
		private var generatedChapter:uint = 0;
		
		/**
		 * 
		 * <code>isPageEmpty</code> Defines is page empty. 
		 * 
		 */				
		private var isPageEmpty:Boolean = true;
		
		/**
		 * 
		 * <code>lessonIndex</code> An integer value indicating whether index of a lesson. 
		 * 
		 */				
		private var lessonIndex:uint = 0;
		
		/**
		 * 
		 *  A reference to the object which manages
		 *  all of the application's localized resources.
		 *  This is a singleton instance which implements
		 *  the IResourceManager interface.
		 *
		 */   		
		private var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables : public
		//
		//--------------------------------------------------------------------------		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Constructor
		 * VocabularyBuilder
		 * Initializes PDF documents, loads font resources and organize PDF Template
		 *  
		 */
		public function VocabularyBuilder()
		{
			buffer = new ByteArray();
			
			pdf = PdfWriter.create( buffer, PageSize.A4 );
			
			document = pdf.pdfDocument;
			document.addEventListener( PageEvent.PAGE_END, onEndPage );
			document.addEventListener( PageEvent.PAGE_START, onStartPage );
			
			FontsResourceFactory.getInstance().registerFont( BaseFont.TIMES_ITALIC, new BuiltinFonts.TIMES_ITALIC() );
			FontsResourceFactory.getInstance().registerFont( BaseFont.HELVETICA, new BuiltinFonts.HELVETICA() );
			
			headerFont = new Font( Font.TIMES_ROMAN, 10, Font.ITALIC, new RGBColor(100, 100, 100) );
			headerTblFont = new Font( Font.HELVETICA, 14, Font.NORMAL, new RGBColor( 0xFF, 0xFF, 0xFF ) );
			
			addTemplate();
			
			headerTbl = new PdfPTable( 1 );
			
			headerTbl.totalWidth = 70;
			headerTbl.defaultCell.horizontalAlignment = Element.ALIGN_CENTER;
			headerTbl.defaultCell.border = RectangleElement.NO_BORDER;
			
			line = getLine();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Get created a PDF document.
		 * 
		 * @return Created PDF document.  
		 * 
		 */		
		public function createPDF() : ByteArray
		{
			document.close();
			
			return buffer;
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
		public function setFonts( l1Code:String, l2Code:String ) : void
		{
			var manager:LanguageInfoUtil = LanguageInfoUtil.getInstance();
			
			var tempL1FontName:String = manager.getFontByLanguageCode( l1Code );
			var tempLl2FontName:String = manager.getFontByLanguageCode( l2Code );
			l1FontName = tempL1FontName? tempL1FontName + "TTF": "LatinTTF";
			l2FontName = tempLl2FontName? tempLl2FontName + "TTF": "LatinTTF";
			
			isFontLoaded = false;
			fontLoader = new TTFFontManager();
			fontLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorEventHandler );
			fontLoader.addEventListener( Event.COMPLETE, onFontsLoadComplete );
			fontLoader.addEventListener( ProgressEvent.PROGRESS, onProgressEventHandler );
			fontLoader.load( [ 'fonts/' + l1FontName + '.swf', 'fonts/' + l2FontName + '.swf' ] );
			
			header1Title =  l1Code ; 
			header2Title =  l2Code ;
			
			_l1Code = l1Code;
			_l2Code = l2Code;
		}
		
		/**
		 * 
		 * Create a custom font from the given class
		 * 
		 * @param <code>cls</code> Loaded font class
		 * @param <code>fontName</code> Font name of the current loaded font
		 * @param <code>languageCode</code> Language code of the current font
		 * 
		 * @return Create a custom font
		 * 
		 * @see org.purepdf.Font
		 * @see org.purepdf.pdf.fonts.BaseFont
		 * @see org.purepdf.pdf.fonts.FontsResourceFactory
		 * @see com.transparent.utils.language.LanguageInfoManager
		 * 
		 */		
		private function createFont( cls:Class, fontName:String, languageCode:String ) : Font
		{
			if( cls && fontName && fontName != "" )
			{
				var sizeFont:uint = 12;
				var encoding:String = BaseFont.IDENTITY_H;
				var fontType:String = LanguageInfoUtil.getInstance().getFontByLanguageCode( languageCode );
				
				fontName += ".ttf";
				FontsResourceFactory.getInstance().registerFont( fontName, new cls() ); 			
				var bf:BaseFont = BaseFont.createFont( fontName, encoding, BaseFont.EMBEDDED );
				
				// trace info about font
				trace( 'Font: ' + bf.getFamilyFontName().join( ',' ) );
				trace( 'Encoding: ' + bf.encoding );
				
				return new Font( -1, sizeFont , -1, RGBColor.BLACK, bf );
			}
			return null;
		}
		
		/**
		 * 
		 * Create vocabular table, perform sorting and process pdf's header
		 * 
		 * @see com.transparent.pdf.utils.BykiCardSorter
		 * @see #createVocabularies()
		 * @see #addHeader()
		 * 
		 */		
		private function startProcess() : void
		{
			if( lesson )
			{	
				var _chapters:Array;
				
				generatedChapter = 0;
				
				if( !document.opened )
				{
					addHeader( lesson.name );
					
					document.open();
					headerTbl.addImageCell( createImage( TTULogo ) );
				}
				
				addHeader( lesson.name ); 
				_chapters = lesson.chapters;
				
				countChapters = _chapters.length;
				createVocabularies( _chapters, headerText );
				
			}
		}
		
		/**
		 * 
		 * Processing of the next card
		 * 
		 * @see com.transparent.pdf.utils.BykiCardSorter
		 * @see #createVocabularies()
		 * 
		 */				
		private function nextChapter() : void
		{
			if( countChapters == generatedChapter && buffer.length > 0 )
				dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 * 
		 * Create an image from embbeded class
		 * 
		 * @param <code>imageStream</code> Embbeded class
		 * 
		 * @return Created an image
		 * 
		 * @see flash.display.Bitmap
		 * @see org.purepdf.elements.images.ImageElement
		 * 
		 */ 
		private function createImage( imageStream:Class ) : ImageElement
		{
			var bmp:Bitmap = Bitmap( new imageStream() );
			var bitmap:BitmapData = bmp.bitmapData;
			var image:ImageElement;
			
			image = ImageElement.getBitmapDataInstance( bitmap );
			image.setAbsolutePosition( 0, 0 );
			
			return image;
		}
		
		/**
		 * 
		 * Set header and footer into a PDF document
		 * 
		 * @see #addFooter()
		 * @see #addHeader()
		 *
		 */		
		private function addTemplate() : void
		{
			var curDate:Date = new Date();
			
			footerText = footerText.replace( '${year}', curDate.getFullYear() );
			addFooter( footerText );
			addHeader( "" );
		}
		
		/**
		 * 
		 * Set footer into a PDF document
		 * 
		 * @param <code>text</code> Any available string.
		 * 
		 * @see org.purepdf.elements.HeaderFooter
		 *
		 */		
		private function addFooter( text:String ) : void
		{
			var footer:HeaderFooter = new HeaderFooter( new Phrase( text, headerFont ), 
				null , false );
			footer.alignment = Element.ALIGN_LEFT;
			footer.borderColor = new RGBColor( 100, 100, 100 );
			footer.border = RectangleElement.TOP;
			footer.borderWidth = 1;
			
			document.resetFooter();
			document.setFooter( footer );			
		}
		
		/**
		 * 
		 * Set header into a PDF document
		 * 
		 * @param <code>text</code> Any available string.
		 * 
		 * @see org.purepdf.elements.HeaderFooter
		 *
		 */		
		//		private function addHeader( text:String ) : void
		private function addHeader( lessonName:String ) : void
		{
			headerText = lessonName;
		}
		
		/**
		 * 
		 * Create a vocabularies in the table
		 * 
		 * @param <code>_cards</code> Reference BykiCards
		 * @param <code>_text</code> Header of the vocabulary table
		 * 
		 * @see #addHeaderTable()
		 * @see #addCell()
		 *
		 */
		private function createVocabularies( _chapters:Array, _text:String = null ) : void
		{
			if( _chapters && _chapters.length > 0 )
			{
				var phrase:Paragraph;
				var content:PdfContentByte = pdf.getDirectContent();			
				var table:PdfPTable;
				var chapter:ChapterVO;
				var sideOneHint:String = "cardSide1Hint";
				var sideTwoHint:String = "cardSide2Hint";
				var fontOne:Font = l1Font;
				var fontTwo:Font = l2Font;
				var hide1Hint:Boolean = true;
				var hide2Hint:Boolean = true;
				var isAnsiOne:Boolean = true;
				var isAnsiTwo:Boolean = true;
				var hideTranslit:Boolean = true;
				var countCol:uint = 2;
				//var hideTranslit:Boolean = !isTransliterationShown;
				//var countCol:uint = ( !isTransliterationShown ? 2 : 3 );
				var headerOneTitle:String = header1Title;
				var headerTwoTitle:String = header2Title;
				var cardTranslit:String; 
				var fontTranslit:Font;
				var onGenerateProcessHandler:Function;
				
				
				table = new PdfPTable( countCol );
				table.widthPercentage = 100;
				table.headerRows = 1;
				
				var hint:String 			= resourceManager.getString( "builder", "hint" ) || "Hint";
				var transliteration:String 	= resourceManager.getString( "builder", "transliteration" ) || "Transliteration";
				
				var i:uint = 0;
				onGenerateProcessHandler = function( event:Event ) : void
				{	
					if( i < _chapters.length )
					{
						generatedChapter++;
						
						//dispatchEvent( new VocabEvent( VocabEvent.PROGRESS, 'pdfGenerate', generatedChapter, countCards ) );
						
						chapter = _chapters[ i ] as ChapterVO;
						if( isEmpty( chapter.text ) || isEmpty( chapter.title ) )
						{
							i++;
							return;
						}
						
						phrase = new Paragraph( chapter.title, fontOne );
						addCell( table, phrase, i, false, phrase.leading, chapter.text );
						
						phrase = new Paragraph( chapter.title, fontTwo );
						addCell( table, phrase, i, false, phrase.leading, chapter.title );
						
						i++;
					}
					else
					{
						timerProcess.stop();
						timerProcess.removeEventListener( TimerEvent.TIMER, onGenerateProcessHandler );
						timerProcess = null;
						
						var currentPosition:Number = document.getVerticalPosition( false );
						
						if( currentPosition < 200 )	
						{
							document.newPage();
							isPageEmpty = true;
						}
						
						if( !isPageEmpty && _text != null )
						{
							addText( "\n\n" + _text, headerFont, isRTL( _text ) );
							//document.add( new Phrase( "\n\n" + _text, headerFont ) );
							document.add( line );
						}
						
						isPageEmpty = !document.add( table );
						
						nextChapter();
					}
				}
				
				var timerProcess:Timer = new Timer( 10 );
				timerProcess.addEventListener( TimerEvent.TIMER, onGenerateProcessHandler );
				timerProcess.start();
				
			}
			else
			{
				//isPageEmpty = true;
				nextChapter();
			}
		}
		
		/**
		 * 
		 * Create a header with data in the table
		 * 
		 * @param <code>table</code> Reference to the <code>PdfPTable</code> class. 
		 * @param <code>paragraph</code> Reference to the <code>Paragraph</code> class.
		 * 
		 * @see org.purepdf.elements.SimpleTable
		 * @see org.purepdf.elements.Paragraph
		 * @see org.purepdf.elements.SimpleCell
		 * @see org.purepdf.colors.RGBColor
		 *
		 */		
		private function addHeaderTable( table:PdfPTable, 
										 paragraph:Paragraph ) : void
		{
			var rowHeader:PdfPCell = new PdfPCell();
			
			paragraph.alignment = Element.ALIGN_CENTER;
			
			rowHeader.column.alignment = Element.ALIGN_CENTER;
			
			rowHeader.phrase = paragraph;
			rowHeader.border = RectangleElement.BOX;
			rowHeader.borderWidth = 0.3;
			rowHeader.paddingBottom = 5;
			rowHeader.backgroundColor = new RGBColor( 0x01, 0x4E, 0x82 ); //014e82
			table.addCell( rowHeader );
		}
		
		/**
		 * 
		 * Add a cell with data in the table
		 * 
		 * @param <code>table</code> Reference to the <code>PdfPTable</code> class.
		 * @param <code>paragraph</code> Reference to the <code>Paragraph</code> class.
		 * @param <code>rowIndex</code> An integer value indicating whether a sequence of fill the background rows.
		 * @param <code>isRTL</code> A bolean value indicating direction of learning langauge.
		 * 		<li>If it is <code>true</code> means that direction is right to left.</li> 
		 * 		<li>If it is <code>false</code> means that direction is left to right.</li>
		 * @param <code>leading</code>
		 * @param <code>text</code> Any available string.
		 * 
		 * @see org.purepdf.elements.SimpleTable
		 * @see org.purepdf.elements.Paragraph
		 * @see org.purepdf.elements.SimpleCell
		 * @see org.purepdf.colors.RGBColor
		 *
		 */			
		private function addCell( table:PdfPTable, 
								  paragraph:Paragraph,
								  rowIndex:int, 
								  isRTL:Boolean = false,
								  leading:Number = 0, text:String = null ) : void
		{
			var rowData:PdfPCell = new PdfPCell();
			var colorF:RGBColor = new RGBColor( 0xED, 0xF4, 0xFE ); //0xedf4fe
			var colorS:RGBColor = new RGBColor( 0xFF, 0xFF, 0xFF );
			
			rowData.phrase = paragraph;
			rowData.border = RectangleElement.BOX;
			rowData.borderWidth = 0.3;
			rowData.paddingBottom = 10;						
			rowData.paddingRight = 5;						
			rowData.paddingLeft = 5;						
			rowData.backgroundColor = ( rowIndex & 0x01 ? colorS : colorF );
			//rowData.verticalAlignment = Element.ALIGN_TOP;
			
			if( text != null && text.charCodeAt() == 0x0C56 )
			{
				rowData.paddingLeft = 12;						
			}
			if( leading != 0 )
				rowData.setLeading( leading, 0 );
			
			if( isRTL )
				rowData.runDirection = PdfWriter.RUN_DIRECTION_RTL;
			
			table.addCell( rowData );
		}
		
		private function addText( text:String, 
								  font:Font, 
								  isRTL:Boolean = false ) : void
		{
			var paragraph:Paragraph;
			var table:PdfPTable = new PdfPTable(1);
			table.widthPercentage = 100;
			paragraph = new Paragraph( text, font );
			
			var rowData:PdfPCell = new PdfPCell();
			rowData.phrase = paragraph;
			rowData.border = 0;
			rowData.borderWidth = 0;
			rowData.paddingBottom = 5;
			
			if( paragraph.leading != 0 )
				rowData.setLeading( paragraph.leading, 0 );
			
			if( isRTL )
				rowData.runDirection = PdfWriter.RUN_DIRECTION_RTL;
			
			table.addCell( rowData );
			
			document.add( table );
		}
		
		private function isRTL( text:String ) : Boolean
		{
			// Range: 0590-05FF Hebrew
			// Range: 0600-06FF Arabic
			
			if( text )
			{
				for( var i:uint = 0; i < text.length ; i++ )
				{
					if( ( text.charCodeAt( i ) >= 0x0600 && text.charCodeAt( i ) <= 0x06FF ) || 
						( text.charCodeAt( i ) >= 0x0590 && text.charCodeAt( i ) <= 0x05FF ) )
						return true;
				}
			}
			
			return false;
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
		 * 
		 * @param <code>value</code> Any available string.
		 * 
		 * @return An boolean value indicating whether the string is not empty or empty. 
		 *			<li>If the return value is <code>true</code>, <code>source</code> is empty.</li> 
		 *			<li>If the return value is <code>false</code>, <code>source</code> is not empty</code>.</li> 
		 * 
		 */			
		private function isEmpty( value:String ) : Boolean
		{
			value = TrimUtil.trim( value );
			
			if( value == null || value == '' )
				return true;
			
			return false;
		}
		
		private function isAnsi( value:String ) : Boolean
		{
			if( value )
			{
				for( var i:uint = 0; i < value.length; i++ )
				{
					var code:int = value.charCodeAt( i );
					
					if( !( code < 128 || 
						( code >= 160 && code <= 255 ) ) )
						return false;
				}
			}
			
			return true;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Handler for <code>PageEvent.PAGE_START</code> event dispatched by PdfDocument.
		 * 
		 * @param event The <code>PageEvent</code> event dispatched by PdfDocument.
		 * 
		 */			
		private function onStartPage( event:PageEvent ) : void
		{
			var header:String = 'السلام عليكم ورحمة الله وبركاته';
			
			addText( "\n\n" + headerText, headerFont, isRTL( headerText ) );
			document.add( line );		
			
			isPageEmpty = true;
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
			var cb:PdfContentByte = pdf.getDirectContent();
			headerTbl.writeSelectedRows2( 0, -1, document.left(), document.top() + 20, cb  );		
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
			
			//dispatchEvent( new VocabEvent( VocabEvent.PROGRESS, msg, event.bytesLoaded, event.bytesTotal ) );
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
			
			l1Font = createFont( fontLoader.getFont(l1FontName), l1FontName, _l1Code );
			l2Font = createFont( fontLoader.getFont(l2FontName), l2FontName, _l2Code );
			
			headerFont 		= l1Font.clone() as Font;
			headerTblFont 	= l1Font.clone() as Font;
			
			headerFont.size 	= 8;
			headerTblFont.size 	= 10;
			
			//headerFont.style 	= Font.ITALIC;
			//headerTblFont.style	= Font.NORMAL;
			
			headerFont.color 	= new RGBColor(100, 100, 100);
			headerTblFont.color	= new RGBColor( 0xFF, 0xFF, 0xFF );
			
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
	}
}