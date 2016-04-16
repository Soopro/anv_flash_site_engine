package comps.dropmenu{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import tools.*;
	import comps.*;

	public class DropMenu extends MovieClip {

		//events preplace
		private var form_event:Event=new Event(Site.FORM_ADDED,true,false);
		private var removed_event:Event=new Event(Site.FORM_REMOVED);

		//object preplace
		private var item_arr:Array=new Array();
		private var view_arr:Array=new Array();
		private var itembox:Sprite=new Sprite();

		//variable preplace

		private var seted:Boolean=false;
		private var partspace:int=0;
		private var form:String="";
		private var key:String="";
		private var error:Boolean=false;
		private var currItem:int=0;
		private var preplace:int=0;
		private var menuWidth:int=100;
		private var limit:int=0;
		private var currOrder:int=0;
		private var itemHeight:int=0;
		private var scrollTimer:int=0;

		public function DropMenu() {
			board.mouseEnabled=false;
			board.mouseChildren=false;
			itembox.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null,pm_form:String="",pm_key:String=""):void {

			addChild(itembox);
			itembox.visible=false;
			board.visible=false;

			if (pm_xml!=null) {
				if (pm_xml.@w>0) {
					menuWidth=pm_xml.@w;
				}
				if (pm_xml.@limit!=undefined) {
					limit=pm_xml.@limit;
				}
				form=pm_form;
				key=pm_key;

				if (pm_xml.@partspace != undefined) {
					partspace=pm_xml.@partspace;
				} else {
					partspace=TextStyle.getParagraph.partspace;
				}
				for (var i:int=0; i<pm_xml.children().length(); i++) {
					item_arr[i]=new DropMenuItem();
					itembox.addChild(item_arr[i]);
					item_arr[i].setup(pm_xml.children()[i].@dat,pm_xml.children()[i],i,(menuWidth-board.tl.width-board.tr.width));

					item_arr[i].visible=false;


					if (i>=limit && limit!=0) {
						item_arr[i].y=0;
					} else {
						view_arr[i]=item_arr[i];
						sortItem(i);
						view_arr[i].visible=true;
					}
					if (pm_xml.children()[i].@select!=undefined) {
						preplace=i;
					}
				}
				if (item_arr.length>0) {
					itemHeight=item_arr[0].height;
				}

				dropbtn.setup(menuWidth);
				board.top.width=board.bottom.width=menuWidth-board.tl.width-board.tr.width;
				board.bg.width=board.bottom.width;

				board.bg.height=Math.ceil(itembox.height);
				board.left.height=board.right.height=board.bg.height;

				board.tr.x=board.bg.width+board.bg.x;

				board.bl.y=board.bg.height+board.bg.y;
				board.br.x=board.tr.x;
				board.br.y=board.bl.y;
				board.bottom.y=board.br.y;
				board.right.x=board.br.x;
				var aw_x:int=board.bg.width/2-board.aw_t.width/2+board.bg.x;
				board.aw_t.x=aw_x;
				board.aw_t.alpha=0.2;
				board.aw_b.x=aw_x;
				board.aw_b.y=board.bl.y+1;
				if (item_arr.length<=limit || limit==0) {
					board.aw_t.visible=board.aw_b.visible=false;
				}
				itembox.x=board.bg.x;
				itembox.y=board.bg.y;
				currItem=preplace;
				select(preplace);
				dropbtn.addEventListener(MouseEvent.CLICK,clickHandler);
				addEventListener(MouseEvent.ROLL_OUT,outHandler);
				addEventListener(Site.DROP_CLICKED,selectHandler);
				this.addEventListener(Event.REMOVED,removed);
				this.visible=true;
				dispatchEvent(form_event);
			} else {
				this.visible=false;
			}
		}
		public function reset():void {
			select(preplace);
			currItem=preplace;
		}

		private function clickHandler(event:MouseEvent):void {
			swith(true);
		}
		private function outHandler(event:MouseEvent):void {
			swith(false);
		}
		private function swith(b:Boolean):void {
			itembox.visible=b;
			board.visible=b;
			if (b && item_arr.length>limit && limit!=0) {
				addEventListener(Event.ENTER_FRAME,scrollHandler);
			} else {
				removeEventListener(Event.ENTER_FRAME,scrollHandler);
			}
		}
		private function scrollHandler(event:Event):void {
			if (scrollTimer>2) {
				if (mouseY<itemHeight) {
					scrollUp();
				}
				if (mouseY>itembox.height-itemHeight) {
					scrollDown();
				}
				scrollTimer=0;
			} else {
				scrollTimer++;
			}
		}
		private function sortItem(n:int):void {
			if (n>0) {
				view_arr[n].y=view_arr[n-1].y+view_arr[n-1].height;
			} else {
				view_arr[n].y=0;
			}
		}
		private function scrollUp():void {
			if (currOrder>0) {
				for (var i:int=0; i<limit; i++) {
					view_arr[i].visible=false;
					view_arr[i].y=0;
					view_arr[i]=item_arr[currOrder-1+i];
					view_arr[i].visible=true;
					sortItem(i);
				}
				currOrder--;
			}
			if (currOrder<=0) {
				board.aw_t.alpha=0.2;
			}
			board.aw_b.alpha=1;
		}
		private function scrollDown():void {
			if (currOrder+limit<item_arr.length) {
				for (var i:int=0; i<limit; i++) {
					//view_arr[i].visible=false;
					//view_arr[i].y=0;
					view_arr[i]=item_arr[i+currOrder+1];
					view_arr[i].visible=true;
					sortItem(i);
				}
				currOrder++;
				
			}
			if (currOrder>=item_arr.length-limit) {
				board.aw_b.alpha=0.2;
			}
			board.aw_t.alpha=1;
		}
		private function selectHandler(event:Event):void {
			var obj=event.target;
			select(obj.getOrder);
			currItem=obj.getOrder;
			event.stopPropagation();
			swith(false);
		}
		private function select(order:int):void {
			dropbtn.select(item_arr[order].getTxt);
		}

		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeChildren(itembox);
				dispatchEvent(removed_event);
				removeChild(itembox);
				item_arr=[];
				view_arr=[];
				dropbtn.removeEventListener(MouseEvent.CLICK,clickHandler);
				removeEventListener(Event.ENTER_FRAME,scrollHandler);
				removeEventListener(MouseEvent.ROLL_OUT,outHandler);
				removeEventListener(Site.DROP_CLICKED,selectHandler);

			}
		}
		public function prepareData():void {
			error=false;
		}
		//get
		public function get getData():String {
			var tmp_data:String="";
			tmp_data=item_arr[currItem].getData;
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