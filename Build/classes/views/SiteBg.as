package views{
	import flash.display.Sprite;
	import flash.events.Event;


	public class SiteBg extends Sprite {

		public function SiteBg(w:int,h:int,p_x:int,p_y:int) {
			this.width=w
			this.height=h
			this.x=p_x
			this.y=p_y
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
	}
}