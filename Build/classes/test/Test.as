package test{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.*;

	import GText.*;
	import net.*;

	public class Test extends MovieClip {
		
		private static  var arr:Array=new Array();
		private static var order:int=0;

		public function Test() {
			
		}
		
		public static function addTest(xml:XML):GTextField {
			arr[order]=new GTextField();
			arr[order].setup(xml);
			
			return arr[order];
			order++;
		}
		
	}
}