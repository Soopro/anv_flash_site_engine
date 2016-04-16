package players{

	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;

	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import flash.utils.ByteArray;


	public class StreamPlayer extends Sprite {


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

		private var connection:NetConnection;
		private var stream:NetStream
		private var client:CustomClient;
		private var video:Video;

		private var bArray:ByteArray=new ByteArray;

		//property 
		private var video_url:String="";

		private var vol:Number=0.5;
		private var bit:Number=0;

		private var bytes_loaded:Number=0;
		private var bytes_total:Number=0;

		private var position:Number=0;

		private var total_time:Number=0;

		private var connectState:String="";
		private var playState:String="";
		private var lastState:String="";

		private var mute_check:Boolean=false;
		private var playEnd:Boolean=false;

		private var hasVideo:Boolean=false;

		public function StreamPlayer(pm_url:String="",pm_time:Number=0) {
			if (pm_url!="") {
				load(pm_url,pm_time);
			}
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function load(pm_url:String,pm_time:Number=0):void {
			unload();
			if (pm_url!="") {
				if (pm_time>0) {
					total_time=pm_time;
				}
				video_url=pm_url;
				
				connection = new NetConnection();
				connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection.connect(null);

				hasVideo=true;

				
				//configureListeners(sd_clip);

				//var request:URLRequest = new URLRequest(video_url);
				//sd_clip.load(request);

			}
		}
		public function unload():void {
			if (hasVideo) {
				
				removeEventListener(Event.ENTER_FRAME,playerHandler);
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				video.clear()
				stream.close();
				connection.close();
				
				
				sd_trans= new SoundTransform();

				hasVideo=false;

				//removeListeners(sd_clip);
				connectState="";
				playState="";
				lastState="";
				position=0;
				bytes_loaded=0;
				bytes_total=0;

				mute_check=false;

				bArray= new ByteArray;
			}
		}
		//stream listener 
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
				case "NetStream.Pause.Notify" :
					//playState="paused";
					break;
				case "NetStream.Unpause.Notify" :
					//playState="playing";
					break;
				case "NetStream.Play.Start" :
					stream.pause();
					playEnd=false;
					connectState="loading";
					break;
				case "NetStream.Play.Stop" :
					if (stream.time>=totalTime) {
						playEnd=true;
					}
					if (stream.bufferLength==0 && playEnd) {
						endStremPlay();
					}
					break;
				case "NetStream.Buffer.Empty" :
					if (playEnd) {
						endStremPlay();
					}
					break;
			}
		}
		private function endStremPlay():void {
			playState="complete";
			stream.pause();
			dispatchEvent(play_complete_event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			doError();
		}

		private function connectStream():void {
			stream= new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			addEventListener(Event.ENTER_FRAME,playerHandler);
			client=new CustomClient();
			client.addEventListener("Metadaten",setMetaData);
			client.addEventListener("StreamEnd",finishStream);
			stream.client =client;
			video= new Video();
            video.attachNetStream(stream);
			addChild(video)
			stream.play(video_url);
			sd_trans=stream.soundTransform;
		}
		private function setMetaData(event:Event):void {
			total_time=client.metaData.duration;
		}
		private function finishStream(event:Event):void {
			trace("finished");
		}

		//sound listener
		private function playerHandler(event:Event):void {

			if (connectState=="loading") {
				if (stream.bytesTotal > 0) {
					dispatchEvent(loading_event);
				}else{
					connectState="loaded";
					dispatchEvent(loaded_event);
				}
			}
			if (sd_trans.volume!=vol) {
				sd_trans.volume=sd_trans.volume-(sd_trans.volume-vol)/5;
				sd_trans.volume = vol;
			}

			if (mute_check) {
				sd_trans.volume=0;
			} else {
				sd_trans.volume = vol;
			}

			if (playState=="playing") {
				SoundMixer.computeSpectrum(bArray,false,0);
				bit=bArray.readFloat();
				dispatchEvent(playhead_event);
				trace(this.time)
			} else {
				bit=0;
			}
		}
		//error
		private function doError():void {
			connectState="error";
			playState=connectState;
			dispatchEvent(error_event);
		}
		//set player

		public function play():void {
			if (connectState!="" && connectState!="error") {
				stream.resume();
				playState="playing";
				dispatchEvent(play_event);
			}
		}
		public function stop():void {
			if (connectState!="" && connectState!="error") {
				stream.pause();
				stream.seek(0);
				playState="stoped";
				dispatchEvent(stoped_event);
			}
		}
		public function pause():void {
			if (connectState!="" && connectState!="error") {
				stream.pause();
				playState="paused";
				dispatchEvent(paused_event);
			}
		}
		public function seek(t:Number):void {
			var seek_to:Number=t;
			if (t<0) {
				seek_to=0;
			}
			if (t>total_time) {
				seek_to=total_time;
			}
			stream.seek(seek_to);
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
			return stream.time;
		}
		public function get totalTime():Number {
			return total_time;
		}
		//close all
		public function close():void {
			unload();
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