package nav{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;

	public class PopupNav extends MovieClip {

		//object preplace
		private var btns:Array=new Array;
		private var txt:TextField=new TextField;
		private var popupXML:XML=new XML();
		//variable preplace
		private var space:int=10;
		private var seted:Boolean=false;

		private var animOrder:int=0;

		public function PopupNav() {
			txt.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (!seted && pm_xml!=null) {
				popupXML=pm_xml;
				txt=new TextField();
				txt.defaultTextFormat=TextStyle.getDesFormat;
				txt.type=TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txtbox.addChild(txt);
				txt.htmlText=popupXML.title[0];
				btns=[];
				for (var i:int=0; i<popupXML.btn.length(); i++) {
					btns[i]=new PopupBtn();
					btns[i].setup(popupXML.btn[i]);
					if (popupXML.btn[i].@x==undefined) {
						if (i>0) {
							btns[i].x=btns[i-1].x+btns[i-1].width+space;
						} else {
							btns[i].x=space*2;
						}
					}
					addChild(btns[i]);
				}
				this.addEventListener(Event.REMOVED,removed);
				seted=true;
			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
			}
		}
		private function btnAnimIn(order:int):void {
			if (order<btns.length) {
				btns[order].active();
				btns[order].addEventListener(Site.IN_COMPLETE,nextHandler);
			}
		}
		private function nextHandler(event:Event):void {
			event.target.removeEventListener(Site.IN_COMPLETE,nextHandler);

			if (animOrder<btns.length) {
				animOrder++;
				btnAnimIn(animOrder);
			}
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeChildren(this);
				for (var i:int=0; i<btns.length; i++) {
					btns[i].removeEventListener(Site.IN_COMPLETE,nextHandler);
				}
				btns=[];

			}
		}
	}
}