package views{

	import flash.display.MovieClip;
	import flash.display.BlendMode;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class SiteLogo extends MovieClip {

		private var in_event:Event=new Event(Site.IN_COMPLETE);
		private var out_event:Event=new Event(Site.OUT_COMPLETE);
		
		//object preplace
		private var txt:TitleText=new TitleText();
		private var shadow_txt:TitleText=new TitleText();
		private var randTimer:Timer=new Timer(5000);


		//property preplace

		private var seted:Boolean=false;

		public function SiteLogo() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.blendMode=BlendMode.MULTIPLY;
		}
		public function setup(str:String="",p_x:int=0,p_y:int=0):void {
			if (!seted) {
				
				txt=new TitleText(str);
				
				shadow_txt=new TitleText(str);
				
				shadow_txt.y=p_y;
				txt.y=p_y;
				
				if(p_x==0){
					p_x=-txt.width/2;
				}
				shadow_txt.x=p_x;
				txt.x=p_x;
				txtbox.addChild(txt);
				shadowbox.addChild(shadow_txt);
				this.addEventListener(Event.REMOVED,removed);
			}
		}
		public function animIn():void {
			if(currentLabel!="in" && currentLabel!="stop"){
				this.gotoAndPlay("in");
				this.visible=true;
			}
		}
		public function animOut():void{
			if(currentLabel!="out"){
				stopTimer();
				this.gotoAndPlay("out");
			}
		}
		private function finish():void{
			this.visible=false;
		}
		//set timer animation
		private function timerHandler(event:TimerEvent):void {
			var i:Number=Math.random();
			if (i>0.6) {
				this.gotoAndPlay("shake");
			}
		}
		private function startTimer():void {
			randTimer.start();
			randTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		private function stopTimer():void {
			randTimer.stop();
			randTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}

		//this function use on timeline, layer "action",when state must be change.
		private function setShake(str:String):void {
			switch (str) {
				case "on" :
					startTimer();
					break;
				case "off" :
					stopTimer();
					break;
			}
		}
		//this function use on timeline, layer "action"
		private function dispatchState(dispatcher:String):void {
			switch (dispatcher) {
				case "in" :
					dispatchEvent(in_event);
					break;
				case "out" :
					dispatchEvent(out_event);
					break;
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				stopTimer();
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
			}
		}
	}
}
import flash.display.Sprite;
import flash.text.*;
class TitleText extends Sprite {
	private var txt:TextField=new TextField();

	public function TitleText(str:String="") {
		txt = new TextField();

		txt.defaultTextFormat = TextStyle.getLogoFormat;
		txt.type = TextFieldType.DYNAMIC;
		txt.embedFonts=true;
		txt.selectable=false;
		txt.multiline=false;
		txt.wordWrap=false;
		txt.antiAliasType = AntiAliasType.ADVANCED;

		txt.styleSheet=TextStyle.getStyleSheet;
		txt.autoSize= TextFieldAutoSize.CENTER;
		txt.htmlText=str;
		addChild(txt);
	}
}