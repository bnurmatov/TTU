////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import mx.collections.ArrayCollection;
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
	 * XMLToLessonUtil class 
	 */
	public class XMLToLessonUtil
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
		public var lesson:LessonVO;
		private var path:String ="";
		private var xsi:Namespace;
		namespace xsi = "http://www.w3.org/2001/XMLSchema-instance"; 
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * XMLToLessonUtil 
		 */
		public function XMLToLessonUtil()
		{
			super();
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;
			XML.prettyPrinting = true;
		}
		
		
		public var errorString:String="";
		
		/**
		 * Event handler method for Stream read complete event.
		 * This method would take over from the parseB4X, to initiate parsing the 
		 * bytes that were read from the B4X file resource.
		 * 
		 * This method calls the B4XStream class parseStream method to parse the bytes 
		 */ 
		public function createLesson(xml:XML, rootPath:String=null):void 
		{
			var bns:Namespace = xml.namespace();
			if(bns.uri.length  > 0)
			{
				var xmlString:String = xml.toXMLString();
				var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
				xmlString = xmlString.replace(xmlnsPattern, "");
				xml = new XML(xmlString);
			}
			errorString = "";
			if(rootPath)
				path = rootPath;
			
			
			try
			{
				lesson = new LessonVO();
				var head:XML = XML(xml.head);
				var aboutAuthor:XML = XML(head.AboutCreator);
				lesson.name 						= TrimUtil.trim(head.name.toString());
				lesson.description 					= TrimUtil.trim(head.description.toString());
				lesson.creator 						= TrimUtil.trim(head.creator.toString());
				lesson.creatorURL 					= TrimUtil.trim(head.creator_url.toString());
				lesson.appCreatorName 				= TrimUtil.trim(head.creator_application.toString());
				lesson.departmentId 				= int(TrimUtil.trim(head.department.toString()));
				lesson.specialityId 				= int(TrimUtil.trim(head.speciality.toString()));
				lesson.discipline 					= TrimUtil.trim(head.discipline.toString());
				lesson.creationDate 				= stringToDate(head.creation_date);
				lesson.aboutCreator	 				= TrimUtil.trim(aboutAuthor.author.toString());
				lesson.aboutCreatorImages 			= parseImages(aboutAuthor.images.children());
				lesson.sound	 					= parseSound(XML(head.sound));
				lesson.chapters						= parseChapters( xml.chapters.children());
				lesson.resources					= parseResources( xml.resources.children());
			}
			catch(e:Error)
			{
				errorString = e.message;
			}
			
			
		}
		
		/**
		 * @private
		 * 
		 * Parses images properties
		 */ 
		private function parseImages(images:XMLList):IList 
		{
			var imageList:IList = new ArrayCollection();
			var image:ImageVO;
			var len:int = images.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(images[i]);
				if(item)
				{
					image 					= new ImageVO();
					image.imageUrl 			= path + TrimUtil.trim( item.@imageUrl.toString());
					image.width 			= TrimUtil.trim( item.@width.toString());
					image.height 			= TrimUtil.trim( item.@height.toString());
					image.location 			= TrimUtil.trim( item.@location.toString());
					image.textPosition 		= int(TrimUtil.trim( item.@textPosition.toString()));
					image.paddingLeft 		= Number(TrimUtil.trim( item.@paddingLeft.toString()));
					image.paddingRight	 	= Number(TrimUtil.trim( item.@paddingRight.toString()));
					image.paddingTop 		= Number(TrimUtil.trim( item.@paddingTop.toString()));
					image.paddingBottom 	= Number(TrimUtil.trim( item.@paddingBottom.toString()));
					imageList.addItem( image );
				}
			}
			return imageList;
		}
		/**
		 * @private
		 * 
		 * Parses images properties
		 */ 
		private function parseVideos(videos:XMLList):IList 
		{
			var videoList:IList = new ArrayCollection();
			var video:VideoVO;
			var len:int = videos.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(videos[i]);
				if(item)
				{
					video 					= new VideoVO();
					video.videoUrl 			= path + TrimUtil.trim( item.@videoUrl.toString());
					video.location 			= TrimUtil.trim( item.@location.toString());
					video.textPosition 		= int(TrimUtil.trim( item.@textPosition.toString()));
					video.paddingLeft 		= Number(TrimUtil.trim( item.@paddingLeft.toString()));
					video.paddingRight	 	= Number(TrimUtil.trim( item.@paddingRight.toString()));
					video.paddingTop 		= Number(TrimUtil.trim( item.@paddingTop.toString()));
					video.paddingBottom 	= Number(TrimUtil.trim( item.@paddingBottom.toString()));
					videoList.addItem( video );
				}
			}
			return videoList;
		}
		
		/**
		 * @private
		 * 
		 * Parses sounds properties
		 */ 
		private function parseSounds(sounds:XMLList):IList 
		{
			var soundList:IList = new ArrayCollection();
			var len:int = sounds.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(sounds[i]);
				if(item)
					soundList.addItem( parseSound(item) );
			}
			return soundList;
		}
		
		
		/**
		 * @private
		 * 
		 * Parses sounds properties
		 */ 
		private function parseSound(sound:XML):SoundVO 
		{
			var soundVo:SoundVO;
			if(sound)
			{
				soundVo 					= new SoundVO();
				soundVo.soundUrl 			= path + TrimUtil.trim( sound.@soundUrl.toString());
				soundVo.location 			= TrimUtil.trim( sound.@location.toString());
				soundVo.textPosition 		= int(TrimUtil.trim( sound.@textPosition.toString()));
				soundVo.paddingLeft 		= Number(TrimUtil.trim( sound.@paddingLeft.toString()));
				soundVo.paddingRight	 	= Number(TrimUtil.trim( sound.@paddingRight.toString()));
				soundVo.paddingTop 			= Number(TrimUtil.trim( sound.@paddingTop.toString()));
				soundVo.paddingBottom 		= Number(TrimUtil.trim( sound.@paddingBottom.toString()));
			}
			return soundVo;
		}
		
		/**
		 * @private
		 * 
		 * Parses images properties
		 */ 
		private function parseResources(resources:XMLList):Array 
		{
			var resourceList:Array = new Array();
			var resource:ResourceVO;
			var len:int = resources.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(resources[i]);
				if(item)
				{
					resource 					= new ResourceVO();
					resource.title 				= TrimUtil.trim( item.title.toString());
					resource.comment 			= TrimUtil.trim( item.comment.toString());
					resource.resouceType 		= TrimUtil.trim( item.resouceType.toString());
					resource.resourcePath 		= TrimUtil.trim( item.resourcePath.toString());
					resource.resourcePath 		= !StringUtil.isNullOrEmpty(resource.resourcePath) ? path + resource.resourcePath : null;
					resource.url	 			= TrimUtil.trim( item.url.toString());
					resource.position 			= int(TrimUtil.trim( item.list_position.toString()));
					resourceList.push( resource );
				}
			}
			return resourceList;
		}
		/**
		 * @private
		 * 
		 * Parses question properties
		 */ 
		private function parseQuestions(questions:XMLList):IList 
		{
			var questionList:IList = new ArrayCollection();
			var question:QuestionVo;
			var len:int = questions.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(questions[i]);
				if(item)
				{
					question 						= new QuestionVo();
					question.text 					= TrimUtil.trim( item.text.toString());
					question.incorrectAnswerHint 	= TrimUtil.trim( item.incorrectAnswerHint.toString());
					question.answers 				= parseAnswers( item.answers.children());
					questionList.addItem( question );
				}
			}
			return questionList;
		}
		/**
		 * @private
		 * 
		 * Parses answer properties
		 */ 
		private function parseAnswers(answers:XMLList):IList 
		{
			var answerList:IList = new ArrayCollection();
			var answer:AnswerVo;
			var len:int = answers.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(answers[i]);
				if(item)
				{
					answer 						= new AnswerVo();
					answer.text 				= TrimUtil.trim( item.text.toString());
					answer.isCorrect 			= item.isCorrect == "true"?true:false;;
					answer.position 			= uint(TrimUtil.trim( item.position));
					answerList.addItem( answer );
				}
			}
			return answerList;
		}
		/**
		 * @private
		 * 
		 * Parses chapters  properties
		 */
		private function parseChapters(chapters:XMLList):Array 
		{ 
			var parsedChapters:Array = new Array();
			var len:int = chapters.length();
			for (var i:int =0; i < len; i++)
			{
				var item:XML = XML(chapters[i]);
				if(item)
					parsedChapters.push(parseChapter(item));
			}
			return parsedChapters;
		}
		
		/**
		 * @private
		 * 
		 * Parses ChapterVO  properties
		 * 
		 */
		private function parseChapter(chapter:XML):ChapterVO 
		{ 
			//We never can be sure that our strings do not have whitespaces, therefore we should clean them
			var chapterVO:ChapterVO = new ChapterVO();
			chapterVO.text = removeCDATATag(TrimUtil.trim( chapter.text.toString()));
			chapterVO.title = TrimUtil.trim( chapter.title.toString());
			chapterVO.comment = TrimUtil.trim( chapter.comment.toString());
			chapterVO.position = int(TrimUtil.trim( chapter.list_position.toString()));
			chapterVO.images = parseImages( chapter.images.children());
			chapterVO.sounds = parseSounds( chapter.sounds.children());
			chapterVO.videoList = parseVideos( chapter.VideoList.children());
			chapterVO.questions = parseQuestions( chapter.questions.children());
			
			
			return chapterVO;
		}
		
		private function removeCDATATag(str:String):String
		{
			if(!str)
				return null;
			str = str.replace("<![CDATA[", "");
			str = str.replace("]]>", "");
			return str;
		}
		
		/**
		 * temp method til I find my util 
		 * @return Date object from string
		 * 
		 */		
		private function stringToDate(str:String):Date
		{
			var arr1:Array = str.split("T")[0].split("-");
			var arr2:Array = str.split("T")[1].split(":");
			if(arr1.length != 3 ||arr2.length != 3)
				return new Date();
			
			return new Date(arr1[0],arr1[1]-1,arr1[2],arr2[0],arr2[1],arr2[2]); 
		}
	}
}