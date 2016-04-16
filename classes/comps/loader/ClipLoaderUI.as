package comps.loader{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;


	public class ClipLoaderUI extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField();

		public function ClipLoaderUI() {
			setup();
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}
		private function setup():void {
			txt.defaultTextFormat = TextStyle.getUiFormat;
			txt.type = TextFieldType.DYNAMIC;
			txt.embedFonts=true;
			txt.selectable=false;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.thickness=200;
			txt.sharpness=0;
			txt.styleSheet=TextStyle.getStyleSheet;
			txt.autoSize= TextFieldAutoSize.CENTER;
			txt.htmlText=SiteStyle.getloaderTxt.clip;
			txt.width=txt.textWidth+TextStyle.getUiFormat.size;
			addChild(txt);
			txt.y=Math.round(-txt.height/2);
			txt.x=Math.round(-txt.width/2);
			this.alpha=0.5;
		}
		public function setError():void{
			txt.htmlText=SiteStyle.getloaderTxt.error;
			
		}
		public function setPercent(p:Number):void{
			txt.htmlText=p.toString();
		}

	}
}