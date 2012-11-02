package com.abagames.util;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.Sprite;
import nme.filters.BlurFilter;
import nme.geom.Rectangle;
class DotsShape {
	public static inline var DOT_SIZE = 2;
	public var bd:BitmapData;
	public var rect:Rectangle;
	public var size:Vector;
	public function new(pattern:DotsPattern, colors:Array<Int>) {
		rect = new Rectangle();
		var xc:Int = pattern.size.xi;
		var yc:Int = pattern.size.yi;
		size = new Vector(xc, yc);
		bd = new BitmapData(Std.int(size.x * DOT_SIZE), Std.int(size.y * DOT_SIZE), true, 0);
		var dr:Rectangle = new Rectangle(0, 0, DOT_SIZE, DOT_SIZE);
		for (y in 0...yc) {
			for (x in 0...xc) {
				var ci:Int = pattern.getDot(x, y);
				if (ci <= 0) continue;
				dr.x = x * DOT_SIZE;
				dr.y = y * DOT_SIZE;
				bd.fillRect(dr, 0xff000000 + colors[ci - 1]);
			}
		}
		rect = new Rectangle(0, 0, size.x * DOT_SIZE, size.y * DOT_SIZE);
	}
}