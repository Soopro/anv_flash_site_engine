package jumpmenu{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.filters.BlurFilter;
	
	import tools.*;

	public class JumpButton extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField();

		//variable preplace
		private var btnWidth:int=0;

		private var space:int=10;
		private var topspace:int=2;

		private var listenerCheck:Boolean=false;


		public function JumpButton() {
			btnWidth=0;
			txt.mouseEnabled=false;
			this.mouseEnabled=false;
			listenerCheck=false;
		}
		public function setup(pm_w:int=0,str:String="------"):void {
			if (str!="") {
				txt=new TextField();
				txt.defaultTextFormat = TextStyle.getInputFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				txt.htmlText=str;
				btn_txt.addChild(txt);
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = 0;
				blur.blurY = 0;
				txt.filters = [blur];
				btn_txt.alpha=0.6
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
			txt.htmlText=str;
		}
		
		private function setButton():void {
			
			btn.btn_bg.x=btn.btn_left.x+btn.btn_left.width;
			btn.btn_bg.width=btnWidth-(btn.btn_left.width+btn.btn_right.width);
			btn.btn_right.x=btn.btn_bg.x+btn.btn_bg.width;
			txt.y=btn.btn_bg.y+topspace;
			txt.x=btn.btn_bg.x;
			area.width=this.width;
			icons.ico.x=btn.btn_right.x-space/2;
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