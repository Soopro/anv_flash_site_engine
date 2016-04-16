/*
Great TextField varsion 1.0
script by redy, Anvolution Studio.
usage:
create textfield -
setup(pm_xml:XML=null);

*/

package comps{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import comps.*;
	import comps.loader.*;
	import tools.*;
	import views.*;

	public class GTextField extends MovieClip {


		private var in_complete_event:Event=new Event(Site.IN_COMPLETE);
		private var out_complete_event:Event=new Event(Site.OUT_COMPLETE);

		//object preplace
		private var tf_XML:XML=new XML  ;
		private var tabs:Array=new Array  ;
		private var titles:Array=new Array  ;
		private var tf_Rect:Rectangle=new Rectangle  ;

		private var arrows:Arrows=new Arrows  ;
		private var dataloader_ui:DataLoaderUI=new DataLoaderUI  ;
		
		//variable preplace
		private var tf_tag:String="";

		private var tab_order:int=0;
		private var seted:Boolean=false;

		public function GTextField() {
			this.visible=false;
			this.mouseEnabled=false;
			outline.mouseChildren=false;
			//clean();
		}
		public function setup(pm_xml:XML=null):void {
			if(stage!=null && !seted){
				clean();
	
				if (tf_XML != null) {
					tf_XML=pm_xml;
					setData();
					setPos();
					if (tf_XML.tab.length() > 1) {
	
						addArrows(tf_XML.tab.length() - 1,tab_order);
						//tab_XML=tf_XML.tab[tab_order];
					} else {
						//tab_XML=tf_XML;
						removeArrows();
					}
					if (tf_XML.@tag != undefined) {
						tf_tag=tf_XML.@tag;
					}
					seted=true;
	
					this.addEventListener(Event.REMOVED,removed);
				}
			}
		}
		public function count(pm_order:int):void {
			if (pm_order >= 0 && pm_order < tabs.length) {
				tabs[tab_order].visible=false;
				var last_order=tab_order;
				tab_order=pm_order;
				tabs[tab_order].visible=true;

				if (titles[tab_order] != titles[last_order]) {
					setOutline(true);
				}
				Anim.fadeIn(tabs[tab_order]);
			}
		}
		public function reset(pm_xml:XML=null):void {
			if(stage!=null&& seted){
				tabs=[];
				titles=[];
				
				if (pm_xml != null) {
					tf_XML=pm_xml;
					setData(true);
					if (tf_XML.tab.length() > 1) {
						addArrows(tf_XML.tab.length() - 1,tab_order);
						//tab_XML=tf_XML.tab[tab_order];
					} else {
						//tab_XML=tf_XML;
						removeArrows();
					}
				}else{
					var tmp_xml:XML=tf_XML.copy();
					tf_XML=tmp_xml.setChildren("");
					setData(true);
					removeArrows();
				}
			}
		}
		public function doFunction(str:String):void {
			var d_x:int=tf_Rect.width/2;
			var d_y:int=tf_Rect.height/2;
			dataloader_ui.x=d_x;
			dataloader_ui.y=d_y;
			switch (str) {
				case "loading" :
					addChild(dataloader_ui);
					this.alpha=0.5;
					break;
				case "complete" :
					removeChild(dataloader_ui);
					this.alpha=1;
					break;
				case "error" :
					dataloader_ui.setError();
					this.alpha=0.5;
					break;
				case "nodata" :
					addChild(dataloader_ui);
					dataloader_ui.setNodata();
					this.alpha=0.5;
					break;
			}
		}
		private function setData(re:Boolean=false):void {
			if (tf_XML.@count != undefined) {
				tab_order=tf_XML.@count;
			} else {
				tab_order=0;
			}
			if (tab_order > tf_XML.tab.length() - 1 && tf_XML.tab.length() > 0) {
				tab_order=tf_XML.tab.length() - 1;
			}
			if (tab_order < 0) {
				tab_order=0;
			}
			tf_Rect=new Rectangle(tf_XML.@x,tf_XML.@y,tf_XML.@w,tf_XML.@h);

			//set arrows position

			var tmp_rx:int;
			var tmp_ry:int;

			if (tf_XML.@ax != undefined) {
				tmp_rx=tf_XML.ax;
			} else {
				tmp_rx=SiteStyle.getArrows.rx;
			}
			if (tf_XML.@ay != undefined) {
				tmp_ry=tf_XML.ay;
			} else {
				tmp_ry=SiteStyle.getArrows.ry;
			}
			arrows.x=tf_Rect.width + tmp_rx;
			arrows.y=tf_Rect.height + tmp_ry;

			removeChildren(contents);


			//set contents
			if (tf_XML.tab.length() > 0) {
				for (var i:int=0; i < tf_XML.tab.length(); i++) {
					tabs[i]=new NodeSprite  ;
					contents.addChild(tabs[i]);
					titles[i]=tf_XML.tab[i].title;
					//set text
					for (var t:int=0; t < tf_XML.tab[i].texts.length(); t++) {
						var txtcontent=new TextContents  ;
						tabs[i].addChild(txtcontent);
						txtcontent.setup(tf_XML.tab[i].texts[t]);
					}
					//set poster
					for (var p:int=0; p < tf_XML.tab[i].poster.length(); p++) {
						var poster=new PosterPiece  ;
						tabs[i].addChild(poster);
						poster.setup(tf_XML.tab[i].poster[p]);
					}
					/*
					//set video player
					for (var v:int=0; v < tf_XML.tab[i].videoplayer.length(); v++) {
					var video=new GVideoPlayer();
					tabs[i].addChild(video);
					video.setup(tf_XML.tab[i].videoplayer[v]);
					}
					*/
					//set stream player
					for (var s:int=0; s < tf_XML.tab[i].streamplayer.length(); s++) {
						var stream=new GStreamPlayer  ;
						tabs[i].addChild(stream);
						stream.setup(tf_XML.tab[i].streamplayer[s]);
					}
					tabs[i].visible=false;
				}
				tabs[tab_order].visible=true;
			} else {
				titles[0]=tf_XML.title;
				for (var t2:int=0; t2 < tf_XML.texts.length(); t2++) {
					var txtcontent2=new TextContents  ;
					contents.addChild(txtcontent2);
					txtcontent2.setup(tf_XML.texts[t2]);
				}
				//set poster
				for (var p2:int=0; p2 < tf_XML.poster.length(); p2++) {
					var poster2=new PosterPiece  ;
					contents.addChild(poster2);
					poster2.setup(tf_XML.poster[p2]);
				}
				/*
				//set video player
				for (var v2:int=0; v2 < tf_XML.videoplayer.length(); v2++) {
				var video2=new GVideoPlayer();
				contents.addChild(video2);
				video2.setup(tf_XML.videoplayer[v2]);
				}
				*/
				//set stream player
				for (var s2:int=0; s2 < tf_XML.streamplayer.length(); s2++) {
					var stream2=new GStreamPlayer  ;
					contents.addChild(stream2);
					stream2.setup(tf_XML.streamplayer[s2]);
				}
			}
			setOutline(re);
		}
		private function setOutline(re:Boolean):void {
			//set outline
			var tmp:Boolean=true;
			if (tf_XML.@border == 0) {
				tmp=false;
			}
			outline.setup(titles[tab_order],tf_Rect,tmp);
			//active animation
			outline.animIn(re);

		}

		public function animIn():void {
			outline.animIn(false);
			arrows.animIn(false);
			this.gotoAndPlay("in");
		}
		public function animOut():void {
			arrows.animOut();
			this.gotoAndPlay("out");
		}
		private function setPos():void {
			this.x=tf_Rect.x;
			this.y=tf_Rect.y;
			this.visible=true;
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				removeChildren(contents);
				removeChildren(this);
				clean();
				tf_XML=null;
			}
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function clean():void {
			tf_Rect=new Rectangle  ;
			tf_tag="";
			tabs=[];
			titles=[];
			tab_order=0;
			seted=false;
			removeArrows();
		}

		private function countHandler(event:Event):void {
			count(arrows.countNumber);
		}
		private function addArrows(pm_limit:int=0,pm_count:int=0):void {
			if (! this.contains(arrows) && tf_XML.@arrows != 0) {
				addChild(arrows);
				arrows.setup(pm_limit,pm_count);
				arrows.addEventListener(Site.COUNTED,countHandler);
			}
		}
		private function removeArrows():void {
			if (this.contains(arrows)) {
				removeChild(arrows);
				arrows.removeEventListener(Site.COUNTED,countHandler);
			}
		}

		//this function is use on timeline, layer "action"
		private function dispatchState(str:String):void {
			switch (str) {
				case "in" :
					dispatchEvent(in_complete_event);
					break;
				case "out" :
					dispatchEvent(out_complete_event);
					break;
			}
		}

		//get
		public function get getTag():String {
			return tf_tag;
		}
		public function get getData():XML{
			return tf_XML;
		}
	}
}