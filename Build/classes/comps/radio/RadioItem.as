package comps.radio{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import comps.images.*;
	import comps.*;
	import tools.*;

	public class RadioItem extends MovieClip {

		//events preplace
		private var radio_event:Event=new Event(Site.RADIO_CLICKED,true,false);

		//object preplace
		private var txt:TextField=new TextField();
		private var area:AreaSprite=new AreaSprite();


		//variable preplace
		private var seted:Boolean=false;
		private var order:int=0;
		private var space:int=5;
		private var topspace:int=1;
		private var selectCheck:Boolean=false;

		private var dat:String="";

		public function RadioItem() {
			order=0;
			seted=false;
			selectCheck=false;
			dat="";
			this.mouseChildren=false;
		}
		public function setup(pm_dat:String="",str:String="",pm_order:int=0,pm_w:int=0):void {
			order=pm_order;
			dat=pm_dat;
			
			if (!seted) {
				txt.defaultTextFormat = TextStyle.getFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				if(pm_w==0){
					txt.multiline=false;
					txt.wordWrap=false;
				}else{
					txt.width=pm_w;
					txt.multiline=true;
					txt.wordWrap=true;
				}
				
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				txt.x=radio.x+radio.width+space;
				txt.y=topspace;
				seted=true;
			}
			if (!this.contains(txt)) {
				addChild(txt);
				addEventListener(MouseEvent.CLICK,clickHandler);
				this.buttonMode=true;
				this.tabEnabled=false;
				this.addEventListener(Event.REMOVED,removed);
			}
			if (str=="") {
				this.visible=false;
				this.width=0;

			} else {
				this.visible=true;
				txt.htmlText=str;
				setRadio();
			}
		}

		private function setRadio():void {
			addChild(area);
			Align.same(this,area);
			var tmp_h=txt.getTextFormat().size;
			radio.y=Math.round(tmp_h-radio.height/2);
		}
		private function clickHandler(event:MouseEvent):void {
			dispatchEvent(radio_event);
		}
		public function select():void {
			selectCheck=true;
			radio.gotoAndStop("on");
		}
		public function unselect():void {
			selectCheck=false;
			radio.gotoAndStop("off");
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				if (this.contains(txt)) {
					removeChild(txt);
				}
				if (this.contains(area)) {
					removeChild(area);
				}
				removeEventListener(MouseEvent.CLICK,clickHandler);

				
			}
		}
		//get
		public function get checkSelect():Boolean{
			return selectCheck;
		}
		public function get getData():String {
			return dat;
		}
		public function get getOrder():int {
			return order;
		}
	}
}