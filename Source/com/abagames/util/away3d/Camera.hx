package com.abagames.util.away3d;
import flash.geom.Vector3D;
import away3d.cameras.Camera3D;
import away3d.cameras.lenses.PerspectiveLens;
import com.abagames.util.Vector;
class Camera {
	public var camera:Camera3D;
	var lookPos:Vector3D;
	var lookUp:Vector3D;
	public function new():Void {
		var lens = new PerspectiveLens();
		this.camera = new Camera3D(lens);
		camera.lens.near = 1;
		camera.lens.far = 1000;
		lens.fieldOfView = 60;
		lookPos = new Vector3D();
		lookUp = new Vector3D();
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public function lookAt(p:Vector, up:Vector = null):Void {
		lookPos.x = p.x;
		lookPos.y = p.y;
		lookPos.z = p.z;
		if (up == null) {
			camera.lookAt(lookPos);
			return;
		}
		lookUp.x = up.x;
		lookUp.y = up.y;
		lookUp.z = up.z;
		camera.lookAt(lookPos, lookUp);
	}
	function getX():Float { return camera.x;  }
	function getY():Float { return camera.y;  }
	function getZ():Float { return camera.z;  }
	function setX(v:Float):Float {
		camera.x = v;
		return v;
	}
	function setY(v:Float):Float {
		camera.y = v;
		return v;
	}
	function setZ(v:Float):Float {
		camera.z = v;
		return v;
	}
}