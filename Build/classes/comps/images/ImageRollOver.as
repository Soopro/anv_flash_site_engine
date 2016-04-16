package comps.images{
	import flash.display.MovieClip;

	public class ImageRollOver extends MovieClip {

		public function ImageRollOver() {
			this.gotoAndStop("stop");
			this.mouseChildren=false;
		}
		
		public function animOver():void {
			this.gotoAndPlay("on");

		}
		public function animOut():void {
			this.gotoAndPlay("out");
		}
	}
}