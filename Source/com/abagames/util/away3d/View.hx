package com.abagames.util.away3d;
import com.abagames.util.Vector;
import nme.display.BitmapData;
import nme.Lib;
import flash.geom.Vector3D;
import away3d.containers.View3D;
import away3d.containers.Scene3D;
import away3d.filters.BloomFilter3D;
import away3d.filters.DepthOfFieldFilter3D;
import away3d.lights.DirectionalLight;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.methods.SoftShadowMapMethod;
import away3d.materials.methods.FogMethod;
class View {
	public var camera:Camera;
	public var view:View3D;
	public var light:DirectionalLight;
	public var lightPicker:StaticLightPicker;
	public var fogMethod:FogMethod;
	public var shadowMethod:SoftShadowMapMethod;
	public var isShadowEnabled:Bool;
	var scene:Scene3D;
	var pos3d:Vector3D;
	var projectedPos:Vector;
	public function new() {
		view = new View3D();
		view.width = Lib.stage.stageWidth;
		view.height = Lib.stage.stageHeight;
		view.backgroundColor = 0;
		Lib.current.addChild(view);
		scene = view.scene;
		var bf = new BloomFilter3D(10, 10, 0.1, 1);
		view.filters3d = [bf];
		light = new DirectionalLight(0.4, -0.2, 0.5);
		light.diffuse = 0.2;
		light.specular = 0.2;
		light.ambient = 0.2;
		view.scene.addChild(light);
		lightPicker = new StaticLightPicker([light]);
		//fogMethod = new FogMethod(750, 1000, 0);
		shadowMethod = new SoftShadowMapMethod(light);
		shadowMethod.epsilon = 0.0001;
		shadowMethod.alpha = 0.5;
		isShadowEnabled = true;
		pos3d = new Vector3D();
		projectedPos = new Vector();
		camera = new Camera();
		view.camera = camera.camera;
	}
	public function render() {
		view.render();
	}
	public function renderToBitmapData(bd:BitmapData) {
		view.renderer.swapBackBuffer = false;
		view.render();
		view.renderer.queueSnapshot(bd);
		view.renderer.swapBackBuffer = true;
	}
	public function addChild(mesh:Mesh):Void {
		scene.addChild(mesh.mesh);
	}
	public function removeChild(mesh:Mesh):Void {
		scene.removeChild(mesh.mesh);
	}
	public function reset():Void {
		while (scene.numChildren > 1) {
			var o = scene.getChildAt(1);
			scene.removeChild(o);
			o.dispose();
		}
	}
	public function project(p:Vector):Vector {
		pos3d.x = p.x;
		pos3d.y = p.y;
		pos3d.z = p.z;
		var pp = view.project(pos3d);
		projectedPos.x = pp.x / 2;
		projectedPos.y = pp.y / 2;
		return projectedPos;
	}
	public var width(null, setWidth):Float;
	public var height(null, setHeight):Float;
	function setWidth(v:Float):Float {
		return view.width = v;
	}
	function setHeight(v:Float):Float {
		return view.height = v;
	}
}