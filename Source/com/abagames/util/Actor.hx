package com.abagames.util;
class Actor {
	public var pos:Vector;
	public var vel:Vector;
	var PI:Float;
	var PI2:Float;
	var random:Random;
	var screen:Screen;
	public function new() {
		pos = new Vector();
		vel = new Vector();
		PI = Math.PI;
		PI2 = Math.PI * 2;
		random = Frame.i.random;
		screen = Frame.i.screen;
	}
	public function update():Bool {
		return true;
	}
	public function remove():Void {
	}
	public static function updateAll(s:Array<Dynamic>):Void {
		var i:Int = 0;
		while (i < s.length) {
			if (s[i].update()) {
				i++;
			} else {
				s[i].remove();
				s.splice(i, 1);
			}
		}
	}
}