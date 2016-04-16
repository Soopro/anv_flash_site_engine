package views{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;

	import tools.*;

	public class CrText extends MovieClip {


		//object preplace
		private var txt:TextField=new TextField();
		private var btns:Array=new Array();

		//property 
		private var space:int=10;
		private var p_y:int=5;
		private var c_y:int=629;
		private var seted:Boolean=false;

		public function CrText() {
			this.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (!seted && pm_xml!=null) {
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getCrFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=100;
				txt.y=p_y;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				txt.htmlText=pm_xml.info;
				addChild(txt);

				addButtons(pm_xml.btn);



				if (pm_xml.@x!=undefined) {
					this.x=pm_xml.@x;
				} else {
					var tmp_x:int=Site.WIDTH/2-this.width/2;
					this.x=tmp_x;
				}
				if (pm_xml.@y!=undefined) {
					this.y=pm_xml.@y;
				} else {
					this.y=c_y;
				}
				this.addEventListener(Event.REMOVED,removed);
				seted=true;
				this.visible=false;
			}
		}
		public function active():void {
			Anim.fadeIn(this,0.05);
			this.visible=true;
		}
		private function addButtons(list:XMLList):void {
			for (var i:int=0; i<list.length(); i++) {
				btns[i]=new CrButton();
				addChild(btns[i]);
				btns[i].setup(list[i]);
				if (list[i].@x!=undefined) {
					btns[i].x=list[i].@x;
				} else {
					btns[i].x=txt.x+ this.width+space;
				}
				if (list[i].@y!=undefined) {
					btns[i].y=list[i].@y;
				}
			}
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