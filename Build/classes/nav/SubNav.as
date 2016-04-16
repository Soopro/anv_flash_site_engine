package nav{
	import flash.display.Sprite;
	import flash.events.Event;

	import tools.*;

	public class SubNav extends Sprite {

		//object preplace
		private var backBtn:BackBtn=new BackBtn();
		private var btns:Array=new Array;
		private var names:Array=new Array;
		private var tags:Array=new Array;
		private var subNavBar:Sprite=new Sprite();

		//variable preplace
		private var back_txt:String="";
		private var space:int=2;
		private var currOrder:int=0;

		public function SubNav() {
			this.mouseEnabled=false;
		}
		public function setup(pm_names:Array,pm_tags:Array,pm_order:int=0):void {
			clean();
			names=pm_names;
			tags=pm_tags;
			currOrder=pm_order;
			addChild(backBtn);
			Align.centerX(backBtn,null,backBtn.width / 2);
			backBtn.setup(SiteStyle.getBack.txt);
			backBtn.visible=false;
			
			addChild(subNavBar);
			backBtn.addEventListener(Site.SUB_OUT_COMPLETE,hiddenBackHandler)
			this.addEventListener(Event.REMOVED,removed);
			setSubNav();
		}
		public function reset(changed:Boolean,pm_names:Array,pm_tags:Array,pm_order:int=0,showback:Boolean=false):void {

			if (changed) {
				names=pm_names;
				tags=pm_tags;
				nextSubNav(showback);
				currOrder=pm_order;
			} else {
				if (currOrder < btns.length) {
					btns[currOrder].active();
					btns[pm_order].select();
				}
				currOrder=pm_order;
			}
		}
		private function setBackBtn(showback:Boolean=false):void {
			//if (backBtn.visible!=showback) {
				if (showback) {
					backBtn.animIn();
				} else {
					backBtn.animOut();
				}
				backBtn.visible=true;
			//}
		}
		private function hiddenBackHandler(event:Event):void{
			backBtn.visible=false;
		}
		
		private function nextSubNav(showback:Boolean=false):void {

			for each (var btn:SubNavBtn in btns) {
				btn.animOut();
			}
			if (btns.length>0) {
				btns[0].addEventListener(Site.SUB_OUT_COMPLETE,nextHandler);
			} else {
				setSubNav();
			}
			setBackBtn(showback);
		}
		private function nextHandler(event:Event):void {
			event.target.removeEventListener(Site.SUB_OUT_COMPLETE,nextHandler);

			setSubNav();
		}
		private function setSubNav():void {
			removeChildren(subNavBar);

			cleanBtns();

			var left:int=backBtn.x - space * 2;
			var right:int=backBtn.x + backBtn.width;
			if (tags.length > 1) {

				for (var i:int=0; i < tags.length; i++) {
					btns[i]=new SubNavBtn();
					subNavBar.addChild(btns[i]);
					btns[i].setup(names[i],tags[i],i);
					btns[i].animIn();
					if (i % 2 == 0) {
						btns[i].x=left - btns[i].width + space;
						left=btns[i].x;
					} else {
						btns[i].x=right;
						right+= btns[i].width;
					}
					addListeners(btns[i]);
				}
			}
		}
		private function addListeners(obj:SubNavBtn):void {
			obj.addEventListener(Site.SUB_IN_COMPLETE,animHandler);
		}
		private function removeListeners(obj:SubNavBtn):void {
			obj.removeEventListener(Site.SUB_IN_COMPLETE,animHandler);
		}
		private function cleanBtns():void {
			for (var i:int=0; i<btns.length; i++) {
				removeListeners(btns[i]);
			}
			btns=[];
		}
		private function animHandler(event:Event):void {
			if (event.target.getOrder==currOrder) {
				event.target.select();
			}
		}
		private function clean():void {
			cleanBtns();
			names=[];
			tags=[];
			currOrder=0;
			
			removeChildren(subNavBar);
			removeChildren(this);
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				clean();
				backBtn.removeEventListener(Site.SUB_OUT_COMPLETE,hiddenBackHandler)
				
			}
		}
	}
}