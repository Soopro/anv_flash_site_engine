package views{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class SideCoverBg extends MovieClip {
		private var limitY:int=100;
		
		public function SideCoverBg(dir:Boolean=true,p_x:int=0,p_y:int=0) {
			if (!dir){
				this.scaleX=-1;
			}
			this.x=p_x;
			this.y=p_y;
			this.mouseChildren=false;
			this.mouseEnabled=false;
			//this.addEventListener(Event.REMOVED,removed);
		}
		/*
		private function mouseHandler(event:Event):void {
			if (mouseY<limitY && mouseY>-limitY) {
				var frame:int=(limitY-Math.abs(mouseY))/limitY*20;
				if (currentFrame!=frame) {
					this.gotoAndStop(frame);
				}
			}else{
				if (currentFrame!=1) {
					this.gotoAndStop(1);
				}
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeEventListener(Event.ENTER_FRAME,mouseHandler);
			}
		}
		*/
	}
}