package comps{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;

	public class DesPiece extends Sprite {


		//object preplace
		private var txt:TextField=new TextField();
		private var seted:Boolean=false;


		public function DesPiece() {
			seted=false;
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}

		public function setup(str:String="",pm_w:int=0,pm_h:int=0):void {

			if (!seted) {
				txt.defaultTextFormat = TextStyle.getDesFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=true;
				txt.wordWrap=true;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.styleSheet=TextStyle.getStyleSheet;
				seted=true;
			}
			if (!this.contains(txt)) {
				addChild(txt);
				this.addEventListener(Event.REMOVED,removed);

			}
			if (str=="") {
				this.visible=false;
				this.width=0;

			} else {
				this.visible=true;
				txt.width=pm_w;

				txt.htmlText=str;

				if (pm_h!=0) {
					txt.height=pm_h;
				} else {
					txt.height=Math.ceil(txt.textHeight+TextStyle.getDesFormat.size);
				}
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