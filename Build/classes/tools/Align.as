package tools{
	public class Align {
		private static  var page_w:Number;
		private static  var page_h:Number;

		public function Align():void {

		}
		public static function setup(w:Number=600,h:Number=600):void {
			page_w=w;
			page_h=h;
		}
		public static function center(target1:*,target2:*=null,w:Number=0,h:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {
				target1.x=Math.round(page_w/2-target1.width/2)+w;
				target1.y=Math.round(page_h/2-target1.height/2)+h;
			} else {
				target1.x=Math.round(target2.width/2+target2.x-target1.width/2)+w;
				target1.y=Math.round(target2.height/2+target2.y-target1.height/2)+h;
			}
			if(intCheck){
				target1.x=Math.round(target1.x)
				target1.y=Math.round(target1.y)
			}
		}
		public static function centerX(target1:*,target2:*=null,w:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {
				target1.x=Math.round(page_w/2-target1.width)+w;

			} else {
				target1.x=Math.round(target2.width/2+target2.x-target1.width/2)+w;
			}
			if(intCheck){
				target1.x=Math.round(target1.x)
			}
		}
		public static function centerY(target1:*,target2:*=null,h:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {

				target1.y=Math.round(page_h/2-target1.height)+h;
			} else {

				target1.y=Math.round(target2.height/2+target2.y-target1.height/2)+h;
			}
			if(intCheck){
				target1.y=Math.round(target1.y)
			}
		}
		
		public static function heart(target1:*,target2:*=null,w:Number=0,h:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {
				target1.x=Math.round(page_w/2)+w;
				target1.y=Math.round(page_h/2)+h;
			} else {
				target1.x=Math.round(target2.width/2+target2.x)+w;
				target1.y=Math.round(target2.height/2+target2.y)+h;
			}
			if(intCheck){
				target1.x=Math.round(target1.x)
				target1.y=Math.round(target1.y)
			}
		}
		public static function heartX(target1:*,target2:*=null,w:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {
				target1.x=Math.round(page_w/2)+w;

			} else {
				target1.x=Math.round(target2.width/2+target2.x)+w;
			}
			if(intCheck){
				target1.x=Math.round(target1.x)
			}
		}
		public static function heartY(target1:*,target2:*=null,h:Number=0,intCheck:Boolean=true):void {
			if (target2==null) {

				target1.y=Math.round(page_h/2)+h;
			} else {

				target1.y=Math.round(target2.height/2+target2.y)+h;
			}
			if(intCheck){
				target1.y=Math.round(target1.y)
			}
		}
		
		public static function same(target1:*,...targets):void {
			for (var i:uint = 0; i < targets.length; i++) {
				targets[i].x=target1.x;
				targets[i].y=target1.y;
				targets[i].width=target1.width;
				targets[i].height=target1.height;
			}
		}
	}
}