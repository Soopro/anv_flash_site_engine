package player{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import player.*;
	import net.*;

	public class SimplePlayerUI extends MovieClip {

		//events
		private var soundPlayer:SimplePlayer=new SimplePlayer();
		private var soundEq:SimpleEq=new SimpleEq(6,6);

		//property 
		private var playState:Boolean;


		public function SimplePlayerUI() {
			playState=false;
			addEventListener(Event.ADDED_TO_STAGE,startPlay);
			addEventListener(Event.REMOVED_FROM_STAGE,stopPlay);
		}
		//set function
		private function stopPlay(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE,stopPlay);
			removeListeners();
		}
		private function startPlay(event:Event):void {
			var sound_list:XMLList=SiteXML.getSounds.sound;
			var sound_folder:String=SiteXML.getSounds.@folder;
			var sound_src:String=sound_folder+sound_list[0].@sd_url;
			soundPlayer.setup(sound_src,sound_list[0].@sd_name);
			addListeners();
			soundBtn.ico.addChild(soundEq);
			soundEq.x=24;
			soundEq.y=5;
		}
		//listeners
		private function addListeners():void {
			soundBtn.addEventListener(MouseEvent.ROLL_OVER,soundBtnHandler);
			soundBtn.addEventListener(MouseEvent.ROLL_OUT,soundBtnHandler);
			soundBtn.addEventListener(MouseEvent.MOUSE_DOWN,soundBtnHandler);
			soundBtn.addEventListener(MouseEvent.MOUSE_UP,soundBtnHandler);
			soundBtn.addEventListener(MouseEvent.CLICK,soundBtnHandler);
			soundPlayer.addEventListener(SimplePlayer.SP_PLAYING,eqHandler);
			soundPlayer.addEventListener(SimplePlayer.SP_STOP,eqHandler);
			soundPlayer.addEventListener(SimplePlayer.SP_PLAY,switchHandler);
			soundPlayer.addEventListener(SimplePlayer.SP_STOP,switchHandler);
		}
		private function removeListeners():void {
			soundBtn.removeEventListener(MouseEvent.ROLL_OVER,soundBtnHandler);
			soundBtn.removeEventListener(MouseEvent.ROLL_OUT,soundBtnHandler);
			soundBtn.removeEventListener(MouseEvent.MOUSE_DOWN,soundBtnHandler);
			soundBtn.removeEventListener(MouseEvent.MOUSE_UP,soundBtnHandler);
			soundBtn.removeEventListener(MouseEvent.CLICK,soundBtnHandler);
		}
		private function soundBtnHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					soundBtn.gotoAndPlay("on");
					break;
				case MouseEvent.ROLL_OUT :
					soundBtn.gotoAndPlay("off");
					break;
				case MouseEvent.MOUSE_DOWN :
					soundBtn.gotoAndPlay("press");
					break;
				case MouseEvent.MOUSE_UP :
					soundBtn.gotoAndPlay("on");
					break;
				case MouseEvent.CLICK :
					checkSoundPlay();
					break;
			}
		}
		//play function
		private function checkSoundPlay():void {
			if (soundPlayer.getPlay) {
				soundPlayer.setStop();
			} else {
				soundPlayer.setPlay();
			}
		}
		private function switchHandler(event:Event):void {
			switch (event.type) {
				case SimplePlayer.SP_PLAY :
					soundBtn.ico.alpha=1;
					break;
				case SimplePlayer.SP_STOP :
					soundBtn.ico.alpha=0.5;
					break;
			}
		}
		private function eqHandler(event:Event):void {
			soundEq.setBit=soundPlayer.getBit;
			soundEq.setVol=soundPlayer.getVol;
		}
	}
}