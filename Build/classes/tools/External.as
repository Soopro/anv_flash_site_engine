package tools{

	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;

	public class External {
		//string
		private static  const WINDOW_OPEN_FUNCTION:String="openWindow";
		private static  const GET_BROWSER_FUNCTION:String="getBrowser";
		private static  const NO_JS_BROWSER:String="no_js_browser";
		private static  const UNKNOW_BROWSER:String="unknow_browser";
		//browser list
		private static  var browserArray:Array=new Array("Firefox","MSIE","Opera","Safari","Netscape");

		//browser must use js to open a new window, the name must same with browserArray
		private static  var allowArray:Array=new Array("Firefox","MSIE");
		
		public function External() {

		}
		
		public static function openWindow(url:String,window:String="_self",features:String=""):void {

			if (window=="_self") {
				toURL(url,window);
			} else {

				var checkAllow:Boolean=false;

				var browserName:String=getBrowserName();

				if (browserName==NO_JS_BROWSER) {
					window="_self";
				}
				//if browser is in allowArray use ExternalInterface,otherwise use navigateToURL
				for each (var n:String in allowArray) {
					if (browserName == n) {
						checkAllow=true;
						break;
					}
				}
				if (checkAllow && ExternalInterface.available) {
					//ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, window, features);
					var popSuccess:Boolean=ExternalInterface.call(WINDOW_OPEN_FUNCTION,url,window,features);
					//if open window was failed
					if (popSuccess == false) {
						//navigateToURL(myURL, "_self");
					}
				} else {
					toURL(url,window);
				}
			}
		}
		private static function toURL(url:String,window:String="_self"):void {
			var myURL:URLRequest=new URLRequest(url);
			navigateToURL(myURL,window);
		}
		public static function getBrowserName():String {
			var browser:String=UNKNOW_BROWSER;
			var browserAgent:String;
			//Uses external interface to reach out to browser and grab browser useragent info.
			if (ExternalInterface.available) {
				browserAgent=ExternalInterface.call(GET_BROWSER_FUNCTION);
			}
			//  Debug.text += "Browser Info: [" + browserAgent + "]";


			if (browserAgent != null) {
				for (var i:int=0; i < browserArray.length; i++) {
					//Determines brand of browser using a find index. If not found indexOf returns (-1).
					if (browserAgent.indexOf(browserArray[i]) >= 0) {
						browser=browserArray[i];
						break;
					}
				}
				
			} else {
				browser=NO_JS_BROWSER;
			}
			return browser;
		}
	}
}