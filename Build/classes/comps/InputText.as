package comps{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.*;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;


	import tools.*;

	public class InputText extends MovieClip {

		//events preplace
		private var form_event:Event=new Event(Site.FORM_ADDED,true,false);
		private var removed_event:Event=new Event(Site.FORM_REMOVED);

		//object preplace
		private var txt:TextField=new TextField();
		private var pattern:RegExp=new RegExp();


		//variable preplace
		private var areaWidth:int=0;
		private var seted:Boolean=false;

		private var key:String="";
		private var form:String="";
		private var max:int=60;
		private var optional:Boolean=false;
		private var error:Boolean=false;
		private var perpCheck:Boolean=true;
		private var space:int=1;
		private var preplace:String="";
		private var color:*;

		public function InputText() {
			this.mouseEnabled=false;
			areaWidth=0;
			seted=false;
			key="";
			form="";
			preplace="";
			max=60;
			optional=false;
			error=false;
			perpCheck=true;
			pattern=new RegExp();
		}
		public function setup(pm_w:int=0,pm_key:String="",pm_form:String="",pm_max:int=60,op:Boolean=false,pm_prep:String="",pm_pattern:String=""):void {
			areaWidth=pm_w;
			preplace=pm_prep;
			key=pm_key;
			form=pm_form;
			optional=op;
			pattern=new RegExp(pm_pattern);
			
			if (pm_max!=0) {
				max=pm_max;
			}
			if (areaWidth!=0) {

				setArea();

				if (!seted) {
					txt.defaultTextFormat = TextStyle.getInputFormat;
					txt.type = TextFieldType.INPUT;
					txt.embedFonts=false;
					txt.selectable=true;
					txt.multiline=false;
					txt.wordWrap=true;
					txt.maxChars=max;
					//txt.antiAliasType = AntiAliasType.ADVANCED;
					//txt.thickness=200;
					//txt.sharpness=200;
					setError();
					reset();//cheat for fix text field  bug, first time fill max charecter and focus back. TextFormat will no longer to used.

					txt.width=bg.width;
					txt.height=bg.height;
					txt.x=bg.x;
					txt.y=bg.y+space;
					color=TextStyle.getInputFormat.color;
					seted=true;

				}
				if (!this.contains(txt)) {
					addChild(txt);
					txt.text=preplace;
					txt.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
					this.addEventListener(Event.REMOVED,removed);
				}
				this.visible=true;
				dispatchEvent(form_event);
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
			bg.width=areaWidth-left.width-right.width;
			bg.x=left.width+left.x;
			right.x=bg.x+bg.width;
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
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				if (this.contains(txt)) {
					removeChild(txt);
				}
				color=null;
				txt.removeEventListener(FocusEvent.FOCUS_IN, focusHandler);
				dispatchEvent(removed_event);
				
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