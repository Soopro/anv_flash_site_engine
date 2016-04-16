package {


	public class SiteStyle {


		//object preplace
		private static  var imageSize:Object=new Object();
		private static  var buttonSize:Object=new Object();
		private static  var loaderTxt:Object=new Object();
		private static  var scrollbar:Object=new Object();
		private static  var arrows:Object=new Object();
		private static  var back:Object=new Object();
		private static var formerror:Object=new Object();
		private static var top:Object=new Object();
		
		private static var page_out:Boolean=true;
		
		

		public function SiteStyle() {

		}
		public static function setup(display:XML):void {
			
			//top
			top.x=display.top.@x;
			top.y=display.top.@y;
			//ui text
			loaderTxt.site=display.loader.site;
			loaderTxt.clip=display.loader.clip;
			loaderTxt.error=display.loader.error;
			loaderTxt.nodata=display.loader.nodata;

			//img
			imageSize.width=display.images.@w;
			imageSize.height=display.images.@h;

			//button
			buttonSize.width=display.button.@w;
			
			//scroll
			scrollbar.pos=display.scroll.@pos;
			scrollbar.speed=display.scroll.@speed;
			scrollbar.alpha=display.scroll.@alpha;
			scrollbar.tips=display.scroll.tips;
			
			//arrow
			arrows.rx=display.arrows.@rx;
			arrows.ry=display.arrows.@ry;
			
			//back
			back.txt=display.back;
			
			//form error
			formerror.empty=display.formerror.empty;
			formerror.input=display.formerror.input;
			formerror.color=display.formerror.@color;
			formerror.failed=display.formerror.failed;
			formerror.ok=display.formerror.ok;
			
			//page out anim
			if(display.page.@animout==0){
				page_out=false;
			}
		}
		//get
		public static function get getTop():Object{
			return top;
		}
		public static function get getImageSize():Object {
			return imageSize;
		}
		public static function get getButtonSize():Object {
			return buttonSize;
		}
		public static function get getloaderTxt():Object {
			return loaderTxt;
		}
		public static function get getScroll():Object {
			return scrollbar;
		}
		public static function get getArrows():Object {
			return arrows;
		}
		
		public static function get getBack():Object {
			return back;
		}
		
		public static function get pageOutAnim():Boolean{
			return page_out;
		}
		public static function get getFormError():Object {
			return formerror;
		}
		
	}
}