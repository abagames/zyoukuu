package com.abagames.util;
import nme.Lib;
class Message extends Actor {
	public static var s:Array<Message> = new Array<Message>();
	static var shownMessages:Array<String> = new Array<String>();
	public static function addOnce(text:String, pos:Vector, vx:Float = 0, vy:Float = 0,
	ticks:Int = 180):Message {
		for (m in shownMessages) if (m == text) return null;
		shownMessages.push(text);
		return add(text, pos, vx, vy, ticks);
	}
	public static function add(text:String, pos:Vector, vx:Float = 0, vy:Float = 0,
	ticks:Int = 180):Message {
		var m = new Message();
		m.text = text;
		m.pos.xy = pos;
		m.vel.x = vx / ticks;
		m.vel.y = vy / ticks;
		m.ticks = ticks;
		s.push(m);
		return m;
	}
	public var text:String;
	public var ticks:Int;
	public function new() {
		super();
	}
	override public function update():Bool {
		pos.incrementBy(vel);
		screen.drawText(text, pos.x, pos.y);
		return --ticks > 0;
	}
}