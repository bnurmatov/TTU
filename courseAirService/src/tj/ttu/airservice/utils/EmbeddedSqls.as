////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 21, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	/**
	 * EmbeddedSqls class 
	 */
	public class EmbeddedSqls
	{
		
		//--------------------------------------------------------------------------
		//
		//  Schema Tables
		//
		//--------------------------------------------------------------------------
		[Embed (source="/embed_assets/sql/schema/tbl_Lessons.sql", mimeType = 'application/octet-stream')]
		public static const Lessons:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_User_Lessons.sql", mimeType = 'application/octet-stream')]
		public static const UserLessons:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Users.sql", mimeType = 'application/octet-stream')]
		public static const Users:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Spec.sql", mimeType = 'application/octet-stream')]
		public static const Spec:Class;
		
		[Embed (source="/embed_assets/sql/data/specialities.sql", mimeType = 'application/octet-stream')]
		public static const SpecData:Class;
		
		[Embed (source="/embed_assets/sql/schema/tblSpr_Kafedra.sql", mimeType = 'application/octet-stream')]
		public static const Kaferdra:Class;
		
		[Embed (source="/embed_assets/sql/data/kafedra.sql", mimeType = 'application/octet-stream')]
		public static const KaferdraData:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Images.sql", mimeType = 'application/octet-stream')]
		public static const Images:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Sounds.sql", mimeType = 'application/octet-stream')]
		public static const Sounds:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Video.sql", mimeType = 'application/octet-stream')]
		public static const Video:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Chapters.sql", mimeType = 'application/octet-stream')]
		public static const Chapters:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Questions.sql", mimeType = 'application/octet-stream')]
		public static const Questions:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Answers.sql", mimeType = 'application/octet-stream')]
		public static const Answers:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Artifacts.sql", mimeType = 'application/octet-stream')]
		public static const Artifacts:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_Resources.sql", mimeType = 'application/octet-stream')]
		public static const Resources:Class;
		
		[Embed (source="/embed_assets/sql/schema/tbl_UserSettings.sql", mimeType = 'application/octet-stream')]
		public static const UserSettings:Class;
		
		//-----------------------------------------------
		//  Triggers
		//-----------------------------------------------
		[Embed (source="/embed_assets/sql/schema/triggers/tbl_Users_inserttrigger.sql", mimeType = 'application/octet-stream')]
		public static const UsersInsertTrigger:Class;
		
		[Embed (source="/embed_assets/sql/schema/triggers/tbl_Lesson_deletetrigger.sql", mimeType = 'application/octet-stream')]
		public static const LessonsDeleteTrigger:Class;
		
		[Embed (source="/embed_assets/sql/schema/triggers/tbl_Chapters_deletetrigger.sql", mimeType = 'application/octet-stream')]
		public static const ChaptersDeleteTrigger:Class;
		
		[Embed (source="/embed_assets/sql/schema/triggers/tbl_Questions_deletetrigger.sql", mimeType = 'application/octet-stream')]
		public static const QuestionsDeleteTrigger:Class;
		
	}
}