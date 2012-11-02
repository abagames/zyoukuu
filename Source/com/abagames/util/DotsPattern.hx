package com.abagames.util;
using com.abagames.util.FloatUtil;
class DotsPattern {
	public var dots:Array<Int>;
	public var size:Vector;
	public function new(pattern:Array<String> = null) {
		size = new Vector();
		if (pattern == null) return;
		setSize(pattern[0].length, pattern.length);
		for (y in 0...size.yi) {
			var p:String = pattern[y];
			for (x in 0...size.xi) {
				if (x >= p.length) break;
				var ci:Int = p.charCodeAt(x) - 48;
				if (ci > 0) setDot(ci, x, y);
			}
		}
	}
	public function setSize(w:Int, h:Int = -1):Void {
		if (h < 0) h = w;
		dots = new Array<Int>();
		for (i in 0...w * h) dots.push(0);
		size.x = w;
		size.y = h;
	}
	public function clone():DotsPattern {
		var p = new DotsPattern();
		p.setSize(size.xi, size.yi);
		for (i in 0...dots.length) p.dots[i] = dots[i];
		return p;
	}
	public function setDot(n:Int, x:Int, y:Int):Void {
		if (x < 0 || x >= size.x || y < 0 || y >= size.y) return;
		dots[x + y * size.xi] = n;
	}
	public function getDot(x:Int, y:Int):Int {
		if (x < 0 || x >= size.x || y < 0 || y >= size.y) return 0;
		return dots[x + y * size.xi];
	}
	public function getHash():Int {
		var t = 0;
		var dl = Std.int(dots.length.clamp(0, 32));
		for (i in 0...dl) t += dots[i] * (i + 1) * Std.int(i % size.x + 1) * Std.int(i / size.x + 1);
		return t;
	}
	public function getCount(color:Int):Int {
		var c = 0;
		for (i in 0...dots.length) {
			if (dots[i] == color) c++;
		}
		return c;
	}
	public function rotate(angle:Float):DotsPattern {
		var tp = clone();
		var o = new Vector();
		var cx = size.x / 2;
		var cy = size.y / 2;
		for (y in 0...size.yi) {
			for (x in 0...size.xi) {
				o.x = x - cx;
				o.y = y - cy;
				o.rotate(angle);
				setDot(tp.getDot(Std.int(o.x + cx + 0.5), Std.int(o.y + cy + 0.5)), x, y);
			}
		}
		return this;
	}
	public function invertX():DotsPattern {
		var tp:DotsPattern = clone();
		for (y in 0...size.yi) {
			for (x in 0...size.xi) {
				setDot(tp.getDot(size.xi - x - 1, y), x, y);
			}
		}
		return this;
	}
	public function invertY():DotsPattern {
		var tp:DotsPattern = clone();
		for (y in 0...size.yi) {
			for (x in 0...size.xi) {
				setDot(tp.getDot(x, size.yi - y - 1), x, y);
			}
		}
		return this;
	}
	public function drawCircle(radius:Int, colorIndex:Int = 1):Void {
		var d = 3 - radius * 2;
		var y = radius;
		for (x in 0...y + 1) {
			setCircleDots(x, y, colorIndex);
			setCircleDots(y, x, colorIndex);
			if (d < 0) {
				d += 6 + x * 4;
			} else {
				d += 10 + x * 4 - y * 4;
				y--;
			}
		}
	}
	function setCircleDots(x:Int, y:Int, colorIndex:Int):Void {
		var cx = Std.int(size.x / 2), cy = Std.int(size.y / 2);
		setDot(colorIndex, x + cx, y + cy);
		setDot(colorIndex, -x + cx, y + cy);
		setDot(colorIndex, x + cx, -y + cy);
		setDot(colorIndex, -x + cx, -y + cy);
	}
}