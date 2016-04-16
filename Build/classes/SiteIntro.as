package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SiteIntro extends MovieClip {

		//public static  const INTRO_COMPLETE:String = "intro_complete";
		//public static  const INTRO_CHANGE:String = "intro_change";
		//set this string in SWFconfig
		
		private var complete_event:Event= new Event(SWFConfig.INTRO_COMPLETE,true,false);
		private var change_event:Event= new Event(SWFConfig.INTRO_CHANGE);
		private var curr_state:String="in";

		public function SiteIntro() {
			addEventListener(Event.ADDED_TO_STAGE,startPlay);
			addEventListener(Event.REMOVED_FROM_STAGE,stopPlay);
		}
		private function startPlay(event:Event):void {
			addEventListener(SWFConfig.INTRO_CHANGE, changeHandler);
			curr_state="in";
			this.gotoAndPlay("in");
		}
		private function stopPlay(event:Event):void {
			this.gotoAndStop(1);
		}
		public function skipIntro():void {
			this.gotoAndPlay("out");
		}
		//this function is listen "dispatchState()" on timeline, "root", layer "action"
		private function changeHandler(event:Event):void {
			switch (curr_state) {
				case "in" :
					curr_state="out";
					break;
				case "out" :
					curr_state="finish";
					break;
				case "finish" :
					finish();
					break;
			}
		}

		//this function use on timeline, "root", layer "action"
		private function dispatchState():void {
			dispatchEvent(change_event);
		}
		private function finish():void {
			removeEventListener(SWFConfig.INTRO_CHANGE, changeHandler);

			dispatchEvent(complete_event);

		}
	}
}