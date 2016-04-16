package comps{
	import flash.display.Sprite;
	import flash.events.Event;

	public class NodeSprite extends Sprite {
		//variable preplace
		private var pos_X:int=0;
		private var pos_Y:int=0;
		private var n_width:int=0;
		private var n_height:int=0;
		private var form_name:String="";

		public function NodeSprite() {
			this.mouseEnabled=false;
			this.addEventListener(Event.REMOVED,removed);
			//addEventListener(Site.BTN_ROLLOVER,swapHandler);
		}
		
		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
				
			}
		}
		public function get posX():int {
			return pos_X;
		}
		public function set posX(pm_x:int) {
			pos_X=pm_x;
		}
		public function get posY():int {
			return pos_Y;
		}
		public function set posY(pm_y:int) {
			pos_Y=pm_y;
		}
		public function get nodeWidth():int {
			return n_width;
		}
		public function set nodeWidth(pm_w:int) {
			n_width=pm_w;
		}
		public function get nodeHeight():int {
			return n_height;
		}
		public function set nodeHeight(pm_h:int) {
			n_height=pm_h;
		}
		public function get form():String {
			return form_name;
		}
		public function set form(str:String) {
			form_name=str;
		}
	}
}