/*
MultiLoader varsion 1.6
script by redy, Gestaltic Studio.
usage:
start loading - 

loading(urls:Array)

event listener - 
MultiLoader.ON_PROGRESS      "event progress"
MultiLoader.ON_ERROR         "event error"
MultiLoader.LOAD_INIT        "event load init"
MultiLoader.LOAD_COMPLETE    "event load complete"

get property -
getLoaded"return bytes_Loaded"
getTotal"return bytes_Total"
getPercent"return percent"
getLoaderList"return loaderList"

*/

package loader{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;

	public class MultiLoader extends EventDispatcher {

		public static  const ON_PROGRESS:String="progress";
		public static  const ON_ERROR:String="error";
		public static  const LOAD_INIT:String="load_init";
		public static  const LOAD_COMPLETE:String="load_complete";

		private var progress_event:Event=new Event(ON_PROGRESS);
		private var error_event:Event=new Event(ON_ERROR);
		private var load_init_event:Event=new Event(LOAD_INIT);
		private var load_complete_event:Event=new Event(LOAD_COMPLETE);

		private var URLList:Array=new Array;
		private var loaderList:Array=new Array;
		private var getList:Array=new Array;
		private var bytes_Loaded:uint=0;
		private var bytes_Total:uint=0;
		private var loaderInfoList:Array=new Array;
		private var complateList:Array=new Array;
		private var totalChecked:Boolean=false;
		
		private var complateChecked:Boolean=false;

		public function MultiLoader() {
			bytes_Loaded=bytes_Total=0;
			loaderInfoList=[];
			loaderList=[];
			getList=[];
			URLList=[];
			complateList=[];
		}
		public function load(...urls):void {
			URLList=urls;
			for (var i:uint=0; i < URLList.length; i++) {
				getList[i]= new Loader();
				loaderInfoList[i]=getList[i].contentLoaderInfo;
				configureListeners(loaderInfoList[i]);

				getList[i].load(new URLRequest(URLList[i]));
				complateList[i]="get";
			}
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			dispatcher.addEventListener(Event.INIT,initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN,openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.addEventListener(Event.UNLOAD,unLoadHandler);
		}
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			dispatcher.addEventListener(Event.INIT,initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN,openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS,progressHandler);
		}
		private function checkAllComplete(obj):void {
			for (var i:uint=0; i < loaderInfoList.length; i++) {
				if (obj == loaderInfoList[i]) {
					complateList[i]="complate";
				}
			}
			if (complateList.indexOf("get") == -1 && complateList.indexOf("ready") == -1) {
				if(!complateChecked){
					dispatchEvent(load_complete_event);
					complateChecked=true;
				}
				for each (var j:IEventDispatcher in loaderInfoList) {
					removeListeners(j);
					//remove unload when you unload. i.removeEventListener(Event.UNLOAD, unLoadHandler);
				}
				//trace(complateList)
			}
		}
		//check total bytes
		private function checkTotalBytes():void {
			for (var i:int=0; i<loaderInfoList.length; i++) {
				if (loaderInfoList[i].bytesTotal > 1 && complateList[i]=="get") {
					bytes_Total+= loaderInfoList[i].bytesTotal;
					//trace(getList[i]);
					getList[i].close();
					getList[i].unload();
					removeListeners(loaderInfoList[i]);
					complateList[i]="ready";
				}
			}

			if (complateList.indexOf("get") ==-1) {
				totalChecked=true;
				loaderInfoList=[];
				for (var j:int=0; j<getList.length; j++) {
					//trace(bytes_Total);
					loaderList[j]= new Loader();
					loaderInfoList[j]=loaderList[j].contentLoaderInfo;
					configureListeners(loaderInfoList[j]);
					loaderList[j].load(new URLRequest(URLList[j]));
				}
				getList=[];
				dispatchEvent(load_init_event);
			} else {
				totalChecked=false;
			}
		}
		//progress
		private function addProgress():void {
			if (totalChecked) {
				bytes_Loaded=0;
				for each (var i:Object in loaderInfoList) {
					bytes_Loaded+= i.bytesLoaded;
					//bytes_Total+= i.bytesTotal;
				}
				//trace("loaded: "+bytes_Loaded+"   total:  "+bytes_Total)
			} else {
				checkTotalBytes();
			}
		}
		//loading event function
		private function completeHandler(event:Event):void {
			addProgress();
			var obj=event.target;
			checkAllComplete(obj);
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			//trace("httpStatusHandler: " + event);
		}
		private function initHandler(event:Event):void {
			//trace("initHandler: " + event);
			addProgress();
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			dispatchEvent(error_event);
			//trace("ioErrorHandler: " + event);
		}
		private function openHandler(event:Event):void {
			//trace("openHandler: " + event);

		}
		private function progressHandler(event:ProgressEvent):void {
			addProgress();
			if (totalChecked) {
				dispatchEvent(progress_event);
			}
		}
		private function unLoadHandler(event:Event):void {
			//trace("unLoadHandler: " + event);
			event.target.removeEventListener(Event.UNLOAD,unLoadHandler);
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
		public function get getLoaderList():Array {
			return loaderList;
		}
		public function get getURLList():Array {
			return URLList;
		}
		public function getContent(str:String):MovieClip {
			var tmp_content:MovieClip;
			if (complateList.indexOf("get") == -1 && complateList.indexOf("ready") == -1 && complateList.length==URLList.length) {
				
				for (var i:int=0; i<URLList.length; i++) {
					if (URLList[i]==str) {
						tmp_content=loaderList[i].content;
						break;
					}
				}
			}
			return tmp_content;
		}
	}
}