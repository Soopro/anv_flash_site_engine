package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nav.*;
	import tools.*;

	public class Section extends Sprite {

		//private var home_event:Event=new Event(Site.RETURN_HOME);
		private var change_event:Event=new Event(Site.SEC_CHANGE,true,false);

		//object preplace
		private var page:Page=new Page;
		private var sectionData:Array=new Array();
		private var subnav:SubNav=new SubNav();

		//variable preplace
		private var currSec:int=0;
		private var lastSec:int=0;
		private var currPage:int=0;
		private var lastPage:int=0;
		private var seted:Boolean=false;
		private var animCheck:Boolean=false;

		public function Section() {
			clean();

		}

		public function setup(xmls:Array):void {
			if (stage!=null) {
				removeChildren(this);
				clean();
				addChild(page);
				for (var i:int=0; i < xmls.length; i++) {
					sectionData[i]=xmls[i];
				}

				setPage(false);
				addChild(subnav);
				var tags:Array=new Array();
				var names:Array=new Array();
				for (var s:int=0; s<sectionData[currSec].page.length(); s++) {
					tags[s]=sectionData[currSec].page[s].@tag;
					names[s]=sectionData[currSec].page[s].@name;
				}
				subnav.setup(names,tags,currPage);

				seted=true;
				this.addEventListener(Event.REMOVED,removed);

				addEventListener(Site.SUB_CLICKED,subHandler);
				addEventListener(Site.BACK_CLICKED,backHandler);
			}
		}

		private function setPage(re:Boolean):void {
			var tmp_xml:XML=sectionData[currSec].page[currPage];
			if (! re) {
				page.setup(tmp_xml);
			} else {
				page.reset(tmp_xml);
			}
			dispatchEvent(change_event);
		}
		public function navToPage(str:String,sec_check:Boolean=true):void {
			if (seted) {
				if (str!="home" && str!="") {
					var sec_str:String;
					var page_str:String;
					var notfind_sec:Boolean=true;
					var notfind_page:Boolean=true;

					sec_str=str.slice(0,str.indexOf("#"));
					page_str=str.substr(str.indexOf("#") + 1);


					if (sec_check) {
						for (var i:int=0; i < sectionData.length; i++) {
							if (sectionData[i].@tag == sec_str) {
								currSec=i;
								notfind_sec=false;
								break;
							}
						}
					} else {
						notfind_sec=false;
					}
					if (page_str=="") {
						currPage=0;
						notfind_page=false;
					} else {
						for (var j:int=0; j < sectionData[currSec].page.length(); j++) {
							if (sectionData[currSec].page[j].@tag == page_str) {
								currPage=j;
								notfind_page=false;
								break;
							}
						}
					}
				} else {
					currSec=0;
					currPage=0;
				}
				var tags:Array=new Array();
				var names:Array=new Array();
				for (var s:int=0; s<sectionData[currSec].page.length(); s++) {
					tags[s]=sectionData[currSec].page[s].@tag;
					names[s]=sectionData[currSec].page[s].@name;
				}
				if (!notfind_sec && !notfind_page) {
					if (lastSec!=currSec || lastPage!=currPage) {
						setPage(true);
					}
					subnav.reset((lastSec!=currSec),names,tags,currPage,(currSec!=0));
					lastSec=currSec;
					lastPage=currPage;

				}
			}
		}
		private function backHandler(event:Event):void {
			if (event.target.getTag=="") {
				navToPage("home");
			} else {
				navToPage(event.target.getTag);
			}
			event.stopPropagation();
		}
		private function subHandler(event:Event):void {
			navToPage(event.target.getTag,false);
			event.stopPropagation();
		}

		private function clean():void {
			sectionData=[];
			currSec=0;
			currPage=0;
			lastSec=0;
			lastPage=0;
			seted=false;
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeChildren(this);

				removeEventListener(Site.SUB_CLICKED,subHandler);
				removeEventListener(Site.BACK_CLICKED,backHandler);

				clean();
			}
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		//get
		public function get getSec():int {
			return currSec;
		}
		public function get getSecName():String {
			return sectionData[currSec].@tag;
		}
	}
}