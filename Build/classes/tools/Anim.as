package tools{
	import flash.events.Event;
	
	public class Anim {


		public function Anim():void {

		}

		public static function fadeIn(obj:Object,speed:Number=0.1,pos:Number=1):void {
			obj.alpha=0;

			obj.addEventListener(Event.ENTER_FRAME,fadeInEffect);
			function fadeInEffect(event:Event):void {
				if (obj.alpha<pos) {
					obj.alpha+=speed;
				} else {
					obj.alpha=pos;
					
					obj.removeEventListener(Event.ENTER_FRAME,fadeInEffect);
				}
			}
		}
		
		public static function fadeOut(obj:Object,speed:Number=0.1,pos:Number=0):void {

			obj.addEventListener(Event.ENTER_FRAME,fadeOutEffect);
			function fadeOutEffect(event:Event):void {
				if (obj.alpha>pos) {
					obj.alpha-=speed;
				} else {
					obj.alpha=pos;
					
					obj.removeEventListener(Event.ENTER_FRAME,fadeOutEffect);
				}
			}
		}
	}
}