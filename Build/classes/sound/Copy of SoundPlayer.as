package sound{

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
		private var sd_trans:SoundTransform = new SoundTransform();
		private var channel:SoundChannel=new SoundChannel();

		private var bArray:ByteArray=new ByteArray;

		//property 
		private var sd_url:String="";

		private var vol:Number=0.5;
		private var bit:Number=0;

		private var bytes_loaded:Number=0;
		private var bytes_total:Number=0;

		private var position:Number=0;

		private var loadState:String="";
		private var playState:String="";
		private var lastState:String="";

		private var mute_check:Boolean=false;

		private var hasSound:Boolean=false;

		public function SoundPlayer(pm_url:String="") {
			if (pm_url!="") {
				load(pm_url);
			}
		}
		public function load(pm_url:String):void {
			unload();
			if (pm_url!="") {
				loadState="ready";
				hasSound=true;
				sd_url=pm_url;
				configureListeners(sd_clip);
				var request:URLRequest = new URLRequest(sd_url);
				sd_clip.load(request);
			}
		}
		public function unload():void {
			if (hasSound) {
				if (playState=="playing") {
					channel.stop();
				}
				if (loadState=="loading") {
					sd_clip.close();
				}
				removeListeners(sd_clip);
				sd_clip = new Sound();
				sd_trans= new SoundTransform();
				channel= new SoundChannel();
				hasSound=false;
				loadState="";
				playState="";
				lastState="";
				position=0;
				bytes_loaded=0;
				bytes_total=0;
				seekTimer=0;
				mute_check=false;

				bArray= new ByteArray;
			}
		}

		//loader listener
		private function configureListeners(dispatcher:Sound):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.ID3, id3Handler);
			addEventListener(Event.ENTER_FRAME,playerHandler);
		}
		private function removeListeners(dispatcher:Sound):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.ID3, id3Handler);
			removeEventListener(Event.ENTER_FRAME,playerHandler);
		}

		private function completeHandler(event:Event):void {
			sd_clip=sd_loader.content;
			sd_clip.stop();
			sd_clip.soundTransform = sd_trans;
			loadState="loaded";
			dispatchEvent(loaded_event);
		}

		private function id3Handler(event:Event):void {
			trace("id3Handler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			loadState="error";
			dispatchEvent(error_event);
			trace("ioErrorHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			if (totalTime!=0) {
				loadState="loading";
				bytes_loaded=event.bytesLoaded;
				bytes_total=event.bytesTotal;
				dispatchEvent(loading_event);
			}
		}


		//sound listener
		private function playerHandler(event:Event):void {
			if (sd_trans.volume!=vol) {
				sd_trans.volume=sd_trans.volume-(sd_trans.volume-vol)/5;
				sd_trans.volume = vol;
			}
			if (loadState=="loaded") {
				if (mute_check || playState=="seeking") {
					var tmp_trans:SoundTransform = new SoundTransform();
					tmp_trans.volume=0;
					sd_clip.soundTransform=tmp_trans;
				} else {
					sd_clip.soundTransform = sd_trans;
				}
				if (sd_clip.currentFrame>=sd_clip.totalFrames) {
					if (playState=="playing") {
						sd_clip.stop();
						playState="complete";
						dispatchEvent(play_complete_event);
					}
				}
			}
			if (playState=="playing") {
				SoundMixer.computeSpectrum(bArray,false,0);
				bit=bArray.readFloat();
				dispatchEvent(playhead_event);
			} else {
				bit=0;
			}
		}
		//set player

		public function play():void {
			if (loadState=="loading") {
				if (playState=="stoped") {
					sd_clip.gotoAndPlay(2);
					trace("repeat");
				} else {
					if (sd_clip.currentFrame<sd_clip.totalFrames) {
						sd_clip.play();
					}
				}
				playState="playing";
				dispatchEvent(playhead_event);
				dispatchEvent(play_event);
			}
		}
		public function stop():void {
			if (loadState=="loading") {
				playState="stoped";
				sd_clip.gotoAndStop(1);
				dispatchEvent(playhead_event);
				dispatchEvent(stoped_event);
			}
		}
		public function pause():void {
			if (loadState=="loading") {
				channel.stop();
				position=channel.position;
				playState="paused";
				dispatchEvent(paused_event);
			}
		}
		public function seek(t:Number):void {
			if (loadState=="loaded") {
				if(t<totalTime){
				sd_clip.play(t*1000)
				dispatchEvent(seeking_event);
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
		public function getBit():Number {
			return bit;
		}
		//get info
		public function get currentState():String {
			return playState;
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
		public function get time():Number {
			return channel.position/1000;
		}
		public function get totalTime():Number {
			return sd_clip.length / 1000;
		}
		//close all
		public function close():void {
			unload();
			sd_clip=null;
			sd_loader=null;
		}
	}
}