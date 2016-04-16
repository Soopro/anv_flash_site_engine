package views{
	import flash.display.MovieClip;
	import flash.text.*;

	public class HandReport extends MovieClip {
		
		//object preplace
		private var txt:TextField=new TextField();
		private var hightLimit:int=25;
		//property 
		private var currReport:String="";
		private var seted:Boolean=false;

		public function HandReport() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.visible=false;
		}
		public function setup(str:String="",chk:Boolean=true):void {
			if (!seted) {
				currReport="";
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getUiFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.thickness=0;
				txt.sharpness=0;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.styleSheet=TextStyle.getStyleSheet;
				txtbox.addChild(txt);
				seted=true;
			}
			currReport=str;
			this.visible=true;
			if(!chk){
				bg.gotoAndPlay("error");
			}else{
				bg.gotoAndPlay("ok");
			}
			this.gotoAndPlay("run");
		}
		//this funciton use on timeline layer 'action' when the animation changed.
		private function changeContent():void {
			if(seted){
				txt.htmlText=currReport;
			}
		}
		//this funciton use on timeline layer 'action' when the animation finish.
		private function finish():void{
			this.visible=false;
		}
	}
}