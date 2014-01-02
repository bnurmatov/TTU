////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 11, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.utils
{

	[ResourceBundle("controls")]			/* Image SwfLoader */
	[ResourceBundle("formatters")]			/* Formatters, Audio, VolumeBar */
	[ResourceBundle("SharedResources")]		/* DateFormatter, Audio, VolumeBar */
	[ResourceBundle("validators")]			/* preview resource */
	[ResourceBundle("logging")]				/* mx loging */
	
	/**
	 * MemoryLeakImport class 
	 */
	
	public class MemoryLeakImport
	{
		import flashx.textLayout.factory.TextFlowTextLineFactory;TextFlowTextLineFactory
		import flashx.textLayout.container.TextContainerManager;TextContainerManager
		import flashx.textLayout.elements.Configuration;Configuration
		import flashx.textLayout.factory.TextLineFactoryBase;
		import spark.utils.TextUtil;TextUtil
		import flashx.textLayout.elements.GlobalSettings;GlobalSettings;
		
		import mx.core.EmbeddedFontRegistry; EmbeddedFontRegistry
		import mx.collections.ArrayCollection;ArrayCollection
		import mx.managers.DragManager;DragManager
		import mx.managers.PopUpManager;PopUpManager
		
		import spark.effects.AnimateTransform3D;AnimateTransform3D
		import spark.effects.interpolation.NumberInterpolator;NumberInterpolator
		import spark.utils.TextUtil;TextUtil
		import spark.effects.Resize;Resize
		import mx.formatters.DateFormatter;DateFormatter;
		//import com.video.player.VideoPlayer;VideoPlayer;
		import mx.core.UIFTETextField;UIFTETextField
		import spark.components.List;List
		import spark.components.supportClasses.ItemRenderer;ItemRenderer
		import mx.charts.PieChart;PieChart
		import mx.controls.Menu;Menu
		
		// 
		import tj.ttu.base.coretypes.LessonVO;LessonVO;
		import tj.ttu.base.coretypes.ChapterVO;ChapterVO;
		import tj.ttu.base.vo.DepartmentVO;DepartmentVO;
		import tj.ttu.base.vo.ImageVO;ImageVO;
		import tj.ttu.base.vo.SoundVO;SoundVO;
		import tj.ttu.base.vo.SpecialityVO;SpecialityVO;
		
	}
}