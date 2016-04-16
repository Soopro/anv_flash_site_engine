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
	import loader.*;
	import players.*;

	import nav.*;

	import test.*;

	public class TestTextField extends MovieClip {


		//object preplace
		private var navs:Array=new Array();

		private var testData:XMLData=new XMLData();
		private var testConifg:XMLData=new XMLData();
		private var tData:XMLData=new XMLData();

		private var page_XML:XML=new XML();
		private var tf_arr:Array=new Array();

		private var sec:Section=new Section();

		private var mloader:MultiLoader=new MultiLoader();

		//variable preplace

		private var time:Number=1;
		private var checker:Boolean=false;

		public function TestTextField() {
			testData.loadXML("en/about.xml");
			testData.addEventListener(XMLData.XML_COMPLETE,nextData);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			TestReport.setup(this,250,560);
			Align.setup(Site.WIDTH,Site.HEIGHT);
			this.addEventListener(Event.REMOVED,removed)
		}
		private function nextData(event:Event):void {
			testData.removeEventListener(XMLData.XML_COMPLETE,nextData);
			tData.loadXML("en/general.xml");
			tData.addEventListener(XMLData.XML_COMPLETE,nextXML);

		}
		private function nextXML(event:Event):void {
			testData.removeEventListener(XMLData.XML_COMPLETE,nextXML);
			testConifg.loadXML("en/config.xml");
			testConifg.addEventListener(XMLData.XML_COMPLETE,run);

		}

		private function run(event:Event):void {
			mloader.load("_fonts.swf","_module.swf");
			mloader.addEventListener(MultiLoader.LOAD_COMPLETE,completeHandler);

		}

		private function completeHandler(event:Event):void {
			mloader.removeEventListener(MultiLoader.LOAD_COMPLETE,completeHandler);
			Site.module=mloader.getContent("_module.swf");
			setConfig();

			addChild(sec);
			var arr:Array=new Array()
			arr[0]=testData.getData.contents
			sec.setup(arr);


			Site.module.addScreen(this);

			addEventListener(Site.BTN_CLICKED,btnHandler);
			addEventListener(Site.LINKED,linkHandler);
			setNav();
		}
		private function toPage(ta:String=""):void {
			sec.navToPage(ta);
		}
		private function setNav():void{

		}

		private function secHandler(event:Event):void{
			switch (event.type){
				case Site.SEC_CHANGE:
					 navEnable(event.target.getSecName)
				break;
			}
		}
		private function navEnable(ta:String):void {
				for each(var obj:MainNavBtn in navs){
					if (obj.getTag==ta){
						obj.select()
					}else{
						if(obj.getSelect){
							obj.unselect();
						}
					}
				}
			}
		
		private function btnHandler(event:Event):void {
			if (event.target.getType == "go") {
				toPage(event.target.getTarget);
				event.stopPropagation();
			}
		}
		private function linkHandler(event:Event):void {

			trace(event.target+" "+event.target.getLink);
		}
		private function clickHandler(event:MouseEvent):void {
			GC.run();
		}
		private function setConfig():void {
			TextStyle.setup(testConifg.getData.text[0]);
			SiteStyle.setup(testConifg.getData.display[0]);
		}
		private function removed(event:Event):void{
			if(event.target==this){
				this.addEventListener(Event.REMOVED,removed)

				
				removeEventListener(Site.BTN_CLICKED,btnHandler);
				removeEventListener(Site.LINKED,linkHandler);
			}
		}
	}
}