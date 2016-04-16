package comps.loader{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;


	public class ClipLoader extends Sprite {

		public static  const ON_PROGRESS:String="progress";
		public static  const ON_ERROR:String="error";
		public static  const LOAD_INIT:String="load_init";
		public static  const LOAD_COMPLETE:String="load_complete";
		public static  const UNLOADED:String = "unloaded";
		public static  const ON_SKIP:String = "on_skip";


		private var progress_event:Event=new Event(ON_PROGRESS);
		private var error_event:Event=new Event(ON_ERROR);
		private var load_init_event:Event=new Event(LOAD_INIT);
		private var load_complete_event:Event=new Event(LOAD_COMPLETE);
		private var unloaded_event:Event=new Event(UNLOADED);
		private var skiped_event:Event=new Event(ON_SKIP);

		//object preplace
		private var clipLoader:Loader=new Loader();
		private var clipLoaderInfo:*;

		private var clip:Object=new Object();

		//variable preplace
		private var loadedState:String;
		private var bytes_Loaded:uint=0;
		private var bytes_Total:uint=0;


		public function ClipLoader() {
			this.mouseEnabled=false;
			this.mouseChildren=false;
			bytes_Loaded=0;
			bytes_Total=0;
			loadedState="none";
			this.addEventListener(Event.REMOVED,removed);
		}
		public function load(url:String):void {
			clipLoader=new Loader();
			clip=new Object();
			if (loadedState!="none") {
				skipClip();
			}
			clipLoaderInfo=clipLoader.contentLoaderInfo;
			configureListeners(clipLoaderInfo);
			clipLoader.load(new URLRequest(url));
			loadedState="loading";
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			//dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			//dispatcher.addEventListener(Event.INIT,initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			//dispatcher.addEventListener(Event.OPEN,openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.addEventListener(Event.UNLOAD,unLoadHandler);
		}
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE,completeHandler);
			//dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			//dispatcher.removeEventListener(Event.INIT,initHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			//dispatcher.removeEventListener(Event.OPEN,openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.removeEventListener(Event.UNLOAD,unLoadHandler);
		}
		//progress
		private function addProgress():void {
			bytes_Loaded=clipLoaderInfo.bytesLoaded;
			bytes_Total=clipLoaderInfo.bytesTotal;
		}
		//add Clip
		public function addClip():void {
			addChild(clipLoader);
			clip=clipLoader.content;
		}

		//loading event function
		private function completeHandler(event:Event):void {
			addProgress();
			loadedState="loaded";
			dispatchEvent(load_complete_event);
			removeListeners(clipLoaderInfo);
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + event);
		}
		private function initHandler(event:Event):void {
			//trace("initHandler: " + event);
			dispatchEvent(load_init_event);
			addProgress();
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			dispatchEvent(error_event);
			removeListeners(clipLoaderInfo);
			//trace("ioErrorHandler: " + event);
		}
		private function openHandler(event:Event):void {
			//trace("openHandler: " + event);
		}
		private function progressHandler(event:ProgressEvent):void {
			addProgress();
			dispatchEvent(progress_event);
		}
		private function unLoadHandler(event:Event):void {
			//trace("unLoadHandler: " + event);
			dispatchEvent(unloaded_event);
			clipLoaderInfo.removeEventListener(Event.UNLOAD,unLoadHandler);
		}
		//get property
		public function get getLoaded():uint {
			return bytes_Loaded;
		}
		public function get getTotal():uint {
			return bytes_Total;
		}
		public function get getPercent():uint {
			var percent=Math.round(bytes_Loaded / bytes_Total * 100);
			return percent;
		}
		public function get getLoadedState():Boolean {
			if (loadedState=="loaded") {
				return true;
			} else {
				return false;
			}
		}
		public function get getTarget():* {
			return clip;
		}
		//skipfunction
		public function skipClip():void {
			if (loadedState=="loading") {
				try {
					clipLoader.close();
				} catch (e:Error) {
				}
			}
			clipLoader.unload();
			removeListeners(clipLoaderInfo);
			dispatchEvent(skiped_event);
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
				clipLoader=new Loader();
				clip=new Object();
			}
		}
	}
}