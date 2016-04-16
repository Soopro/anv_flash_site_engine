package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	//import flash.net.URLRequest;
	//import flash.net.navigateToURL;
	import flash.external.ExternalInterface;

	import tools.*;
	import views.*;
	import players.*;
	import nav.*;

	public class MainController extends MovieClip {


		//object preplace
		private var navs:Array=new Array;
		private var sec:Section=new Section;
		private var generalData:XML=new XML;
		private var contentsData:Array=new Array;
		private var toptitle:TopTitle=new TopTitle();
		private var copyright:CrText=new CrText();
		private var currSec:int=0;

		//variable preplace

		private var time:Number=1;
		private var checker:Boolean=false;

		public function MainController() {
			this.mouseEnabled=false;
		}
		public function setup(pm_gd:XML,pm_cd:Array):void {
			generalData=pm_gd;
			contentsData=pm_cd;
			secbox.addChild(sec);
			sec.y=198;
			sec.mouseEnabled=false;
			addChildAt(copyright,0);
			addChild(toptitle);
			copyright.setup(generalData.copyright[0]);
			sdplayer.setup(generalData.sdplayer[0]);
			soundbtn.setup(generalData.soundbtn[0]);
			langbtn.setup(generalData.lang[0]);
			logo.setup(generalData.logo[0],generalData.logo[0].@x,generalData.logo[0].@y);
			topbox.setup(generalData.logo[0].@short);
			Site.module.addScreen(this);

			addEventListener(Site.SEC_CHANGE,secHandler);
			addEventListener(Site.BTN_CLICKED,btnHandler);
			addEventListener(TextEvent.LINK,linkHandler);
			setNav();
			setPop();
			this.addEventListener(Event.REMOVED,removed);
			this.gotoAndPlay("in");

			logo.addEventListener(Site.IN_COMPLETE,topHandler);
			logo.addEventListener(Site.OUT_COMPLETE,topHandler);
			addEventListener(Event.ENTER_FRAME,soundWaveHandler);
		}
		//this function use on timeline, layer'action' when all animation in.
		private function setSec():void {
			sec.setup(contentsData);
			copyright.active();
		}
		private function toPage(ta:String=""):void {
			sec.navToPage(ta);
		}
		private function setPop():void {
			pop_nav.setup(generalData.popups[0]);
			pop_info.setup(generalData.popups[0].info[0]);
		}
		private function setNav():void {
			navs=[nav_0,nav_1,nav_2];
			nav_0.setup(generalData.navigation.nav[0]);
			nav_1.setup(generalData.navigation.nav[1]);
			nav_2.setup(generalData.navigation.nav[2]);
			nav_info.setup(generalData.navigation.info[0]);
			addEventListener(Site.NAV_ROLL_OVER,navHandler);
			addEventListener(Site.NAV_ROLL_OUT,navHandler);
			addEventListener(Site.NAV_CLICKED,navHandler);
		}
		private function navHandler(event:Event):void {
			switch (event.type) {
				case Site.NAV_ROLL_OVER :
					nav_info.reset(event.target.getInfo);
					break;
				case Site.NAV_ROLL_OUT :
					nav_info.reset();
					break;
				case Site.NAV_CLICKED :
					toPage(event.target.getTarget);
					break;
			}
		}
		private function secHandler(event:Event):void {
			switch (event.type) {
				case Site.SEC_CHANGE :
					if (event.target.getSec!=currSec) {
						currSec=event.target.getSec;
						surfEnable(event.target.getSec);
						navEnable(event.target.getSecName);
					}
					break;
			}
		}
		private function surfEnable(sec:int):void {
			if (sec==0) {
				surfboard.doOpen();
				toptitle.reset();
				logo.animIn();
			} else {
				surfboard.doClose();
				logo.animOut();
				toptitle.reset(generalData.navigation.nav[sec-1].txt[0]);
			}
		}
		private function topHandler(event:Event):void {
			switch (event.type) {
				case Site.IN_COMPLETE :
					topbox.animOff();
					break;
				case Site.OUT_COMPLETE :
					topbox.animOn();
					break;

			}
		}
		private function navEnable(ta:String):void {
			for each (var obj:MainNavBtn in navs) {
				if (obj.getTag == ta) {
					obj.select();
				} else {
					if (obj.getSelect) {
						obj.unselect();
					}
				}
			}
		}
		private function soundWaveHandler(event:Event):void {
			topbox.setWave(sdplayer.getBit);
		}
		private function btnHandler(event:Event):void {
			switch (event.target.getType) {
				case "go" :
					toPage(event.target.getTarget);
					break;
				case "download" :
					urlTo(event.target.getDataSource,event.target.getTarget);
					break;
				case "link" :
					urlTo(event.target.getDataSource,event.target.getTarget);
					break;
			}
			event.stopPropagation();
		}
		private function urlTo(url:String="#",ta:String="_self"):void {
			if (ta=="" || ta==null) {
				ta="_self";
			}
			

			//if (ta!="_self") {
				External.openWindow(url,ta)
				//ExternalInterface.call("openwindow", url,ta);
			//} else {
				//var request:URLRequest=new URLRequest(url);
				//navigateToURL(request,ta);
			//}
			
		}
		private function linkHandler(event:TextEvent):void {

			var link:String=event.text;
			var target:String=link.slice(link.indexOf("$")+1);
			var url:String=link.slice(0,link.indexOf("$"));

			urlTo(url,target);
		}

		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				navs=[];
				generalData=new XML  ;
				contentsData=[];
				removeEventListener(Site.NAV_ROLL_OVER,navHandler);
				removeEventListener(Site.NAV_ROLL_OUT,navHandler);
				removeEventListener(Site.NAV_CLICKED,navHandler);

				removeEventListener(Site.BTN_CLICKED,btnHandler);
				removeEventListener(Site.LINKED,linkHandler);
				logo.removeEventListener(Site.IN_COMPLETE,topHandler);
				logo.removeEventListener(Site.OUT_COMPLETE,topHandler);
				removeEventListener(Event.ENTER_FRAME,soundWaveHandler);
				removeChildren(this);
			}
		}
	}
}