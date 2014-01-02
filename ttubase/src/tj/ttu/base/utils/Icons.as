////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 17, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	[Bindable]
	/**
	 * Icon class 
	 */
	public class Icons
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
		/**
		 *  Icons used in unit  browser list. We are embedding them, 
		 *  because loading them each time is very slow
		 */ 
		
		// icon image for tajiki flag
		[Embed("/embed_assets/icons/tajikistan_flag_icon.png", mimeType="image/png")]
		private static var TajikistanFlagIcon:Class;
		
		
		// icon image for russian flag
		[Embed("/embed_assets/icons/russia_flag_icon.png", mimeType="image/png")]
		private static var RussianFlagIcon:Class;
		
		
		// icon image for tajiki flag
		[Embed("/embed_assets/icons/usa_flag_icon.png", mimeType="image/png")]
		private static var USAFlagIcon:Class;
		
		// icon image for Play audio button
		[Embed("/embed_assets/icons/pause_upIcon.png", mimeType="image/png")]
		public static var PlayAudioIcon:Class;
		
		
		// icon image for Pause audio button
		[Embed("/embed_assets/icons/pause_upIcon.png", mimeType="image/png")]
		public static var PauseAudioIcon:Class;
		
		// icon image for Pause audio button
		[Embed("/embed_assets/images/mic_up.png", mimeType="image/png")]
		public static var RecordSoundIcon:Class;
		
		// icon image for Pause audio button
		[Embed("/embed_assets/images/audio_upload_icon.jpg", mimeType="image/jpg")]
		public static var UploadSoundIcon:Class;
		
		// icon image for Pause audio button
		[Embed("/embed_assets/images/insert_image_icon_up.png", mimeType="image/png")]
		public static var UploadImageIcon:Class;
		
		// icon image for upload video button
		[Embed("/embed_assets/icons/add_movie_icon.png", mimeType="image/png")]
		public static var UploadVideoIcon:Class;
		
		// icon image for assessment
		[Embed("/embed_assets/icons/AssessmentIcon.png", mimeType="image/png")]
		private static var AssessmentIcon:Class;
		
		// icon image for Resources
		[Embed("/embed_assets/icons/CultureIcon.png", mimeType="image/png")]
		private static var ResourcesIcon:Class;
		
		// icon image for ChapterPlayer
		[Embed("/embed_assets/icons/ReadingIcon.png", mimeType="image/png")]
		private static var ChapterPlayerIcon:Class;
		
		// icon image for pdf
		[Embed("/embed_assets/icons/pdf_icon.png", mimeType="image/png")]
		public static var PdfIcon:Class;
		
		// icon image for internet resource
		[Embed("/embed_assets/icons/inet_resource_icon.png", mimeType="image/png")]
		public static var InternetResourceIcon:Class;
		
		// icon image for zip
		[Embed("/embed_assets/icons/zip_icon.png", mimeType="image/png")]
		public static var ZipIcon:Class;
		
		// icon image for dvd
		[Embed("/embed_assets/icons/dvd_icon.png", mimeType="image/png")]
		public static var DvdIcon:Class;
		
		// icon image for dvd
		[Embed("/embed_assets/icons/installer_icon.png", mimeType="image/png")]
		public static var InstallerIcon:Class;
		
		/**
		 * @private
		 * An xml object containing activity attributes and icon class names
		 */
		private static var icons:XML = <items>
			<item key="Tajiki" >TajikistanFlagIcon</item>
			<item key="Russian" >RussianFlagIcon</item>
			<item key="English">USAFlagIcon</item>
			<item key="Assessment" 			colors="0x920abf,0xcb92de">AssessmentIcon</item>
			<item key="ChapterPlayer" 		colors="0xBF0A92,0xDE92CB">ChapterPlayerIcon</item>
			<item key="Resources" 			colors="0xBF0A92,0xDE92CB">ResourcesIcon</item>

		</items>
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * Icon 
		 */
		public function Icons()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
		
		//---------------------------------------------------------
		// Methods : static
		//---------------------------------------------------------
		/**
		 * Gets embedded icon for an activity by given key
		 * @param key e.g. "Reading"
		 * @return The class for icon if it exists or <code>null</code>
		 */ 	
		public static function getIcon(key:String):Object
		{
			
			var xml:XML = getXMLByKey(key);
			if(xml)
			{
				var cls:Class = Icons[xml.text()] as Class
				if(cls)
					return cls;
				return null;
				
			}
			else
				return null;
		}
		
		/**
		 * Gets colors assosiated with an activity by given key
		 * @param key e.g. "Reading"
		 * @return The name of colors for activity background if they exist or empty string
		 */ 	
		public static function getColors(key:String):Array
		{
			if(!key)
				return [];
			
			var xml:XML = getXMLByKey(key);
			if(xml)
			{
				return String(xml.@colors).split(",");
			}
			else
				return [];
		}
		
		/**
		 * @private
		 * Gets xml children by given key
		 * @param key e.g: "Assessment"
		 * @return Item with required key or <code>null</code> if suchn an item is not found 
		 */ 	
		private static function getXMLByKey(key:String):XML
		{
			var pat:RegExp = /(REP)$/;
			key = key.replace(pat, '');
			var item:XML;
			try
			{
				item = XML(icons.item.(attribute("key") == key));
			}
			catch(e:TypeError)
			{
			}
			return item;
		}
		
	}
}