package views{
	import flash.display.MovieClip;


	public class SurfBoard extends MovieClip {
		private var currState:String="";
		private var running:Boolean=false;
		public function SurfBoard() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function doOpen():void {
			if (currentLabel!="open" && !running) {
				this.gotoAndPlay("open");
				running=true;
			}
			currState="open";
		}
		public function doClose():void {
			if (currentLabel!="close"&& !running) {
				this.gotoAndPlay("close");
				running=true;
			}
			currState="close";

		}
		//this function use on timeline, layer'action',when the state is changed.
		private function checkState():void {
			running=false;
			if (currentLabel!=currState) {
				this.gotoAndPlay(currState);
			}
		}
	}
}