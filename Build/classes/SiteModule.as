package {
	import flash.display.MovieClip;
	import flash.events.Event;

	import comps.*;
	import rotationmenu.*;
	import views.*;

	public class SiteModule extends MovieClip {

		//object preplace
		private var cursor:HandCursor=new HandCursor();
		private var tips:Tips=new Tips();
		
		//variable preplace
		private var type:String="module";

		public function SiteModule() {
			this.addEventListener(Event.REMOVED,removed);
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				
			}
		}
		
		
		
		public function addScreen(target:Object):void {
			target.addChild(tips);
			target.addChild(cursor);
		}
		
		
		public function newGTextField():GTextField {
			var tmp_tf=new GTextField();
			return tmp_tf;
		}
		
		public function newRotationMenu():RotationMenu {
			var tmp_rm=new RotationMenu();
			return tmp_rm;
		}
		
		public function get getType():String{
			return type;
		}
	}
}