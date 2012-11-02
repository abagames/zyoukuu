package com.abagames.util;
using com.abagames.util.IntUtil;
class Color {
	static inline var BASE_BRIGHTNESS = 20;
	static inline var WHITENESS = 2;
	static var scatterdColor = new Color();
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var brightness = 1.0;
	public function new(r:Int = 0, g:Int = 0, b:Int = 0) {
		this.r = r * BASE_BRIGHTNESS;
		this.g = g * BASE_BRIGHTNESS;
		this.b = b * BASE_BRIGHTNESS;
	}
	public function normalize():Void {
		r = r.clampi(0, 255);
		g = g.clampi(0, 255);
		b = b.clampi(0, 255);
	}	
	public function getScatterd(w:Int = 64):Color {
		var random = Frame.i.random;
		scatterdColor.r = r + random.i(w) * random.pm();
		scatterdColor.g = g + random.i(w) * random.pm();
		scatterdColor.b = b + random.i(w) * random.pm();
		scatterdColor.normalize();
		return scatterdColor;
	}
	public var i(getI, null):Int;
	public var rgb(null, setRgb):Color;
	function getI():Int {
		return Std.int(
			Std.int(r * brightness) * 0x10000 + 
			Std.int(g * brightness) * 0x100 + 
			b * brightness);
	}
	function setRgb(c:Color):Color {
		r = c.r;
		g = c.g;
		b = c.b;
		return this;
	}
	public static var black:Color = new Color(0, 0, 0);
	public static var red:Color = new Color(10, WHITENESS, WHITENESS);
	public static var green:Color = new Color(WHITENESS, 10, WHITENESS);
	public static var blue:Color = new Color(WHITENESS, WHITENESS, 10);
	public static var yellow:Color = new Color(10, 10, WHITENESS);
	public static var magenta:Color = new Color(10, WHITENESS, 10);
	public static var cyan:Color = new Color(WHITENESS, 10, 10);
	public static var white:Color = new Color(10, 10, 10);
}