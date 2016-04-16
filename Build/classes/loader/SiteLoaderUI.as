package loader{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;

	public class SiteLoaderUI extends MovieClip {

		//event preplace
		private var out_complete_event:Event=new Event(Site.OUT_COMPLETE);
		//variable preplace
		private var percent:Number=1;
		private var seted:Boolean=false;
		//object preplace
		//private var txt:TextField=new TextField();
		//private var format:TextFormat=new TextFormat();

		public function SiteLoaderUI() {
			showProgress();
		}
		public function startLoading():void {
			setup();
			showProgress();
			this.gotoAndPlay("in");
		}

		private function setup():void {
			//format.letterSpacing = 1;
			//loadinfo.txt.styleSheet=TextStyle.getStyleSheet;
			//loadinfo.txt.defaultTextFormat = format;

			//loadinfo.txt.htmlText=SiteStyle.getloaderTxt.site;
		}
		private function showProgress():void {
			loadbar.gotoAndStop(percent);
			loadinfo.gotoAndStop(percent);
			//loadinfo.txt.text=percent;
		}
		private function showComplete():void {
			this.gotoAndPlay("out");
		}
		//this function is use on timeline when all animation play end.
		private function dispatchFinish():void {
			dispatchEvent(out_complete_event);
		}

		//set property
		public function setPercent(per:Number):void {
			percent=per;
			showProgress();
		}
		public function setComplete():void {
			showComplete();
		}
	}
}