package views{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.*;
	import jumpmenu.*;
	
	public class LangBtn extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField;
		private var langXML:XML=new XML();
		//variable preplace

		private var seted:Boolean=false;
		private var listenerCheck:Boolean=false;
		private var mute:Boolean=false;

		public function LangBtn() {
			this.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (!seted && pm_xml != null) {
				langXML=pm_xml;
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
				txt.htmlText=langXML.title;
				this.addEventListener(Event.REMOVED,removed);
				jumper.setup(langXML.jumpmenu[0])
				seted=true;
			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
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
			}
		}
	}
}