package nav{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	import tools.*;

	public class MainNavInfo extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField  ;
		private var loader:Loader=new Loader  ;

		//property 
		private var infoXML:XML=new XML  ;
		private var currInfo:String="";
		private var lastInfo:String="";
		private var currURL:String="";

		private var w:int=346;
		private var h:int=30;
		private var p_x:int=74;
		private var p_y:int=5;

		private var seted:Boolean=false;
		private var hasPic:Boolean=false;

		public function MainNavInfo() {
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}
		public function setup(pm_xml:XML=null):void {

			if (! seted && pm_xml != null) {
				infoXML=pm_xml;
				currURL=infoXML.@src;
				currInfo=infoXML;
				txt=new TextField  ;
				txt.defaultTextFormat=TextStyle.getDesFormat;
				txt.type=TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=true;
				txt.wordWrap=true;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.width=w;
				txt.height=h;
				txt.x=p_x;
				txt.y=p_y;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.htmlText=currInfo;
				txtbox.addChild(txt);
				this.addEventListener(Event.REMOVED,removed);

				loadPic(currURL);

				seted=true;
			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
			}
		}
		public function reset(pm_xml:XML=null) {
			if (seted && pm_xml != null) {
				var tmp_str:String=pm_xml;
				if (lastInfo != tmp_str) {
					currURL=pm_xml.@src;
					currInfo=pm_xml;
					this.gotoAndPlay("run");
				} else {
					this.gotoAndStop("stop");
				}
			} else {
				this.gotoAndPlay("back");
			}
		}
		//this function use on time line layer 'action'
		private function back():void {
			currURL=infoXML.@src;
			currInfo=infoXML;
			this.gotoAndPlay("run");
		}
		private function loadPic(url:String):void {

			if (hasPic) {
				try {
					loader.close();
				} catch (e:Error) {
				}
				loader.unload();
				removeListeners(loader.contentLoaderInfo);
				hasPic=false;
			}
			if (url != "") {
				loader=new Loader  ;
				configureListeners(loader.contentLoaderInfo);

				var request:URLRequest=new URLRequest(url);
				loader.load(request);

				hasPic=true;
			}
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE,completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		private function completeHandler(event:Event):void {
			removeListeners(loader.contentLoaderInfo);
			imgbox.addChildAt(loader,0);
			loader.mask=imgbox.imgmask;
			Anim.fadeIn(loader);
			//trace("completeHandler: " + event);
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			removeListeners(loader.contentLoaderInfo);
			trace("ioErrorHandler: " + event);
		}

		//this funciton use on timeline layer 'action' when the animation changed.
		private function changeContent():void {
			if (seted) {
				loadPic(currURL);
				lastInfo=currInfo;
				txt.htmlText=currInfo;
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				loader.unload();
				removeListeners(loader.contentLoaderInfo);
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
			}
		}
	}
}