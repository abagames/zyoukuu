package com.abagames.util;
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
class Se {
	public static var driver:SiONDriver = new SiONDriver();
	public static var isStarting = false;
	public static var s:Array<Se> = new Array<Se>();
	public var data:SiONData;
	public var isPlaying:Bool;
	public function new(mml:String, voice:Int = 10, l:Int = 64) {
		isStarting = isPlaying = false;
		data = driver.compile("%1@" + voice + "l" + l + mml);
		driver.volume = 0;
		driver.play();
		s.push(this);
	}
	public function play():Void {
		if (!Frame.i.isInGame) return;
		isPlaying = true;
	}
	public function update():Void {
		if (!isPlaying) return;
		if (!isStarting) {
			driver.volume = 0.9;
			isStarting = true;
		}
		driver.sequenceOn(data, null, 0, 0, 0);
		isPlaying = false;
	}
	public static function updateAll():Void {
		for (se in s) se.update();
	}
}