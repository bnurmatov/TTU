////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 17, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import mx.collections.IList;
	
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.QuestionVo;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;
	
	/**
	 * LessonToXMLUtil class 
	 */
	public class LessonToXMLUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Default description
		 */
		public static const DEFAULT_DESCRIPTION:String = "Created By Tajik Technical University";
		
		/**
		 * Default creator
		 */
		public static const DEFAULT_CREATOR:String = "Copyright TTU";
		
		/**
		 * Default app creator name
		 */
		public static const DEFAULT_APP_CREATOR_NAME:String = "CourseCreatorAir";
		
		/**
		 * Default creator url
		 */
		public static const DEFAULT_CREATOR_URL:String = "http://www.ttu.tj";
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonToXMLUtil 
		 */
		public function LessonToXMLUtil()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  Public Static
		//--------------------------------------------------------------------------
		/**
		 * Convert a <code>LessonVO</code> object into XML, to be used for lesson.xml file in the .b4x
		 * container. Left as public, to allow xml generation outside of b4x converter.
		 * 
		 * @param lessonVo	The <code>LessonVO</code> object representing the lesson
		 * @return			The <code>XML</code> object created based on the lesson
		 */
		public static function generateLessonXml(lessonVo:LessonVO):XML
		{
			// create list node and set attributes
			var lesson:XML = new XML(<lesson  xmlns="http://www.ttu.tj/xml/Lesson/v1"/>);
			lesson.@uuid						= lessonVo.guid;
			lesson.@version						= lessonVo.version;
			
			// create and append 'head' and 'cards' nodes
			lesson.appendChild(generateHeadXml(lessonVo));
			lesson.appendChild(generateChaptersXml(lessonVo.chapters));
			lesson.appendChild(generateResourcesXml(lessonVo.resources));
			
			return lesson;
		}
		
		//--------------------------------------------------------------------------
		//  Private Static
		//--------------------------------------------------------------------------
		/**
		 * Generate and return the head XML of the lesson.
		 * 
		 * @param lessonVo	The <code>LessonVO</code> object representing the lesson
		 */
		private static function generateHeadXml(lessonVo:LessonVO):XML
		{
			// create head node
			var head:XML = new XML(<head/>);
			
			// set elements
			head.name 						= lessonVo.name								|| "";
			head.description 				= lessonVo.description						|| DEFAULT_DESCRIPTION;
			head.creator 					= lessonVo.creator							|| DEFAULT_CREATOR;
			head.creator_url 				= lessonVo.creatorURL						|| DEFAULT_CREATOR_URL;
			head.creator_application 		= lessonVo.appCreatorName					|| DEFAULT_APP_CREATOR_NAME;
			head.department 				= lessonVo.departmentId;
			head.speciality 				= lessonVo.specialityId;
			head.discipline 				= lessonVo.discipline;
			head.creation_date 				= lessonVo.creationDate	|| new Date();
			
			// add about creator info
			head.appendChild(generateAboutCreatorXml(lessonVo.aboutCreator, lessonVo.aboutCreatorImages));
			
			//add lesson sound
			if(lessonVo.sound)
			{
				// create sound node and set attributes
				var sound:XML = new XML(<sound/>);
				sound.@soundUrl  		= AssetsUtil.normalizeSoundPath(lessonVo.sound.soundUrl);
				sound.@location  		= lessonVo.sound.location;
				sound.@textPosition  	= lessonVo.sound.textPosition;
				sound.@paddingLeft  	= lessonVo.sound.paddingLeft;
				sound.@paddingRight  	= lessonVo.sound.paddingRight;
				sound.@paddingTop  		= lessonVo.sound.paddingTop;
				sound.@paddingBottom  	= lessonVo.sound.paddingBottom;
				
				head.appendChild(sound);
			}
			return head;
		}
		
		/**
		 * Generate XML for creator of a list.
		 * 
		 * @param aboutCreator		The <code>LearningModes</code> object representing all mode flags
		 * @return					The generated XML
		 */
		private static function generateAboutCreatorXml(aboutCreator:String, aboutCreatorImages:IList):XML
		{
			// create AboutCreator node
			var aboutCreatorXml:XML = new XML(<AboutCreator/>);
			
			aboutCreatorXml.author 				= aboutCreator;
			aboutCreatorXml.appendChild(generateImagesXml(aboutCreatorImages))
			
			return aboutCreatorXml;
		}
		
		private static function generateImagesXml(images:IList):XML
		{
			// create images node
			var imagesXml:XML = new XML(<images/>);
			for each(var imageVo:ImageVO in images)
			{
				// create image node and set attributes
				var image:XML = new XML(<image/>);
				
				image.@imageUrl  		= AssetsUtil.normalizeImagePath(imageVo.imageUrl);
				image.@width  	 		= imageVo.width;
				image.@height    		= imageVo.height;
				image.@location  		= imageVo.location;
				image.@textPosition  	= imageVo.textPosition;
				image.@paddingLeft  	= imageVo.paddingLeft;
				image.@paddingRight  	= imageVo.paddingRight;
				image.@paddingTop  		= imageVo.paddingTop;
				image.@paddingBottom  	= imageVo.paddingBottom;
				
				imagesXml.appendChild(image);
			}
			
			return imagesXml;
		}
		
		private static function generateVideoXml(videoList:IList):XML
		{
			// create VideoList node
			var videoXml:XML = new XML(<VideoList/>);
			for each(var videoVo:VideoVO in videoList)
			{
				// create image node and set attributes
				var video:XML = new XML(<video/>);
				
				video.@videoUrl  		= AssetsUtil.normalizeVideoPath(videoVo.videoUrl);
				video.@location  		= videoVo.location;
				video.@textPosition  	= videoVo.textPosition;
				video.@paddingLeft  	= videoVo.paddingLeft;
				video.@paddingRight  	= videoVo.paddingRight;
				video.@paddingTop  		= videoVo.paddingTop;
				video.@paddingBottom  	= videoVo.paddingBottom;
				
				videoXml.appendChild(video);
			}
			
			return videoXml;
		}
		
		private static function generateSoundsXml(sounds:IList):XML
		{
			// create sounds node
			var soundsXml:XML = new XML(<sounds/>);
			for each(var soundVO:SoundVO in sounds)
			{
				// create sound node and set attributes
				var sound:XML = new XML(<sound/>);
				
				sound.@soundUrl  		= AssetsUtil.normalizeSoundPath(soundVO.soundUrl);
				sound.@location  		= soundVO.location;
				sound.@textPosition  	= soundVO.textPosition;
				sound.@paddingLeft  	= soundVO.paddingLeft;
				sound.@paddingRight  	= soundVO.paddingRight;
				sound.@paddingTop  		= soundVO.paddingTop;
				sound.@paddingBottom  	= soundVO.paddingBottom;
				
				soundsXml.appendChild(sound);
			}
			
			return soundsXml;
		}
		
		private static function generateQuestionsXml(questions:IList):XML
		{
			// create questions node
			var questionsXml:XML = new XML(<questions/>);
			for each(var questionVo:QuestionVo in questions)
			{
				// create question node and set attributes
				var question:XML = new XML(<question/>);
				
				question.@uuid  			  = questionVo.guid;
				question.incorrectAnswerHint  = questionVo.incorrectAnswerHint;
				question.text  				  = questionVo.text;
				question.appendChild(generateAnswersXml(questionVo.answers));
				
				questionsXml.appendChild(question);
			}
			
			return questionsXml;
		}
		
		private static function generateAnswersXml(answers:IList):XML
		{
			// create answers node
			var answersXml:XML = new XML(<answers/>);
			for each(var answerVo:AnswerVo in answers)
			{
				// create answer node and set attributes
				var answer:XML = new XML(<answer/>);
				
				answer.@uuid  			= answerVo.guid;
				answer.position  		= answerVo.position;
				answer.text  			= answerVo.text;
				answer.isCorrect  		= answerVo.isCorrect;
				
				answersXml.appendChild(answer);
			}
			
			return answersXml;
		}
		/**
		 * Generate and return the chapters XML of the lesson. Currently the chapter version is hard-coded
		 * to zero, because the <code>ChapterVO</code> object does not have a version property.
		 * 
		 * @param chapters		An array of <code>ChapterVO</code> objects representing the chapters
		 */
		private static function generateChaptersXml(chapters:Array):XML
		{
			// create root node for chapters
			var chaptersXML:XML = new XML(<chapters/>);
			
			for each(var chapterVo:ChapterVO in chapters)
			{
				// create chapter node and set attributes
				var chapter:XML = new XML(<chapter/>);
				chapter.@uuid				= chapterVo.chapterUuid;
				chapter.@version			= 0;
				chapter.title 				= chapterVo.title;
				chapter.comment 			= chapterVo.comment;
				chapter.list_position 		= chapterVo.position;
				chapter.appendChild( new XML("<text><![CDATA["+ chapterVo.text +"}]]></text>"));
				
				chapter.appendChild(generateImagesXml(chapterVo.images));
				chapter.appendChild(generateSoundsXml(chapterVo.sounds));
				chapter.appendChild(generateVideoXml(chapterVo.videoList));
				chapter.appendChild(generateQuestionsXml(chapterVo.questions));
				
				chaptersXML.appendChild(chapter);
			}
			
			return chaptersXML;
		}
		
		/**
		 * Generate XML for resources. Appends <resource/> to the
		 * parent node, for each resource.
		 * 
		 * @param resources	   Array of resources to append
		 * @return 				Updated XML with resources included
		 */
		private static function generateResourcesXml(resources:Array):XML
		{
			// create root node for resources
			var resourcesXML:XML = new XML(<resources/>);
			
			for each(var resourceVo:ResourceVO in resources)
			{
				// create resource node and set attributes
				var resource:XML = new XML(<resource/>);
				resource.title				= resourceVo.title;
				resource.comment			= resourceVo.comment;
				resource.resouceType 		= resourceVo.resouceType;
				resource.resourcePath 		= AssetsUtil.normalizeResourcePath(resourceVo.resourcePath);
				resource.url 				= resourceVo.url;
				resource.list_position 		= resourceVo.position;
				
				resourcesXML.appendChild(resource);
			}
			
			return resourcesXML;
		}
		
		/**
		 * Set url attribute of an XML node. Checks that the url is valid, so we do 
		 * not create any empty url attribute strings.
		 * 
		 * @param node	The <code>XML</code> node to set the url attribute of
		 * @param url	The url to set the attribute to
		 * @return		The xml containing new attribute
		 */
		private static function appendUrlAttribute(node:XML, url:String):XML
		{
			if(url && url.length > 0)
				node.@url = url;
			
			return node;
		}
		
		/**
		 * Replace url from .mp3 to .ogg
		 * 
		 * @param soundUrl	The url to replace
		 * @return 			Replaced sound url
		 */		
		private static function replaceMp3ToOgg(soundUrl:String):String
		{
			return soundUrl ? soundUrl.replace(/\.mp3$/ig, ".ogg") : null;
		}
	}
}