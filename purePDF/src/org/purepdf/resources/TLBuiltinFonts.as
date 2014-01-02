////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package org.purepdf.resources
{
	/**
	 * BuiltinFonts class 
	 */
	public class TLBuiltinFonts
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
/*		[Embed( source="afm/tl/Abyssinica_SIL.afm", mimeType="application/octet-stream" )]
		public static const AMHARIC:Class;
		
		[Embed( source="afm/tl/TLArabic.afm", mimeType="application/octet-stream" )]
		public static const ARABIC:Class;
		
		[Embed( source="afm/tl/TLArabicBold.afm", mimeType="application/octet-stream" )]
		public static const ARABIC_BOLD:Class;
		
		[Embed( source="afm/tl/Sylfaen.plusLatin.afm", mimeType="application/octet-stream" )]
		public static const ARMENIAN:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const BAMBARA:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const BAMBARA_BOLD:Class;
		
		[Embed( source="afm/tl/TLBangla.afm", mimeType="application/octet-stream" )]
		public static const BENGALI:Class;
		
		[Embed( source="afm/tl/HeiS.plusLatin.afm", mimeType="application/octet-stream" )]
		public static const CHINESE:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const CYRILLIC:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const CYRILLIC_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const ENGLISH:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const ENGLISH_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const FRENCH:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const FRENCH_BOLD:Class;
		
		[Embed( source="afm/tl/ariali.afm", mimeType="application/octet-stream" )]
		public static const FRENCH_ITALIC:Class;
		
		[Embed( source="afm/tl/arialbi.afm", mimeType="application/octet-stream" )]
		public static const FRENCH_BOLD_ITALIC:Class;
		
		[Embed( source="afm/tl/Sylfaen.plusLatin.afm", mimeType="application/octet-stream" )]
		public static const GEORGIAN:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const GERMAN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const GERMAN_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const GREEK:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const GREEK_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const HEBREW:Class;
		
		[Embed( source="afm/tl/mangal.plusLatin.afm", mimeType="application/octet-stream" )]
		public static const HINDI:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const ITALIAN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const ITALIAN_BOLD:Class;
		
		[Embed( source="afm/tl/MSGOTHIC.afm", mimeType="application/octet-stream" )]
		public static const JAPANESE:Class;
		
		[Embed( source="afm/tl/Dotum.plusLatin.afm", mimeType="application/octet-stream" )]
		public static const KOREAN:Class;		
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const LATIN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const LATIN_BOLD:Class;
		
		[Embed( source="afm/tl/ariali.afm", mimeType="application/octet-stream" )]
		public static const LATIN_ITALIC:Class;
		
		[Embed( source="afm/tl/arialbi.afm", mimeType="application/octet-stream" )]
		public static const LATIN_BOLD_ITALIC:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const MONGOLIAN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const MONGOLIAN_BOLD:Class;
		
		[Embed( source="afm/tl/arialw7.afm", mimeType="application/octet-stream" )]
		public static const PASHTO:Class;
		
		[Embed( source="afm/tl/arialbdw7.afm", mimeType="application/octet-stream" )]
		public static const PASHTO_BOLD:Class;
		
		[Embed( source="afm/tl/TLArabic.afm", mimeType="application/octet-stream" )]
		public static const PERSIAN:Class;
		
		[Embed( source="afm/tl/TLArabicBold.afm", mimeType="application/octet-stream" )]
		public static const PERSIAN_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const POLISH:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const POLISH_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const PORTUGUESE:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const PORTUGUESE_BOLD:Class;
		
		[Embed( source="afm/tl/lohit.punjabi.1.1.afm", mimeType="application/octet-stream" )]
		public static const PUNJABI:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const ROMANIAN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const ROMANIAN_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const RUSSIAN:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const RUSSIAN_BOLD:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const SPANISH:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const SPANISH_BOLD:Class;
		
		[Embed( source="afm/tl/ariali.afm", mimeType="application/octet-stream" )]
		public static const SPANISH_ITALIC:Class;
		
		[Embed( source="afm/tl/arialbi.afm", mimeType="application/octet-stream" )]
		public static const SPANISH_BOLD_ITALIC:Class;
		
		[Embed( source="afm/tl/micross.afm", mimeType="application/octet-stream" )]
		public static const TAGALOG:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const TAGALOG_BOLD:Class;
		
		[Embed( source="afm/tl/akshar.afm", mimeType="application/octet-stream" )]
		public static const TELUGU:Class;
		
		[Embed( source="afm/tl/micross.afm", mimeType="application/octet-stream" )]
		public static const THAI:Class;
		
		[Embed( source="afm/tl/TLThaiBold.afm", mimeType="application/octet-stream" )]
		public static const THAI_BOLD:Class;
		
		[Embed( source="afm/tl/Jomolhari.afm", mimeType="application/octet-stream" )]
		public static const TIBETAN:Class;
		
		[Embed( source="afm/tl/ARIAL.afm", mimeType="application/octet-stream" )]
		public static const TURKISH:Class;
		
		[Embed( source="afm/tl/ARIALBD.afm", mimeType="application/octet-stream" )]
		public static const TURKISH_BOLD:Class;
		
		[Embed( source="afm/tl/TLUrdu.afm", mimeType="application/octet-stream" )]
		public static const URDU:Class;
		
		[Embed( source="afm/tl/TLUrduBold.afm", mimeType="application/octet-stream" )]
		public static const URDU_BOLD:Class;
*/		
	}
}