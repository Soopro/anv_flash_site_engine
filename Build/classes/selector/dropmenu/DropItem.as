package selector.dropmenu{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;

	public class DropItem extends MovieClip {

		public static  const SELECTED:String="selected";
		private var selected_event:Event= new Event(SELECTED);
		private var src:String;

		public function DropItem(t:String="",s:String="") {
			txt.txt.text=t;
			src=s;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			addEventListener(Event.REMOVED_FROM_STAGE, removeListeners);
		}
		private function initialize(event:Event):void {
			this.gotoAndStop(1);
			btn.addEventListener(MouseEvent.ROLL_OVER, btnHandler);
			btn.addEventListener(MouseEvent.ROLL_OUT, btnHandler);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			btn.addEventListener(MouseEvent.MOUSE_UP, btnHandler);
			btn.addEventListener(MouseEvent.CLICK, btnHandler);
		}
		private function removeListeners(event:Event):void {
			this.gotoAndStop(1);
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnHandler);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnHandler);
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			btn.removeEventListener(MouseEvent.MOUSE_UP, btnHandler);
			btn.removeEventListener(MouseEvent.CLICK, btnHandler);
		}
		private function btnHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					this.gotoAndStop("on");
					break;
				case MouseEvent.ROLL_OUT :
					this.gotoAndStop("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					this.gotoAndStop("press");
					break;
				case MouseEvent.MOUSE_UP :
					this.gotoAndStop("off");
					break;
				case MouseEvent.CLICK :
					this.gotoAndStop("off");
					dispatchState();
					break;
			}
		}
		private function dispatchState():void {
			dispatchEvent(selected_event);
		}
		//get property
		public function get getSrc():String{
			return src;
		}
	}
}