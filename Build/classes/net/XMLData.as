package net{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.*;


	public class XMLData extends EventDispatcher {

		//event preplace
		public static  const XML_COMPLETE:String="xml_complete";
		public static  const XML_ERROR:String="xml_error";
		private var xml_complete_event:Event=new Event(XML_COMPLETE);
		private var xml_error_event:Event=new Event(XML_ERROR);

		//object preplace
		private var data_XML:XML=new XML();
		private var loader:URLLoader=new URLLoader();

		//variable preplace

		public function XMLData(url:String=null) {
			if (url!=null) {
				loadXML(url);
			}
		}
		public function loadXML(url:String) {
			var _request:URLRequest=new URLRequest("xml/"+url);
			configureListeners(loader);
			loader.load(_request);
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			//dispatcher.addEventListener(Event.OPEN, openHandler);
			//dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}

		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE,completeHandler);
			//dispatcher.removeEventListener(Event.OPEN, openHandler);
			//dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);

		}
		
		private function completeHandler(event:Event):void {

			data_XML=XML(loader.data);

			if (data_XML.children().length() > 0) {
				dispatchEvents("complete");
			} else {
				dispatchEvents("error");
			}
			var dispatcher=event.target
			removeListeners(dispatcher)
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			// trace("ioErrorHandler: " + event);
			dispatchEvents("error");
			var dispatcher=event.target
			removeListeners(dispatcher)
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			dispatchEvents("error");
			var dispatcher=event.target
			removeListeners(dispatcher)
		}
		
		
		//get property 
		public function get getData():XML {
			return data_XML;
		}
		//DispatchEvents
		private function dispatchEvents(dispatcher:String) {
			switch (dispatcher) {
				case "complete" :
					dispatchEvent(xml_complete_event);
					break;
				case "error" :
					dispatchEvent(xml_error_event);
					break;
			}
		}
	}
}