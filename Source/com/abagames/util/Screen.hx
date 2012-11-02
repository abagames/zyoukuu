package com.abagames.util;
import nme.Lib;
class Screen {
	public var pixelSize:Vector;
	public var size:Vector;
	public var center:Vector;
	public var letterDots:Array<Dots>;
	static inline var LETTER_COUNT = 49;
	var tPos:Vector;
	public function new() {
		pixelSize = new Vector(Lib.stage.stageWidth, Lib.stage.stageHeight);
		size = new Vector(
			Std.int(pixelSize.x / DotsShape.DOT_SIZE),
			Std.int(pixelSize.y / DotsShape.DOT_SIZE));
		center = new Vector(size.x / 2, size.y / 2);
		tPos = new Vector();
		var letterPatterns = [
		0x4644AAA4, 0x6F2496E4, 0xF5646949, 0x167871F4, 0x2489F697, 0xE9669696, 0x79F99668,
		0x91967979, 0x1F799976, 0x1171FF17, 0xF99ED196, 0xEE444E99, 0x53592544, 0xF9F11119,
		0x9DDB9999, 0x79769996, 0x7ED99611, 0x861E9979, 0x994444E7, 0x46699699, 0x6996FD99,
		0xF4469999, 0x2226F248, 0x44644466, 0xF0044E, 0x12448, 0x640444F0, 0x4049,
		0x42445E44, 0x4E54424F, 0x42F24
		];
		letterDots = new Array<Dots>();
		var lp:Int = 0, d:Int = 32;
		var lpIndex:Int = 0;
		var ptn:DotsPattern;
		for (i in 0...LETTER_COUNT) {
			ptn = new DotsPattern();
			ptn.setSize(4, 5);
			for (j in 0...5) {
				for (k in 0...4) {
					if (++d >= 32) {
						lp = letterPatterns[lpIndex++];
						d = 0;
					}
					if (lp & 1 > 0) ptn.setDot(1, k, j);
					lp >>= 1;
				}
			}
			letterDots.push(new Dots([[0xffffff], ptn, 0]));
		}
	}
	public function drawText(text:String, x:Float, y:Float, isFromRight:Bool = false):Void {
		tPos.x = x;
		if (isFromRight) tPos.x -= text.length * 5;
		else tPos.x -= text.length * 5 / 2;
		tPos.y = y;
		for (i in 0...text.length) {
			var c = text.charCodeAt(i);
			var li:Int = -1;
			if (c >= 48 && c < 58) {
				li = c - 48;
			} else if (c >= 65 && c <= 90) {
				li = c - 65 + 10;
			} else {
				switch (c) {
					case 91: li = 36;
					case 93: li = 37;
					case 43: li = 38;
					case 45: li = 39;
					case 47: li = 40;
					case 95: li = 41;
					case 33: li = 42;
					case 63: li = 43;
					case 46: li = 44;
					case 117: li = 45;
					case 114: li = 46;
					case 100: li = 47;
					case 108: li = 48;
				}
			}
			if (li >= 0) letterDots[li].draw(tPos);
			tPos.x += 5;
		}
	}
	public function isIn(p:Vector, spacing:Float = 0):Bool {
		return p.x >= -spacing && p.x <= size.x + spacing && 
			p.y >= -spacing && p.y <= size.y + spacing;
	}
}