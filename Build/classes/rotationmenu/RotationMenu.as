/*
Ellipse Menu varsion 1.0
script by redy, Gestaltic Studio.
usage:
create menu -
MenuClass(xlimit:Number,ylimit:Number,e_w:Number,e_h:Number,rotate:Boolean,rlimit:Number,rspeed:Number)
"xlimit,ylimit" mouse active area
"e_w:Number,e_h:Number" ellipse witdh and height
"rotate:Boolean,rlimit:Number,rspeed:Number" only for rotation Y, type, area limit, speed;


initialize - 

initMenu(nav_data:XMLList)

*/

package rotationmenu{
	import rotationmenu.math.Ellipse;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;

	import tools.*;

	public class RotationMenu extends Sprite {

		private var in_complete_event:Event=new Event(Site.IN_COMPLETE);
		private var out_complete_event:Event=new Event(Site.OUT_COMPLETE);
		private var btn_event:Event=new Event(Site.BTN_CLICKED,true,false);
		
		private var menus_tag:String=""
		private var menus_type:String=""
		private var menus_source:String=""
		private var menus_target:String=""

		//xml
		private var menusXML:XML=new XML;
		private var infoXML:XML=new XML;

		//info
		private var ctrlbar:ControlBar=new ControlBar();
		
		//creat ellipse
		private var ellipse_w:Number=250;
		private var ellipse_h:Number=100;
		private var ellipse:Ellipse=new Ellipse(ellipse_w,ellipse_h);
		
		//views
		private var loader_ui:MenuLoaderUI=new MenuLoaderUI  ;
		//icon
		private var iconCount:int=6;
		private var iconPressed:Boolean=false;
		private var currentIcon:*;
		//rotation angle
		private var endAngle:Number=90;
		//speed
		private var step_speed:int=0;
		private var step_timer:int=0;
		private var angle:Number=0;
		private var moveSpeed:Number=25;
		//temp angle for get new angle next times.
		private var tempAngle:Number=0;

		//rotation state
		private var isRotating:Boolean=true;
		private var moveCheck:Boolean=true;


		private var mposXLimit:Number;
		private var mposYLimit:Number;
		//private var fixX:Number=0;
		//private var fixY:Number=0;
		private var rollOverState:Boolean;
		private var rotateYLimit:Number;
		private var rotateYSpeed:Number;
		private var rotateDirection:Boolean;
		private var actived:Boolean=false;
		private var auto:Boolean=true;
		private var clickCheck=false;

		//array
		private var menusArray:Array=new Array;
		private var depthArray:Array=new Array;

		//position
		private var menus_Rect:Rectangle=new Rectangle;

		//check Opera
		private var Opera:Boolean=false;
		//check set
		private var seted:Boolean=false;
		
		public function RotationMenu() {
			clean();
		}
		public function setup(pm_xml:XML=null) {
			
			Opera=Site.Opera;
			
			if (!seted && pm_xml != null && stage!=null) {
				menusXML=pm_xml;
				//addEventListener(Event.ENTER_FRAME,moveStepHandler);
				addEventListener(Event.ENTER_FRAME,moveHandler);
				this.addEventListener(Event.REMOVED,removed);
				//addChild(logo);
				setMenus();
				infoXML=menusXML.info[0];
				addChild(ctrlbar)
				ctrlbar.setup(infoXML);
				seted=true;
			}
		}
		public function reset(pm_xml:XML=null) {
			if(seted && stage!=null){
					removeEventListener(Event.ENTER_FRAME,moveHandler);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyRotation);
					removeEventListener(Event.ENTER_FRAME,moveStepHandler);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,restartMove);
					removeEventListener(Event.ENTER_FRAME,moveInHandler);
					removeEventListener(Event.ENTER_FRAME,moveOutHandler);
					menusRemoveListeners();
					removeChildren(this);
					clean();
					
				if (pm_xml != null) {
					menusXML=pm_xml;
					addChild(ctrlbar)
					ctrlbar.setup(infoXML);
					addEventListener(Event.ENTER_FRAME,moveHandler);
					//addChild(logo);
					setMenus();
					animIn();
					//Anim.fadeIn(this);
				}
			}
		}
		
		public function doFunction(str:String):void {
			var d_x:int=0;
			var d_y:int=0;
			loader_ui.x=d_x;
			loader_ui.y=d_y;
			switch (str) {
				case "loading" :
					addChild(loader_ui);
					this.alpha=0.5;
					break;
				case "complete" :
					removeChild(loader_ui);
					this.alpha=1;
					break;
				case "error" :
					loader_ui.setError();
					this.alpha=0.5;
					break;
				case "nodata" :
					addChild(loader_ui);
					loader_ui.setNodata();
					this.alpha=0.5;
					break;
			}
		}
		
		private function setMenus():void {
			menus_tag=menusXML.@tag
			menus_Rect=new Rectangle(menusXML.@x,menusXML.@y,menusXML.@w,menusXML.@h);
			ellipse_w=menus_Rect.width;
			ellipse_h=menus_Rect.height;
			if (menusXML.@xlimit != undefined) {
				mposXLimit=menusXML.@xlimit;
			} else {
				mposXLimit=menus_Rect.width;
			}
			if (menusXML.@ylimit != undefined) {
				mposYLimit=menusXML.@ylimit;
			} else {
				mposYLimit=menus_Rect.height;
			}
			if (menusXML.@rollover ==1) {
				rollOverState=true;
			}
			if (menusXML.@rlimit != undefined && menusXML.@rlimit !=0) {
				rotateYLimit=menusXML.@rlimit;
			}
			if (menusXML.@rspeed != undefined) {
				rotateYSpeed=menusXML.@rspeed;
			}
			if (menusXML.@icon != undefined && menusXML.@icon>=4) {
				iconCount=menusXML.@icon;
			}
			if (iconCount>menusXML.item.length()) {
				iconCount=menusXML.item.length();
			}
			if (menusXML.@speed != undefined) {
				moveSpeed=menusXML.@speed;
			}
			if(menusXML.@auto == 0){
				auto=false;
			}
			if(menusXML.@step !=undefined){
				step_speed=menusXML.@step
			}
			if(Opera){
				auto=false;
				step_speed=0;
			}
			for (var i:int=0; i < iconCount; i++) {
				menusArray[i]=new MenuBtn  ;
				//mc.scaleX=mc.scaleY=.5;
				addChildAt(menusArray[i],0);
				//menusArray[i].setup(menusXML.item[i],i);

				//set the menu after 3/4 circle, contents should be last of total contents
				var tmp_count:int=Math.round(iconCount*3/4);
				var tmp_xml:XML;
				var tmp_order:int;
				
				if (i<tmp_count) {
					tmp_xml=menusXML.item[i];
					tmp_order=i;
					
				} else {
					tmp_order=menusXML.item.length()-(iconCount-tmp_count)+(i-tmp_count);
					tmp_xml=menusXML.item[tmp_order];
					
				}
				
				var tmp_type:String
				var tmp_target:String

				if(tmp_xml.@type!=undefined){
					tmp_type=tmp_xml.@type
				}else{
					tmp_type=menusXML.@types
				}
				if(tmp_xml.@target!=undefined){
					tmp_target=tmp_xml.@target
				}else{
					tmp_target=menusXML.@targets
				}

				menusArray[i].setup(tmp_xml.@src,tmp_type,tmp_target,tmp_xml.@source,tmp_order);
			}
			//swapDepths();

			this.alpha=0;
			setPos();
		}
		public function animIn():void {
			Anim.fadeIn(this);
			ellipse.width=60;
			ellipse.height=60;
			
			addEventListener(Event.ENTER_FRAME,moveInHandler);
		}
		public function animOut():void {
			Anim.fadeOut(this);
			addEventListener(Event.ENTER_FRAME,moveOutHandler);
		}
		private function setPos():void {
			this.x=menus_Rect.x;
			this.y=menus_Rect.y;
		}
		//menus listener
		private function menusAddListeners():void {
			for (var i:int; i < menusArray.length; i++) {
				if (menusArray[i].actvie) {
					menusArray[i].addEventListener(MouseEvent.ROLL_OVER,btnHandler);
					menusArray[i].addEventListener(MouseEvent.ROLL_OUT,btnHandler);
					menusArray[i].addEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
					menusArray[i].addEventListener(MouseEvent.MOUSE_UP,btnHandler);
					menusArray[i].addEventListener(MouseEvent.CLICK,btnHandler);
					menusArray[i].buttonMode=true;
					menusArray[i].tabEnabled=false;
				}

			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyRotation);
			this.addEventListener(Event.ACTIVATE,activeFlashHandler);
			this.addEventListener(Event.DEACTIVATE,activeFlashHandler);
			if(!auto){
				addEventListener(Event.ENTER_FRAME,dragHandler);
			}
			ctrlbar.addEventListener("go_left",ctrlHandler)
			ctrlbar.addEventListener("go_right",ctrlHandler)
		}
		private function menusRemoveListeners():void {
			for (var i:int; i < menusArray.length; i++) {
				//if (menusArray[i].actvie) {
				menusArray[i].removeEventListener(MouseEvent.ROLL_OVER,btnHandler);
				menusArray[i].removeEventListener(MouseEvent.ROLL_OUT,btnHandler);
				menusArray[i].removeEventListener(MouseEvent.MOUSE_DOWN,btnHandler);
				menusArray[i].removeEventListener(MouseEvent.MOUSE_UP,btnHandler);
				menusArray[i].removeEventListener(MouseEvent.CLICK,btnHandler);
				//}
			}
			//stage.removeEventListener(MouseEvent.MOUSE_UP,btnHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyRotation);
			removeEventListener(Event.ENTER_FRAME,dragHandler);
			this.removeEventListener(Event.ACTIVATE,activeFlashHandler);
			this.removeEventListener(Event.DEACTIVATE,activeFlashHandler);
			ctrlbar.removeEventListener("go_left",ctrlHandler)
			ctrlbar.removeEventListener("go_right",ctrlHandler)
		}

		private function dragHandler(event:Event):void{
			if(step_speed!=0){
				if(step_timer>=step_speed){
					if(mouseX>ctrlbar.width/2){
							runMoveStep(true);
					}
					if(mouseX<-ctrlbar.width/2){
							runMoveStep(false);
					}
					step_timer=0;
				}else{
					step_timer++;
				}
			}
		}
		
		private function moveInHandler(event:Event):void {

			ellipse.width=ellipse.width - (ellipse.width - ellipse_w) / 10;
			ellipse.height=ellipse.height - (ellipse.height - ellipse_h) / 10;
			if (this.alpha>0.8 && !actived) {
				menusAddListeners();
				dispatchEvent(in_complete_event);
				actived=true;
			}
			if (Math.abs(ellipse.width - ellipse_w) < 0.5) {
				ellipse.width=ellipse_w;
				//ellipse.height=ellipse_h;
				removeEventListener(Event.ENTER_FRAME,moveInHandler);
			}
		}
		private function moveOutHandler(event:Event):void {

			ellipse.width=ellipse.width - (ellipse.width - 5) / 10;
			ellipse.height=ellipse.height - (ellipse.height - 5) / 10;

			if (this.alpha<=0) {
				dispatchEvent(out_complete_event);
				removeEventListener(Event.ENTER_FRAME,moveOutHandler);
			}
		}
		//active flash handler
		private function activeFlashHandler(event:Event):void {
			switch (event.type) {
				case Event.DEACTIVATE :
				moveCheck=false;
					//removeEventListener(Event.ENTER_FRAME,moveHandler);
					break;
				case Event.ACTIVATE :
				moveCheck=true;
					//addEventListener(Event.ENTER_FRAME,moveHandler);
					break;
			}
		}
		//button function
		private function btnHandler(event:MouseEvent):void {
			var current=event.currentTarget;
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					//removeEventListener(Event.ENTER_FRAME,moveHandler);
					//moveCheck=false;
					//trace(currentIcon.txt.text);
					current.gotoAndPlay("on");
					break;
				case MouseEvent.ROLL_OUT :
					current.gotoAndPlay("off");
					//moveCheck=true;
					//trace("open section"+currentIcon.txt.text);
					//addEventListener(Event.ENTER_FRAME,moveHandler);
					break;
				case MouseEvent.MOUSE_DOWN :
					moveCheck=false;
					iconPressed=true;
					current.gotoAndPlay("press");

					break;
				case MouseEvent.MOUSE_UP :
					if (iconPressed) {
						current.gotoAndPlay("on");

						iconPressed=false;
					}
					break;
				case MouseEvent.CLICK :
					//trace("open section "+currentIcon.sec);
					menus_target=current.getTarget;
					menus_type=current.getType;
					menus_source=current.getDataSource;
					clickRotation(current);
					clickCheck=true;
					break;
			}
		}
		//initialize
		private function initAngle(b:Boolean) {
			//save angle when the menu is rotation
			if (isRotating) {
				tempAngle+= angle;
			}
			angle=0;
			isRotating=b;
		}
		//get ellipse height
		private function rotateH():void {
			var mposY:Number=mouseY //+ fixY;
			if (mposY > mposYLimit) {
				mposY=mposYLimit;
			} else if (mposY < - mposYLimit) {
				mposY=- mposYLimit;
			}
			if (mposY == 0) {
				mposY=0.5;
			}
			var _hight:Number;
			if (rollOverState) {
				_hight=mposY;
			} else {
				_hight=ellipse_h - mposY / rotateYLimit;
			}
			ellipse.height=ellipse.height - Math.round(ellipse.height - _hight / rotateYSpeed);
			ellipse.height=(ellipse.height > -1 && ellipse.height < 1)?0.5:ellipse.height;
		}
		//menus animation by mouse move
		private function moveHandler(event:Event):void {
			rotateH();
			if(auto){
				if (moveCheck) {
					var mposX:Number=mouseX;
					if (mposX>mposXLimit) {
						mposX=mposXLimit;
					} else if (mposX<-mposXLimit) {
						mposX=-mposXLimit;
					}
	
					if (mposX>0) {
						rotateDirection=true;
					} else {
						rotateDirection=false;
					}
					for (var z:int; z < menusArray.length; z++) {
						setProp(z);
					}
					endAngle=mposX/moveSpeed;
					angle+=(endAngle-angle)*.2;
					initAngle(true);
					swapDepths();
					swapContents();
				}
			}else{
				rotateDirection=true;
				for (var z2:int; z2 < menusArray.length; z2++) {
						setProp(z2);
				}
				swapDepths();
				swapContents();
				angle+=(endAngle-angle)*.2
				if(Math.abs(angle-endAngle)<0.1){
					this.removeEventListener(Event.ENTER_FRAME,moveHandler)
					initAngle(false)
				}
			}
			/*
			if (Math.abs(angle-endAngle)<1) {
			this.removeEventListener(Event.ENTER_FRAME,moveHandler);
			initAngle(false);
			}
			*/
		}
		//active click rotation
		private function clickRotation(traget:MovieClip):void {
			moveCheck=false;
			removeEventListener(Event.ENTER_FRAME,moveStepHandler);

			currentIcon=traget;

			if (currentIcon.x>0) {
				rotateDirection=true;
			} else {
				rotateDirection=false;
			}
			//get angle
			endAngle=ellipse.angle(currentIcon.y,currentIcon.angle);
			//change to engAngle
			if (ellipse.height<0) {
				endAngle+=180;
			}
			endAngle=(endAngle>-180&&endAngle<-90)?-270-endAngle:90-endAngle;
			//initialize angle

			initAngle(true);

			addEventListener(Event.ENTER_FRAME,moveStepHandler);
		}
		//active key rotation
		private function keyRotation(event:KeyboardEvent):void {
			switch (event.keyCode){
				case 37:
					runMoveStep(true);
				break;
				case 39:
					runMoveStep(false);
				break;
			}
		}
		
		//action by control bar
		private function ctrlHandler(event:Event):void{
			switch (event.type){
				case "go_left":
					runMoveStep(true);
				break;
				case "go_right":
					runMoveStep(false);
				break;
			}
		}
		
		private function runMoveStep(chk:Boolean):void{
			if(depthArray.length>0){
				moveCheck=false;
				removeEventListener(Event.ENTER_FRAME,moveStepHandler);
				
				var _order=menusArray.indexOf(depthArray[depthArray.length-1]);
				switch (chk){
					case true:
						currentIcon=(_order>0)?menusArray[_order-1]:menusArray[menusArray.length-1];
						rotateDirection=true;
					break;
					case false:
						currentIcon=(_order<menusArray.length-1)?menusArray[_order+1]:menusArray[0];
						rotateDirection=false;
					break;
				}
				//get angle
					endAngle=ellipse.angle(currentIcon.y,currentIcon.angle);
					//change to engAngle
					if (ellipse.height<0) {
						endAngle+=180;
					}
					endAngle=(endAngle>-180&&endAngle<-90)?-270-endAngle:90-endAngle;
					//initialize angle
					initAngle(true);
					addEventListener(Event.ENTER_FRAME,moveStepHandler);
			}
		}
		
		//menus animation play by step
		private function moveStepHandler(event:Event):void {
			rotateH();
			for (var z:int; z < menusArray.length; z++) {
				setProp(z);
			}
			swapDepths();
			swapContents();

			angle+=(endAngle-angle)*.2;
			if (Math.abs(angle-endAngle)<0.2) {
				removeEventListener(Event.ENTER_FRAME,moveStepHandler);
				initAngle(false);
				if(clickCheck){
					clickCheck=false;
					//dispatch event after click rotation animation finish. 
					dispatchEvent(btn_event);
				}
				if(auto){
					stage.addEventListener(MouseEvent.MOUSE_MOVE,restartMove);
				}
			}
		}
		//restart to animatin play by mouse move
		private function restartMove(event:MouseEvent):void {
			//speed=0;
			moveCheck=true;
			//addEventListener(Event.ENTER_FRAME,moveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,restartMove);
		}
		//set icon property
		private function setProp(target_order:int) {

			var mc:MovieClip=menusArray[target_order];
			var p:Point=ellipse.getxy(mc.angle=tempAngle + angle + 360 / iconCount * target_order);
			mc.x=p.x //- fixX;
			mc.y=p.y;
			mc.alpha=ellipse.yscale(mc.y)*(mc.depth/depthArray.length);
			mc.scaleY=mc.scaleX=ellipse.yscale(mc.y,.2,.7);
			//mc.y-= fixY;

		}
		private function swapContents():void {
			//swap contents
			if (depthArray.length>3) {
			var _order=menusArray.indexOf(depthArray[0]);
			var tmp_order:int=0;

			if (rotateDirection) {
				tmp_order=(_order<menusArray.length-1)?menusArray[_order+1].order:menusArray[0].order;
				tmp_order-=1;
			} else {
				tmp_order=(_order>0)?menusArray[_order-1].order:menusArray[menusArray.length-1].order;
				tmp_order+=1;
			}
			/*
			var tmp_order1:int=0;
			var tmp_order2:int=0;
			var item_left:MenuBtn;
			var item_right:MenuBtn;
			
			if (depthArray[0].x>0) {
			item_left=depthArray[1];
			item_right=depthArray[0];
			} else {
			item_left=depthArray[0];
			item_right=depthArray[1];
			}
			var item_left2:MenuBtn;
			var item_right2:MenuBtn;
			if (depthArray[2].x>0) {
			item_left2=depthArray[3];
			item_right2=depthArray[2];
			} else {
			item_left2=depthArray[2];
			item_right2=depthArray[3];
			}
			if (item_right2.order>0) {
			tmp_order1=item_right2.order-1;
			} else {
			tmp_order1=menusXML.item.length()-1;
			}
			if (item_left2.order<menusXML.item.length()-1) {
			tmp_order2=item_left2.order+1;
			} else {
			tmp_order2=0;
			}
			*/
				
			if (tmp_order>menusXML.item.length()-1) {
				tmp_order=0;
			}
			if (tmp_order<0) {
				tmp_order=menusXML.item.length()-1;
			}
			//trace(depthArray[0].order);
			var tmp_xml:XML=menusXML.item[tmp_order];
	
			var tmp_type:String
			var tmp_target:String

			if(tmp_xml.@type!=undefined){
				tmp_type=tmp_xml.@type
			}else{
				tmp_type=menusXML.@types
			}
			if(tmp_xml.@target!=undefined){
				tmp_target=tmp_xml.@target
			}else{
				tmp_target=menusXML.@targets
			}
			if(depthArray[0].order!=tmp_order){
				depthArray[0].setup(tmp_xml.@src,tmp_type,tmp_target,tmp_xml.@source,tmp_order);
			}
			//item_right.setup(menusXML.item[tmp_order1],tmp_order1);
			}
		}
		//set depths
		private function swapDepths():void {
			for (var z:int=0; z < menusArray.length; z++) {
				depthArray[z]=menusArray[z];
			}
			depthArray.sortOn("scaleX",Array.NUMERIC);
			for (var a:int=0; a < menusArray.length; a++) {
				depthArray[a].depth=a;
			}
			//swap depth
			var allDepthArray:Array=new Array;
			allDepthArray=[];
			for (var j:int=0; j < depthArray.length; j++) {
				if (j == Math.round(depthArray.length / 2) - 1) {
					allDepthArray.push(ctrlbar);
				}
				allDepthArray.push(depthArray[j]);
			}
			//allDepthArray.pop()
			var i:int=allDepthArray.length;

			while (i--) {
				this.setChildIndex(allDepthArray[i],i);

			}
			
			ctrlbar.doChange(depthArray[depthArray.length-1].order+1,menusXML.item.length())
		}
		private function clean():void {
			step_speed=0;
			step_timer=0;
			angle=0;
			moveSpeed=25;
			tempAngle=0;
			endAngle=90;
			auto=true;
			mposXLimit=610;
			mposYLimit=610;
			ellipse_w=610;
			ellipse_h=610;
			rollOverState=false;
			rotateDirection=true;
			moveCheck=true;
			rotateYLimit=600;
			rotateYSpeed=6;
			iconCount=6;
			menusArray=[];
			depthArray=[];

			//menus_tag=""
			//menus_type=""
			//menus_source=""
			//menus_target=""
			actived=false;
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
				clean();
				menusRemoveListeners();
				removeEventListener(Event.ENTER_FRAME,moveHandler);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyRotation);
				removeEventListener(Event.ENTER_FRAME,moveStepHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,restartMove);
				removeEventListener(Event.ENTER_FRAME,moveInHandler);
				removeEventListener(Event.ENTER_FRAME,moveOutHandler);
			}
		}
		//set property
		public function setrollOverState(rotate:Boolean):void {
			rollOverState=rotate;
		}
		public function setRotateYLimit(rlimit:Number):void {
			rotateYLimit=rlimit;
		}
		
		//get
		public function get getTag():String {
			return menus_tag;
		}
		public function get getTarget():String {
			return menus_target;
		}
		public function get getType():String {
			return menus_type;
		}
		public function get getDataSource():String{
			return menus_source;
		}
	}
}