package players{

	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;

	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;


	public class MCPlayer extends Sprite {


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
		private var sd_loader:Loader=new Loader();
		private var sd_clip:Object=new Object();
		private var sd_trans:SoundTransform = new SoundTransform();

		private var bArray:ByteArray=new ByteArray;

		//property 
		private var sd_url:String="";

		private var vol:Number=0.5;
		private var bit:Number=0;

		private var bytes_loaded:Number=0;
		private var bytes_total:Number=0;
		private var frameRate:int=30;
		private var seekTimer:int=0;

		private var connectState:String="";
		private var playState:String="";
		private var lastState:String="";

		private var mute_check:Boolean=false;

		private var hasSound:Boolean=false;

		public function MCPlayer(pm_url:String="",pm_framerate:int=30) {
			if (pm_url!="") {
				load(pm_url,pm_framerate);
			}
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function load(pm_url:String,pm_framerate:int=30):void {
			unload();
			if (pm_url!="") {
				connectState="loading";
				hasSound=true;
				sd_url=pm_url;
				frameRate=pm_framerate;
				sd_loader = new Loader();
				configureListeners(sd_loader.contentLoaderInfo);
				var request:URLRequest = new URLRequest(sd_url);
				sd_loader.load(request);
			}
		}
		public function unload():void {
			if (hasSound) {
				if (connectState=="loaded") {
					sd_clip.stop();
				}
				sd_loader.unload();
				removeListeners(sd_loader.contentLoaderInfo);
				hasSound=false;
				sd_clip=new Object();
				connectState="";
				playState="";
				lastState="";
				bytes_loaded=0;
				bytes_total=0;
				seekTimer=0;
				frameRate=30;
				mute_check=false;
				sd_trans= new SoundTransform();
				bArray= new ByteArray;
			}
		}

		//loader listener
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
			addEventListener(Event.ENTER_FRAME,playerHandler);
		}
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
			removeEventListener(Event.ENTER_FRAME,playerHandler);
		}

		private function completeHandler(event:Event):void {
			sd_clip=sd_loader.content;
			sd_clip.stop();
			sd_clip.soundTransform = sd_trans;
			connectState="loaded";
			dispatchEvent(loaded_event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			connectState="error";
			dispatchEvent(error_event);
			trace("ioErrorHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			bytes_loaded=event.bytesLoaded;
			bytes_total=event.bytesTotal;
			dispatchEvent(loading_event);
		}

		private function unLoadHandler(event:Event):void {
			trace("unLoadHandler: " + event);
		}

		//sound listener
		private function playerHandler(event:Event):void {
			if (sd_trans.volume!=vol) {
				sd_trans.volume=sd_trans.volume-(sd_trans.volume-vol)/5;
				sd_trans.volume = vol;
			}
			if (connectState=="loaded") {
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
			if (playState=="seeking") {
				if (seekTimer<10) {
					seekTimer++;
					dispatchEvent(seeking_event);
				} else {
					seekTimer=0;
					mute_check=false;
					playState=lastState;
					if (playState=="playing") {
						sd_clip.play();
					}
					dispatchEvent(seeked_event);
					dispatchEvent(playhead_event);
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
			if (connectState=="loaded") {
				if(playState=="stoped"){
					sd_clip.gotoAndPlay(2);
					trace("repeat")
				}else{
					if(sd_clip.currentFrame<sd_clip.totalFrames){
						sd_clip.play();
					}
				}
				playState="playing";
				dispatchEvent(playhead_event);
				dispatchEvent(play_event);
			}
		}
		public function stop():void {
			if (connectState=="loaded") {
				playState="stoped";
				sd_clip.gotoAndStop(1);
				dispatchEvent(playhead_event);
				dispatchEvent(stoped_event);
			}
		}
		public function pause():void {
			if (connectState=="loaded") {
				sd_clip.stop();
				playState="paused";
				dispatchEvent(paused_event);
			}
		}
		public function seek(t:Number):void {
			if (connectState=="loaded") {

				var _frame:int=sd_clip.totalFrames*(t/this.totalTime);
				if (_frame<0) {
					_frame=0;
				}
				if (_frame>sd_clip.totalFrames) {
					_frame=sd_clip.totalFrames;
				}
				sd_clip.gotoAndStop(_frame);

				if (playState!="seeking") {
					lastState=playState;
					playState="seeking";
				}
				seekTimer=0;
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
		public function get time():Number {
			var _time:Number;
			if (connectState=="loaded") {
				_time=(sd_clip.currentFrame/sd_clip.totalFrames)*this.totalTime;
			} else {
				stage.frameRate;
				_time=0;
			}
			return _time;
		}
		public function get totalTime():Number {
			var _totaltime:Number;
			if (connectState=="loaded") {
				_totaltime=sd_clip.totalFrames/frameRate;
			} else {
				_totaltime=0;
			}
			return _totaltime;
		}
		//close all
		public function close():void {
			unload();
			sd_clip=null;
			sd_loader=null;
		}
	}
}