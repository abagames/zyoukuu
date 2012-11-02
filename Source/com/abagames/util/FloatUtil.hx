package com.abagames.util;
class FloatUtil {
	public static inline var PI = Math.PI;
	public static inline var PI2 = Math.PI * 2;
	public static inline function clamp(v:Float, min:Float, max:Float):Float {
		if (v > max) v = max;
		else if (v < min) v = min;
		return v;
	}
	public static inline function normalizeAngle(v:Float):Float {
		var r = v % PI2;
		if (r < -PI) r += PI2;
		else if (r > PI) r -= PI2;
		return r;
	}
	public static inline function circle(v:Float, max:Float, min:Float = 0):Float {
		var w = max - min;
		v -= min;
		var r:Float;
		if (v >= 0) r = v % w + min;
		else r = w + v % w + min;
		return r;
	}
}