////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 26, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.core.ByteArrayAsset;
	
	import tj.ttu.base.vo.ModuleVO;

	/**
	 * ModuleData class 
	 */
	public class ModuleData
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		private static const ACT_URL:String = "CourseCreator";
		[Embed("/embed_assets/xml/modules.xml", mimeType="application/octet-stream")]
		private static const Modules:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		[ArrayElementType("tj.ttu.base.vo.ModuleVO")]
		public var moduleList:IList;
		
		public var modules:XMLList;
		
		public var config:XMLList;
		/**
		 * static instance of the class for singleton
		 */ 
		private static var instance:ModuleData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ModuleData 
		 */
		public function ModuleData()
		{
			if(instance != null) 
				throw new Error("Private constructor. Use LanguageManager.getInstance() instead.");
			init();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/**
		 *  Class method for getting singleton insatnce of the class 
		 */ 
		public static function getInstance():ModuleData
		{
			if(instance == null)
				instance = new ModuleData();
			return instance;
			
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
		 * @private
		 */
		private function parseModule(act:XML):ModuleVO
		{
			var moduleVo:ModuleVO 		= new ModuleVO();
			moduleVo.moduleURL 			= act.@module;
			moduleVo.name 				= act.@name;
			moduleVo.activityType 		= act.@activityType;
			//moduleVo.dataURL 			= ACT_URL; 
			moduleVo.description 		= act.description;
			moduleVo.moduleName	 		= moduleVo.helpName;
			moduleVo.backgroundImageUrl = act.@backgroundImageUrl ;
			moduleVo.icon 				= getIcon(moduleVo);
			return moduleVo;
		}
		
		
		/**
		 * @private
		 *  Gets Icon class for a given activity
		 */
		private function getIcon(moduleVo:ModuleVO):Object
		{
			if (moduleVo.icon && (moduleVo.icon.length >0))
				return Icons.getIcon(String(moduleVo.icon))
			else
				return Icons.getIcon(moduleVo.moduleName);
		}
		
		
		private function init():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset( new Modules() );
			var xml:XML = XML( ba.readUTFBytes( ba.length ));
			modules = xml.activities.children();
			config = xml.config;
			moduleList = new ArrayCollection();
			for each(var item:XML in xml.activities.children())
			{
				if(item)
					moduleList.addItem(parseModule(item));
			}
		}
		
	}
}