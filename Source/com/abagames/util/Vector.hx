package com.abagames.util;
import nme.geom.Vector3D;
class Vector extends Vector3D {
	public static inline var ZERO = new Vector();
	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		super(x, y, z);
	}
	public function clear():Void {
		x = y = z = 0;
	}
	public function distance(p:Vector3D):Float {
		var ox = p.x - x;
		var oy = p.y - y;
		return Math.sqrt(ox * ox + oy * oy);
	}
	public function angle(p:Vector3D):Float {
		return Math.atan2(p.x - x, p.y - y);
	}
	public function addAngle(a:Float, s:Float):Void {
		x += Math.sin(a) * s;
		y += Math.cos(a) * s;
	}
	public function rotate(a:Float):Void {
		var px = x;
		x = x * Math.cos(a) - y * Math.sin(a);
		y = px * Math.sin(a) + y * Math.cos(a);
	}
	public var xy(null, setXy):Vector3D;
	public var xyz(null, setXyz):Vector3D;
	public var way(getWay, null):Float;
	public var xi(getXi, null):Int;
	public var yi(getYi, null):Int;
	function setXy(v:Vector3D):Vector3D {
		x = v.x;
		y = v.y;
		return this;
	}
	function setXyz(v:Vector3D):Vector3D {
		x = v.x;
		y = v.y;
		z = v.z;
		return this;
	}
	function getWay():Float {
		return Math.atan2(x, y);
	}
	function getXi():Int {
		return Std.int(x);
	}
	function getYi():Int {
		return Std.int(y);
	}
	function getZi():Int {
		return Std.int(z);
	}
}