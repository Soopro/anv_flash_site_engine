package jumpmenu{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import tools.*;

	public class JumpMenu extends MovieClip {

		//events preplace
		private var btn_event:Event=new Event(Site.BTN_CLICKED,true,false);
		
		//object preplace
		private var item_arr:Array=new Array();
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
		
		private var btn_type:String="";
		private var btn_target:String="";
		private var btn_tag:String="";


		public function JumpMenu() {


		}
		public function setup(pm_xml:XML=null):void {

			addChild(itembox);
			itembox.visible=false;
			board.visible=false;

			if (pm_xml!=null) {
				if (pm_xml.@w>0) {
					menuWidth=pm_xml.@w;
				}
				btn_type=pm_xml.@type;
				btn_target=pm_xml.@target;
				btn_tag=pm_xml.@tag;
				
				for (var i:int=0; i<pm_xml.children().length(); i++) {
					item_arr[i]=new JumpMenuItem();
					itembox.addChild(item_arr[i]);
					item_arr[i].setup(pm_xml.children()[i].@dat,pm_xml.children()[i],i,(menuWidth-board.tl.width-board.tr.width));


					if (i>0) {
						item_arr[i].y=item_arr[i-1].y+item_arr[i-1].height;
					}

					if (pm_xml.children()[i].@select!=undefined) {
						preplace=i;
					}
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
				itembox.x=board.bg.x;
				itembox.y=board.bg.y;
				currItem=preplace;
				select(preplace);
				
				dropbtn.addEventListener(MouseEvent.CLICK,clickHandler);
				addEventListener(MouseEvent.ROLL_OUT,outHandler);
				this.addEventListener(Event.REMOVED,removed);
				addEventListener(Site.DROP_CLICKED,selectHandler);
				this.visible=true;

			} else {
				this.visible=false;
			}
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
		}
		private function selectHandler(event:Event):void {
			var obj=event.target;
			
			select(obj.getOrder);
			currItem=obj.getOrder;
			event.stopPropagation();
			swith(false);
			
			if(obj.getOrder!=preplace){
				dispatchEvent(btn_event);
			}
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
				removeChild(itembox);
				item_arr=[];
				dropbtn.removeEventListener(MouseEvent.CLICK,clickHandler);
				removeEventListener(MouseEvent.ROLL_OUT,outHandler);
				removeEventListener(Site.DROP_CLICKED,selectHandler);
			}
		}

		//get
		public function get getTag():String {
			return btn_tag;
		}
		public function get getTarget():String {
			return btn_target;
		}
		public function get getType():String {
			return btn_type;
		}
		public function get getDataSource():String {
			var tmp_data:String="";
			tmp_data=item_arr[currItem].getData;
			return tmp_data;
		}
	}
}