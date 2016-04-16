package nav{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.events.Event;

	import tools.*;

	public class MainNavBtn extends MovieClip {

		private var nav_event:Event=new Event(Site.NAV_CLICKED,true,false);
		private var over_event:Event=new Event(Site.NAV_ROLL_OVER,true,false);
		private var out_event:Event=new Event(Site.NAV_ROLL_OUT,true,false);

		//object preplace
		private var txt:TextField=new TextField();
		private var navXML:XML=new XML();
		//variable preplace
		private var nav_type:String="";
		private var nav_target:String="";
		private var nav_tag:String="";
		private var nav_source:String="";

		private var w:int=95;
		private var h:int=23;
		private var p_x:int=30;
		private var p_y:int=1;
		private var seted:Boolean=false;
		private var selectCheck:Boolean=false;


		private var listenerCheck:Boolean=false;


		public function MainNavBtn() {
			txt.mouseEnabled=false;
			this.mouseChildren=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (pm_xml!=null) {
				navXML=pm_xml;
				var str:String=navXML.txt[0];
				nav_type=navXML.@type;
				nav_target=navXML.@target;
				nav_tag=navXML.@tag;
				nav_source=navXML.@source;
			}

			if (str!="" && !seted && nav_type=="nav") {

				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getNavFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=true;
				txt.wordWrap=true;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=0;
				txt.sharpness=100;
				txt.width=w;
				txt.height=h;
				txt.x=p_x;
				txt.y=p_y;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.htmlText=str;
				txtbox.addChild(txt);
				seted=true;

				//set button

				this.addEventListener(Event.REMOVED,removed);
			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
				addListeners();
			}
		}
		public function select():void {
			this.gotoAndPlay("select");
			selectCheck=true;
			this.buttonMode=false;
		}
		public function unselect():void {
			this.gotoAndPlay("unselect");
			selectCheck=false;
			this.buttonMode=true;
		}

		private function addListeners():void {
			addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			addEventListener(MouseEvent.CLICK,mouseHandler);
			this.buttonMode=true;
			this.tabEnabled=false;
			listenerCheck=true;
		}
		private function removeListeners():void {
			if (listenerCheck) {
				removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				removeEventListener(MouseEvent.CLICK,mouseHandler);
				listenerCheck=false;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			if (currentLabel!="select" && currentLabel!="in") {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						this.gotoAndPlay("on");
						dispatchEvent(over_event);
						break;
					case MouseEvent.ROLL_OUT :
						this.gotoAndPlay("off");
						dispatchEvent(out_event);
						break;
					case MouseEvent.MOUSE_DOWN :
						this.gotoAndPlay("press");
						break;
					case MouseEvent.MOUSE_UP :
						this.gotoAndPlay("on");
						break;
					case MouseEvent.CLICK :
						dispatchEvent(nav_event);
						break;
				}
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {

				this.removeEventListener(Event.REMOVED,removed);

				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				removeListeners();
			}
		}
		//get
		public function get getTag():String {
			return nav_tag;
		}
		public function get getTarget():String {
			return nav_target;
		}
		public function get getType():String {
			return nav_type;
		}
		public function get getDataSource():String {
			return nav_source;
		}
		public function get getInfo():XML {
			return navXML.info[0];
		}
		public function get getSelect():Boolean {
			return selectCheck;
		}
	}
}