package {
	import flash.display.Sprite;
	import flash.text.Font;

	public class Fonts extends Sprite {

		
		private var font:Trade=new Trade();
		private var fontBold:TradeBold=new TradeBold();
		private var fontItalic:TradeItalic=new TradeItalic();
		private var fontItalicB:TradeItalicB=new TradeItalicB();
		

		public function Fonts() {
			this.mouseChildren=false;
			Font.registerFont(Trade);
			Font.registerFont(TradeBold);
			Font.registerFont(TradeItalic);
			Font.registerFont(TradeItalicB);
			/*
			var embeddedFonts:Array = Font.enumerateFonts(false);
			embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
			for (var i:int=0; i<embeddedFonts.length; i++) {
				trace(embeddedFonts[i].hasGlyphs ("üäöß πà â ç è é ê ë î ï ô ù û œ ") );
			}
			*/
		}
	}
}