package comps{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import tools.*;

	public class GButton extends MovieClip {

		private var btn_event:Event=new Event(Site.BTN_CLICKED,true,false);


		//object preplace
		private var txt:UiText=new UiText();

		//variable preplace
		private var btnWidth:int=0;
		private var btn_type:String="";
		private var btn_target:String="";
		private var btn_tag:String="";
		private var btn_source:String="";

		private var space:int=10;
		private var topspace:int=2;

		private var listenerCheck:Boolean=false;


		public function GButton() {
			btnWidth=0;
			btn_tag="";
			btn_type="";
			btn_target="";
			btn_source="";
			listenerCheck=false;
			this.mouseChildren=false;
		}
		public function setup(str:String="",pm_type:String="",pm_tag:String="",pm_target:String="",pm_source:String="",pm_w:int=0):void {

			btn_type=pm_type;
			btn_target=pm_target;
			btn_tag=pm_tag;
			btn_source=pm_source;

			function typeCheck(element:*, index:int, arr:Array):Boolean {
				return (element == btn_type);
			}
			var report:Array = Site.getBtnTypes.filter(typeCheck);

			if (report.length>0) {
				icons.gotoAndStop(btn_type);
			} else {
				icons.gotoAndStop("none");
			}

			if (str!="") {
				txt.setup(str);
				btn_txt.addChild(txt);
			}

			if (pm_w!=0) {
				btnWidth=pm_w;
			} else {
				btnWidth=Math.round(txt.width+space)+(btn.btn_left.width+btn.btn_right.width);
			}

			//set button
			if (btnWidth !=0 ) {
				setButton();
			}
			this.addEventListener(Event.REMOVED,removed);
			addListeners();
		}
		private function setButton():void {
			btn.btn_bg.x=btn.btn_left.x+btn.btn_left.width;
			btn.btn_bg.width=btnWidth-(btn.btn_left.width+btn.btn_right.width);
			btn.btn_right.x=btn.btn_bg.x+btn.btn_bg.width;
			txt.y=btn.btn_bg.y+topspace;
			txt.x=btn.btn_bg.x+space;
			area.width=this.width;
			this.buttonMode=true;
			this.tabEnabled=false;
		}

		private function addListeners():void {
			addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			addEventListener(MouseEvent.CLICK,mouseHandler);
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
		private function removed(event:Event):void {
			if (event.target == this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				
				for (var i:int=btn_txt.numChildren - 1; i >= 0; i--) {
					btn_txt.removeChildAt(0);
				}
				
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
		public function get getDataSource():String{
			return btn_source;
		}
	}
}