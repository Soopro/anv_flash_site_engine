package comps{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import comps.images.*;
	import comps.dropmenu.*;
	import comps.radio.*;
	import comps.scrollbar.*;
	import tools.*;

	public class TextContents extends Sprite {


		//events preplace
		private var cursorOn_event:Event=new Event(Site.CURSOR_ON,true,false);
		private var cursorOff_event:Event=new Event(Site.CURSOR_OFF,true,false);
		private var tipsOn_event:Event=new Event(Site.TIPS_ON,true,false);
		private var tipsOff_event:Event=new Event(Site.TIPS_OFF,true,false);

		//object preplace

		private var contents_XML:XML=new XML;
		private var contents_Rect:Rectangle=new Rectangle;

		private var contentsSprite:NodeSprite=new NodeSprite;
		private var activeSprite:NodeSprite=new NodeSprite;
		private var mask_area:AreaSprite=new AreaSprite;
		private var mask_area2:AreaSprite=new AreaSprite;
		private var scrollbar:ScrollUI=new ScrollUI;
		private var drag_area:AreaSprite=new AreaSprite;

		//variable preplace
		private var partspace:int=0;
		private var scroll_h:int=0;
		private var scroll_top:int=0;
		private var mouseWheel:Boolean=false;
		private var seted:Boolean=false;
		private var handCheck:Boolean=true;

		private var listenerCheck:Boolean=false;

		public function TextContents() {
			contents_Rect=new Rectangle();
			partspace=0;
			scroll_h=0;
			mouseWheel=false;
			listenerCheck=false;
			handCheck=true;
			scroll_top=0;
			
		}

		public function setup(pm_xml:XML):void {
			if(stage!=null){
				setData(pm_xml);
				if (pm_xml.@hand==0) {
					handCheck=false;
				} else {
					handCheck=true;
				}
				this.addEventListener(Event.REMOVED,removed);
			}
		}

		private function setData(pm_xml:XML):void {
			var tmp_x:int;
			var tmp_y:int;
			mouseWheel=false;

			if (pm_xml != null) {
				contents_XML=pm_xml;
			}
			if (contents_XML.@x != undefined) {
				tmp_x=contents_XML.@x;
			} else {

				tmp_x=TextStyle.getParagraph.left;
			}
			if (contents_XML.@y != undefined) {
				tmp_y=contents_XML.@y;
			} else {
				tmp_y=TextStyle.getParagraph.top;
			}
			if (contents_XML.@partspace != undefined) {
				partspace=contents_XML.@partspace;
			} else {
				partspace=TextStyle.getParagraph.partspace;
			}
			contents_Rect=new Rectangle(tmp_x,tmp_y,contents_XML.@w,contents_XML.@h);
			if (contents_XML.@scroll != undefined) {
				scroll_h=toNumber(contents_XML.@scroll,contents_Rect.height);
			} else {
				scroll_h=0;
			}
			setContents();
			setPos();

		}
		private function setContents():void {

			contentsSprite=new NodeSprite  ;
			addChild(contentsSprite);
			contentsSprite.nodeWidth=contents_Rect.width;

			if (contents_XML.empty.length() > 0) {
				addEmpty();
			} else {
				addNode(contents_XML,contentsSprite);

				//mask and scroll
				if (scroll_h > 0 && contentsSprite.height > contents_Rect.height) {
					setMask();
					setScroll();
				}
			}
			//animation fade in
			Anim.fadeIn(contentsSprite);
		}
		private function addEmpty():void {
			var empty:EmptyPiece=new EmptyPiece;
			contentsSprite.addChild(empty);
			empty.setup(contents_XML.empty,contents_Rect.width,contents_Rect.height);

		}
		private function addNode(obj:XML,parentSprite:NodeSprite):void {

			for each (var element:XML in obj.children()) {
				if (element.name() != null) {

					var elementSprite:NodeSprite=new NodeSprite;
					if(element.@alpha!=undefined){
						elementSprite.alpha=element.@alpha
					}

					if (element.@w == undefined) {

						elementSprite.nodeWidth=parentSprite.nodeWidth;

						if (element.name() == "img") {
							elementSprite.nodeWidth=SiteStyle.getImageSize.width;
						}
						if (element.name() == "button") {
							elementSprite.nodeWidth=SiteStyle.getButtonSize.width;
						}
					} else {
						elementSprite.nodeWidth=toNumber(element.@w,parentSprite.nodeWidth);
					}
					if (element.@h == undefined) {
						elementSprite.nodeHeight=element.name() == "img"?SiteStyle.getImageSize.height:0;
					} else {
						elementSprite.nodeHeight=toNumber(element.@h,parentSprite.nodeHeight);
					}
					if (elementSprite.nodeWidth < 0 || elementSprite.nodeHeight < 0) {
						elementSprite.visible=false;
					}
					if (element.@form != undefined) {
						elementSprite.form=element.@form;
					}
					//set position
					if (parentSprite.nodeWidth - parentSprite.posX - elementSprite.nodeWidth < 0 && parentSprite.posX != 0) {
						parentSprite.posX=0;
						parentSprite.posY=Math.round(parentSprite.height) + partspace;
					}

					elementSprite.x=element.@x == undefined?parentSprite.posX:element.@x;
					elementSprite.y=element.@y == undefined?parentSprite.posY:element.@y;

					parentSprite.addChild(elementSprite);

					//set next X
					parentSprite.posX=elementSprite.x + elementSprite.nodeWidth + partspace;


					//set contents txt or img

					if (element.name() == "txt") {
						var txtNode:TextPiece=new TextPiece;
						elementSprite.addChild(txtNode);
						txtNode.setup(element,elementSprite.nodeWidth,elementSprite.nodeHeight,element.@link!=undefined);

					}
					if (element.name() == "des") {
						var desNode:DesPiece=new DesPiece;
						elementSprite.addChild(desNode);
						desNode.setup(element,elementSprite.nodeWidth,elementSprite.nodeHeight);

					}
					if (element.name() == "ico") {
						var icoNode:IconPiece=new IconPiece;
						elementSprite.addChild(icoNode);
						icoNode.setup(element.@src);

					}

					if (element.name() == "img") {
						var imgNode:ImagePiece=new ImagePiece;
						var img_border:int=1;
						if (element.@border != undefined) {
							img_border=element.@border;
						}
						elementSprite.addChild(imgNode);
						imgNode.setup(element.@src,img_border,elementSprite.nodeWidth,elementSprite.nodeHeight);

					}
					if (element.name() == "inarea") {
						var inareaNode:InputArea=new InputArea;
						var tmp_form:String;
						if (element.@form == undefined) {
							tmp_form=parentSprite.form;
						} else {
							tmp_form=element.@from;
						}
						elementSprite.addChild(inareaNode);
						inareaNode.setup(elementSprite.nodeWidth,elementSprite.nodeHeight,element.@key,tmp_form,element.@max,element.@optional != undefined,element,element.@pattern);

					}
					if (element.name() == "input") {
						var inputNode:InputText=new InputText;
						var tmp_form2:String;
						if (element.@form == undefined) {
							tmp_form2=parentSprite.form;
						} else {
							tmp_form2=element.@from;
						}
						elementSprite.addChild(inputNode);
						inputNode.setup(elementSprite.nodeWidth,element.@key,tmp_form2,element.@max,element.@optional != undefined,element,element.@pattern);
					}
					if (element.name() == "button") {
						var btnNode:GButton=new GButton;
						elementSprite.addChild(btnNode);
						btnNode.setup(element,element.@type,element.@tag,element.@target,element.@src,element.@w);

					}
					if (element.name() == "radio") {
						var radioNode:Radio=new Radio;
						var tmp_form3:String;
						if (element.@form == undefined) {
							tmp_form3=parentSprite.form;
						} else {
							tmp_form3=element.@from;
						}
						elementSprite.addChild(radioNode);
						radioNode.setup(element,tmp_form3,element.@key,elementSprite.nodeWidth);

					}
					if (element.name() == "dropmenu") {

						var dropNode:DropMenu=new DropMenu;
						var tmp_form4:String;
						if (element.@form == undefined) {
							tmp_form4=parentSprite.form;
						} else {
							tmp_form4=element.@from;
						}
						elementSprite.addChild(dropNode);
						dropNode.setup(element,tmp_form4,element.@key);
					}
					//function loop
					if (element.name() != "radio" && element.name() != "dropmenu") {
						addNode(element,elementSprite);
					}
				}
			}
		}
		private function replaceObject(target:Object,target2:Object):void {
			var hold:AreaSprite=new AreaSprite;
			Align.same(target,hold);
			target2.addChild(hold);
			target2.removeChild(target);
		}

		private function toNumber(str:*,target:int):int {
			var number:int;
			if (str.search("%") < 0) {
				number=str;
			} else {
				var tmp=str.substring(0,str.search("%"));
				number=target * tmp / 100;

			}
			return number;

		}
		private function setPos():void {
			this.x=contents_Rect.x;
			this.y=contents_Rect.y;
		}
		//mask and scroll
		private function setMask():void {
			addChild(mask_area);
			mask_area.set(contents_Rect.width,contents_Rect.height);
			contentsSprite.mask=mask_area;
		}
		private function setScroll():void {

			addChild(scrollbar);
			addChild(mask_area2);
			Align.same(mask_area,mask_area2);
			drag_area.set(contentsSprite.width,contentsSprite.height);
			drag_area.mask=mask_area2;
			addChildAt(drag_area,0);


			scrollbar.setup(mask_area,scroll_h);

			addListeners();

			if (contentsSprite.height > contents_Rect.height) {
				scroll_top=-(contentsSprite.height - contents_Rect.height);
			} else {
				scroll_top=0;
			}

			activeScroll();

			seted=true;

		}

		private function addListeners():void {

			addEventListener(MouseEvent.MOUSE_DOWN,dragHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,dragHandler);
			addEventListener(MouseEvent.ROLL_OVER,dragHandler);
			addEventListener(MouseEvent.ROLL_OUT,dragHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL,dragHandler);

			addEventListener(Event.ENTER_FRAME,scrollContent);
			listenerCheck=true;
			this.tabEnabled=false;
		}
		private function removeListeners():void {
			if (listenerCheck) {
				removeEventListener(MouseEvent.MOUSE_DOWN,dragHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,dragHandler);
				removeEventListener(MouseEvent.ROLL_OVER,dragHandler);
				removeEventListener(MouseEvent.ROLL_OUT,dragHandler);
				removeEventListener(MouseEvent.MOUSE_WHEEL,dragHandler);

				removeEventListener(Event.ENTER_FRAME,scrollContent);
				listenerCheck=false;
			}

		}
		private function dragHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN :
					var tmp_rect:Rectangle=new Rectangle(0,0,0,scroll_top);
					drag_area.startDrag(false,tmp_rect);
					dispatchEvent(tipsOff_event);
					if (handCheck) {
						contentsSprite.alpha=SiteStyle.getScroll.alpha;
					}
					break;
				case MouseEvent.MOUSE_UP :
					drag_area.stopDrag();
					contentsSprite.alpha=1;

					break;
				case MouseEvent.ROLL_OVER :
					mouseWheel=true;
					Site.tips=SiteStyle.getScroll.tips;
					dispatchEvent(tipsOn_event);
					if (handCheck) {
						dispatchEvent(cursorOn_event);
					}
					break;
				case MouseEvent.ROLL_OUT :
					mouseWheel=false;
					dispatchEvent(tipsOff_event);
					if (handCheck) {
						dispatchEvent(cursorOff_event);
					}
					break;
				case MouseEvent.MOUSE_WHEEL :
					if (mouseWheel) {
						var tmp_delta=event.delta;
						if (tmp_delta > 0) {

							if (drag_area.y < 0) {
								drag_area.y+= tmp_delta * SiteStyle.getScroll.speed;
							} else {
								drag_area.y=0;
							}
						}
						if (tmp_delta < 0) {

							if (drag_area.y > scroll_top) {
								drag_area.y+= tmp_delta * SiteStyle.getScroll.speed;
							} else {
								drag_area.y=scroll_top;
							}
						}
					}
					break;
			}
		}
		private function scrollContent(event:Event):void {
			if (contentsSprite.y != drag_area.y) {
				var tmp_y:Number=(contentsSprite.y - drag_area.y )/ SiteStyle.getScroll.speed;
				if (tmp_y > -1 && tmp_y < 0) {
					tmp_y=-1;
				}
				contentsSprite.y=contentsSprite.y - Math.ceil(tmp_y);
				activeScroll();
				var tmp_dy:int=drag_area.y;
				drag_area.y=tmp_dy;
			}
		}
		private function activeScroll():void {
			var percent:Number=1 - (contentsSprite.height + contentsSprite.y - contents_Rect.height) / contentsSprite.height;
			scrollbar.scrollTo(percent);
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				dispatchEvent(tipsOff_event);
				dispatchEvent(cursorOff_event);

				removeListeners();
				contents_XML=null;
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				
			}
		}
	}
}