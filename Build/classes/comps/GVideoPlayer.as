package comps{
	import flash.display.MovieClip;
	import fl.video.VideoPlayer;
	import fl.video.VideoScaleMode;
	import fl.video.VideoState;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoError;
	import fl.video.VideoProgressEvent;
	import flash.geom.Rectangle;

	import comps.images.*;
	import comps.loader.*;
	import tools.*;

	public class GVideoPlayer extends MovieClip {

		//Object preplace
		private var loader_ui:ClipLoaderUI=new ClipLoaderUI  ;

		private var outline:ImageOutline=new ImageOutline  ;
		private var mask_area:AreaSprite=new AreaSprite  ;

		private var player_Rect:Rectangle=new Rectangle  ;
		private var video:VideoPlayer=new VideoPlayer  ;

		//variable preplace
		private var topspace:int=5;
		private var space:int=10;

		private var path:String="";
		private var buffer_time:Number=0.1;
		private var auto:Boolean=true;
		private var loop:Boolean=false;
		private var reback:Boolean=false;
		private var playDraging:Boolean=false;
		private var volDraging:Boolean=false;
		private var vol:Number=0.5;
		private var playState:String="";
		private var playTime:Number=0;
		private var idleCheck:int=5;
		private var idleTop:int=10;
		private var videoTime:Number=0;
		private var stream:Boolean=true;
		private var downloadState:Boolean=false;

		public function GVideoPlayer() {

			clean();
		}
		public function setup(pm_xml:XML=null):void {
			if(stage!=null){
			clean();
				if (pm_xml != null) {
					player_Rect=new Rectangle(pm_xml.@x,pm_xml.@y,pm_xml.@w,pm_xml.@h);
	
					addChild(mask_area);
	
					mask_area.set(player_Rect.width - ImageOutline.getBorder * 2,player_Rect.height - ImageOutline.getBorder * 2,ImageOutline.getBorder,ImageOutline.getBorder);
	
					addChildAt(video,0);
					addChild(loader_ui);
					addChild(outline);
	
					if (pm_xml.@border != 0) {
	
						outline.setup(player_Rect.width,player_Rect.height);
						outline.visible=true;
	
					} else {
						outline.visible=false;
					}
					path=pm_xml.@src;
	
					if (pm_xml.@buffer != undefined) {
						buffer_time=pm_xml.@buffer;
					}
	
					if (pm_xml.@auto == 1) {
						auto=true;
					}
					if (pm_xml.@loop == 1) {
						loop=true;
					}
					if (pm_xml.@reback == 1) {
						reback=true;
					}
					if (pm_xml.@vol != undefined) {
						vol=pm_xml.@vol;
					}
					if (pm_xml.@time != undefined) {
						videoTime=pm_xml.@time;
					}
					if (pm_xml.@stream == 0) {
						stream=false;
					}
					setPlayer();
	
					setControl();
					Anim.fadeIn(this);
					this.addEventListener(Event.REMOVED,removed);
				}
			}
		}
		private function setControl():void {
			this.x=player_Rect.x;
			this.y=player_Rect.y;

			Align.heart(loader_ui,mask_area);
			Align.same(mask_area,pause_mask);


			btn_play.y=btn_stop.y=btn_pause.y=timeline.y=volumebar.y=player_Rect.height + topspace;
			btn_stop.x=player_Rect.width - btn_stop.width - space;
			btn_pause.x=btn_play.x=btn_stop.x - btn_play.width - space;
			volumebar.x=btn_play.x - volumebar.width - space;



			timeline.bg.width=timeline.btn.width=volumebar.x - timeline.x - space;
			timeline.right.x=timeline.bg.width + timeline.bg.x;
			timeline.dbar.width=timeline.pbar.width=1;
			var vol_pos:int=vol * volumebar.area.width;
			volumebar.mark.x=volumebar.area.x + vol_pos;

			addDragListeners(timeline.btn,volumebar.mark);
			addBtnListeners(btn_play,btn_stop,btn_pause);
		}
		private function setPlayer():void {
			video.mask=mask_area;
			video.width=player_Rect.width;
			video.height=player_Rect.height;
			video.bufferTime=buffer_time;
			video.width=player_Rect.width;
			video.height=player_Rect.height;
			video.scaleMode=VideoScaleMode.EXACT_FIT;

			video.autoRewind=true;
			video.idleTimeout=60000;
			video.addEventListener(VideoEvent.COMPLETE,playerHandler);
			video.addEventListener(VideoEvent.PLAYHEAD_UPDATE,playerHandler);
			video.addEventListener(VideoEvent.READY,playerHandler);
			video.addEventListener(VideoEvent.STATE_CHANGE,playerHandler);
			doClose();
			loaderUIState("off");
			video.load(path);
			setVolume(vol);
		}
		private function playerHandler(event:*):void {
			switch (event.type) {
				case VideoEvent.COMPLETE :
					doPause();
					if (reback) {
						doStop();
					}
					if (loop) {
						doStop();
						doPlay();
					}
					break;
				case VideoEvent.PLAYHEAD_UPDATE :
					videoPlaying();
					loaderUIState("off");
					totalTimeCheck();
					break;
				case VideoEvent.READY :
					playState="ready";
					doOpen();
					downloadState=true;
					addEventListener(Event.ENTER_FRAME,downloadHandler);
					streamCheck();
					loaderUIState("off");
					totalTimeCheck();
					break;
				case VideoEvent.STATE_CHANGE :
					if (video.state == VideoState.CONNECTION_ERROR) {
						doError();
					}
					if (video.state == VideoState.LOADING) {
						doClose();
					}

					totalTimeCheck();
					break;
			}
		}
		private function streamCheck():void {
			if (! stream) {
				timeline.btn.visible=false;
				timeline.mark.alpha=0.5;
			} else {
				timeline.btn.visible=true;
				timeline.mark.alpha=1;
			}
		}
		private function downloadHandler(event:Event):void {
			downloading(video.bytesLoaded / video.bytesTotal);
			videoPlaying();
			loaderUIState("on");
			totalTimeCheck();
			if (video.bytesLoaded == video.bytesTotal && video.bytesTotal > 0) {
				removeEventListener(Event.ENTER_FRAME,downloadHandler);
				stream=true;
				streamCheck();
				loaderUIState("off");
			}
		}
		private function downloading(percent:Number):void {
			var d_w:int=timeline.bg.width * percent;
			timeline.dbar.width=d_w;
			var p:int=percent * 100;
			loader_ui.setPercent(p);
		}
		private function totalTimeCheck():void {
			if (video.totalTime > 0) {
				videoTime=video.totalTime;
			}
		}
		
		private function playheadUpdate(percent:Number):void {
			timeline.pbar.width=timeline.bg.width * percent;

			var m_x:int=timeline.pbar.width + timeline.pbar.x;
			var limit:int=timeline.bg.width + timeline.bg.x - timeline.mark.width / 2;
			if (m_x > limit) {
				m_x=limit;
			}
			timeline.mark.x=m_x;
		}

		private function videoPlaying():void {
			if (! playDraging && video.state != VideoState.SEEKING && playState == "playing") {
				playheadUpdate(video.playheadTime / videoTime);
			}
			if (video.state == VideoState.PAUSED && playState == "playing") {
				video.play();
			}
		}
		
		//buttons listeners
		private function addBtnListeners(... targets):void {
			for (var i:int=0; i < targets.length; i++) {
				targets[i].addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				targets[i].addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				targets[i].addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				targets[i].addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				targets[i].addEventListener(MouseEvent.CLICK,mouseHandler);
				targets[i].buttonMode=true;
				targets[i].tabEnabled=false;
			}
		}
		private function removeBtnListeners(... targets):void {
			for (var i:int=0; i < targets.length; i++) {
				targets[i].removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
				targets[i].removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
				targets[i].removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
				targets[i].removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				targets[i].removeEventListener(MouseEvent.CLICK,mouseHandler);
			}
		}
		//drag buttons listeners
		private function addDragListeners(... targets):void {
			for (var i:int=0; i < targets.length; i++) {
				targets[i].addEventListener(MouseEvent.ROLL_OVER,dragHandler);
				targets[i].addEventListener(MouseEvent.ROLL_OUT,dragHandler);
				targets[i].addEventListener(MouseEvent.MOUSE_DOWN,dragHandler);
				targets[i].buttonMode=true;
				targets[i].tabEnabled=false;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,dragHandler);
		}
		private function removeDragListeners(... targets):void {
			for (var i:int=0; i < targets.length; i++) {
				targets[i].removeEventListener(MouseEvent.ROLL_OVER,dragHandler);
				targets[i].removeEventListener(MouseEvent.ROLL_OUT,dragHandler);
				targets[i].removeEventListener(MouseEvent.MOUSE_DOWN,dragHandler);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,dragHandler);
		}
		//set player buttons
		private function mouseHandler(event:Event):void {
			var obj=event.currentTarget;

			if (obj.currentLabel != "close") {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						obj.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						obj.gotoAndPlay("off");
						break;
					case MouseEvent.MOUSE_DOWN :
						obj.gotoAndPlay("press");

						break;
					case MouseEvent.MOUSE_UP :
						obj.gotoAndPlay("on");

						break;
					case MouseEvent.CLICK :
						switch (obj) {
							case btn_play :
								doPlay();
								break;
							case btn_pause :
								doPause();
								break;
							case btn_stop :
								doStop();
								break;
						}
						break;
				}
			}
		}
		//set drag buttons
		private function dragHandler(event:Event):void {
			var obj=event.currentTarget;
			if (obj == volumebar.mark) {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						obj.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						obj.gotoAndPlay("off");
						break;
					case MouseEvent.MOUSE_DOWN :
						volMark("on");
						break;
				}
			}
			if (playState != "error" && playState != "close") {
				if (obj == timeline.btn) {
					switch (event.type) {
						case MouseEvent.ROLL_OVER :
							timeline.mark.gotoAndPlay("on");
							break;
						case MouseEvent.ROLL_OUT :
							timeline.mark.gotoAndPlay("off");
							break;
						case MouseEvent.MOUSE_DOWN :
							playMark("on");
							break;
					}
				}
				if (event.type == MouseEvent.MOUSE_UP) {
					if (playDraging) {
						playMark("off");

					}
					if (volDraging) {
						volMark("off");
					}
				}
			}
		}
		//timeline drag
		private function playMark(str:String):void {
			switch (str) {
				case "on" :
					video.pause();
					idleCheck=10;
					addEventListener(Event.ENTER_FRAME,playChangeHandler);
					playDraging=true;
					break;
				case "off" :
					removeEventListener(Event.ENTER_FRAME,playChangeHandler);

					playDraging=false;
					if (playState == "playing") {
						video.play();
					}
					break;

			}
		}
		private function playChangeHandler(event:Event):void {

			if (playDraging) {
				var tmp_p:Number;
				if (idleCheck >= idleTop) {
					if (timeline.mouseX <= timeline.dbar.width && timeline.mouseX >= timeline.btn.x) {
						tmp_p=timeline.mouseX / timeline.btn.width;
					} else {
						if (timeline.mouseX < timeline.btn.x) {
							tmp_p=0;
						}
						if (timeline.mouseX > timeline.dbar.width) {
							tmp_p=timeline.dbar.width / timeline.btn.width;
						}
					}
					playheadUpdate(tmp_p);
					seekTo(tmp_p);
					idleCheck=0;
				} else {
					idleCheck++;
				}
			}
		}
		//volume drag
		private function volMark(str:String):void {
			switch (str) {
				case "on" :
					var tmp_rect2:Rectangle=new Rectangle(volumebar.area.x,3,volumebar.area.width,0);
					volumebar.mark.startDrag(false,tmp_rect2);
					addEventListener(Event.ENTER_FRAME,volChangeHandler);
					volDraging=true;
					break;
				case "off" :
					volumebar.mark.stopDrag();
					removeEventListener(Event.ENTER_FRAME,volChangeHandler);
					volDraging=false;
					break;
			}
		}
		private function volChangeHandler(event:Event):void {
			if (volDraging) {
				var m:Number=volumebar.mark.x - volumebar.area.x;
				var v:Number=m/ volumebar.area.width;
				setVolume(v);
			}
		}
		private function seekTo(percent:Number):void {
			playTime=Math.round(percent * videoTime);
			if (playTime >0 && video.totalTime > 0 && stream) {
				video.seek(playTime);
			} else {
				playheadUpdate(0);
			}
		}

		private function setVolume(percent:Number):void {
			vol=percent;
			video.volume=vol;
			volumebar.bar.width=volumebar.area.width * vol;

		}
		private function doPlay():void {
			btn_play.visible=false;
			btn_pause.visible=true;
			btn_stop.gotoAndPlay("stop");
			video.play();
			playState="playing";
			pause_mask.visible=false;
		}
		private function doStop():void {
			btn_play.visible=true;
			btn_pause.visible=false;
			btn_stop.gotoAndPlay("close");
			video.stop();
			playState="stoped";
			playheadUpdate(0);
			pause_mask.visible=true;
		}
		private function doPause():void {
			btn_play.visible=true;
			btn_pause.visible=false;
			video.pause();
			playState="pause";
			pause_mask.visible=true;
		}
		private function doClose():void {
			playState="close";
			btn_stop.gotoAndPlay("close");
			btn_pause.gotoAndPlay("close");
			btn_play.gotoAndPlay("close");
		}
		private function doOpen():void {
			btn_play.gotoAndPlay("stop");
			btn_pause.gotoAndPlay("stop");
			btn_play.gotoAndPlay("stop");
			if (auto) {
				doPlay();
			} else {
				doStop();
			}
		}
		private function doError():void {
			playState="error";
			btn_stop.gotoAndPlay("close");
			btn_pause.gotoAndPlay("close");
			btn_play.gotoAndPlay("close");
			loaderUIState("error");
		}
		private function loaderUIState(str:String) {
			switch (str) {
				case "off" :
					loader_ui.visible=false;
					break;
				case "on" :
					loader_ui.visible=true;
					break;
				case "error" :
					loader_ui.visible=true;
					loader_ui.setError();
					break;
			}
		}
		private function clean():void {
			btn_pause.visible=false;
			btn_play.visible=true;
			btn_stop.visible=true;
			auto=false;
			loop=false;
			reback=false;
			vol=0.5;

			playDraging=false;
			volDraging=false;
			path="";
			buffer_time=0.1;
			playState="";
			playTime=0;
			idleCheck=10;
			idleTop=10;
			videoTime=0;
			stream=true;
			downloadState=false;
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				removeDragListeners(timeline.btn,volumebar.mark);
				removeBtnListeners(btn_play,btn_stop,btn_pause);
				if (volDraging) {
					removeEventListener(Event.ENTER_FRAME,volChangeHandler);
				}
				if (playDraging) {
					removeEventListener(Event.ENTER_FRAME,playChangeHandler);
				}
				video.removeEventListener(VideoEvent.COMPLETE,playerHandler);
				video.removeEventListener(VideoEvent.PLAYHEAD_UPDATE,playerHandler);
				video.removeEventListener(VideoEvent.BUFFERING_STATE_ENTERED,playerHandler);
				video.removeEventListener(VideoEvent.READY,playerHandler);
				video.removeEventListener(VideoEvent.STATE_CHANGE,playerHandler);
				if(downloadState){
					removeEventListener(Event.ENTER_FRAME,downloadHandler);
				}
				video.load("none.flv");
				video.idleTimeout=1;
				try {
					video.stop();

					//video.close();
				} catch (e:Error) {
				}
				clean();

				//video=new VideoPlayer();

			}
		}
		//get
		public function get getState():String {
			return playState;
		}
	}
}