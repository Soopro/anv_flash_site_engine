package nav{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BackBtn extends MovieClip {

		private var back_event:Event=new Event(Site.BACK_CLICKED,true,false);
		private var sub_in_event:Event=new Event(Site.SUB_IN_COMPLETE);
		private var sub_out_event:Event=new Event(Site.SUB_OUT_COMPLETE);

		//object preplace
		private var txt:TextField=new TextField;

		//variable preplace

		private var tag:String="";
		private var space:int=15;
		private var topspace:int=6;
		private var seted:Boolean=false;

		private var listenerCheck:Boolean=false;

		private var pos:int=0;

		public function BackBtn() {
			clean();
			this.mouseChildren=false;
			txt.mouseEnabled=false;
			this.addEventListener(Event.REMOVED,removed);
		}
		public function setup(str:String="",pm_tag:String=""):void {
			tag=pm_tag;

			if (! seted) {
				txt.defaultTextFormat=TextStyle.getSubNavFormat;
				txt.type=TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.thickness=0;
				txt.sharpness=0;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize=TextFieldAutoSize.LEFT;
				b_txt.addChild(txt);

				seted=true;
			}
			if (str == "") {
				this.visible=false;

			} else {
				this.visible=true;

				txt.htmlText=str;
			}

			//set BackBtn
			setBtn();

		}
		public function animIn():void {
			this.gotoAndPlay("in");
			addListeners();
		}
		public function animOut():void {
			this.gotoAndPlay("out");
			removeListeners();
		}

		private function setBtn():void {
			txt.y=Math.round(bck.height-b_txt.height-topspace);
			txt.x=Math.round(bck.width/2-b_txt.width/2);
			point_box.point.x=txt.x-space;
			point_box.point.y=Math.round(b_txt.height/2);
			area.width=this.width;

		}

		//this function use on timeline  layer 'action' when the button rollover
		private function iconSwitch(str:String):void {
			switch (str) {
				case "on" :
					point_box.point.gotoAndPlay("on");
					break;
				case "off" :
					point_box.point.gotoAndPlay("off");
					break;
			}
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
				this.buttonMode=false;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			if (currentLabel!="in") {
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
						dispatchEvent(back_event);
						iconSwitch("off");
						break;
				}
			}
		}
		private function clean():void {
			seted=false;
			listenerCheck=false;

			tag="";
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				
				for (var i:int=b_txt.numChildren - 1; i >= 0; i--) {
					b_txt.removeChildAt(0);
				}
				
				removeListeners();
			}
		}
		//this function use on timeline, layer 'action' when animtion
		private function dispatchState(str:String):void {
			switch (str) {
				case "in" :
					dispatchEvent(sub_in_event);
					break;
				case "out" :
					dispatchEvent(sub_out_event);
					break;
			}
		}

		//get

		public function get getTag():String {
			return tag;
		}
	}
}