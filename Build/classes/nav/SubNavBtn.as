package nav{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SubNavBtn extends MovieClip {

		private var sub_event:Event=new Event(Site.SUB_CLICKED,true,false);
		private var sub_in_event:Event=new Event(Site.SUB_IN_COMPLETE);
		private var sub_out_event:Event=new Event(Site.SUB_OUT_COMPLETE);

		//object preplace
		private var txt:TextField=new TextField;

		//variable preplace
		private var subWidth:int=0;
		private var tag:String="";
		private var order:int=0;
		private var space:int=2;
		private var topspace:int=4;
		private var seted:Boolean=false;
		private var selectCheck:Boolean=false;
		private var listenerCheck:Boolean=false;

		private var pos:int=0;

		public function SubNavBtn() {
			clean();
			this.mouseChildren=false;
			txt.mouseEnabled=false;
			this.addEventListener(Event.REMOVED,removed);
		}
		public function setup(str:String="",pm_tag:String="",pm_order:int=0):void {
			order=pm_order;
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
				sub_txt.addChild(txt);
				seted=true;
			}
			if (str == "") {
				this.visible=false;

			} else {
				this.visible=true;

				txt.htmlText=str;
			}

			subWidth=Math.round(sub_txt.width + space) + sub.sub_left.width + sub.sub_right.width;
			//set SubNavBtn
			if (subWidth != 0) {
				setBtn();
			}
		}
		public function animIn():void {
			this.gotoAndPlay("in");
			addListeners();
		}
		public function animOut():void {
			this.gotoAndPlay("out");
			removeListeners();
		}
		public function select():void {
			if(currentLabel!="select"){
				this.gotoAndPlay("select");
			}
			selectCheck=true;
			this.buttonMode=false;
		}
		public function active():void {
			this.gotoAndPlay("active");
			selectCheck=false;
			this.buttonMode=true;
		}
		private function setBtn():void {
			sub.sub_bg.x=sub.sub_left.x + sub.sub_left.width;
			sub.sub_bg.width=subWidth - (sub.sub_left.width + sub.sub_right.width);
			sub.sub_right.x=sub.sub_bg.x + sub.sub_bg.width;
			sel.sel_bg.x=sub.sub_bg.x;
			sel.sel_bg.width=sub.sub_bg.width;
			sel.sel_right.x=sub.sub_right.x;
			txt.y=sub.sub_bg.y + Math.round(sub.sub_bg.height-sub_txt.height-topspace);
			txt.x=sub.sub_bg.x;
			area.width=this.width;
			
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
				this.buttonMode=false;
				listenerCheck=false;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			if (!selectCheck && currentLabel!="in") {
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
						dispatchEvent(sub_event);
						break;
				}
			}
		}
		private function clean():void {
			seted=false;
			listenerCheck=false;
			selectCheck=false;
			subWidth=0;
			order=0;
			tag="";
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=sub_txt.numChildren - 1; i >= 0; i--) {
					sub_txt.removeChildAt(0);
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
		//set
		public function set setPos(p:int):void {
			pos=p;
		}
		
		//get
		public function get getPos():int {
			return pos;
		}

		public function get getTag():String {
			return tag;
		}
		
		public function get getOrder():int {
			return order;
		}
	}
}