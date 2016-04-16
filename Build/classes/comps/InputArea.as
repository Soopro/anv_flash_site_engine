package comps{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;

	import comps.scrollbar.*;
	import tools.*;

	public class InputArea extends MovieClip {

		//events preplace
		private var added_event:Event=new Event(Site.FORM_ADDED,true,false);
		private var removed_event:Event=new Event(Site.FORM_REMOVED);

		//object preplace
		private var txt:TextField=new TextField  ;
		private var scrollbar:ScrollUI=new ScrollUI  ;
		private var pattern:RegExp=new RegExp();

		//variable preplace
		private var areaHeight:int=0;
		private var areaWidth:int=0;
		private var seted:Boolean=false;

		private var key:String="";
		private var form:String="";
		private var max:int=600;
		private var optional:Boolean=false;
		private var error:Boolean=false;
		private var preplace:String="";
		private var perpCheck:Boolean=true;
		private var color:*;

		public function InputArea() {
			this.mouseEnabled=false;
			areaHeight=0;
			areaWidth=0;
			seted=false;
			key="";
			form="";
			preplace="";
			max=600;
			optional=false;
			error=false;
			perpCheck=true;
			pattern=new RegExp();

		}
		public function setup(pm_w:int=0,pm_h:int=0,pm_key:String="",pm_form:String="",pm_max:int=600,op:Boolean=false,pm_prep:String="",pm_pattern:String=""):void {
			areaWidth=pm_w;
			areaHeight=pm_h;
			preplace=pm_prep;
			key=pm_key;
			form=pm_form;
			optional=op;
			pattern=new RegExp(pm_pattern);
			
			if (pm_max != 0) {
				max=pm_max;
			}

			if (areaWidth != 0 && areaHeight != 0) {

				setArea();
				var tmp_area:Object=new Object  ;
				Align.same(bg,tmp_area);
				tmp_area.width-= 4;

				addChild(scrollbar);
				scrollbar.setup(tmp_area,tmp_area.height);
				scrollbar.setAlpha(0.5);

				if (! seted) {
					txt.defaultTextFormat=TextStyle.getInputFormat;
					txt.type=TextFieldType.INPUT;
					txt.embedFonts=false;
					txt.selectable=true;
					txt.multiline=true;
					txt.wordWrap=true;
					txt.maxChars=max;
					setError();
					reset();//cheat for fix text field  bug, first time fill max charecter and focus back. TextFormat will no longer to used.

					//txt.antiAliasType = AntiAliasType.ADVANCED;
					//txt.thickness=200;
					//txt.sharpness=200;
					//txt.styleSheet=TextStyle.getStyleSheet;
					txt.width=bg.width;
					txt.height=bg.height;

					txt.x=bg.x;
					txt.y=bg.y;

					color=TextStyle.getInputFormat.color;
					seted=true;
				}
				if (! this.contains(txt)) {
					addChild(txt);
					txt.text=preplace;
					txt.addEventListener(Event.CHANGE,inputHandler);
					txt.addEventListener(FocusEvent.FOCUS_IN,focusHandler);
					this.addEventListener(Event.REMOVED,removed);
				}
				this.visible=true;
				dispatchEvent(added_event);
			} else {
				this.visible=false;
			}
		}
		public function reset():void {
			perpCheck=true;
			error=false;
			txt.textColor=color;
			txt.setTextFormat(TextStyle.getInputFormat);
			txt.text=preplace;
		}

		private function setArea():void {
			right.height=left.height=areaHeight - bl.height - tl.height;
			right.x=areaWidth - right.width;
			bottom.width=areaWidth - bl.width - br.width;
			bottom.y=areaHeight - bottom.height;
			top.width=bottom.width;
			top.x=areaWidth - top.width - tr.width;
			tr.x=areaWidth - tr.width;
			br.x=areaWidth - br.width;
			br.y=areaHeight - br.height;
			bl.y=areaHeight - bl.height;
			bg.width=top.width;
			bg.height=right.height;
		}
		private function inputHandler(event:Event):void {
			var percent=txt.length / txt.maxChars;
			scrollbar.scrollTo(percent);
		}
		private function focusHandler(event:FocusEvent):void {
			if (error || perpCheck) {
				txt.textColor=color;
				txt.setTextFormat(TextStyle.getInputFormat);
				txt.text="";
				error=false;
				perpCheck=false;
			}
		}
		private function setError(has:Boolean=false):void {
			txt.textColor=SiteStyle.getFormError.color;
			if(has){
				txt.text=SiteStyle.getFormError.input;
			}else{
				txt.text=SiteStyle.getFormError.empty;
			}
			error=true;
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				if (this.contains(txt)) {
					removeChild(txt);
				}
				color=null;
				dispatchEvent(removed_event);
				txt.removeEventListener(Event.CHANGE,inputHandler);
				txt.removeEventListener(FocusEvent.FOCUS_IN,focusHandler);
			}
		}
		
		
		public function prepareData():void{
			if (perpCheck) {
				txt.text="";
			}
			if(txt.text!="" && !pattern.test(txt.text)){
				setError(true);
			}
			if (txt.text=="" && !optional) {
				setError();
			}
			
		}
		//get
		public function get getData():String {
			return txt.text;
		}

		public function get getKey():String {
			return key;
		}
		public function get getForm():String {
			return form;
		}
		public function get getError():Boolean {
			return error;
		}
	}
}