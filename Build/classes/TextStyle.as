package {

	import flash.text.*;

	public class TextStyle {

		//object preplace
		private static  var style:StyleSheet = new StyleSheet();
		private static  var ui_format:TextFormat = new TextFormat();
		private static  var ui_cformat:TextFormat = new TextFormat();
		private static  var nav_format:TextFormat = new TextFormat();
		private static  var sub_format:TextFormat = new TextFormat();
		private static  var pop_format:TextFormat = new TextFormat();
		private static  var top_format:TextFormat = new TextFormat();
		private static  var title_format:TextFormat = new TextFormat();
		private static  var logo_format:TextFormat = new TextFormat();
		private static  var slogo_format:TextFormat = new TextFormat();
		private static  var des_format:TextFormat = new TextFormat();
		private static  var format:TextFormat = new TextFormat();
		private static  var cformat:TextFormat = new TextFormat();
		private static  var empty_format:TextFormat = new TextFormat();
		private static  var input_format:TextFormat = new TextFormat();
		private static  var cr_format:TextFormat = new TextFormat();

		private static  var paragraph:Object=new Object();
		//private var font:FontTrade=new FontTrade();

		//private var fontfamily:FontFamily=new FontFamily();

		public function TextStyle() {

		}
		public static function setup(textcfg:XML):void {

			//font
			var fontName="Trade Gothic LT Std Extended";

			//text
			format.letterSpacing = textcfg.content.@spacing;
			format.color = textcfg.content.@color;
			format.font=fontName;
			format.size=textcfg.content.@size;
			format.leading=textcfg.content.@leading;
			
			cformat.letterSpacing = textcfg.content.@spacing;
			cformat.color = textcfg.content.@color;
			cformat.font=fontName;
			cformat.size=textcfg.content.@size;
			cformat.leading=textcfg.content.@leading;
			cformat.align=TextFormatAlign.CENTER;

			des_format.letterSpacing = textcfg.des.@spacing;
			des_format.color = textcfg.des.@color;
			des_format.font=fontName;
			des_format.bold=true;
			des_format.size=textcfg.des.@size;
			des_format.leading=textcfg.des.@leading;

			title_format.letterSpacing = textcfg.title.@spacing;
			title_format.color = textcfg.title.@color;
			title_format.font=fontName;
			title_format.size=textcfg.title.@size;
			
			logo_format.letterSpacing = textcfg.logo.@spacing;
			logo_format.color = textcfg.logo.@color;
			logo_format.font=fontName;
			logo_format.size=textcfg.logo.@size;
			logo_format.bold=true;
			
			slogo_format.letterSpacing = textcfg.slogo.@spacing;
			slogo_format.color = textcfg.slogo.@color;
			slogo_format.font=fontName;
			slogo_format.size=textcfg.slogo.@size;
			slogo_format.align=TextFormatAlign.CENTER;
			
			top_format.letterSpacing = textcfg.top.@spacing;
			top_format.color = textcfg.top.@color;
			top_format.font=fontName;
			top_format.size=textcfg.top.@size;
			top_format.bold=true;

			nav_format.letterSpacing = textcfg.nav.@spacing;
			nav_format.color = textcfg.nav.@color;
			nav_format.font=fontName;
			nav_format.size=textcfg.nav.@size;
			
			sub_format.letterSpacing = textcfg.subnav.@spacing;
			sub_format.color = textcfg.subnav.@color;
			sub_format.font=fontName;
			sub_format.size=textcfg.subnav.@size;

			pop_format.letterSpacing = textcfg.popup.@spacing;
			pop_format.color = textcfg.popup.@color;
			pop_format.font=fontName;
			pop_format.size=textcfg.popup.@size;
			
			cr_format.letterSpacing = textcfg.copyright.@spacing;
			cr_format.color = textcfg.copyright.@color;
			cr_format.font=fontName;
			cr_format.size=textcfg.copyright.@size;
			
			ui_format.letterSpacing = textcfg.ui.@spacing;
			ui_format.color = textcfg.ui.@color;
			ui_format.font=fontName;
			ui_format.size=textcfg.ui.@size;
			ui_format.bold=true;
			
			ui_cformat.letterSpacing = textcfg.ui.@spacing;
			ui_cformat.color = textcfg.ui.@color;
			ui_cformat.font=fontName;
			ui_cformat.size=textcfg.ui.@size;
			ui_cformat.bold=true;
			ui_cformat.align=TextFormatAlign.CENTER;
			
			empty_format.letterSpacing = textcfg.empty.@spacing;
			empty_format.color = textcfg.empty.@color;
			empty_format.font=fontName;
			empty_format.size=textcfg.empty.@size;
			empty_format.align=TextFormatAlign.CENTER;
			
			input_format.letterSpacing = textcfg.input.@spacing;
			input_format.color = textcfg.input.@color;
			input_format.font="Arial";
			input_format.size=textcfg.input.@size;


			var red:Object = new Object();

			if(textcfg.mark.red.@color!=undefined){
				red.color = textcfg.mark.red.@color;
			}

			var red2:Object = new Object();

			if(textcfg.mark.red2.@color!=undefined){
				red2.color = textcfg.mark.red2.@color;
			}
			
			var h1:Object = new Object();
			if(textcfg.mark.h1.@size!=undefined){
				h1.fontSize=textcfg.mark.h1.@size;
			}
			if(textcfg.mark.h1.@color!=undefined){
				h1.color = textcfg.mark.h1.@color;
			}
			if(textcfg.mark.h1.@style!=undefined){
				h1.fontStyle = textcfg.mark.h1.@style;
			}
			
			var h2:Object = new Object();
			if(textcfg.mark.h2.@size!=undefined){
				h2.fontSize=textcfg.mark.h2.@size;
			}
			if(textcfg.mark.h2.@color!=undefined){
				h2.color = textcfg.mark.h2.@color;
			}
			if(textcfg.mark.h2.@style!=undefined){
				h2.fontStyle = textcfg.mark.h2.@style;
			}
			
			var h3:Object = new Object();
			if(textcfg.mark.h3.@size!=undefined){
				h3.fontSize=textcfg.mark.h3.@size;
			}
			if(textcfg.mark.h3.@color!=undefined){
				h3.color = textcfg.mark.h3.@color;
			}
			if(textcfg.mark.h3.@style!=undefined){
				h3.fontStyle = textcfg.mark.h3.@style;
			}

			var dark:Object = new Object();
			if(textcfg.mark.dark.@color!=undefined){
				dark.color = textcfg.mark.dark.@color;
			}
			
			var it:Object = new Object();
			if(textcfg.mark.it.@style!=undefined){
				it.fontStyle = textcfg.mark.it.@style;
			}
			
			var small:Object = new Object();
			if(textcfg.mark.small.@size!=undefined){
				small.fontSize=textcfg.mark.small.@size;
			}
			
			
			var normal:Object = new Object();
			if(textcfg.mark.normal.@size!=undefined){
				normal.fontSize=textcfg.mark.normal.@size;
			}
			
			var big:Object = new Object();
			if(textcfg.mark.big.@size!=undefined){
				big.fontSize=textcfg.mark.big.@size;
			}
			var large:Object = new Object();
			if(textcfg.mark.large.@size!=undefined){
				large.fontSize=textcfg.mark.large.@size;
			}

			var link:Object = new Object();
			if(textcfg.mark.link.@color!=undefined){
				link.color = textcfg.mark.link.@color;
			}
			var center:Object= new Object();
			center.textAlign="center";
			
			style.setStyle(".red", red);
			style.setStyle(".red2", red2);
			style.setStyle(".h1", h1);
			style.setStyle(".h2", h2);
			style.setStyle(".h3", h3);
			style.setStyle(".dark", dark);
			style.setStyle(".it", it);
			style.setStyle(".small", small);
			style.setStyle(".normal", normal);
			style.setStyle(".big", big);
			style.setStyle(".large", large);
			style.setStyle(".link", link);
			style.setStyle(".center", center);

			//paragraph
			paragraph.top=textcfg.paragraph.@top;
			paragraph.left=textcfg.paragraph.@left;
			paragraph.partspace=textcfg.paragraph.@partspace;

		}
		//get
		public static function get getFormat():TextFormat {
			return format;
		}
		public static function get getCFormat():TextFormat {
			return cformat;
		}
		public static function get getTopFormat():TextFormat {
			return top_format;
		}
		public static function get getTitleFormat():TextFormat {
			return title_format;
		}
		public static function get getLogoFormat():TextFormat {
			return logo_format;
		}
		public static function get getSLogoFormat():TextFormat {
			return slogo_format;
		}
		public static function get getDesFormat():TextFormat {
			return des_format;
		}
		public static function get getNavFormat():TextFormat {
			return nav_format;
		}
		public static function get getSubNavFormat():TextFormat {
			return sub_format;
		}
		public static function get getPopFormat():TextFormat {
			return pop_format;
		}
		public static function get getCrFormat():TextFormat {
			return cr_format;
		}
		public static function get getUiFormat():TextFormat {
			return ui_format;
		}
		public static function get getUiCFormat():TextFormat {
			return ui_cformat;
		}
		
		public static function get getEmptyFormat():TextFormat {
			return empty_format;
		}
		
		public static function get getInputFormat():TextFormat {
			return input_format;
		}
		
		public static function get getStyleSheet():StyleSheet {
			return style;
		}
		public static function get getParagraph():Object {
			return paragraph;
		}
	}
}