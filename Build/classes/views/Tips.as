package views{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;

	public class Tips extends MovieClip {

		//variable preplace
		private var seted:Boolean=false;
		//object preplace
		private var txt:TextField=new TextField();

		public function Tips() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.addEventListener(Event.ADDED,added);
			this.visible=false;
		}
		private function added(event:Event):void {

			if (event.target==this && stage!=null) {
				this.removeEventListener(Event.ADDED,added);

				stage.addEventListener(Site.TIPS_ON,tipsHandler,false,0,true);
				stage.addEventListener(Site.TIPS_OFF,tipsHandler,false,0,true);

				this.addEventListener(Event.REMOVED,removed);
				
				txt.defaultTextFormat = TextStyle.getUiFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=-50;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				txt.htmlText=Site.tips;
				
				box.addChild(txt);
				this.addEventListener(Event.REMOVED,removed);

			}
			
		}
		private function tipsHandler(event:Event):void {
			switch (event.type) {
				case Site.TIPS_ON :
					setTips();
					break;
				case Site.TIPS_OFF :
					removeTips();
					break;
			}
		}
		private function setTips():void {
			this.visible=true;
			txt.htmlText=Site.tips;
			box.bg.x=box.leftbar.x+box.leftbar.width;
			box.bg.width=txt.width;
			box.rightbar.x=box.bg.x+box.bg.width;
			txt.x=Math.round(box.bg.x);
			txt.y=Math.round(box.bg.y+2);

			this.gotoAndPlay("on");
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moving,false,0,true);
			//addEventListener(Event.ENTER_FRAME,moving);
		}
		private function removeTips():void {
			if (currentLabel=="open") {
				this.gotoAndPlay("off");
			} else {
				this.gotoAndStop("stop");
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moving);
			//removeEventListener(Event.ENTER_FRAME,moving);
		}

		private function moving(event:MouseEvent):void {
			this.x=stage.mouseX+15;
			this.y=stage.mouseY+15;
		}
		//this funciton use on timeline, layer 'action' when animation finish.
		private function finish():void {
			this.visible=false;
			this.gotoAndStop("stop");
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				box.removeChild(txt);
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,moving);
				stage.removeEventListener(Site.TIPS_ON,tipsHandler);
				stage.removeEventListener(Site.TIPS_OFF,tipsHandler);
				
				
			}
		}
	}
}