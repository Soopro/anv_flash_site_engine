package views{
	import flash.display.MovieClip;
	import flash.text.*;

	public class TopLogo extends MovieClip {
		//object preplace
		private var txt:TextField=new TextField();
		
		//property preplace
		private var waveing:Boolean=false

		public function TopLogo() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function setup(str:String=""):void {
			txt = new TextField();

			txt.defaultTextFormat = TextStyle.getSLogoFormat;
			txt.type = TextFieldType.DYNAMIC;
			txt.embedFonts=true;
			txt.selectable=false;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.thickness=200;
			txt.sharpness=100;
			txt.width=122;
			txt.styleSheet=TextStyle.getStyleSheet;
			txt.htmlText=str;
			txtbox.addChild(txt);
		}
		public function animOn():void {
			if (currentLabel!="on") {
				this.gotoAndPlay("on");
			}
		}
		public function animOff():void {
			if (currentLabel!="off" && currentLabel!="stop") {
				this.gotoAndPlay("off");
			}
		}
		public function setWave(n:Number):void {
			if (n==0) {
				if(waveing){
					wave.gotoAndPlay("off");
					waveing=false;
				}
			} else {
				if(!waveing){
					wave.gotoAndPlay("on");
					waveing=true;
				}
			}
		}
	}
}