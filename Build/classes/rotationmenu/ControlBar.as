package rotationmenu{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	import tools.*;

	public class ControlBar extends MovieClip {


		//Object preplace
		private var txt:TextField=new TextField();

		private var left_event:Event=new Event("go_left");
		private var right_event:Event=new Event("go_right");

		//variable preplace
		private var seted:Boolean=false;
		private var item:int=0;
		private var total:int=0;
		private var info:String="";
		private var last_item:String="&P";
		private var last_total:String="&T";
		private var space=3;

		public function ControlBar() {
			clean();
			txt.mouseEnabled=false;
		}
		public function setup(pm_info:String=""):void {
			if(pm_info!=null){
				info=pm_info;
			}

			if (!seted) {
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getUiCFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.thickness=-50;
				txt.sharpness=200;
				txt.width=bg.width;
				txt.height=bg.height;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.x=bg.x;
				txt.y=bg.y+space;
				txt.styleSheet=TextStyle.getStyleSheet;
				

				addChild(txt);
				txt.htmlText="";
				seted=true;
				this.addEventListener(Event.REMOVED,removed);
				addEventListners(aw_l,aw_r);
			}
		}
		private function addEventListners(...objs):void {
			for (var i:int=0; i<objs.length; i++) {
				objs[i].addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				objs[i].addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				objs[i].addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				objs[i].addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				objs[i].addEventListener(MouseEvent.CLICK,mouseHandler);
				objs[i].buttonMode=true;
				objs[i].tabEnabled=false;
				objs[i].mouseChildren=false;
			}
		}
		private function removeEventListners(...objs):void {
			for (var i:int=0; i<objs.length; i++) {
				objs[i].removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				objs[i].removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				objs[i].removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				objs[i].removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				objs[i].removeEventListener(MouseEvent.CLICK,mouseHandler);
			}
		}
		private function mouseHandler(event:Event):void {
			var obj=event.currentTarget;
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					obj.gotoAndPlay("on");
					break;
				case MouseEvent.ROLL_OUT :
					obj.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					obj.gotoAndPlay("press");
					break;
				case MouseEvent.MOUSE_UP :
					obj.gotoAndPlay("on");
					break;
				case MouseEvent.CLICK :
					if (obj==aw_l) {
						dispatchEvent(right_event);
					}
					if (obj==aw_r) {
						dispatchEvent(left_event);
					}
					break;
			}
		}
		private function clean():void {
			item=0;
			total=0;
			info="";
			last_item="&P";
			last_total="&T";
			txt=new TextField();
			seted=false;
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				
				removeEventListners(aw_l,aw_r);
				removeChild(txt)
				clean();
			}
		}
		//set
		public function doChange(_it:int,_tol:int):void {
			item=_it;
			total=_tol;
			info=info.replace(last_item,item);
			info=info.replace(last_total,total);
			txt.htmlText=info;
			last_item=item.toString();
			last_total=total.toString();
		}
	}
}