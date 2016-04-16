package players{

	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;

	import flash.media.SoundTransform;
	import flash.media.SoundMixer;

	import flash.media.Sound;
	import flash.media.SoundChannel;

	import flash.utils.ByteArray;


	public class SoundPlayer extends Sprite {


		//events
		public static  const START_PLAY:String="start_play";
		public static  const PLAYHEAD_UPDATE:String="playhead_update";
		public static  const STOPED:String="stoped";
		public static  const PAUSED:String="paused";
		public static  const SEEKED:String="seeked";
		public static  const SEEKING:String="seeking";
		public static  const LOADED:String="loaded";
		public static  const PROGRESS:String="progress";
		public static  const ERROR:String="error";
		public static  const COMPLETE:String="play_complete";
		public static  const ID:String="id";

		private var play_event:Event=new Event(START_PLAY);
		private var playhead_event:Event=new Event(PLAYHEAD_UPDATE);
		private var stoped_event:Event=new Event(STOPED);
		private var paused_event:Event=new Event(PAUSED);
		private var seeked_event:Event=new Event(SEEKED);
		private var seeking_event:Event=new Event(SEEKING);
		private var loading_event:Event=new Event(PROGRESS);
		private var loaded_event:Event=new Event(LOADED);
		private var error_event:Event=new Event(ERROR);
		private var play_complete_event:Event=new Event(COMPLETE);
		private var id_event:Event=new Event(ID);

		//object
		private var sd_clip:Sound=new Sound();
		private var sd_loader:Loader=new Loader();
		private var sd_channel:SoundChannel=new SoundChannel();
		private var sd_trans:SoundTransform = new SoundTransform();

		private var bArray:ByteArray=new ByteArray;

		//property 
		private var sd_url:String="";

		private var sd_type:String="";

		private var vol:Number=0.5;
		private var bit:Number=0;

		private var position:Number=0;

		private var bytes_loaded:Number=0;
		private var bytes_total:Number=0;
		private var total_time:Number=0;
		private var time:Number=0;
		private var seekTimer:int=0;

		private var loop:Boolean=false;

		private var connectState:String="";
		private var playState:String="";
		private var lastState:String="";
		private var error_code:String="none";

		private var mute_check:Boolean=false;
		private var last_mute:Boolean=false;

		private var hasSound:Boolean=false;

		public function SoundPlayer(pm_url:String="",pm_bgm:Boolean=false,pm_time:Number=0) {
			if (pm_url!="") {
				load(pm_url,pm_bgm,pm_time);
			}
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function load(pm_url:String,pm_bgm:Boolean=false,pm_time:Number=0):void {
			unload();
			if (pm_url!="") {
				total_time=pm_time;
				sd_url=pm_url;

				var request:URLRequest = new URLRequest(sd_url);

				if (pm_bgm) {
					sd_type="bgm";
					sd_loader.load(request);
					configureLoaderListeners(sd_loader.contentLoaderInfo);
				} else {
					sd_type="mp3";
					configureListeners(sd_clip);
					sd_clip.load(request);
				}
				connectState="ready";
				hasSound=true;
			}
		}
		public function unload():void {
			if (hasSound) {
				stop();
				try {
					sd_clip.close();
				} catch (e:Error) {
				}
				if (sd_type=="mp3") {
					removeListeners(sd_clip);
					sd_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				} else {
					sd_loader.unload();
					removeLoaderListeners(sd_loader.contentLoaderInfo);
				}
				sd_clip=new Sound();
				sd_channel=new SoundChannel();
				sd_loader=new Loader();
				sd_trans= new SoundTransform();

				connectState="";
				playState="";
				lastState="";
				error_code="none";
				sd_type="";
				position=0;
				bytes_loaded=0;
				bytes_total=0;
				total_time=0;
				time=0;
				seekTimer=0;
				loop=false;

				bArray= new ByteArray();

				hasSound=false;
			}
		}

		//loader listener

		//mp3
		private function configureListeners(dispatcher:Sound):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);

			addEventListener(Event.ENTER_FRAME,playerHandler);
		}
		private function removeListeners(dispatcher:Sound):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);

			removeEventListener(Event.ENTER_FRAME,playerHandler);
		}
		private function completeHandler(event:Event):void {
			total_time=sd_clip.length;
			connectState="loaded";
			dispatchEvent(loaded_event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			connectState="error";
			error_code="ioError:"+ event;
			dispatchEvent(error_event);
			trace("ioErrorHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			connectState="loading";
			bytes_loaded=event.bytesLoaded;
			bytes_total=event.bytesTotal;
			dispatchEvent(loading_event);
		}
		//swf
		private function configureLoaderListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeLoaderHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorLoaderHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressLoaderHandler);
			addEventListener(Event.ENTER_FRAME,playerHandler);
		}

		private function removeLoaderListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeLoaderHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorLoaderHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressLoaderHandler);
			removeEventListener(Event.ENTER_FRAME,playerHandler);
		}
		private function completeLoaderHandler(event:Event):void {
			var obj=sd_loader.content;
			sd_clip=obj.sound;
			total_time=sd_clip.length;
			connectState="loaded";
			dispatchEvent(loaded_event);
		}
		private function progressLoaderHandler(event:ProgressEvent):void {
			connectState="loading";
			bytes_loaded=event.bytesLoaded;
			bytes_total=event.bytesTotal;
			dispatchEvent(loading_event);
		}
		private function ioErrorLoaderHandler(event:IOErrorEvent):void {
			connectState="error";
			error_code="ioError:"+ event;
			dispatchEvent(error_event);
			trace("ioErrorHandler: " + event);
		}
		//sound listener
		private function playerHandler(event:Event):void {
			if (sd_trans.volume.toFixed(2)!=vol.toFixed(2) && !mute_check) {
				sd_trans.volume=sd_trans.volume-(sd_trans.volume-vol)/10;
			}
			if (mute_check) {
				sd_trans.volume=0;
			}

			sd_channel.soundTransform = sd_trans;

			if (playState=="seeking") {
				if (seekTimer<5) {
					seekTimer++;
					mute_check=true;
				} else {
					if (lastState=="playing") {
						play();
					}
					mute_check=last_mute;
					playState=lastState;
					seekTimer=0;
					dispatchEvent(seeked_event);
				}
				dispatchEvent(playhead_event);
			}
			if (playState=="playing") {
				try {
					SoundMixer.computeSpectrum(bArray,false,0);
				} catch (e:Error) {
				}
				bit=bArray.readFloat();
				bit=sd_trans.volume*bit*100;
				if (loop) {
					time=0;
				} else {
					time=sd_channel.position;
				}
				dispatchEvent(playhead_event);

			} else {
				bit=0;
			}
		}
		private function soundCompleteHandler(event:Event):void {
			sd_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			playState="complete";
			dispatchEvent(play_complete_event);
		}
		//set player

		public function play(pm_loop:Boolean=false):void {
			loop=pm_loop;

			if (sd_clip.length>0) {
				sd_channel.stop();
				sd_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				if (loop) {
					sd_channel = sd_clip.play(0,int.MAX_VALUE);
				} else {
					sd_channel = sd_clip.play(position);
					sd_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				}
				sd_trans.volume=0;
				sd_channel.soundTransform = sd_trans;
				playState="playing";
				dispatchEvent(playhead_event);
				dispatchEvent(play_event);
			}
		}
		public function stop():void {
			if (sd_clip.length>0) {
				playState="stoped";
				sd_channel.stop();
				position=0;
				time=position;
				dispatchEvent(playhead_event);
				dispatchEvent(stoped_event);
			}
		}
		public function pause():void {
			if (sd_clip.length>0) {
				position=sd_channel.position;
				sd_channel.stop();
				playState="paused";
				dispatchEvent(paused_event);
			}
		}
		public function seek(t:Number):void {
			var tmp_position:Number=t*1000;

			seekTimer=0;
			if (!loop && tmp_position<sd_clip.length && tmp_position>0) {
				sd_channel.stop();
				position=tmp_position;
				time=position;

				if (playState!="seeking") {
					lastState=playState;
					last_mute=mute_check;
					playState="seeking";
				}
				dispatchEvent(seeking_event);
			} else {
				error_code="seekError: can not seek when the sound is loop or the seek position is out of sound's length";
				dispatchEvent(error_event);
			}
		}
		//channel
		public function set mute(chk:Boolean):void {
			mute_check=chk;
		}
		public function get mute():Boolean {
			return mute_check;
		}
		public function set volume(v:Number):void {
			vol=v;
		}
		public function get volume():Number {
			return vol;
		}
		public function get getBit():Number {
			return bit;
		}
		//get info
		public function get type():String {
			return sd_type;
		}
		public function get errorCode():String {
			return error_code;
		}
		public function get currentPlayState():String {
			return playState;
		}
		public function get currentConnectState():String {
			return connectState;
		}
		public function get totalBytes():Number {
			return bytes_total;
		}
		public function get loadedBytes():Number {
			return bytes_loaded;
		}
		public function get percent():Number {
			return bytes_loaded / bytes_total;
		}
		public function get currentTime():Number {
			return time / 1000;
		}
		public function get totalTime():Number {
			return total_time / 1000 - 0.2;
		}
		//close all
		public function close():void {
			unload();
			sd_clip=null;
			sd_channel=null;
			sd_trans= null;
		}
	}
}