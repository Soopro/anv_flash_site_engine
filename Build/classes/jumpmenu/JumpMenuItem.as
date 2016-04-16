package jumpmenu{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.filters.BlurFilter;

	import tools.*;

	public class JumpMenuItem extends MovieClip {

		//events preplace
		private var drop_event:Event=new Event(Site.DROP_CLICKED,true,false);

		//object preplace
		private var txt:TextField=new TextField();

		//variable preplace
		private var btnWidth:int=100;

		private var dat:String="";
		private var order:int=0;
		private var space:int=5;
		private var topspace:int=0;
		private var listenerCheck:Boolean=false;
		private var item_str:String="";


		public function JumpMenuItem() {
			btnWidth=100;
			order=0;
			dat="";
			item_str="";
			listenerCheck=false;
			txt.mouseEnabled=false;
			this.mouseEnabled=false;
		}
		public function setup(pm_dat:String="",str:String="",pm_order:int=0,pm_w:int=100):void {
			order=pm_order;
			item_str=str;
			dat=pm_dat;
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

			}

			btnWidth=pm_w;


			//set button
			if (btnWidth !=0 ) {
				setButton();
			}

			this.addEventListener(Event.REMOVED,removed);
			addListeners();
		}
		private function setButton():void {
			btn.bg.width=btnWidth;
			btn.bg.height=this.height;
			txt.x+=space;
			txt.y+=topspace;
			Align.same(this,area);
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
				case MouseEvent.CLICK :
					dispatchEvent(drop_event);
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
				removeChildren(btn_txt);

				removeListeners();
			}
		}
		//get
		public function get getData():String {
			return dat;
		}
		public function get getOrder():int {
			return order;
		}
		public function get getTxt():String {
			return item_str;
		}
	}
}