package tools{
	import flash.display.Sprite;
	import flash.text.*;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.events.Event;

	public class TestReport extends Sprite {


		//object preplace
		private static  var mem:TextField=new TextField  ;
		private static  var ver:TextField=new TextField  ;
		private static  var note:TextField=new TextField  ;
		private static  var round:TextField=new TextField  ;
		private static var mc:Sprite=new Sprite();

		//variable preplace
		private static  var mm1:Number=0;
		private static  var mm2:Number=0;
		private static  var mm3:Number=0;
		private static var round_num:int=0;

		public function TestReport() {

		}
		public static  function setup(traget:Object,pm_x:int=250,pm_y:int=0,color:uint=0xFFFFFF):void {
			mem.autoSize=TextFieldAutoSize.RIGHT;
			ver.autoSize=TextFieldAutoSize.RIGHT;
			note.autoSize=TextFieldAutoSize.RIGHT;
			round.autoSize=TextFieldAutoSize.RIGHT;
			var format:TextFormat=new TextFormat  ;
			format.font="Verdana";
			format.color=color;
			format.size=12;

			note.defaultTextFormat=format;
			ver.defaultTextFormat=format;
			mem.defaultTextFormat=format;
			round.defaultTextFormat=format;
			traget.addChild(ver);
			traget.addChild(mem);
			traget.addChild(note);
			traget.addChild(round)
			mem.x=pm_x;
			mem.y=pm_y;
			ver.x=mem.x;
			ver.y=mem.y + mem.height + 15;
			note.x=mem.x;
			note.y=ver.y + ver.height + 15;
			round.x=note.x;
			round.y=note.y+note.height+15;
			mc.addEventListener(Event.ENTER_FRAME,run)
		}
		public static  function run(event:Event):void {
			round_num++
			mm1=System.totalMemory - mm2;
			mm2=System.totalMemory;
			if (mm2 > mm3) {
				mm3=mm2;
			}
			if (mm1 != 0) {
				mem.text=mm1 / 1000000 + "    " + mm2 / 1000000 + "    " + mm3 / 1000000;
			}
			ver.text="Ver: " + Capabilities.version;
			round.text="Round: "+round_num
		}
		public static  function setNote(str:String):void {
			note.text="Note: " + str;
		}

	}
}