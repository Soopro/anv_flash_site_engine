package comps{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.geom.Rectangle;
	import flash.media.Video;

	import comps.images.*;
	import comps.loader.*;
	import tools.*;

	public class GStreamPlayer extends MovieClip {

		private var sound_mute_event:Event=new Event(Site.SOUND_TEMP_MUTE,true,false);
		private var sound_unmute_event:Event=new Event(Site.SOUND_UNTEMP_MUTE,true,false);
		
		//Object preplace
		private var loader_ui:ClipLoaderUI=new ClipLoaderUI;

		private var outline:ImageOutline=new ImageOutline;
		private var mask_area:AreaSprite=new AreaSprite;

		private var player_Rect:Rectangle=new Rectangle;
		private var stream:NetStream;
		private var video:Video;
		private var connection:NetConnection;
		private var screen:Sprite=new Sprite;
		private var trans:SoundTransform;
		private var client:CustomClient;

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
		private var totalTime:Number=0;
		private var streamCheck:Boolean=true;
		private var downloaded:Boolean=false;
		private var playEnd:Boolean=false;
		private var playPercent:Number=0;
		private var loadPercent:Number=0;
		private var mute:Boolean=true;


		public function GStreamPlayer() {
			clean();
		}
		public function setup(pm_xml:XML=null):void {
			if(stage!=null){
			clean();
			if (pm_xml != null) {
				player_Rect=new Rectangle(pm_xml.@x,pm_xml.@y,pm_xml.@w,pm_xml.@h);

				addChild(mask_area);

				mask_area.set(player_Rect.width - ImageOutline.getBorder * 2,player_Rect.height - ImageOutline.getBorder * 2,ImageOutline.getBorder,ImageOutline.getBorder);

				addChildAt(screen,0);
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
					totalTime=pm_xml.@time;
				}
				if (pm_xml.@stream == 0) {
					streamCheck=false;
				}
				if (pm_xml.@mute == 0) {
					mute=false;
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
			var vol_pos:int=vol * volumebar.bararea.width;
			volumebar.mark.x=volumebar.bararea.x + vol_pos;

			addDragListeners(timeline.btn,volumebar.area);
			addBtnListeners(btn_play,btn_stop,btn_pause);
		}
		private function setPlayer():void {
			connection=new NetConnection  ;
			connection.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			connection.connect(null);
			
			screen.mask=mask_area;

			doClose();
			loaderUIState("off");
			setVolume(vol);
			addEventListener(Event.ENTER_FRAME,streamHandler);
		}
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream();
					break;

				case "NetConnection.Connect.Failed" :
					doError();
					break;
				case "NetConnection.Connect.AppShutdown" :
					doError();
					break;
				case "NetConnection.Connect.InvalidApp" :
					doError();
					break;
				case "NetConnection.Connect.Rejected" :
					doError();
					break;
				case "NetStream.Play.StreamNotFound" :
					doError();
					break;
				case "NetStream.Pause.Notify":
					//playState="paused";
				break;
				case "NetStream.Unpause.Notify":
					//playState="playing";
				break;
				case "NetStream.Play.Start" :
					playEnd=false;
					playState="ready";
					doOpen();
					streamSwitch(streamCheck);
					loaderUIState("off");
					break;
				case "NetStream.Play.Stop" :
					if(stream.time>=totalTime){
						playEnd=true;
					}
					if(stream.bufferLength==0 && playEnd){
						endStremPlay()
					}
					break;
				case "NetStream.Buffer.Empty" :
					if(playEnd){
						endStremPlay()
					}
					break;
			}
		}
		private function endStremPlay():void{
				doPause();
				if (reback) {
					doStop();
				}
				if (loop) {
					doStop();
					doPlay();
				}
		}
		
		private function connectStream():void {
			stream=new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
			video=new Video  ;
			video.attachNetStream(stream);
			screen.addChild(video);
			screen.width=player_Rect.width;
			screen.height=player_Rect.height;

			client=new CustomClient();
			client.addEventListener("Metadaten",setMetaData);
			client.addEventListener("StreamEnd",finishStream);
			stream.client=client;
			stream.bufferTime=buffer_time;
			stream.play(path);
			setVolume(vol);
		}
		private function setMetaData(event:Event):void {
			totalTime=client.metaData.duration;
		}
		private function finishStream(event:Event):void {
			trace("finished");
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			doError();
		}
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			doError();
		}

		private function streamSwitch(ch:Boolean):void {
			streamCheck=ch;
			if (! streamCheck) {
				timeline.btn.visible=false;
				timeline.mark.alpha=0.5;
			} else {
				timeline.btn.visible=true;
				timeline.mark.alpha=1;
			}
		}
		private function streamHandler(event:Event):void {
			if (!playDraging && totalTime>0 && stream.time>=0) {
				playPercent=stream.time/totalTime;
				playheadUpdate(playPercent);
				
			}
			//trace(totalTime);
			if (!downloaded) {
				if(stream.bytesTotal > 0){
					loadPercent=stream.bytesLoaded / stream.bytesTotal;
				
					if (loadPercent==1) {
						downloading(1);
						loaderUIState("off");
						streamSwitch(true);
						downloaded=true;
					} else {
					
						downloading(loadPercent);
						streamPlaying();
						if(playState!="playing"){
							loaderUIState("on");
						}else{
							loaderUIState("off");
						}
						downloaded=false;
					}
				}
			}
		}
		private function downloading(percent:Number):void {
			var d_w:int=timeline.bg.width * percent;
			timeline.dbar.width=d_w;
			var p:int=percent * 100;
			loader_ui.setPercent(p);
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

		private function streamPlaying():void {
			if (! playDraging && playState == "playing") {
				playheadUpdate(stream.time / totalTime);
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
			if (obj == volumebar.area) {
				switch (event.type) {
					case MouseEvent.ROLL_OVER :
						volumebar.mark.gotoAndPlay("on");
						break;
					case MouseEvent.ROLL_OUT :
						volumebar.mark.gotoAndPlay("off");
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
		//timeline drag
		private function playMark(str:String):void {
			switch (str) {
				case "on" :
					stream.pause();
					idleCheck=10;
					addEventListener(Event.ENTER_FRAME,seekHandler);
					playDraging=true;
					break;
				case "off" :
					removeEventListener(Event.ENTER_FRAME,seekHandler);

					playDraging=false;
					if (playState == "playing") {
						stream.resume();
					}
					break;

			}
		}
		private function seekHandler(event:Event):void {
			
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
					var tmp_rect2:Rectangle=new Rectangle(volumebar.bararea.x,3,volumebar.bararea.width-volumebar.mark.width,0);
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
				var m:Number=volumebar.mark.x - volumebar.bararea.x;
				var v:Number=m / volumebar.bararea.width;
				setVolume(v);
			}
		}
		private function seekTo(percent:Number):void {
			playTime=Math.round(percent * totalTime);
			//trace(playTime+" "+totalTime+" "+streamCheck)
			if (playTime >=0 && totalTime > 0 && streamCheck) {
				stream.seek(playTime);
				
			} else {
				playheadUpdate(0);
			}
		}

		private function setVolume(percent:Number):void {
			vol=percent;
			trans=stream.soundTransform;
			trans.volume=vol;
			stream.soundTransform=trans;
			volumebar.bar.width=volumebar.bararea.width * vol;
		}
		private function doPlay():void {
			btn_play.visible=false;
			btn_pause.visible=true;
			btn_stop.gotoAndPlay("stop");
			stream.resume();
			playState="playing";
			pause_mask.visible=false;
			if(mute){
				dispatchEvent(sound_mute_event);
			}
		}
		private function doStop():void {
			playEnd=false;
			btn_play.visible=true;
			btn_pause.visible=false;
			btn_stop.gotoAndPlay("close");
			if(totalTime>0){
				stream.seek(0);
			}
			stream.pause();
			playState="stoped";
			playheadUpdate(0);
			pause_mask.visible=true;
			if(mute){
				dispatchEvent(sound_unmute_event);
			}
		}
		private function doPause():void {
			playEnd=false;
			btn_play.visible=true;
			btn_pause.visible=false;
			stream.pause();
			playState="paused";
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
			playEnd=false;
			playDraging=false;
			volDraging=false;
			path="";
			buffer_time=0.1;
			playState="";
			playTime=0;
			idleCheck=10;
			idleTop=10;
			totalTime=0;
			streamCheck=true;
			downloaded=false;
			playPercent=0;
			loadPercent=0;
			mute=true;

		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
				doStop();
				removeDragListeners(timeline.btn,volumebar.area);
				removeBtnListeners(btn_play,btn_stop,btn_pause);
				if (volDraging) {
					removeEventListener(Event.ENTER_FRAME,volChangeHandler);
				}
				if (playDraging) {
					removeEventListener(Event.ENTER_FRAME,seekHandler);
				}
				removeEventListener(Event.ENTER_FRAME,streamHandler);
				connection.removeEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				stream.removeEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
				client.removeEventListener("Metadaten",setMetaData);
				client.removeEventListener("StreamEnd",finishStream);

				video.clear();
				stream.close();
				connection.close();

				clean()
			}
		}
		//get
		public function get getState():String {
			return playState;
		}
		public function get getTotalTime():Number {
			return totalTime;
		}
		public function get getPlayPercent():Number{
			return playPercent;
		}
		public function get getLoadPercent():Number{
			return loadPercent;
		}
	}
}
import flash.events.Event;
import flash.events.EventDispatcher;
class CustomClient extends EventDispatcher {
	public var metaData:Object;
	public function onMetaData(info:Object):void {
		metaData = info;
		//trace("CUSTOM CLIENT: onMetaData");
		this.dispatchEvent(new Event("Metadaten"));
	}
	public function onCuePoint(info:Object):void {
	}
	public function onPlayStatus(info:Object):void {
		//trace("CUSTOM CLIENT: onPlayStatus");
		this.dispatchEvent(new Event("StreamEnd"));
	}
}