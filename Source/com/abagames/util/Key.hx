package com.abagames.util;
import nme.events.KeyboardEvent;
import nme.Lib;
class Key {
	public var s:Array<Bool>;
	public var isWPressed(getIsWPressed, null):Bool;
	public var isAPressed(getIsAPressed, null):Bool;
	public var isSPressed(getIsSPressed, null):Bool;
	public var isDPressed(getIsDPressed, null):Bool;
	public var isButtonPressed(getIsButtonPressed, null):Bool;
	public var isButton1Pressed(getIsButton1Pressed, null):Bool;
	public var isButton2Pressed(getIsButton2Pressed, null):Bool;
	public var stick(getStick, null):Vector;
	var sVector:Vector;
	public function new() {
		s = new Array<Bool>();
		for (i in 0...256) s.push(false);
		sVector = new Vector();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
	}
	function onPressed(e:KeyboardEvent) {
		s[e.keyCode] = true;
	}
	function onReleased(e:KeyboardEvent) {
		s[e.keyCode] = false;
	}
	function getIsWPressed():Bool {
		return s[0x26] || s[0x57];
	}
	function getIsAPressed():Bool {
		return s[0x25] || s[0x41];
	}
	function getIsSPressed():Bool {
		return s[0x28] || s[0x53];
	}
	function getIsDPressed():Bool {
		return s[0x27] || s[0x44];
	}
	function getIsButtonPressed():Bool {
		return isButton1Pressed || isButton2Pressed;
	}
	function getIsButton1Pressed():Bool {
		return s[0x5a] || s[0xbe] || s[0x20];
	}
	function getIsButton2Pressed():Bool {
		return s[0x58] || s[0xbf];
	}	
	function getStick():Vector {
		sVector.clear();
		if (isWPressed) sVector.y -= 1;
		if (isAPressed) sVector.x -= 1;
		if (isSPressed) sVector.y += 1;
		if (isDPressed) sVector.x += 1;
		if (sVector.x != 0 && sVector.y != 0) sVector.scaleBy(0.7);
		return sVector;
	}
}