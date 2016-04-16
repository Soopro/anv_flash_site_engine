package views{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.*;

	public class SoundBtn extends MovieClip {


		private var sound_mute_event:Event=new Event(Site.SOUND_TO_MUTE,true,false);
		private var sound_unmute_event:Event=new Event(Site.SOUND_UN_MUTE,true,false);
		//object preplace
		private var txt:TextField=new TextField;

		//variable preplace

		private var seted:Boolean=false;
		private var listenerCheck:Boolean=false;
		private var mute:Boolean=false;

		public function SoundBtn() {
			txt.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (!seted && pm_xml != null) {
				txt=new TextField();
				txt.defaultTextFormat=TextStyle.getDesFormat;
				txt.type=TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txtbox.addChild(txt);
				txt.htmlText=pm_xml;
				this.addEventListener(Event.REMOVED,removed);
				seted=true;
				if (pm_xml.@mute==1){
					mute=true;
				}
				dispatchMute(mute)
			}
		}
		public function active():void {
			if (seted) {
				this.gotoAndPlay("in");
				addListeners();
			}
		}
		
		private function addListeners():void {
			btn.addEventListener(MouseEvent.ROLL_OVER,btnHandler);
			btn.addEventListener(MouseEvent.ROLL_OUT,btnHandler);
			btn.addEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
			btn.addEventListener(MouseEvent.MOUSE_UP,btnHandler);
			btn.addEventListener(MouseEvent.CLICK,btnHandler);
			btn.buttonMode=true;
			btn.tabEnabled=false;
			listenerCheck=true;
		}
		private function removeListeners():void {
			if (listenerCheck) {
				btn.removeEventListener(MouseEvent.ROLL_OVER,btnHandler);
				btn.removeEventListener(MouseEvent.ROLL_OUT,btnHandler);
				btn.removeEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
				btn.removeEventListener(MouseEvent.MOUSE_UP,btnHandler);
				btn.removeEventListener(MouseEvent.CLICK,btnHandler);
				listenerCheck=false;
			}
		}
		private function btnHandler(event:MouseEvent):void {
			if (currentLabel !="in") {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						btn.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						btn.gotoAndPlay("off");
						break;
					case MouseEvent.MOUSE_DOWN :
						btn.gotoAndPlay("press");
						break;
					case MouseEvent.MOUSE_UP :
						btn.gotoAndPlay("on");
						break;
					case MouseEvent.CLICK :
						mute=!mute;
						dispatchMute(mute)
						break;
				}
			}
		}
		
		private function dispatchMute(chk:Boolean=false):void{
			if(chk){
				dispatchEvent(sound_mute_event);
				btn.ico.gotoAndStop("off")
			}else{
				dispatchEvent(sound_unmute_event);
				btn.ico.gotoAndStop("on")
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
				removeChildren(this);
				removeListeners();
			}
		}
		//get
		public function get getMute():Boolean{
			return mute;
		}
	}
}