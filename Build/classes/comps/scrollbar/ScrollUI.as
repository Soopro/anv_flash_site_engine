package comps.scrollbar{
	import flash.display.MovieClip;
	import flash.events.Event;

	import tools.*;
	import comps.images.AreaSprite;

	public class ScrollUI extends MovieClip {

		//object preplace
		private var mask_area:AreaSprite=new AreaSprite();

		//variable preplace
		private var scrollHeight:int=0;
		private var pos:int=0;

		private var scrollCheck:Boolean=false;


		public function ScrollUI() {
			scrollHeight=0;
			pos=0;
			scrollCheck=false;
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.addEventListener(Event.REMOVED,removed);
		}
		public function setup(pm_mask:Object,pm_h:int=0):void {

			var tmp_pos:int=SiteStyle.getScroll.pos;
			this.x=tmp_pos+pm_mask.width+pm_mask.x;
			this.y=pm_mask.y;

			scrollHeight=pm_h;


			//set outline
			if (scrollHeight !=0 ) {
				setScroll();
			}
		}
		public function scrollTo(percent:Number):void {
			pos=scroll_bg.height*percent;
			if (!scrollCheck) {
				addEventListener(Event.ENTER_FRAME,scrolling);
				scrollCheck=true;
			}
		}

		private function scrolling(event:Event):void {

			
			var tmp_h:Number=(line.height-pos)/SiteStyle.getScroll.speed;
			if (tmp_h>-1 && tmp_h<0) {
				tmp_h=-1;
			}
			var tmp_dh:int=line.height-Math.ceil(tmp_h);;
			line.height=tmp_dh;
			if (line.height==pos) {
				removeEventListener(Event.ENTER_FRAME,scrolling);
				scrollCheck=false;
			}
		}
		private function setScroll():void {
			scroll_bg.y=scroll_top.height+scroll_top.y;
			scroll_bg.height=scrollHeight-scroll_top.height-scroll_bottom.height;
			scroll_bottom.y=scroll_bg.height+scroll_bg.y;
			mask_area.set(scroll_bg.width,scroll_bg.height,scroll_bg.x,scroll_bg.y);
			line.height=0;
			line.y=scroll_bg.y;
			line.mask=mask_area;
			addChild(mask_area);
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
				if (scrollCheck) {
					removeEventListener(Event.ENTER_FRAME,scrolling);
					scrollCheck=false;
				}
			}
		}
		public function setAlpha(alph:Number):void {
			line.alpha=alph;
		}
	}
}