package nav{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.*;

	public class PopupBtn extends MovieClip {


		private var btn_event:Event=new Event(Site.BTN_CLICKED,true,false);
		private var in_event:Event=new Event(Site.IN_COMPLETE);
		//object preplace
		private var txt:TextField=new TextField;

		//variable preplace
		private var p_x:int=10;
		private var p_y:int=2;
		private var h:int=20;
		private var space:int=10;
		private var btn_type:String="";
		private var btn_target:String="";
		private var btn_tag:String="";
		private var btn_source:String="";

		private var seted:Boolean=false;
		private var listenerCheck:Boolean=false;

		public function PopupBtn() {
			txt.mouseEnabled=false;
			this.mouseChildren=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (!seted && pm_xml != null) {
				txt=new TextField  ;
				txt.defaultTextFormat=TextStyle.getPopFormat;
				txt.type=TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.thickness=0;
				txt.sharpness=100;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txtbox.addChild(txt);
				txt.htmlText=pm_xml;
				txt.x=p_x;
				txt.y=p_y;
				if (pm_xml.@x !=undefined) {
					this.x=pm_xml.@x;
				}
				if (pm_xml.@y !=undefined) {
					this.y=pm_xml.@y;
				}
				area.width=txt.width+space;
				btn_type=pm_xml.@type;
				btn_target=pm_xml.@target;
				btn_tag=pm_xml.@tag;
				btn_source=pm_xml.@src;
				this.addEventListener(Event.REMOVED,removed);
				seted=true;

			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
				addListeners();
			}
		}
		private function dispatchIn():void{
			dispatchEvent(in_event);
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.ROLL_OVER,btnHandler);
			addEventListener(MouseEvent.ROLL_OUT,btnHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
			addEventListener(MouseEvent.MOUSE_UP,btnHandler);
			addEventListener(MouseEvent.CLICK,btnHandler);
			this.buttonMode=true;
			this.tabEnabled=false;
			listenerCheck=true;
		}
		private function removeListeners():void {
			if (listenerCheck) {
				removeEventListener(MouseEvent.ROLL_OVER,btnHandler);
				removeEventListener(MouseEvent.ROLL_OUT,btnHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
				removeEventListener(MouseEvent.MOUSE_UP,btnHandler);
				removeEventListener(MouseEvent.CLICK,btnHandler);
				listenerCheck=false;
			}
		}
		private function btnHandler(event:MouseEvent):void {
			if (currentLabel !="in") {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						this.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						this.gotoAndPlay("off");
						break;
					case MouseEvent.MOUSE_DOWN :
						this.gotoAndPlay("press");
						break;
					case MouseEvent.MOUSE_UP :
						this.gotoAndPlay("on");
						break;
					case MouseEvent.CLICK :
						dispatchEvent(btn_event);
						break;
				}
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
				removeListeners();
			}
		}
		//get
		public function get getTag():String {
			return btn_tag;
		}
		public function get getTarget():String {
			return btn_target;
		}
		public function get getType():String {
			return btn_type;
		}
		public function get getDataSource():String {
			return btn_source;
		}
	}
}