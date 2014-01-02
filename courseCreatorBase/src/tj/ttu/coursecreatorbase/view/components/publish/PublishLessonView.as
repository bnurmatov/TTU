////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 27, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.publish
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.List;
	
	import tj.ttu.base.vo.PublishOptionVO;
	import tj.ttu.components.events.PublishEvent;
	import tj.ttu.coursecreatorbase.view.components.create.BaseCreateCourseView;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	/**
	 * PublishLessonView class 
	 */
	public class PublishLessonView extends BaseCreateCourseView
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var preview:Button;
		
		[SkinPart(required="true")]
		public var publishButton:Button;
		
		[SkinPart(required="true")]
		public var publishOptionsList:List;
		
		[SkinPart(required="true")]
		public var artifactList:List;
		
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * PublishLessonView 
		 */
		public function PublishLessonView()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// artifacts
		//-----------------------------------------
		private var artifactsChanged:Boolean;
		private var _artifacts:IList;
		
		public function get artifacts():IList
		{
			return _artifacts;
		}
		
		public function set artifacts(value:IList):void
		{
			if( _artifacts !== value)
			{
				_artifacts = sortArtifacts(value);
				artifactsChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// publishEnabled
		//-----------------------------------------
		private var _publishEnabled:Boolean;

		[Bindable(event="publishEnabledChange")]
		public function get publishEnabled():Boolean
		{
			return _publishEnabled;
		}

		public function set publishEnabled(value:Boolean):void
		{
			if( _publishEnabled !== value)
			{
				_publishEnabled = value;
				dispatchEvent(new Event("publishEnabledChange"));
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(artifactsChanged && artifactList)
			{
				artifactList.dataProvider = _artifacts;
				artifactsChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == preview)
				preview.addEventListener(MouseEvent.CLICK, onPreviewClick);
			if(instance == publishButton)
				publishButton.addEventListener(MouseEvent.CLICK, onPublishClick);
			if(instance == publishOptionsList)
				publishOptionsList.addEventListener(PublishEvent.PUBLISH_OPTION_SELECTION_CHANGE, onPublishOptionChange);
			if(instance == artifactList)
			{
				artifactList.addEventListener(PublishEvent.DOWNLOAD_LESSON_ARTIFACT, onDownloadArtifact);
				artifactList.addEventListener(PublishEvent.SAVE_LESSON_ARTIFACT, onSaveArtifact);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == preview)
				preview.removeEventListener(MouseEvent.CLICK, onPreviewClick);
			if(instance == publishButton)
				publishButton.removeEventListener(MouseEvent.CLICK, onPublishClick);
			if(instance == publishOptionsList)
				publishOptionsList.removeEventListener(PublishEvent.PUBLISH_OPTION_SELECTION_CHANGE, onPublishOptionChange);
			if(instance == artifactList)
			{
				artifactList.removeEventListener(PublishEvent.DOWNLOAD_LESSON_ARTIFACT, onDownloadArtifact);
				artifactList.removeEventListener(PublishEvent.SAVE_LESSON_ARTIFACT, onSaveArtifact);
			}
			super.partRemoved(partName, instance);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function resetComponent():void
		{
			artifacts = null;
			publishEnabled = false;
		}
		/**
		 *  @private
		 */
		private function calculateSelectedOptions():void
		{
			if(publishOptionsList.dataProvider)
			{
				var selectedItems:Array = [];
				for each(var item:PublishOptionVO in publishOptionsList.dataProvider)
				{
					if(item && item.selected)
						selectedItems.push(item);
				}
				
				publishEnabled = selectedItems.length > 0;
			}
		}
		
		public function resetSelectedOptions():void
		{
			if(publishOptionsList.dataProvider)
			{
				for each(var item:PublishOptionVO in publishOptionsList.dataProvider)
				{
					if(item)
						item.selected = false;
				}
				
				publishEnabled = false;
			}
		}
		
		private function sortArtifacts(list:IList):IList
		{
			if(!list)
				return null;
			var sort:Sort = new Sort();
			sort.fields = [new SortField("sortId", false, true)];
			ArrayCollection(list).sort = sort;
			ArrayCollection(list).refresh();
			return list;
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		protected function onPreviewClick(event:MouseEvent):void
		{
			dispatchEvent(new CourseEvent(CourseEvent.PREVIEW_LESSON));
		}
		
		protected function onDownloadArtifact(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function onSaveArtifact(event:Event):void
		{
			dispatchEvent(event.clone());
		}		
		
		protected function onPublishOptionChange(event:Event):void
		{
			calculateSelectedOptions();
		}
		
		protected function onPublishClick(event:MouseEvent):void
		{
			if(publishOptionsList.dataProvider)
			{
				var options:Array = [];
				for each(var item:PublishOptionVO in publishOptionsList.dataProvider)
				{
					if(item && item.selected)
						options.push(item);
				}
				
				if(options.length > 0)
					dispatchEvent(new PublishEvent(PublishEvent.PUBLISH_LESSON, options));
			}
		}
		
	}
}