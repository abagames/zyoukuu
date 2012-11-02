package com.abagames.util;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
class Mouse {
	public var pos:Vector;
	public var isPressing = false;
	public function new() {
		pos = new Vector();
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		Lib.current.stage.addEventListener(Event.MOUSE_LEAVE, onReleased);
	}
	function onMoved(e:MouseEvent) {
		pos.x = e.stageX / DotsShape.DOT_SIZE;
		pos.y = e.stageY / DotsShape.DOT_SIZE;
	}
	function onPressed(e:MouseEvent) {
		isPressing = true;
		onMoved(e);
	}
	function onReleased(e:Event) {
		isPressing = false;
	}
}