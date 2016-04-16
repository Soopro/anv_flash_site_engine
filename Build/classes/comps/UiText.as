package comps{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;



	public class UiText extends Sprite {

		//object preplace
		private var txt:TextField=new TextField();
		
		//variable preplace
		private var seted:Boolean=false;

		public function UiText() {
			seted=false;
			this.mouseChildren=false;
		}
		public function setup(str:String=""):void {
			if (!seted) {
				txt.defaultTextFormat = TextStyle.getUiFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=false;
				txt.wordWrap=false;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=-50;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.autoSize= TextFieldAutoSize.LEFT;
				seted=true;
				addChild(txt);
				this.addEventListener(Event.REMOVED,removed);
			}

			if (str=="") {
				this.visible=false;

			} else {
				this.visible=true;

				txt.htmlText=str;


			}

		}
		private function removed(event:Event):void {
			if (event.target==this) {
				this.removeEventListener(Event.REMOVED,removed);
				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
				
			}
		}
	}
}