package comps{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Arrows extends MovieClip {

		//events preplace
		private var counted_event:Event=new Event(Site.COUNTED);

		//variable preplace
		private var count:int=0;
		private var last_count:int=-1;
		private var limit:int=0;
		private var seted:Boolean=false;

		private var listenerCheck:Boolean=false;

		public function Arrows() {
			
			listenerCheck=false;
		}
		public function setup(pm_limit:int=0,pm_count:int=0):void {
			limit=pm_limit;
			count=pm_count;
			ar.gotoAndStop("off");
			al.gotoAndStop("off");
			
			
			if (limit==count) {
				ar.gotoAndStop("stop");
				al.gotoAndStop("off");
			}
			if (count==0) {
				al.gotoAndStop("stop");
				ar.gotoAndStop("off");
			}
			if (limit==0) {
				al.gotoAndStop("stop");
				ar.gotoAndStop("stop");
			}
			addListeners(ar,al);
			seted=true;
			this.addEventListener(Event.REMOVED,removed);
		}
		public function animIn(chk:Boolean):void {
			if (chk) {
				this.gotoAndPlay("re");
			} else {
				this.gotoAndPlay("in");
			}
		}
		public function animOut():void {

			this.gotoAndPlay("out");

		}
		private function addListeners(...obj):void {
			for (var i:int=0; i<obj.length; i++) {
				obj[i].addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				obj[i].addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				obj[i].addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				obj[i].addEventListener(MouseEvent.CLICK,mouseHandler);
				obj[i].buttonMode=true;
				obj[i].tabEnabled=false;
			}
			listenerCheck=true;
		}
		private function removeListeners(...obj):void {
			if (listenerCheck) {
				for (var i:int=0; i<obj.length; i++) {
					obj[i].removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
					obj[i].removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					obj[i].removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
					obj[i].removeEventListener(MouseEvent.CLICK,mouseHandler);
					obj[i].buttonMode=false;
				}
				listenerCheck=false;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			var obj=event.currentTarget;
			if (obj.currentLabel!="stop") {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :

						obj.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						obj.gotoAndPlay("off");
						break;
					case MouseEvent.MOUSE_DOWN :
						obj.gotoAndPlay("press");
						break;
					case MouseEvent.CLICK :
						obj.gotoAndPlay("on");
						if (obj==al) {
							reCount(false);
						}
						if (obj==ar) {
							reCount(true);
						}
						break;
				}
			}
		}
		private function reCount(b:Boolean):void {
			if (b && count<limit) {
				count++;
			}
			if (!b && count>0) {
				count--;
			}
			if (limit>count) {
				ar.gotoAndStop("off");
			} else {
				ar.gotoAndStop("stop");
			}
			if (count>0) {
				al.gotoAndStop("off");
			} else {
				al.gotoAndStop("stop");
			}
			if (limit==0) {
				al.gotoAndStop("stop");
				ar.gotoAndStop("stop");
			}
			if (last_count!=count) {
				last_count=count;
				dispatchEvent(counted_event);
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				
				al.gotoAndStop("stop");
				ar.gotoAndStop("stop");
				this.gotoAndPlay("stop");
				removeListeners(ar,al);
				
			}
		}
		//get
		public function get countNumber():int {
			return count;
		}
	}
}