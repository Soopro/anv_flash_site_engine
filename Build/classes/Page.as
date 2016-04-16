package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;

	import tools.*;
	import net.*;
	import views.*;

	public class Page extends Sprite {


		private var anim_on_event:Event=new Event(Site.ANIM_ON);
		private var anim_off_event:Event=new Event(Site.ANIM_OFF);
		
		private var form_sending_event:Event=new Event(Site.FORM_SENDING,true,false);
		private var form_sent_event:Event=new Event(Site.FORM_SENT,true,false);
		private var form_error_event:Event=new Event(Site.FORM_ERROR,true,false);

		//object preplace
		private var contents:Array=new Array;
		private var formData:Array=new Array;
		private var currXML:XML=new XML;
		private var nextXML:XML=new XML;
		//variable preplace
		private var animOrder:int=0;
		private var page_tag:String="";


		public function Page() {
			this.addEventListener(Event.REMOVED,removed);
			addEventListener(Site.FORM_ADDED,formCollector);
			addEventListener(Site.BTN_CLICKED,btnHandler);
			clean();
		}

		public function setup(pm_xml:XML):void {
			if (stage!=null) {
				currXML=pm_xml;
				setData();
				animIn(0);
			}
		}
		public function reset(pm_xml:XML):void {
			if (stage!=null) {
				removeContentListeners();
				nextXML=pm_xml;
				animOut(0);
			}
		}

		private function animIn(num:int):void {
			this.mouseChildren=false;
			animOrder=num;
			if (animOrder < contents.length) {
				contents[animOrder].addEventListener(Site.IN_COMPLETE,animInNext);
				contents[animOrder].animIn();
				contents[animOrder].visible=true;
				
			}else{
				this.mouseChildren=true;
			}
		}
		private function animInNext(event:Event) {
			var obj=event.target;
			obj.removeEventListener(Site.IN_COMPLETE,animInNext);
			animOrder++;
			animIn(animOrder);
		}
		private function animOut(num:int):void {
			this.mouseChildren=false;

			if(SiteStyle.pageOutAnim){
				
				animOrder=num;
				if (animOrder < contents.length) {
					contents[animOrder].addEventListener(Site.OUT_COMPLETE,animOutNext);
					contents[animOrder].animOut();
				} else {
					nextPage();
				}
			}else{
				nextPage();
			}
		}
		private function animOutNext(event:Event):void {
			var obj=event.target;
			obj.visible=false;
			obj.removeEventListener(Site.OUT_COMPLETE,animOutNext);
			animOrder++;
			animOut(animOrder);
		}
		private function removeContentListeners():void {
			for each (var obj:Object in contents) {
				obj.removeEventListener(Site.OUT_COMPLETE,animOutNext);
				obj.removeEventListener(Site.IN_COMPLETE,animInNext);
			}
		}
		private function setData():void {
			clean();
			page_tag=currXML.@tag;
			for (var i:int=0; i < currXML.children().length(); i++) {
				if (currXML.children()[i].name() == "textfield") {
					contents[i]=Site.module.newGTextField();
					addChild(contents[i]);
					contents[i].setup(currXML.children()[i]);
				}
				if (currXML.children()[i].name() == "rotationmenu") {
					contents[i]=Site.module.newRotationMenu();
					addChild(contents[i]);
					contents[i].setup(currXML.children()[i]);

				}
			}
		}
		private function nextPage():void {

			currXML=nextXML;

			setData();
			animIn(0);
		}

		private function formCollector(event:Event):void {
			var obj=event.target;
			var new_check:Boolean=true;
			if (formData.length > 0) {

				for each (var f:FormField in formData) {
					if (obj.getForm == f.form) {
						f.push(obj);
						new_check=false;
						break;
					}
				}
			}
			if (new_check) {
				var ff:FormField=new FormField(obj);
				formData.push(ff);
			}
		}
		private function btnHandler(event:Event):void {
			var obj=event.target;
			var variables:URLVariables=new URLVariables;
			if (obj.getType == "submit" || obj.getType == "reset" || obj.getType == "set") {
				for (var i:int=0; i < formData.length; i++) {
					if (formData[i].form == obj.getTag) {

						obj.getType == "submit" || obj.getType == "set"?variables=formData[i].getData():formData[i].reset();
						break;
					}
				}
				if (variables.error != "error") {
					switch (obj.getType) {
						case "submit" :
							formData[i].reset();
							sendContents(obj.getDataSource,variables);
							break;
						case "set" :
							setNewContents(obj.getDataSource,obj.getTarget,variables);
							break;
					}
				}
				event.stopPropagation();
			}
		}
		private function sendContents(url:String,pm_variables:URLVariables):void {
			var send_variables:URLVariables=pm_variables;
			var request:URLRequest=new URLRequest(url);
			var sender:URLLoader=new URLLoader;
			request.method=URLRequestMethod.POST;
			for each (var str:String in send_variables) {
				str=str.replace("<", "[");
				str=str.replace(">", "]");
				str=str.replace("\\", "/");
			}
			
			request.data=send_variables;
			sender.dataFormat=URLLoaderDataFormat.TEXT;
			configureListeners(sender);
			try {
               sender.load(request);
			   dispatchEvent(form_sending_event);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				dispatchEvent(form_error_event);
            }
			function configureListeners(dispatcher:IEventDispatcher):void {
				dispatcher.addEventListener(Event.COMPLETE, completeHandler);
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				
			}
			function removeListeners(dispatcher:IEventDispatcher):void {
				dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
				dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
			function completeHandler(event:Event):void {
				 removeListeners(sender)
				 dispatchEvent(form_sent_event);
			}
			function ioErrorHandler(event:IOErrorEvent):void{
				removeListeners(sender)
				dispatchEvent(form_error_event);
			}
			function securityErrorHandler(event:SecurityErrorEvent):void {
				removeListeners(sender)
				dispatchEvent(form_error_event)
			}
		}
		
		private function setNewContents(url:String,pm_target:String,pm_variables:URLVariables):void {
			var targetObject:Object;

			for each (var obj:Object in contents) {
				if (obj.getTag == pm_target && pm_target!="") {
					targetObject=obj;
					targetObject.reset();
					targetObject.doFunction("loading");
					var xml:XMLData=new XMLData;
					xml.loadXML(Site.langCode+"/"+url);
					xml.addEventListener(XMLData.XML_COMPLETE,xmlLoadHandler);
					xml.addEventListener(XMLData.XML_ERROR,xmlLoadHandler);

					break;
				}
			}
			function xmlLoadHandler(event:Event):void {
				switch (event.type) {
					case XMLData.XML_COMPLETE :
						targetObject.doFunction("complete");
						var data_xml=xml.getData.children()[0];
						var tmp_variables=pm_variables;
						delete tmp_variables.formid;
						var variablesArray:Array=parseXML(tmp_variables.toString());
						if (variablesArray.length > 0) {

							var tmp_xml:XML=data_xml.copy();

							tmp_xml.setChildren("");


							for (var m:int=0; m < data_xml.children().length(); m++) {
								var match:Boolean=true;
								for (var n:int=0; n < variablesArray.length; n+= 2) {
									if (data_xml.children()[m].attribute(variablesArray[n]) != variablesArray[n + 1] && variablesArray[n + 1]!="all"&& variablesArray[n + 1]!="none") {
										match=false;
									}
								}
								if (match) {
									tmp_xml.appendChild(data_xml.children()[m]);
								}
							}
							if (tmp_xml.children()!="") {

								targetObject.reset(tmp_xml);
							} else {
								targetObject.doFunction("nodata");
							}
						} else {
							targetObject.reset(data_xml);
						}

						break;
					case XMLData.XML_ERROR :
						targetObject.doFunction("error");
						break;
				}
				xml.removeEventListener(XMLData.XML_COMPLETE,xmlLoadHandler);
				xml.removeEventListener(XMLData.XML_ERROR,xmlLoadHandler);
			}
			function parseXML(str:String):Array {
				var re:RegExp=/(=|&)/;
				var arr:Array=str.split(re);
				for (var i:int=0; i < arr.length; i++) {
					if (arr[i] == "=" || arr[i] == "&") {
						for (var j:int=i; j < arr.length - 1; j++) {
							arr[j]=arr[j + 1];
						}
						arr.pop();
					}
				}
				return arr;
			}
		}
		private function clean():void {
			formData=[];
			contents=[];
			animOrder=0;
			page_tag="";
			removeChildren(this);
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);

				removeEventListener(Site.FORM_ADDED,formCollector);
				removeEventListener(Site.BTN_CLICKED,btnHandler);
				clean();
			}
		}
		private function removeChildren(target:Object):void {
			for (var i:int=target.numChildren - 1; i >= 0; i--) {
				target.removeChildAt(0);
			}
		}
		//get 
		public function get getTag():String {
			return page_tag;
		}
	}
}