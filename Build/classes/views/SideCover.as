package views{
	import flash.display.MovieClip;


	public class SideCover extends MovieClip {



		public function SideCover(dir:Boolean=true,p_x:int=0,p_y:int=0) {
			if (!dir) {
				this.scaleX=-1;
			}
			this.x=p_x;
			this.y=p_y;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
	}
}