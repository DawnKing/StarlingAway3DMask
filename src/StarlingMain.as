package
{
	import flash.net.URLLoader;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class StarlingMain extends Sprite
	{
		private var _loader:URLLoader;

		public function StarlingMain()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(evt:starling.events.Event):void
		{
			this.mask = new Quad(300, 300);
			var s:String = "";
			for (var i:int = 0; i < 50; i++) 
			{
				for (var j:int = 0; j < 10; j++) 
				{
					s += "t" + j;
				}
			}
			this.addChild(new TextField(525, 300, s, new TextFormat("Verdana", 12, 0xFF0000)));
		}
	}
}