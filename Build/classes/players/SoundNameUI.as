package players{
	import flash.display.MovieClip;
	import flash.text.*;

	public class SoundNameUI extends MovieClip {
		
		//object preplace
		private var txt:TextField=new TextField();
		
		//property 
		private var currName:String="";
		private var space:int=-1;
		private var w:int=115;
		private var h:int=12;
		private var seted:Boolean=false;

		public function SoundNameUI() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function setup(str:String=""):void {
			if (!seted) {
				currName="";
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getUiFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.thickness=-50;
				txt.sharpness=200;
				txt.width=w;
				txt.height=h;
				txt.y=space;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.styleSheet=TextStyle.getStyleSheet;
				txtbox.addChild(txt);
				seted=true;
			}
			currName=str;
			this.gotoAndPlay("run");
		}
		//this funciton use on timeline layer 'action' when the animation changed.
		private function changeContent():void {
			if(seted){
				txt.htmlText=currName;
			}
		}
	}
}