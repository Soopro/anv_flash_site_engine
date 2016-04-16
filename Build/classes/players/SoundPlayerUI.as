package players{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;


	public class SoundPlayerUI extends MovieClip {

		//object
		private var playerXML:XML=new XML();
		private var player:SoundPlayer=new SoundPlayer();

		//property 
		private var volDraging:Boolean=false;
		private var playDraging:Boolean=false;
		private var playPercent:Number=0;
		private var loadPercent:Number=0;
		private var vol:Number=0.5;

		private var auto:Boolean=false;
		private var repeat:Boolean=false;
		private var bgm:Boolean=false;
		private var reback:Boolean=false;

		private var currSound:int=0;
		
		private var muteCheck:Boolean=false;


		public function SoundPlayerUI() {
			clean();
		}
		public function setup(pm_xml:XML=null):void {
			clean();
			if (stage!=null) {
				if (pm_xml!=null) {
					playerXML=pm_xml;
					
					cover.setup(playerXML.cover[0])
					
					btn_pause.visible=false;

					if (playerXML.@auto ==1) {
						auto=true;
					}
					if (playerXML.@reback ==1) {
						reback=true;
					}
					if (playerXML.@loop ==1) {
						repeat=true;
					}
					if (playerXML.@vol !=undefined) {
						vol=playerXML.@vol;
					} else {
						vol=0.5;
					}
					//vol init
					volbar.mark.x=vol*(volbar.volpoints.width-volbar.mark.width);
					volbar.volmask.width=volbar.mark.x+volbar.mark.width;
					player.volume=vol;

					doRepeat(false);

					setSound(currSound);
					
					
					addMuteListener();
					addItemLisenter();
					addBtnListeners(btn_play,btn_pause,btn_stop);
					addPlayerListeners();
					this.addEventListener(Event.REMOVED,removed);
				}
			}
		}
		
		private function setSound(pm_order:int):void {
			currSound=pm_order;
			if (playerXML.sound[currSound].@bgm==1) {
				bgm=true;
			} else {
				bgm=false;
			}
			if (playerXML.sound[currSound].@vol!=undefined) {
				vol=playerXML.sound[currSound].@vol;
			} else {
				if (playerXML.@vol !=undefined) {
					vol=playerXML.@vol;
				} else {
					vol=0.5;
				}
			}
			var tmp_time:Number=playerXML.sound[currSound].@time;
			player.load(playerXML.sound[currSound].@src,bgm,tmp_time);
			namebar.namebox.setup(playerXML.sound[currSound]);
			if (bgm) {
				timeline.playbar.visible=false;
				timeline.alpha=0.2;
				bgmbar.visible=true;
			} else {
				timeline.playbar.visible=true;
				timeline.alpha=1;
				bgmbar.visible=false;
			}
			playheadUpdate(0);
			timeline.loadbar.gotoAndStop(1);
		}
		//listeners
		private function addPlayerListeners():void {
			player.addEventListener(SoundPlayer.PROGRESS,loadHandler);
			player.addEventListener(SoundPlayer.LOADED,loadHandler);
			player.addEventListener(SoundPlayer.COMPLETE,playHandler);
			player.addEventListener(SoundPlayer.PLAYHEAD_UPDATE,playHandler);
			player.addEventListener(SoundPlayer.STOPED,playHandler);
		}
		private function removePlayerListeners():void {
			player.removeEventListener(SoundPlayer.PROGRESS,loadHandler);
			player.removeEventListener(SoundPlayer.LOADED,loadHandler);
			player.removeEventListener(SoundPlayer.COMPLETE,playHandler);
			player.removeEventListener(SoundPlayer.PLAYHEAD_UPDATE,playHandler);
			player.removeEventListener(SoundPlayer.STOPED,playHandler);
		}
		private function addBtnListeners(...btns):void {
			for (var i:int=0; i<btns.length; i++) {
				btns[i].addEventListener(MouseEvent.ROLL_OVER,playBtnHandler);
				btns[i].addEventListener(MouseEvent.ROLL_OUT,playBtnHandler);
				btns[i].addEventListener(MouseEvent.MOUSE_DOWN,playBtnHandler);
				btns[i].addEventListener(MouseEvent.MOUSE_UP,playBtnHandler);
				btns[i].addEventListener(MouseEvent.CLICK,playBtnHandler);
				btns[i].buttonMode=true;
				btns[i].tabEnabled=false;
			}
			player.addEventListener(SoundPlayer.START_PLAY,playBtnHandler);
			player.addEventListener(SoundPlayer.PAUSED,playBtnHandler);
			player.addEventListener(SoundPlayer.STOPED,playBtnHandler);
		}
		private function removeBtnListeners(...btns):void {
			for (var i:int=0; i<btns.length; i++) {
				btns[i].removeEventListener(MouseEvent.ROLL_OVER,playBtnHandler);
				btns[i].removeEventListener(MouseEvent.ROLL_OUT,playBtnHandler);
				btns[i].removeEventListener(MouseEvent.MOUSE_DOWN,playBtnHandler);
				btns[i].removeEventListener(MouseEvent.MOUSE_UP,playBtnHandler);
				btns[i].removeEventListener(MouseEvent.CLICK,playBtnHandler);
			}
			player.removeEventListener(SoundPlayer.START_PLAY,playBtnHandler);
			player.removeEventListener(SoundPlayer.PAUSED,playBtnHandler);
			player.removeEventListener(SoundPlayer.STOPED,playBtnHandler);
		}
		private function addItemLisenter():void {
			repeat_btn.addEventListener(MouseEvent.CLICK,repeatHandler);
			namebar.aw_r.addEventListener(MouseEvent.ROLL_OVER,namebarHandler);
			namebar.aw_r.addEventListener(MouseEvent.ROLL_OUT,namebarHandler);
			namebar.aw_r.addEventListener(MouseEvent.MOUSE_DOWN,namebarHandler);
			namebar.aw_r.addEventListener(MouseEvent.MOUSE_UP,namebarHandler);
			namebar.aw_r.addEventListener(MouseEvent.CLICK,namebarHandler);
			namebar.aw_l.addEventListener(MouseEvent.ROLL_OVER,namebarHandler);
			namebar.aw_l.addEventListener(MouseEvent.ROLL_OUT,namebarHandler);
			namebar.aw_l.addEventListener(MouseEvent.MOUSE_DOWN,namebarHandler);
			namebar.aw_l.addEventListener(MouseEvent.MOUSE_UP,namebarHandler);
			namebar.aw_l.addEventListener(MouseEvent.CLICK,namebarHandler);

			volbar.area.addEventListener(MouseEvent.ROLL_OVER,volbtnHandler);
			volbar.area.addEventListener(MouseEvent.ROLL_OUT,volbtnHandler);
			volbar.area.addEventListener(MouseEvent.MOUSE_DOWN,volbtnHandler);

			timeline.area.addEventListener(MouseEvent.MOUSE_DOWN,timelineHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,stageHandler);

			namebar.aw_l.buttonMode=namebar.aw_r.buttonMode=repeat_btn.buttonMode=true;
			namebar.aw_l.tabEnabled=namebar.aw_r.tabEnabled=repeat_btn.tabEnabled=false;
		}
		private function removeItemLisenter():void {
			repeat_btn.removeEventListener(MouseEvent.CLICK,repeatHandler);
			namebar.aw_r.removeEventListener(MouseEvent.ROLL_OVER,namebarHandler);
			namebar.aw_r.removeEventListener(MouseEvent.ROLL_OUT,namebarHandler);
			namebar.aw_r.removeEventListener(MouseEvent.MOUSE_DOWN,namebarHandler);
			namebar.aw_r.removeEventListener(MouseEvent.MOUSE_UP,namebarHandler);
			namebar.aw_r.removeEventListener(MouseEvent.CLICK,namebarHandler);
			namebar.aw_l.removeEventListener(MouseEvent.ROLL_OVER,namebarHandler);
			namebar.aw_l.removeEventListener(MouseEvent.ROLL_OUT,namebarHandler);
			namebar.aw_l.removeEventListener(MouseEvent.MOUSE_DOWN,namebarHandler);
			namebar.aw_l.removeEventListener(MouseEvent.MOUSE_UP,namebarHandler);
			namebar.aw_l.removeEventListener(MouseEvent.CLICK,namebarHandler);
			volbar.area.removeEventListener(MouseEvent.ROLL_OVER,volbtnHandler);
			volbar.area.removeEventListener(MouseEvent.ROLL_OUT,volbtnHandler);
			volbar.area.removeEventListener(MouseEvent.MOUSE_DOWN,volbtnHandler);

			timeline.area.removeEventListener(MouseEvent.MOUSE_DOWN,timelineHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageHandler);

		}
		private function addMuteListener():void{
			stage.addEventListener(Site.SOUND_TO_MUTE,muteHandler)
			stage.addEventListener(Site.SOUND_UN_MUTE,muteHandler)
			stage.addEventListener(Site.SOUND_TEMP_MUTE,muteHandler)
			stage.addEventListener(Site.SOUND_UNTEMP_MUTE,muteHandler)
		}
		private function removeMuteListener():void{
			stage.removeEventListener(Site.SOUND_TO_MUTE,muteHandler)
			stage.removeEventListener(Site.SOUND_UN_MUTE,muteHandler)
			stage.removeEventListener(Site.SOUND_TEMP_MUTE,muteHandler)
			stage.removeEventListener(Site.SOUND_UNTEMP_MUTE,muteHandler)
		}
		
		private function loadHandler(event:Event):void {
			switch (event.type) {
				case SoundPlayer.PROGRESS :
					loadPercent=player.percent;
					var _loadframes:int=loadPercent*100;
					timeline.loadbar.gotoAndStop(_loadframes);
					if (player.currentPlayState=="" && !bgm) {
						if(auto || repeat ){
							doPlay();
						}
					}
					break;
				case SoundPlayer.LOADED :
					if (auto && player.currentPlayState=="" && bgm) {
						doPlay();
					}
					break;
			}
		}
		private function playHandler(event:Event):void {
			switch (event.type) {
				case SoundPlayer.PLAYHEAD_UPDATE :
					playheadUpdate(player.currentTime/player.totalTime);

					break;
				case SoundPlayer.COMPLETE :
					if (reback) {
						doStop();
					} else {
						doPause();
					}
					doNext();
					break;
				case SoundPlayer.STOPED :
					playheadUpdate(0);
					break;
			}
		}
		private function playheadUpdate(n:Number):void {
			if (!playDraging) {
				playPercent=n;
				var _playframes:int=playPercent*100;
				timeline.playbar.gotoAndStop(_playframes);
			}
		}
		private function playBtnHandler(event:*):void {
			var obj=event.currentTarget;
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

					if (obj==btn_play) {
						doPlay();
					}
					if (obj==btn_pause) {
						doPause();
					}
					if (obj==btn_stop) {
						doStop();
					}
					break;
				case SoundPlayer.START_PLAY :
					btn_play.visible=false;
					btn_pause.visible=true;
					break;
				case SoundPlayer.STOPED :
					btn_play.visible=true;
					btn_pause.visible=false;
					break;
				case SoundPlayer.PAUSED :
					btn_play.visible=true;
					btn_pause.visible=false;
					break;
			}
		}
		private function namebarHandler(event:MouseEvent):void {
			var obj=event.currentTarget;
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
					if (obj==namebar.aw_l) {
						if (currSound>0) {
							currSound--;
						} else {
							currSound=playerXML.sound.length()-1;
						}
					}
					if (obj==namebar.aw_r) {
						if (currSound<playerXML.sound.length()-1) {
							currSound++;
						} else {
							currSound=0;
						}
					}
					setSound(currSound);
					break;
			}
		}
		private function repeatHandler(event:MouseEvent):void {
			doRepeat();
		}
		private function doRepeat(chk:Boolean=true):void {
			if (chk) {
				repeat=!repeat;
			}
			if (repeat) {
				repeat_btn.gotoAndPlay("on");
			} else {
				repeat_btn.gotoAndPlay("off");
			}
		}
		private function timelineHandler(event:MouseEvent):void {
			playDraging=true;
			addEventListener(Event.ENTER_FRAME,seekHandler);
		}
		private function volbtnHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					volbar.mark.gotoAndPlay("on");
					break;
				case MouseEvent.ROLL_OUT :
					volbar.mark.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					var tmp_rect:Rectangle=new Rectangle(0,0,18,0);
					volbar.mark.startDrag(false,tmp_rect);
					addEventListener(Event.ENTER_FRAME,volChangeHandler);
					volDraging=true;
					break;
			}
		}
		private function stageHandler(event:MouseEvent):void {
			if (event.type==MouseEvent.MOUSE_UP) {
				if (volDraging) {
					volbar.mark.stopDrag();
					removeEventListener(Event.ENTER_FRAME,volChangeHandler);
					volDraging=false;
				}

				if (playDraging) {
					removeEventListener(Event.ENTER_FRAME,seekHandler);
					playDraging=false;
				}
			}
		}
		private function volChangeHandler(event:Event):void {
			volbar.volmask.width=volbar.mark.x+volbar.mark.width;
			vol=volbar.mark.x/(volbar.volpoints.width-volbar.mark.width);
			player.volume=vol;
		}
		private function seekHandler(event:Event):void {
			if (playDraging) {
				var tmp_percent:Number=0;
				if (timeline.area.mouseX>=0 && timeline.mouseX<timeline.area.width) {
					tmp_percent=timeline.mouseX/timeline.area.width;
				}
				if (timeline.mouseX<0) {
					tmp_percent=0;
				}
				if (timeline.mouseX>timeline.area.width) {
					tmp_percent=1;
				}
				if (tmp_percent>=loadPercent) {
					tmp_percent=loadPercent;
				}
				var tmp_frame:int=tmp_percent*100;
				timeline.playbar.gotoAndStop(tmp_frame);

				player.seek(player.totalTime*tmp_percent);
			}
		}
		
		//mute
		private function muteHandler(event:Event):void{
			switch(event.type){
				case Site.SOUND_TO_MUTE:
					muteCheck=true;
					doMute(muteCheck);
			    break;
				case Site.SOUND_UN_MUTE:
					muteCheck=false;
					doMute(muteCheck);
			    break;
				case Site.SOUND_TEMP_MUTE:
					doMute(true);
			    break;
				case Site.SOUND_UNTEMP_MUTE:
					doMute(muteCheck);
			    break;
			}
		}
		
		//play function
		private function doNext():void {
			if (currSound<playerXML.sound.length()-1 || repeat) {
				if (currSound<playerXML.sound.length()-1) {
					currSound++;
				} else {
					currSound=0;
				}
				if (playerXML.sound[currSound].@bgm==1) {
					doNext();
				} else {
					setSound(currSound);
				}
			}
		}
		private function doPlay():void {
			player.play(bgm);
		}
		private function doPause():void {
			player.pause();
		}
		private function doStop():void {
			player.stop();
		}
		private function doMute(chk:Boolean=false):void {
			player.mute=chk;
		}
		//get
		public function get getBit():Number {
			return player.getBit;
		}
		//class function 
		private function clean():void {
			volbar.volpoints.mask=volbar.volmask;
			playDraging=false;
			volDraging=false;
			playPercent=0;
			vol=0.5;
			auto=false;
			repeat=false;
			bgm=false;
			reback=false;
			currSound=0;
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				clean();
				player.close();
				removeChildren(this);
				removeItemLisenter();
				removePlayerListeners();
				removeBtnListeners(btn_play,btn_pause,btn_stop);
				removeMuteListener();
				if (volDraging) {
					removeEventListener(Event.ENTER_FRAME,volChangeHandler);
				}
				if (playDraging) {
					removeEventListener(Event.ENTER_FRAME,seekHandler);
				}
			}
		}
	}
}