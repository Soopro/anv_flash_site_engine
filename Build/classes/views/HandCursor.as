package views{
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import tools.*;

	public class HandCursor extends MovieClip {

		//variable preplace
		private var report:HandReport=new HandReport();
		private var sendingTimeOut:int=1600;

		public function HandCursor() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.addEventListener(Event.ADDED,added);
			hand.visible=false;
			sender.visible=false;
		}
		private function added(event:Event):void {
			if (event.target==this && stage!=null) {
				this.removeEventListener(Event.ADDED,added);

				addChild(report);
				report.x=6;
				report.y=-30;
				stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);

				stage.addEventListener(Site.CURSOR_ON,cursorHandler);
				stage.addEventListener(Site.CURSOR_OFF,cursorHandler);


				stage.addEventListener(Site.FORM_SENDING,cursorHandler);
				stage.addEventListener(Site.FORM_SENT,cursorHandler);
				stage.addEventListener(Site.FORM_ERROR,cursorHandler);

				this.addEventListener(Event.REMOVED,removed);
			}
		}
		private function cursorHandler(event:Event):void {
			switch (event.type) {
				case Site.CURSOR_ON :
					Mouse.hide();
					hand.visible=true;
					Anim.fadeIn(this,0.5);
					break;
				case Site.CURSOR_OFF :
					hand.visible=false;
					Mouse.show();
					break;
				case Site.FORM_SENDING :
					sender.visible=true;
					sendingTimeOut=0;
					break;
				case Site.FORM_SENT :
					sender.visible=false;
					report.setup(SiteStyle.getFormError.ok,true);
					break;
				case Site.FORM_ERROR :
					sender.visible=false;
					report.setup(SiteStyle.getFormError.failed,false);
					break;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN :
					hand.gotoAndPlay("on");
					break;
				case MouseEvent.MOUSE_UP :
					hand.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_MOVE :
					this.x=stage.mouseX;
					this.y=stage.mouseY;
					if (sender.visible) {
						if (sendingTimeOut<1600) {
							sendingTimeOut++;
						} else {

							sender.visible=false;
							report.setup(SiteStyle.getFormError.failed,false);
						}
					}
					break;
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {

				this.removeEventListener(Event.REMOVED,removed);

				stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);

				stage.removeEventListener(Site.CURSOR_ON,cursorHandler);
				stage.removeEventListener(Site.CURSOR_OFF,cursorHandler);
			}
		}
	}
}