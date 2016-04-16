package selector.dropmenu{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import selector.dropmenu.*;
	import net.*;

	public class SimpleDropMenu extends MovieClip {

		private var dropData:XMLList;

		public static  const SELECTED:String="selected";
		private var selected_event:Event= new Event(SELECTED);

		private var listArray:Array;
		private var viewArray:Array;

		private var space:int;
		private var moveRect:Rectangle;
		private var clickRect:Rectangle;

		public function SimpleDropMenu() {
			//addEventListener(Event.ADDED_TO_STAGE, initialize);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
		public function setup(xml_list:XMLList,str:String,sp:int=100):void {
			dropData=xml_list;
			space=sp;
			select_btn.txt.text=str;
			listContents();
			list.visible=false;
			select_btn.addEventListener(MouseEvent.ROLL_OVER, btnHandler);
			select_btn.addEventListener(MouseEvent.ROLL_OUT, btnHandler);
			select_btn.addEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			select_btn.addEventListener(MouseEvent.MOUSE_UP, btnHandler);
			select_btn.addEventListener(MouseEvent.CLICK, btnHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageHandler);
			stage.addEventListener(MouseEvent.CLICK, stageHandler);
			
			moveRect = new Rectangle(list.x-space,list.y-space,list.width+space*2,list.height+space*2);
			clickRect = new Rectangle(list.x,list.y-space,list.width,list.height+space);

		}
		private function remove(event:Event):void {
			select_btn.txt.text="";
			list.visible=false;
			removeListeners();
		}
		private function listContents():void {
			listArray=[];
			viewArray=[];
			for (var i:int=0; i<dropData.length(); i++) {
				listArray[i]=new DropItem(dropData[i].@txt,dropData[i].@src);
				list.addChild(listArray[i]);
				listArray[i].y=list.topbar.y+list.topbar.height+i*listArray[i].height;
				listArray[i].addEventListener(DropItem.SELECTED,selectItem);
			}
			list.bottombar.y=listArray[listArray.length-1].y+listArray[listArray.length-1].height;
		}
		private function removeListeners():void {
			for (var i:int=1; i<listArray.length; i++) {

				listArray[i].removeEventListener(DropItem.SELECTED,selectItem);
				list.removeChild(listArray[i]);

			}
			select_btn.removeEventListener(MouseEvent.ROLL_OVER, btnHandler);
			select_btn.removeEventListener(MouseEvent.ROLL_OUT, btnHandler);
			select_btn.removeEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			select_btn.removeEventListener(MouseEvent.MOUSE_UP, btnHandler);
			select_btn.removeEventListener(MouseEvent.CLICK, btnHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageHandler);
			stage.removeEventListener(MouseEvent.CLICK, stageHandler);
		}
		private function btnHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					select_btn.gotoAndPlay("on");
					break;
				case MouseEvent.ROLL_OUT :
					select_btn.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					select_btn.gotoAndStop("press");
					break;
				case MouseEvent.MOUSE_UP :
					select_btn.gotoAndStop("off");
					break;
				case MouseEvent.CLICK :
					select_btn.gotoAndStop("off");
					switchMenu();
					break;
			}
		}
		private function stageHandler(event:MouseEvent):void {
			if (list.visible) {
				switch (event.type) {
					case MouseEvent.MOUSE_MOVE :
						if (!moveRect.contains(mouseX, mouseY)) {
							list.visible=false;
						}
						break;
					case MouseEvent.CLICK :
						if (!clickRect.contains(mouseX, mouseY)) {
							list.visible=false;
						}
						break;
				}
			}
		}
		private function switchMenu():void {
			if (!list.visible) {
				list.visible=true;
			} else {
				list.visible=false;
			}
		}
		//select item
		private function selectItem(event:Event):void {
			var targetURL:URLRequest = new URLRequest(event.target.getSrc);
			navigateToURL(targetURL,"_blank");
		}
		//get property


		//set property

	}
}