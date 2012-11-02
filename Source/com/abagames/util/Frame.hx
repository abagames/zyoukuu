package com.abagames.util;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;
import com.abagames.util.away3d.View;
import com.abagames.util.away3d.Camera;
class Frame {
	public var title = "";
	public var isDebugging = false;
	public function initialize() {
	}
	public function update() {
	}
	public static var i:Frame;
	public var mouse:Mouse;
	public var key:Key;
	public var random:Random;
	public var screen:Screen;
	public var bd:BitmapData;
	public var view:View;
	public var camera:Camera;
	public var score = 0;
	public var ticks = 0;
	public var rank = 0.0;
	public var isInGame = false;
	public var fps = 0.0;
	var lastTimer = 0;
	var fpsCount = 0;
	var isPaused = false;
	var wasClicked = false;
	var wasReleased = false;
	var titleTicks = 0;
	var screenRect:Rectangle;
	var lowFpsCount = 0;
	public function new() {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Frame.i = this;
		bd = new BitmapData(Lib.stage.stageWidth, Lib.stage.stageHeight, true, 0);
		mouse = new Mouse();
		key = new Key();
		random = new Random();
		screen = new Screen();
		screenRect = new Rectangle(0, 0, screen.pixelSize.xi - 1, screen.pixelSize.yi - 1);
		view = new View();
		camera = view.camera;
		Lib.current.addChild(new Bitmap(bd));
		initializeGame();
		if (isDebugging) beginGame();
		lastTimer = Lib.getTimer();
		Lib.current.addEventListener(Event.ACTIVATE, onActivated);
		Lib.current.addEventListener(Event.DEACTIVATE, onDeactivated);
		Lib.current.addEventListener(Event.ENTER_FRAME, updateFrame);
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		if (isInGame) isPaused = true;
	}
	function beginGame():Void {
		isInGame = true;
		score = 0;
		ticks = 0;
		rank = 0;
		initializeGame();
	}
	function initializeGame():Void {
		view.reset();
		Particle.s = new Array<Particle>();
		initialize();
	}
	public function endGame():Bool {
		if (!isInGame) return false;
		isInGame = false;
		wasClicked = false;
		wasReleased = false;
		rank = 0;
		titleTicks = 10;
		return true;
	}
	function updateFrame(e:Event):Void {
		bd.lock();
		bd.fillRect(screenRect, 0);
		if (!isPaused) {
			Actor.updateAll(Particle.s);
			update();
			Se.updateAll();
			Actor.updateAll(Message.s);
			ticks++;
		} else {
			screen.drawText("PAUSED", screen.center.x, screen.center.y - 4);
			screen.drawText("CLICK TO RESUME", screen.center.x, screen.center.y + 4);
		}
		screen.drawText(Std.string(score), screen.size.x, 2, true);
		if (!isInGame) {
			screen.drawText(title, screen.center.x, screen.center.y - 10);
			screen.drawText("CLICK", screen.center.x, screen.center.y + 4);
			screen.drawText("TO", screen.center.x, screen.center.y + 9);
			screen.drawText("START", screen.center.x, screen.center.y + 14);
			if (mouse.isPressing) {
				if (wasReleased) wasClicked = true;
			} else {
				if (wasClicked) beginGame();
				if (--titleTicks <= 0) wasReleased = true;
			}
		}
		bd.unlock();
		view.render();
		fpsCount++;
		var currentTimer:Int = Lib.getTimer();
		var delta:Int = currentTimer - lastTimer;
		if (delta >= 1000) {
			fps = fpsCount * 1000 / delta;
			if (fps < Lib.stage.frameRate / 2) {
				lowFpsCount++;
				//if (view.isShadowEnabled && lowFpsCount > 5) view.isShadowEnabled = false;
			} else {
				lowFpsCount = 0;
			}
			lastTimer = currentTimer;
			fpsCount = 0;
		}
	}
}