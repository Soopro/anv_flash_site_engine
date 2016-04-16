package rotationmenu{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	import tools.*;

	public class MenuBtn extends MovieClip {

		private var loader:Loader=new Loader();

		private var btn_type:String="";
		private var btn_target:String="";
		private var btn_source:String="";
		private var img_url:String="";

		private var currAngle:Number=0;
		private var actvieState=true;
		private var item_depth:Number=0;
		private var item_order:int=0;

		public function MenuBtn() {
			this.mouseChildren=false;
			loader.mouseEnabled=false;
		}
		public function setup(pm_url:String="",pm_type:String="",pm_target:String="",pm_source:String="",pm_order:int=0):void {
			img_url=pm_url;
			btn_type=pm_type;
			btn_source=pm_source;
			btn_target=pm_target;

			item_order=pm_order;

			if (btn_source=="") {
				disable();
			}
			if (pm_url!="") {
				loadImg();
			}
			this.addEventListener(Event.REMOVED,removed);
		}
		private function loadImg():void {
			removeListeners(loader.contentLoaderInfo);
			try{
				loader.close();
			}catch(e:Error){
			}
			loader.unload();
			loader=new Loader();
			configureListeners(loader.contentLoaderInfo);
			var request:URLRequest = new URLRequest(img_url);
			loader.load(request);
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {

			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function completeHandler(event:Event):void {
			removeListeners(loader.contentLoaderInfo);
			imgbox.addChild(loader);
			Anim.fadeIn(loader);
			var tmp_x:int=-loader.width/2;
			var tmp_y:int=-loader.height/2;
			loader.x=tmp_x;
			loader.y=tmp_y;

			var obj=loader.content;
			if (obj is Bitmap) {
				obj.smoothing=true;
			}
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			removeListeners(loader.contentLoaderInfo);
			trace("error");
		}

		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				try{
					loader.close();
				}catch(e:Error){
				}
				loader.unload();
				removeListeners(loader.contentLoaderInfo);
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
			}
		}
		//get
		public function get getTarget():String {
			return btn_target;
		}
		public function get getType():String {
			return btn_type;
		}
		public function get getDataSource():String {
			return btn_source;
		}
		public function get order():int {
			return item_order;
		}
		public function get depth():Number {
			return item_depth;
		}
		public function get sec():String {
			return btn_source;
		}
		public function get angle():Number {
			return currAngle;
		}
		public function get actvie():Boolean {
			return actvieState;
		}
		//set
		public function set depth(d:Number):void {
			item_depth=d;
		}

		public function set angle(a:Number):void {
			currAngle=a;
		}
		public function set actvie(s:Boolean):void {
			actvieState=s;
		}
		public function disable():void {
			this.alpha=0.5;
			actvieState=false;
		}
		public function enable():void {
			this.alpha=1;
			actvieState=true;
		}
	}
}