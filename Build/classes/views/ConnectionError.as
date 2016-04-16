package views{
	import flash.display.MovieClip;

	public class ConnectionError extends MovieClip {

		public function ConnectionError() {
			this.alpha=0.6;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		private function back():void{
			var t:Number=Math.random()*10
			if(t>6){
				this.gotoAndPlay("re")
			}
		}
	}
}