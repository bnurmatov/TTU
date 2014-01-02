////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package org.purepdf.resources
{
	/**
	 * TLBuiltinFontsTTF class 
	 */
	public class TLBuiltinFontsTTF
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
/*		//[Embed( source="ttf/tl/Abyssinica_SIL.ttf", mimeType="application/octet-stream" )]
		public static const AMHARIC:Class;
		
		[Embed( source="ttf/tl/TLArabic.ttf", mimeType="application/octet-stream" )]
		public static const ARABIC:Class;
		
		[Embed( source="ttf/tl/TLArabicBold.ttf", mimeType="application/octet-stream" )]
		public static const ARABIC_BOLD:Class;
		
		//[Embed( source="ttf/tl/Sylfaen.plusLatin.ttf", mimeType="application/octet-stream" )]
		public static const ARMENIAN:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const BAMBARA:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const BAMBARA_BOLD:Class;
		
		//[Embed( source="ttf/tl/TLBangla.ttf", mimeType="application/octet-stream" )]
		public static const BENGALI:Class;
		
		//[Embed( source="ttf/tl/HeiS.plusLatin.ttf", mimeType="application/octet-stream" )]
		public static const CHINESE:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const CYRILLIC:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const CYRILLIC_BOLD:Class;
		
		[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const ENGLISH:Class;
		
		[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const ENGLISH_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const FRENCH:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const FRENCH_BOLD:Class;
		
		//[Embed( source="ttf/tl/ariali.ttf", mimeType="application/octet-stream" )]
		public static const FRENCH_ITALIC:Class;
		
		//[Embed( source="ttf/tl/arialbi.ttf", mimeType="application/octet-stream" )]
		public static const FRENCH_BOLD_ITALIC:Class;
		
		//[Embed( source="ttf/tl/Sylfaen.plusLatin.ttf", mimeType="application/octet-stream" )]
		public static const GEORGIAN:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const GERMAN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const GERMAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const GREEK:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const GREEK_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const HEBREW:Class;
		
		//[Embed( source="ttf/tl/mangal.plusLatin.ttf", mimeType="application/octet-stream" )]
		public static const HINDI:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const ITALIAN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const ITALIAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/MSGOTHIC.ttf", mimeType="application/octet-stream" )]
		public static const JAPANESE:Class;
		
		//[Embed( source="ttf/tl/Dotum.plusLatin.ttf", mimeType="application/octet-stream" )]
		public static const KOREAN:Class;		
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const LATIN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const LATIN_BOLD:Class;
		
		//[Embed( source="ttf/tl/ariali.ttf", mimeType="application/octet-stream" )]
		public static const LATIN_ITALIC:Class;
		
		//[Embed( source="ttf/tl/arialbi.ttf", mimeType="application/octet-stream" )]
		public static const LATIN_BOLD_ITALIC:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const MONGOLIAN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const MONGOLIAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/arialw7.ttf", mimeType="application/octet-stream" )]
		public static const PASHTO:Class;
		
		//[Embed( source="ttf/tl/arialbdw7.ttf", mimeType="application/octet-stream" )]
		public static const PASHTO_BOLD:Class;
		
		//[Embed( source="ttf/tl/TLArabic.ttf", mimeType="application/octet-stream" )]
		public static const PERSIAN:Class;
		
		//[Embed( source="ttf/tl/TLArabicBold.ttf", mimeType="application/octet-stream" )]
		public static const PERSIAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const POLISH:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const POLISH_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const PORTUGUESE:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const PORTUGUESE_BOLD:Class;
		
		//[Embed( source="ttf/tl/lohit.punjabi.1.1.ttf", mimeType="application/octet-stream" )]
		public static const PUNJABI:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const ROMANIAN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const ROMANIAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const RUSSIAN:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const RUSSIAN_BOLD:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const SPANISH:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const SPANISH_BOLD:Class;
		
		//[Embed( source="ttf/tl/ariali.ttf", mimeType="application/octet-stream" )]
		public static const SPANISH_ITALIC:Class;
		
		//[Embed( source="ttf/tl/arialbi.ttf", mimeType="application/octet-stream" )]
		public static const SPANISH_BOLD_ITALIC:Class;
		
		//[Embed( source="ttf/tl/micross.ttf", mimeType="application/octet-stream" )]
		public static const TAGALOG:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const TAGALOG_BOLD:Class;
		
		//[Embed( source="ttf/tl/akshar.ttf", mimeType="application/octet-stream" )]
		public static const TELUGU:Class;
		
		//[Embed( source="ttf/tl/micross.ttf", mimeType="application/octet-stream" )]
		public static const THAI:Class;
		
		//[Embed( source="ttf/tl/TLThaiBold.ttf", mimeType="application/octet-stream" )]
		public static const THAI_BOLD:Class;
		
		//[Embed( source="ttf/tl/Jomolhari.ttf", mimeType="application/octet-stream" )]
		public static const TIBETAN:Class;
		
		//[Embed( source="ttf/tl/ARIAL.ttf", mimeType="application/octet-stream" )]
		public static const TURKISH:Class;
		
		//[Embed( source="ttf/tl/ARIALBD.ttf", mimeType="application/octet-stream" )]
		public static const TURKISH_BOLD:Class;
		
		//[Embed( source="ttf/tl/TLUrdu.ttf", mimeType="application/octet-stream" )]
		public static const URDU:Class;
		
		//[Embed( source="ttf/tl/TLUrduBold.ttf", mimeType="application/octet-stream" )]
		public static const URDU_BOLD:Class;
*/		
	}
}