package {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;

	public class FormField extends EventDispatcher {

		private var form_name:String="";
		private var form_arr:Array=new Array();

		public function FormField(obj:Object) {
			try {
				form_name=obj.getForm;
			} catch (e:Error) {
			}
			push(obj);
		}
		public function push(obj:Object):void {
			var newcheck:Boolean=true;
			for each (var form:Object in form_arr) {
				if (form==obj) {
					newcheck=false;
				}
			}
			if (newcheck) {
				form_arr.push(obj);
				obj.addEventListener(Site.FORM_REMOVED,removeHandler);
			}
		}

		public function reset():void {
			for each (var f:Object in form_arr) {
				try {
					f.reset();
				} catch (e:Error) {
				}
			}
		}
		private function removeHandler(event:Event):void {
			var obj=event.target;
			obj.removeEventListener(Site.FORM_REMOVED,removeHandler);
			for (var i:int=0; i<form_arr.length; i++) {
				if (obj==form_arr[i]) {
					form_arr[i]=form_arr[form_arr.length-1];
					form_arr.pop();
					break;
				}
			}
		}
		public function getData():URLVariables {
			var variables:URLVariables=new URLVariables();
			var error:Boolean=false;
			variables.formid=form;
			for each (var f:Object in form_arr) {
				f.prepareData();
				if (f.getError) {
					error=true;
				}
			}
			if (!error) {
				for each (var v:Object in form_arr) {
					variables[v.getKey]=v.getData;
				}
			} else {
				variables.error="error";
			}
			//trace("Form:"+f.getForm+";   data:"+f.getData+";   key:"+f.getKey);
			return variables;
		}
		//get
		public function get form():String {
			return form_name;
		}
	}
}