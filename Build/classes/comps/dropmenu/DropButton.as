package comps.dropmenu{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import tools.*;
	import comps.*;

	public class DropButton extends MovieClip {

		//object preplace
		private var txt:UiText=new UiText();

		//variable preplace
		private var btnWidth:int=0;

		private var space:int=10;
		private var topspace:int=2;

		private var listenerCheck:Boolean=false;


		public function DropButton() {
			btnWidth=0;
			txt.mouseEnabled=false;
			btn.mouseEnabled=false;
			area.mouseEnabled=false;
			icons.mouseEnabled=false;
			this.mouseChildren=false;
			listenerCheck=false;
		}
		public function setup(pm_w:int=0,str:String="------"):void {
			if (str!="") {
				txt.setup(str);
				btn_txt.addChild(txt);
			}

			if (pm_w!=0) {
				btnWidth=pm_w;
			} else {
				btnWidth=Math.round(txt.width+space)+(btn.btn_left.width+btn.btn_right.width);
			}

			//set button
			if (btnWidth !=0 ) {
				setButton();
			}
			this.addEventListener(Event.REMOVED,removed);
			addListeners();
		}
		public function select(str:String) {
			txt.setup(str);
		}
		
		private function setButton():void {
			
			btn.btn_bg.x=btn.btn_left.x+btn.btn_left.width;
			btn.btn_bg.width=btnWidth-(btn.btn_left.width+btn.btn_right.width);
			btn.btn_right.x=btn.btn_bg.x+btn.btn_bg.width;
			txt.y=btn.btn_bg.y+topspace;
			txt.x=btn.btn_bg.x;
			area.width=this.width;
			icons.ico.x=btn.btn_right.x;
			this.buttonMode=true;
			this.tabEnabled=false;
			
		}

		private function addListeners():void {
			addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			addEventListener(MouseEvent.CLICK,mouseHandler);
			listenerCheck=true;
		}
		private function removeListeners():void {
			if (listenerCheck) {
				removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				removeEventListener(MouseEvent.CLICK,mouseHandler);
				listenerCheck=false;
				this.buttonMode=false;
			}
		}
		private function mouseHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					this.gotoAndPlay("on");
					//dispatchEvent(roll_event);
					break;
				case MouseEvent.ROLL_OUT :
					this.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					this.gotoAndPlay("press");
					break;
				case MouseEvent.MOUSE_UP :
					this.gotoAndPlay("on");
					break;
			}
		}
		
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeChildren(btn_txt)
				
				removeListeners();
			}
		}		
	}
}