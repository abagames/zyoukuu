package com.abagames.util.away3d;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import com.abagames.util.Frame;
import com.abagames.util.Vector;
enum MeshType {
	Cube;
	Plane;
}
class Mesh {
	public static var geometries:Hash<Dynamic> = new Hash<Dynamic>();
	public static var materials:Hash<ColorMaterial> = new Hash<ColorMaterial>();
	public var mesh:away3d.entities.Mesh;
	var view:View;
	public function new(type:MeshType, width:Float = 1, height:Float = 1, depth:Float = 1,
	color:Int = 0xffffff, alpha:Float = 1, hasLighting:Bool = true, hasShadow:Bool = true) {
		view = Frame.i.view;
		var gkey = type + "/" + width + "/" + height + "/" + depth;
		var geom:Dynamic;
		if (geometries.exists(gkey)) {
			geom = geometries.get(gkey);
		} else {
			switch (type) {
				case MeshType.Cube:
					geom = new CubeGeometry(width, height, depth);
				case MeshType.Plane:
					geom = new PlaneGeometry(width, height);
			}
			geometries.set(gkey, geom);
		}
		var mkey = color + "/" + alpha + "/" + hasLighting;
		var mat;
		if (materials.exists(mkey)) {
			mat = materials.get(mkey);
		} else {
			mat = new ColorMaterial(color, alpha);
			//mat.addMethod(view.fogMethod);
			if (hasLighting) mat.lightPicker = view.lightPicker;
			if (hasShadow && view.isShadowEnabled) mat.shadowMethod = view.shadowMethod;
			materials.set(mkey, mat);
		}
		mesh = new away3d.entities.Mesh(geom, mat);
		if (!hasShadow || !view.isShadowEnabled) mesh.castsShadows = false;
		mesh.z = -99999;
		view.addChild(this);
	}
	public function remove():Void {
		view.removeChild(this);
		mesh.dispose();
	}
	public var x(getX, setX):Float;
	public var y(getY, setY):Float;
	public var z(getZ, setZ):Float;
	public var xyz(null, setXyz):Vector;
	public var rotationX(getRotationX, setRotationX):Float;
	public var rotationY(getRotationY, setRotationY):Float;
	public var rotationZ(getRotationZ, setRotationZ):Float;
	public var scaleX(null, setScaleX):Float;
	public var scaleY(null, setScaleY):Float;
	public var scaleZ(null, setScaleZ):Float;
	public var scale(getScale, setScale):Float;
	public var visible(null, setVisible):Bool;
	function getX():Float { return mesh.x; }
	function getY():Float { return mesh.y; }
	function getZ():Float { return mesh.z; }
	function setX(v:Float):Float {
		return mesh.x = v;
	}
	function setY(v:Float):Float {
		return mesh.y = v;
	}
	function setZ(v:Float):Float {
		return mesh.z = v;
	}
	function setXyz(v:Vector):Vector {
		mesh.x = v.x;
		mesh.y = v.y;
		mesh.z = v.z;
		return v;
	}
	function setRotationX(v:Float):Float {
		return mesh.rotationX = v;
	}
	function setRotationY(v:Float):Float {
		return mesh.rotationY = v;
	}
	function setRotationZ(v:Float):Float {
		return mesh.rotationZ = v;
	}
	function getRotationX():Float {
		return mesh.rotationX;
	}
	function getRotationY():Float {
		return mesh.rotationY;
	}
	function getRotationZ():Float {
		return mesh.rotationZ;
	}
	function setScaleX(v:Float):Float {
		return mesh.scaleX = v;
	}
	function setScaleY(v:Float):Float {
		return mesh.scaleY = v;
	}
	function setScaleZ(v:Float):Float {
		return mesh.scaleZ = v;
	}
	function setScale(v:Float):Float {
		return mesh.scaleX = mesh.scaleY = mesh.scaleZ = v;
	}
	function getScale():Float {
		return mesh.scaleX;
	}
	function setVisible(v:Bool):Bool {
		return mesh.visible = v;
	}
}