package nav{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;

	public class PopupInfo extends MovieClip {

		//object preplace
		private var txt:TextField=new TextField();


		//property 
		private var w:int=230;
		private var h:int=30;
		private var p_x:int=8;
		private var p_y:int=5;
		private var seted:Boolean=false;

		public function PopupInfo() {
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}
		public function setup(pm_xml:XML=null):void {

			if (!seted && pm_xml!=null) {
				txt = new TextField();
				txt.defaultTextFormat = TextStyle.getDesFormat;
				txt.type = TextFieldType.DYNAMIC;
				txt.embedFonts=true;
				txt.selectable=false;
				txt.multiline=true;
				txt.wordWrap=true;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.thickness=200;
				txt.sharpness=200;
				txt.width=w;
				txt.height=h;
				txt.x=p_x;
				txt.y=p_y;
				txt.styleSheet=TextStyle.getStyleSheet;
				txt.htmlText=pm_xml;
				addChild(txt);
				this.addEventListener(Event.REMOVED,removed);
				seted=true;
			}
		}
		
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);

				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}
			}
		}
	}
}