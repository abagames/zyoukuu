package com.abagames.util;
import com.abagames.util.away3d.Mesh;
import nme.geom.ColorTransform;
import away3d.materials.ColorMaterial;
class Particle extends Actor {
	public static var s:Array<Particle>;
	public static var random = new Random();
	public var ticks = 0;
	var cube:Mesh;
	var vrx:Float;
	var vry:Float;
	var colorTransform:ColorTransform;	
	public function new(color:Int, scale:Float) {
		super();
		colorTransform = new ColorTransform();
		cube = new Mesh(MeshType.Cube, 1, 1, 1, color, 0.5);
		cast(cube.mesh.material, ColorMaterial).colorTransform = colorTransform;
		cube.rotationX = random.n(PI2);
		cube.rotationY = random.n(PI2);
		cube.scale = scale;
		vrx = random.n(20) * random.pm();
		vry = random.n(20) * random.pm();
	}
	override public function update():Bool {
		pos.incrementBy(vel);
		vel.scaleBy(0.98);
		cube.xyz = pos;
		cube.rotationX += vrx;
		cube.rotationY += vry;
		cube.scale *= 0.98;
		colorTransform.redMultiplier = random.n(0.6, 0.7);
		colorTransform.greenMultiplier = random.n(0.6, 0.7);
		colorTransform.blueMultiplier = random.n(0.6, 0.7);
		return --ticks > 0;
	}
	override public function remove():Void {
		cube.remove();
	}
	public static function add(p:Vector, color:Int, count:Int, speed:Float,
	ticks:Float = 30, angle:Float = 0, angleWidth:Float = 6.28, scale:Float = 1):Void {
		for (i in 0...count) {
			var pt = new Particle(color, scale);
			pt.pos.xyz = p;
			pt.vel.addAngle(
				angle + random.n(angleWidth / 2) * random.pm(),
				speed * random.n(1, 0.5));
			pt.ticks = Std.int(ticks * random.n(1, 0.5));
			s.push(pt);
		}
	}
}