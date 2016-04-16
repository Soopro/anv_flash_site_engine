package comps.images{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ImageOutline extends MovieClip {

		//static
		private static  var border:int=4;
		
		//variable preplace
		private var outlineHeight:int=0;
		private var outlineWidth:int=0;
		
		public function ImageOutline() {
			outlineHeight=0;
			outlineWidth=0;
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function setup(pm_w:int=0,pm_h:int=0):void{
			outlineWidth=pm_w;

			outlineHeight=pm_h;

			//set outline
			if (outlineHeight !=0 && outlineWidth!=0){
				setOutline();
			}
		}

		private function setOutline():void {
			line_right.height=line_left.height=outlineHeight-(angel_bl.height+angel_tl.height);
			line_right.x=outlineWidth-line_right.width;
			line_bottom.width=outlineWidth-(angel_bl.width+angel_br.width);
			line_bottom.y=outlineHeight-line_bottom.height;
			line_top.width=line_bottom.width;
			line_top.x=outlineWidth-(line_top.width+angel_tr.width);
			angel_tr.x=outlineWidth-angel_tr.width;
			angel_br.x=outlineWidth-angel_br.width;
			angel_br.y=outlineHeight-angel_br.height;
			angel_bl.y=outlineHeight-angel_bl.height;
		}
		
		public static function get getBorder():int{
			return border;
		}
	}
}