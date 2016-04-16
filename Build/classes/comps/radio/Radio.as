package comps.radio{
	import flash.display.Sprite;
	import flash.events.Event;

	import tools.*;
	import comps.*;

	public class Radio extends Sprite {

		//events preplace
		private var form_event:Event=new Event(Site.FORM_ADDED,true,false);
		private var removed_event:Event=new Event(Site.FORM_REMOVED);

		//object preplace
		private var item_arr:Array=new Array();

		//variable preplace

		private var seted:Boolean=false;
		private var partspace:int=0;
		private var form:String="";
		private var error:Boolean=false;
		private var key:String="";
		private var currRadio:int=0;
		private var preplace:int=0;
		private var multiterm:Boolean=false;


		public function Radio() {
			this.mouseEnabled=false;
			item_arr=[];
			seted=false;
			form="";
			key="";
			partspace=0;
			currRadio=0;
			preplace=0;
			multiterm=false;
			error=false;
		}
		public function setup(pm_xml:XML=null,pm_form:String="",pm_key:String="",pm_w:int=0):void {
			if (pm_xml!=null) {

				form=pm_form;
				key=pm_key;

				if (pm_xml.@partspace != undefined) {
					partspace=pm_xml.@partspace;
				} else {
					partspace=TextStyle.getParagraph.partspace;
				}
				if (pm_xml.@multi == 1) {
					multiterm=true;
				}
				for (var i:int=0; i<pm_xml.children().length(); i++) {
					item_arr[i]=new RadioItem();
					addChild(item_arr[i]);
					item_arr[i].setup(pm_xml.children()[i].@dat,pm_xml.children()[i],i,pm_xml.children()[i].@w);

					if (pm_xml.children()[i].@x!=undefined) {
						item_arr[i].x=pm_xml.children()[i].@x;
					} else {
						if (i>0) {
							item_arr[i].x=Math.round(item_arr[i-1].x+item_arr[i-1].width)+partspace;
						}
					}
					if (pm_xml.children()[i].@y!=undefined) {
						item_arr[i].y=pm_xml.children()[i].@y;
					} else {
						if (i>0) {
							item_arr[i].y=item_arr[i-1].y;
						}
					}
					if (item_arr[i].x+item_arr[i].width>pm_w && i>0) {
						item_arr[i].x=0;
						item_arr[i].y=this.height+partspace;
					}
					if (pm_xml.children()[i].@select!=undefined) {
						preplace=i;
					}
				}
				if (!multiterm) {
					currRadio=preplace;
					select(preplace);
				}else{
					for (var j:int=0; j<pm_xml.children().length(); j++) {
						if (pm_xml.children()[j].@select!=undefined) {
							select(j);
						}
					}
				}
				addEventListener(Site.RADIO_CLICKED,selectHandler);
				this.addEventListener(Event.REMOVED,removed);
				this.visible=true;
				dispatchEvent(form_event);
			} else {
				this.visible=false;
			}
		}
		public function reset():void {
			unselect();
			if (!multiterm) {
				currRadio=preplace;
				select(preplace);
			}
		}

		private function selectHandler(event:Event):void {
			var obj=event.target;
			if (!multiterm) {
				unselect();
			}
			if (!obj.checkSelect) {
				select(obj.getOrder);
				currRadio=obj.getOrder;
			} else {
				obj.unselect();
			}
			event.stopPropagation();
		}
		private function select(order:int):void {

			item_arr[order].select();

		}
		private function unselect():void {
			for each (var ra:RadioItem in item_arr) {
				ra.unselect();
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				dispatchEvent(removed_event);
				item_arr=[]
				;
			}
		}
		public function prepareData():void {
			error=false;
		}
		//get
		public function get getData():String {
			var tmp_data:String="";
			for (var i:int=0; i<item_arr.length; i++) {
				if (item_arr[i].checkSelect) {
					tmp_data+=item_arr[i].getData;
					if (multiterm) {
						tmp_data+="+";
					}
				}
			}
			//tmp_data=item_arr[currRadio].getData;
			return tmp_data;
		}
		public function get getForm():String {
			return form;
		}
		public function get getKey():String {
			return key;
		}
		public function get getError():Boolean {
			return error;
		}
	}
}