package comps{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import tools.*;

	public class FieldOutline extends MovieClip {


		//variable preplace
		private var outlineHeight:int=0;
		private var outlineWidth:int=0;
		private var titleWidth:int=0;
		private var title_space:int=15;
		private var title_txt:TextTitle=new TextTitle();

		public function FieldOutline() {
			outlineHeight=0;
			outlineWidth=0;
			titleWidth=0;
			this.mouseEnabled=false;
		}
		public function setup(pm_title:String="",pm_rect:Rectangle=null,pm_v:Boolean=true):void {

			outlineHeight=pm_rect.height;
			outlineWidth=pm_rect.width;

			//set title
			
			if(!titlebox.contains(title_txt)){
				titlebox.addChild(title_txt);
				this.addEventListener(Event.REMOVED,removed);
			}
			title_txt.setup(pm_title);

			if (pm_title=="") {
				titleWidth=0;
			} else {
				titleWidth=title_txt.width+title_space;
			}
			//set outline
			if (outlineHeight !=0 && outlineWidth!=0) {
				setOutline(pm_v);
			} 
			
			
		}
		public function animIn(re_chk:Boolean=false):void {
			if (!re_chk) {
				this.gotoAndPlay("in");
			} else {
				this.gotoAndPlay("re");
				//Anim.fadeIn(this,0.4);
			}
		}

		private function setOutline(pm_v:Boolean=true):void {
			var top_x:int;
			if(!pm_v){
				line_left.alpha=line_right.alpha=line_top.alpha=line_bottom.alpha=line_short.alpha=0;
				angel_tr.alpha=angel_tl.alpha=angel_br.alpha=angel_bl.alpha=point_right.alpha=point_left.alpha=0;
			}
			if (titleWidth==0) {
				point_right.visible=point_left.visible=false;
				top_x=angel_tl.width+angel_tl.x;
			} else {
				top_x=titleWidth+titlebox.x;
			}
			line_right.height=line_left.height=outlineHeight-(angel_bl.height+angel_tl.height);
			line_right.x=outlineWidth-line_right.width;
			line_bottom.width=outlineWidth-(angel_bl.width+angel_br.width);
			line_bottom.y=outlineHeight-line_bottom.height;
			line_top.width=line_bottom.width-top_x;
			line_top.x=outlineWidth-(line_top.width+angel_tr.width);
			point_right.x=line_top.x-point_right.width;
			angel_tr.x=outlineWidth-angel_tr.width;
			angel_br.x=outlineWidth-angel_br.width;
			angel_br.y=outlineHeight-angel_br.height;
			angel_bl.y=outlineHeight-angel_bl.height;
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				
				for (var i:int=titlebox.numChildren-1; i>=0; i--) {
					titlebox.removeChildAt(0);
				}
				this.gotoAndStop("stop");
				
			}
		}
	}
}