package players{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class SdCover extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField();

		//property preplace
		private var space:int=-1;
		private var w:int=120;
		private var h:int=30;
		private var p_x:int=7;
		private var p_y:int=5;
		private var seted:Boolean=false;
		private var limit:int=290;

		public function SdCover() {
			this.mouseChildren=false;
			txt.mouseEnabled=false;
		}
		public function setup(str:String):void {
			if (!seted && stage!=null) {
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getDesFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=true;
				txt.wordWrap=true;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.width=w;
				txt.height=h;
				txt.x=p_x;
				txt.y=p_y;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.htmlText=str;
				txtbox.addChild(txt);
				seted=true;
				stage.addEventListener(MouseEvent.CLICK,openHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,openHandler);
				this.addEventListener(Event.REMOVED,removed);
				this.tabEnabled=false;
			}
		}
		private function animIn():void {
			if (currentLabel!="on") {
				gotoAndPlay("on");
			}
		}
		private function animOut():void {
			if (currentLabel!="off" && currentLabel!="stop") {
				gotoAndPlay("off");
			}
		}

		private function openHandler(event:MouseEvent):void {


			if (mouseY<-limit||mouseY>this.height+limit || mouseX<0-limit || mouseX>this.width+limit) {
				animOut();
			} else {
				if(event.type==MouseEvent.CLICK && mouseY>0 && mouseY<this.height && mouseX>0 && mouseX<this.width){
					animIn();
				}
			}

		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				stage.removeEventListener(MouseEvent.CLICK,openHandler);
			}
		}
	}
}