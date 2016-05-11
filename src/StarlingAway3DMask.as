package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import away3d.primitives.WireframePlane;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	
	public class StarlingAway3DMask extends Sprite
	{
		private var _stage3DManager:Stage3DManager;
		private var _stage3DProxy:Stage3DProxy;
		private var _away3dView:View3D;
		private var _starlingView:Starling;
		private var _size:TextField;
		
		private var _onlyStarling:Boolean = false;
		
		public function StarlingAway3DMask()
		{
			stage.frameRate = 60;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.color = 0x9F9F9F;
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			if (_onlyStarling)
			{
				initStarling();
			}
			else
			{
				_stage3DManager = Stage3DManager.getInstance(stage);
				_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
				_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
				_stage3DProxy.antiAlias = 2;
				_stage3DProxy.color = 0x474747;
			}
			
			_size = new TextField;
			_size.autoSize = TextFieldAutoSize.LEFT;
			_size.text = "stage width heght = " + stage.stageWidth + "/" + stage.stageHeight;
			this.addChild(_size);
		}
		
		protected function onResize(event:Event):void
		{
			_size.text = "stage width heght = " + stage.stageWidth + "/" + stage.stageHeight;
			
			var x:Number = event.target.x;
			var y:Number = event.target.y;
			var stageWidth:Number = event.target.stageWidth;
			var stageHeight:Number = event.target.stageHeight;
			
			if (_stage3DProxy)
			{
				_stage3DProxy.x = x;
				_stage3DProxy.y = y;
				_stage3DProxy.width = stageWidth;
				_stage3DProxy.height = stageHeight;
			}
			
			if (_away3dView)
			{
				_away3dView.x = x;
				_away3dView.y = y;
				_away3dView.width = stageWidth;
				_away3dView.height = stageHeight;
			}
			
			_starlingView.viewPort = new Rectangle(x, y, stageWidth, stageHeight);
			_starlingView.stage.stageWidth = stageWidth;
			_starlingView.stage.stageHeight = stageHeight;
		}
		
		private function onContextCreated(event : Stage3DEvent):void
		{
			initAway3D();
			initStarling();
			
			_stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initAway3D():void
		{
			_away3dView = new View3D();
			_away3dView.stage3DProxy = _stage3DProxy;
			_away3dView.shareContext = true;
			
			addChild(_away3dView);		
			_away3dView.scene.addChild(new WireframePlane(2000, 2000, 10, 10, 0xFFFFFF, 1, "xy"));
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_away3dView.render();
			
			// away3d会修改blendMode，需要重新设置回Starling的默认值
			var blendMode:String = Starling.painter.state.blendMode;
			BlendMode.get(blendMode).activate();
			
			_starlingView.nextFrame();
		}
		
		private function initStarling():void
		{
			_starlingView = new Starling(StarlingMain, stage);			
			_starlingView.simulateMultitouch = false;
			_starlingView.enableErrorChecking = false;
			
			var w:int, h:int;
			if(Capabilities.os.toLowerCase().slice(0,3)=="win" 
				|| Capabilities.os.toLowerCase().slice(0,3)=="mac")
			{
				w = stage.stageWidth;
				h = stage.stageHeight;
			}
			else
			{
				w = Capabilities.screenResolutionX;
				h = Capabilities.screenResolutionY;
			}
			
			_starlingView.stage.stageWidth  = w;
			_starlingView.stage.stageHeight = h;
			_starlingView.viewPort = new Rectangle(0,0,w,h);
			_starlingView.start();
		}
		
	}
}