package player{

	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.utils.Timer;


	public class SimplePlayer extends Sprite {

		public static  const SP_PLAYING:String="playing";
		public static  const SP_PLAY:String="st_play";
		public static  const SP_STATE:String="st_state";
		public static  const SP_STOP:String="st_stop";
		public static  const SP_MUTE:String="st_mute";
		public static  const SP_AUTO:String="st_auto";
		public static  const SP_PAUSE:String="pause";
		public static  const SP_LOADING:String="loading";
		public static  const SP_LOADED:String="loaded";
		public static  const SP_ERROR:String="error";
		public static  const SP_PLAY_COMPLETE:String="play_complete";
		public static  const SP_ID:String="id";
		public static  const SP_CHANGE:String="play_change";
		public static  const SP_SETUP:String="play_setup";

		//events
		private var playing_event:Event=new Event(SP_PLAYING);
		private var auto_event:Event=new Event(SP_AUTO);
		private var play_event:Event=new Event(SP_PLAY);
		private var state_event:Event=new Event(SP_STATE);
		private var stop_event:Event=new Event(SP_STOP);
		private var mute_event:Event=new Event(SP_MUTE);
		private var pause_event:Event=new Event(SP_PAUSE);
		private var loading_event:Event=new Event(SP_LOADING);
		private var loaded_event:Event=new Event(SP_LOADED);
		private var error_event:Event=new Event(SP_ERROR);
		private var play_complete_event:Event=new Event(SP_PLAY_COMPLETE);
		private var id_event:Event=new Event(SP_ID);
		private var change_event:Event=new Event(SP_CHANGE);
		private var setup_event:Event=new Event(SP_SETUP);


		//property 
		private var vol:Number=0;
		private var bit:Number=0;
		private var pos:Number=0;
		private var bytes_Loaded:Number=0;
		private var bytes_Total:Number=0;

		private var soundURL:String;
		private var soundName:String;
		private var sound:Sound=new Sound();
		private var loader:Loader=new Loader();

		private var autoMode:Boolean;
		private var loopMode:Boolean;
		private var playCheck:Boolean;
		private var muteCheck:Boolean;
		private var pauseCheck:Boolean;
		private var stopCheck:Boolean;
		private var channelCheck:Boolean;
		private var loopCheck:Boolean;

		private var loadState:String;


		private var channel:SoundChannel;
		private var sdTransform:SoundTransform;
		private var bArray:ByteArray=new ByteArray;
		private var positionTimer:Timer=new Timer(50);
		private var byteArrayTimer:Timer=new Timer(50);

		public function SimplePlayer() {
			byteArrayTimer.addEventListener(TimerEvent.TIMER,byteArrayHandler);
			positionTimer.addEventListener(TimerEvent.TIMER,positionTimerHandler);
			loadState="";
		}
		//set function
		public function remove():void {
			byteArrayTimer.stop();
			byteArrayTimer.removeEventListener(TimerEvent.TIMER,byteArrayHandler);
			positionTimer.removeEventListener(TimerEvent.TIMER,positionTimerHandler);
		}
		public function setup(url:String,nam:String,v:Number=0.5,auto:Boolean=true,loop:Boolean=true,mute:Boolean=false):void {
			soundURL=url;
			soundName=nam;
			autoMode=auto;
			loopMode=loop;
			muteCheck=mute;
			vol=v;
			pos=0;
			var request:URLRequest = new URLRequest(soundURL);
			sound.load(request);
			addLisenters(sound);
			byteArrayTimer.start();
			dispatchEvents("setup");
			channelCheck=false;
		}
		private function addLisenters(dispatcher):void {
			sound.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			sound.addEventListener(Event.COMPLETE,completeHandler);
			sound.addEventListener(ProgressEvent.PROGRESS,progressHandler);
		}
		private function removeLisenters(dispatcher):void {
			//dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			//dispatcher.addEventListener(Event.ID3, id3Handler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.removeEventListener(Event.COMPLETE,completeHandler);
		}
		private function byteArrayHandler(event:TimerEvent):void {
			SoundMixer.computeSpectrum(bArray,false,0);
			bit=bArray.readFloat();
		}
		private function positionTimerHandler(event:TimerEvent):void {
			pos=channel.position;
			//trace(pos)
			dispatchEvents("playing");
		}

		private function completeHandler(event:Event):void {
			loadState="loaded";
			if (autoMode) {
				setPlay();
			}
		}
		/*
		private function id3Handler(event:Event):void {
		trace("id3Handler: " + event);
		dispatchEvents("id");
		}
		*/
		private function ioErrorHandler(event:Event):void {
			loadState="error";
			dispatchEvents("error");
		}

		private function progressHandler(event:ProgressEvent):void {
			bytes_Loaded=sound.bytesLoaded;
			bytes_Total=sound.bytesTotal;
			loadState="loading";
			dispatchEvents("loading");
		}

		private function soundCompleteHandler(event:Event):void {
			channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
			pos=0;
			if (! loopMode) {
				positionTimer.stop();
				dispatchEvents("play_complete");
			} else {
				if (playCheck) {
					loopCheck=true;
					doPlay();
				}
			}
		}
		private function doPlay():void {
			if (channelCheck) {
				channel.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				channel.stop();
				channelCheck=false;
			}
			channel=sound.play(pos);
			channelCheck=true;
			sdTransform=channel.soundTransform;
			if (! loopCheck) {
				sdTransform.volume=0;
				loopCheck=true;
			} else {
				sdTransform.volume=vol;
			}
			channel.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
			if (sdTransform.volume != vol && ! muteCheck) {

				this.addEventListener(Event.ENTER_FRAME,volUp);
			} else {
				if (muteCheck) {
					sdTransform.volume=0;
				} else {
					sdTransform.volume=vol;
				}
				channel.soundTransform=sdTransform;
			}
		}
		public function setPlay():void {
			if (loadState != "error") {
				playCheck=true;
				pauseCheck=false;
				stopCheck=false;
				positionTimer.start();
				doPlay();
				dispatchEvents("play");
			} else {
				dispatchEvents("error");
			}
		}
		private function volUp(event:Event):void {
			if (playCheck) {

				if (sdTransform.volume < vol) {

					sdTransform.volume=sdTransform.volume + 0.1;
				} else {
					sdTransform.volume=vol;
					this.removeEventListener(Event.ENTER_FRAME,volUp);
				}
				channel.soundTransform=sdTransform;
			}
		}
		private function volDown(event:Event):void {
			if (! playCheck) {
				if (sdTransform.volume > 0) {
					sdTransform.volume=sdTransform.volume - 0.1;
				} else {
					sdTransform.volume=0;
					channel.stop();
					positionTimer.stop();
					this.removeEventListener(Event.ENTER_FRAME,volDown);
				}
				channel.soundTransform=sdTransform;
			}
		}
		public function setPause():void {
			if (loadState != "error") {
				if (! muteCheck && playCheck) {
					this.addEventListener(Event.ENTER_FRAME,volDown);
				}
				playCheck=false;
				pauseCheck=true;
				stopCheck=false;
				positionTimer.stop();
				loopCheck=false;
				dispatchEvents("pause");
			} else {
				dispatchEvents("error");
			}
		}
		public function setStop():void {
			if (loadState != "error") {
				if (! muteCheck && playCheck) {
					this.addEventListener(Event.ENTER_FRAME,volDown);
				}
				pos=0;
				playCheck=false;
				pauseCheck=false;
				stopCheck=true;
				//positionTimer.stop();
				loopCheck=false;

				dispatchEvents("stop");
			} else {
				dispatchEvents("error");
			}
		}
		public function setVol(v:Number):void {
			vol=v;
			if (playCheck && ! muteCheck) {
				sdTransform.volume=vol;
				channel.soundTransform=sdTransform;
			}
		}
		public function setMute():void {
			var _teSP_vol:Number;
			if (! muteCheck) {
				_teSP_vol=0;
				muteCheck=true;
			} else {
				_teSP_vol=vol;
				muteCheck=false;
			}
			if (playCheck) {
				sdTransform.volume=_teSP_vol;
				channel.soundTransform=sdTransform;
			}
			dispatchEvents("mute");
		}


		public function setAuto():void {

			autoMode=!autoMode;

			if (autoMode && loadState == "loaded") {
				pos=0;
				setPlay();
			}
			dispatchEvents("auto");

		}
		//get property 
		public function get getName():String {
			return soundName;
		}
		public function get getVol():Number {
			var _vol=(Math.round(sdTransform.volume*100))/100;
			return _vol;
		}
		public function get getBit():Number {
			return bit;
		}
		public function get getLoaded():Number {
			return bytes_Loaded;
		}
		public function get getTotal():Number {
			return bytes_Total;
		}
		public function get getLoadPercent():Number {
			var percent:Number=Math.round(bytes_Loaded / bytes_Total * 100);
			return percent;
		}
		public function get getMute():Boolean {
			if (! muteCheck) {
				return false;
			} else {
				return true;
			}
		}
		public function get getPlay():Boolean {
			if (! playCheck) {
				return false;
			} else {
				return true;
			}
		}
		public function get getPause():Boolean {
			if (! pauseCheck) {
				return false;
			} else {
				return true;
			}
		}
		public function get getStop():Boolean {
			if (! stopCheck) {
				return false;
			} else {
				return true;
			}
		}
		public function get getAuto():Boolean {
			if (! autoMode) {
				return false;
			} else {
				return true;
			}
		}
		//dispatchEvents
		private function dispatchEvents(dispatcher:String) {
			switch (dispatcher) {
				case "playing" :
					dispatchEvent(playing_event);
					break;
				case "auto" :
					dispatchEvent(auto_event);
					break;
				case "play" :
					dispatchEvent(play_event);
					break;
				case "stop" :
					dispatchEvent(stop_event);
					break;
				case "pasue" :
					dispatchEvent(pause_event);
					break;
				case "loading" :
					dispatchEvent(loading_event);
					break;
				case "loaded" :
					dispatchEvent(loaded_event);
					break;
				case "mute" :
					dispatchEvent(mute_event);
					break;
				case "id" :
					dispatchEvent(id_event);
					break;
				case "error" :
					dispatchEvent(error_event);
					break;
				case "play_complete" :
					dispatchEvent(play_complete_event);
					break;
				case "play_change" :
					dispatchEvent(change_event);
					break;
				case "setup" :
					dispatchEvent(setup_event);
					break;
			}
		}
	}
}