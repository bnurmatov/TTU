package tj.ttu.components.components.layout
{
	import spark.core.NavigationUnit;
	import spark.layouts.BasicLayout;
	
	public class ScrollLayout extends BasicLayout
	{
		public function ScrollLayout()
		{
		}
		
		override  public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
					return -20;
				case NavigationUnit.DOWN:
					return 20;
				default:
					return super.getVerticalScrollPositionDelta(navigationUnit);
			}
			return super.getVerticalScrollPositionDelta(navigationUnit);
		}
		
	}
}