package test{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.net.*;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.System;
	import flash.system.Capabilities;


	import Gcomps.*;
	import net.*;
	import tools.*;
	import views.*;

	public class TestText extends MovieClip {


		//object preplace
		private var cursor:HandCursor=new HandCursor();
		private var tips:Tips=new Tips();

		private var testData:XMLData=new XMLData();
		private var testConifg:XMLData=new XMLData();


		private var page_XML:XML=new XML();
		private var tf_arr:Array=new Array();
		private var paragraph:XML=new XML();
		private var text_style:TextStyle=new TextStyle();
		private var site_style:SiteStyle=new SiteStyle();

		private var loader:Loader=new Loader();


		private var t1:GTextField=new GTextField();
		private var t2:GTextField=new GTextField();
		private var t3:GTextField=new GTextField();

		//variable preplace
		private var mm1:Number=0;
		private var mm2:Number=0;
		private var time:Number=1;
		private var checker:Boolean=false;

		public function TestText() {
			testData.loadXML("about.xml");
			testData.addEventListener(XMLData.XML_COMPLETE,nextXML);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		private function nextXML(event:Event):void {
			testData.removeEventListener(XMLData.XML_COMPLETE,nextXML);
			testConifg.loadXML("config.xml");
			testConifg.addEventListener(XMLData.XML_COMPLETE,run);
		}
		private function run(event:Event):void {


			configureListeners(loader.contentLoaderInfo);

			var request:URLRequest = new URLRequest("_fonts.swf");
			loader.load(request);

		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
		}
		private function completeHandler(event:Event):void {
			setConfig();
			page_XML=testData.getData.contents.page[0];

			setData(0);
			
			addChild(t1);
			addChild(t2);
			addChild(t3);
			t1.setup(tf_arr[0]);
			t2.setup(tf_arr[1]);
			t3.setup(tf_arr[2]);
			
			t1.animIn();
			
			t1.addEventListener(Site.IN_COMPLETE,nextTest);
			t2.addEventListener(Site.IN_COMPLETE,nextTest2);
			function nextTest(event:Event):void {
				t2.animIn();
				//removeChild(t)

			}
			function nextTest2(event:Event):void {
				t3.animIn();
				//removeChild(t)

			}
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
			//addEventListener(Event.ENTER_FRAME,enterHandler);
			addChild(tips);
			addChild(cursor);
			stage.addEventListener(Site.BTN_CLICKED,btnHandler);
			stage.addEventListener(Site.LINKED,linkHandler);
		}
		private function btnHandler(event:Event):void {

			trace(event.target+" "+event.target.getName+" "+event.target.getType)
		}
		private function linkHandler(event:Event):void {

			trace(event.target+" "+event.target.getLink+" "+event.target.getType)
		}
		
		
		private function clickHandler(event:MouseEvent):void {

			
		}
		private function enterHandler(event:Event):void {
			//trace(System.totalMemory)
			
		}
		private function setData(order:int):void {
			tf_arr[0]=page_XML.textfield[0];
			tf_arr[1]=page_XML.textfield[1];
			tf_arr[2]=page_XML.textfield[2];
		}
		private function setConfig():void {

			TextStyle.setup(testConifg.getData.text[0]);
			SiteStyle.setup(testConifg.getData.display[0]);
			paragraph=testConifg.getData.paragraph[0];
		}
	}
}