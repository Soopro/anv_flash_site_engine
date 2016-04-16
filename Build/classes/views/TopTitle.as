package views{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;

	public class TopTitle extends MovieClip {


		//object preplace
		private var txt:TextField=new TextField();
		private var btns:Array=new Array();

		//property 
		//private var space:int=10;

		private var currentTitle:String="";
		private var seted:Boolean=false;

		public function TopTitle() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			setup();
		}
		private function setup():void {
			if (!seted ) {
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getTopFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				//txt.antiAliasType = AntiAliasType.ADVANCED;
				//txt.thickness=0;
				//txt.sharpness=0;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				txt.htmlText=currentTitle;
				titlebox.addChild(txt);
				var tmp_w:int=int(TextStyle.getTopFormat.size)*2.5;
				var tmp_x:int=Site.WIDTH/2-txt.width/2-tmp_w;
				txt.x=tmp_x;
				
				this.x=SiteStyle.getTop.x;
				this.y=SiteStyle.getTop.y;

				this.addEventListener(Event.REMOVED,removed);
				seted=true;
				this.visible=false;
			}
		}
		public function reset(str:String=""):void {
			if (seted) {
				if (currentTitle!="") {
					this.gotoAndPlay("off");
				} else {
					this.gotoAndPlay("on");
				}
				this.visible=true;
				currentTitle=str;
			}
		}
		//this function use on timeline, layer'action' when animation off.
		private function checkTitle():void {
			if (currentTitle!="") {
				this.gotoAndPlay("re");
			} else {
				stop();
				this.visible=false;
			}
		}
		//this function use on timeline, layer'action' when animation on.
		private function setTitle():void {
			txt.htmlText=currentTitle;
		}

		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);

				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
			}
		}
	}
}