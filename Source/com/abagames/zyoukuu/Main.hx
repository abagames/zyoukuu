package com.abagames.zyoukuu;
import com.abagames.util.Dots;
import com.abagames.util.Frame;
import com.abagames.util.Actor;
import com.abagames.util.Color;
import com.abagames.util.Particle;
import com.abagames.util.Message;
import com.abagames.util.Screen;
import com.abagames.util.Key;
import com.abagames.util.Mouse;
import com.abagames.util.Se;
import com.abagames.util.Vector;
import com.abagames.util.Random;
import com.abagames.util.away3d.View;
import com.abagames.util.away3d.Camera;
import com.abagames.util.away3d.Mesh;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.geom.ColorTransform;
import nme.Lib;
import away3d.materials.ColorMaterial;
using Math;
using com.abagames.util.FloatUtil;
using com.abagames.util.IntUtil;
class Main extends Frame {
	public static var i:Main;
	public var bonusScore:Int;
	public var tickSe:Se;
	public var downSe:Se;
	public var upSe:Se;
	public var bonusSe:Se;
	public var destroySe:Se;
	var bonus:Bonus;
	var scrollTicks = 0.0;
	override public function initialize() {
		Main.i = this;
		title = "ZYOUKUU";
		if (tickSe == null) {
			tickSe = new Se("@v128o2c+dc", 1);
			downSe = new Se("o6co5e-d-cc", 9);
			upSe = new Se("o5ccd-e-a-", 9);
			bonusSe = new Se("o5do4aceo5eo7c");
			destroySe = new Se("o5e-o6cd-o7e-g-d-o6a-a-o7d-o6co5co4a-a-a-a-");
		}
		camera.z = -Pattern.LAYER_HEIGHT - 150;
		camera.lookAt(Vector.ZERO);
		var p = new Mesh(MeshType.Plane, 240, 320, 0, 0x448888);
		p.x = p.y = p.z = 0;
		p.rotationX = -90;
		scrollTicks = 0;
		Pattern.i = new Pattern();
		Pattern.i.add(40);
		Player.i = new Player();
		if (isInGame) bonus = new Bonus();
		else bonus = null;
		bonusScore = 100;
	}
	override public function update() {
		if (isInGame) {
			if (ticks == 0) Message.addOnce("[u][r][d][l] TO MOVE.", new Vector(100, 200));
			if (ticks == 60) Message.addOnce("PRESS [Z] TO GO UP/DOWN.", new Vector(100, 220));
			rank = ticks * 0.001;
			Player.i.update();
			score++;
		}
		var sx = Player.i.pos.x * 0.1;
		var sy = 1.0 * (rank + 1);
		Pattern.i.scroll(sx, sy);
		if (bonus != null) {
			bonus.pos.x -= sx;
			bonus.pos.y -= sy;
			if (!bonus.update()) {
				if (isInGame) bonus = new Bonus();
				else bonus = null;
			}
		}
		if (isInGame) {
			scrollTicks += sy;
			if (scrollTicks > 30) {
				tickSe.play();
				scrollTicks -= 30;
			}
		}
		//screen.drawText("FPS " + Std.int(fps), screen.size.x, 10, true);
	}
	public static function main() {
		new Main();
	}
}
class Pattern {
	public static inline var LAYER = 2;
	public static inline var WIDTH = 40;
	public static inline var WIDTH2 = Std.int(WIDTH / 2);
	public static inline var HEIGHT = 60;
	public static inline var HEIGHT3 = Std.int(HEIGHT / 3);
	public static inline var SIZE = 10;
	public static inline var LAYER_HEIGHT = 50;
	public static var i:Pattern;
	public var scrollDist:Vector;
	public var grid:Array<Array<Array<Bool>>>;
	var gridCubes:Array<Array<Array<Mesh>>>;
	var cubes:Array<Mesh>;
	var random:Random;
	public function new() {
		grid = new Array<Array<Array<Bool>>>();
		gridCubes = new Array<Array<Array<Mesh>>>();
		for (x in 0...WIDTH) {
			var xg = new Array<Array<Bool>>();
			var xgc = new Array<Array<Mesh>>();
			for (y in 0...HEIGHT) {
				var yg = new Array<Bool>();
				var ygc = new Array<Mesh>();
				for (l in 0...LAYER) {
					yg.push(false);
					ygc.push(null);
				}
				xg.push(yg);
				xgc.push(ygc);
			}
			grid.push(xg);
			gridCubes.push(xgc);
		}
		cubes = new Array<Mesh>();
		scrollDist = new Vector();
		random = Main.i.random;
	}
	public function add(sy, ox = 0.0, oy = 0.0) {
		for (l in 0...LAYER) {
			var n = 8 + l * 4;
			for (i in 0...n) {
				if (random.i(2) == 0) addBar(l, sy, ox, oy);
				else addSquare(l, sy, ox, oy);
			}
		}
	}
	static inline var OFFSETS = [[1, 0], [0, 1], [-1, 0], [0, -1]];
	function addBar(l, sy, ox, oy) {
		var x = random.i(WIDTH);
		var y = random.i(Std.int(HEIGHT3 / 3), Std.int(HEIGHT3 / 3));
		var w = 0, h = 0;
		var d = random.i(4), dd = 0;
		for (i in 0...random.i(50, 50)) {
			if (grid[x][y + sy][l]) break;
			if (--dd <= 0) {
				if (w != 0 || h != 0) {
					var bx = x, by = y;
					if (w != 0) {
						if (w < 0) w *= -1;
						else {
							bx -= w - 1; 
							if (bx < 0) bx += WIDTH;
						}
						h = 1;
					} else {
						if (h < 0) h *= -1;
						else by -= h - 1;
						w = 1;
					}
					addBox(l, bx, by + sy, w, h, ox, oy);
					w = h = 0;
				}
				d += random.pm();
				d = d.circlei(4);
				if (d % 2 == 0) dd = random.i(6, 6);
				else dd = random.i(3, 3);
			}
			x += OFFSETS[d][0];
			x = x.circlei(WIDTH);
			w += OFFSETS[d][0];
			y += OFFSETS[d][1];
			if (y < 0 || y >= HEIGHT3) break;
			h += OFFSETS[d][1];
		}
	}
	function addSquare(l, sy, ox, oy) {
		var w = random.i(6, 6), h = random.i(3, 3);
		var x = random.i(WIDTH);
		var y = random.i(HEIGHT3 - h) + sy;
		for (gx in x...x + w)
			for (gy in y...y + h)
				if (grid[gx % WIDTH][gy][l]) return;
		addBox(l, x, y, w, h, ox, oy);
	}
	function addBox(l, x, y, w, h, ox, oy) {
		var c;
		if (l == 0) {
			c = new Mesh(MeshType.Cube, (w - 0.1) * SIZE, (h - 0.1) * SIZE, 
			SIZE * 0.9, 0x2277dd);
		} else {
			c = new Mesh(MeshType.Cube, (w - 0.1) * SIZE, (h - 0.1) * SIZE,
			SIZE * 0.9, 0x88bbff);
		}
		c.x = (x - WIDTH / 2 + (w - 1) / 2) * SIZE + ox;
		if (c.x < -WIDTH2 * SIZE) c.x += WIDTH * SIZE;
		if (c.x > WIDTH2 * SIZE) c.x -= WIDTH * SIZE;
		c.y = (y - HEIGHT / 2 + HEIGHT3 / 2 + (h - 1) / 2) * SIZE + oy;
		c.z = -l * LAYER_HEIGHT - SIZE / 2;
		cubes.push(c);
		gridCubes[x][y][l] = c;
		for (gx in x...x + w)
			for (gy in y...y + h)
				grid[gx % WIDTH][gy][l] = true;
	}
	public function scroll(x:Float, y:Float) {
		Player.i.pos.x -= x;
		for (c in cubes) {
			c.x -= x;
			c.x = c.x.circle(WIDTH2 * SIZE, -WIDTH2 * SIZE);
			c.y -= y;
		}
		scrollDist.x += x;
		scrollDist.x = scrollDist.x.circle(WIDTH2 * SIZE, -WIDTH2 * SIZE);
		scrollDist.y += y;
		if (scrollDist.y >= HEIGHT3 * SIZE) {
			scrollDist.y -= HEIGHT3 * SIZE;
			for (l in 0...LAYER) {
				for (x in 0...WIDTH) {
					for (y in 0...HEIGHT3) {
						if (gridCubes[x][y][l] != null) {
							gridCubes[x][y][l].remove();
							cubes.remove(gridCubes[x][y][l]);
							gridCubes[x][y][l] = null;
						}
					}
					for (y in 0...HEIGHT3 * 2) {
						grid[x][y][l] = grid[x][y + HEIGHT3][l];
						gridCubes[x][y][l] = gridCubes[x][y + HEIGHT3][l];
					}
					for (y in HEIGHT3 * 2...HEIGHT) {
						grid[x][y][l] = false;
						gridCubes[x][y][l] = null;
					}
				}
			}
			add(HEIGHT3 * 2, -scrollDist.x, -scrollDist.y);
		}
		for (p in Particle.s) {
			p.pos.x -= x;
			p.pos.y -= y;
		}
	}
}
class Player extends Actor {
	public static var i:Player;
	public var layer = 1;
	var cube:Mesh;
	var roundCubes:Array<Mesh>;
	var key:Key;
	var colorTransform:ColorTransform;
	var ticks = 0;
	public function new() {
		super();
		key = Main.i.key;
		colorTransform = new ColorTransform();
		cube = new Mesh(MeshType.Cube, 5, 20, 5, 0x884488, 1, false);
		cast(cube.mesh.material, ColorMaterial).colorTransform = colorTransform;
		roundCubes = new Array<Mesh>();
		for (i in 0...4) {
			var rc = new Mesh(MeshType.Cube, 3, 10, 3, 0x997799, 1, false);
			roundCubes.push(rc);
			cast(rc.mesh.material, ColorMaterial).colorTransform = colorTransform;
		}
		pos.z = -Pattern.LAYER_HEIGHT;
		createGauge();
	}
	var gauge:Dots;
	var gaugePos:Vector;
	var mark:Dots;
	var markPos:Vector;
	function createGauge() {
		var dp = new Array<String>();
		dp.push("111     111");
		for (i in 0...60) {
			dp.push("1         1");
			dp.push("1         1");
			dp.push("11       11");
		}
		dp.push("1         1");
		dp.push("1         1");
		dp.push("111     111");
		gauge = new Dots([[0xffffff], dp, 0]); 
		gaugePos = new Vector(10, 180);
		mark = new Dots([[0xffffff, 0x88ff88, 0],
		["111222", "133332", "131132", "131132", "133332", "111222"], 0]);
		markPos = new Vector(10);
	}
	override public function update() {
		var s = (1 + Main.i.rank) * 2;
		pos.x += key.stick.x * s;
		pos.y -= key.stick.y * s;
		pos.y = pos.y.clamp(-70, 70);
		if (vel.z == 0) {
			if (key.isButtonPressed) {
				if (pos.z <= -Pattern.LAYER_HEIGHT) {
					vel.z = 1;
					Main.i.downSe.play();
				} else {
					vel.z = -1;
					Main.i.upSe.play();
				}
				layer = -1;
			}
		} else {
			pos.z += vel.z * s;
			if (pos.z <= -Pattern.LAYER_HEIGHT) {
				pos.z = -Pattern.LAYER_HEIGHT;
				vel.z = 0;
				layer = 1;
			} else if (pos.z >= -Pattern.SIZE / 2) {
				pos.z = -Pattern.SIZE / 2;
				vel.z = 0;
				layer = 0;
			}
			colorTransform.redMultiplier = colorTransform.greenMultiplier =
			colorTransform.blueMultiplier = -pos.z / Pattern.LAYER_HEIGHT * 0.4 + 0.6;
		}
		var x = Std.int((pos.x + Pattern.WIDTH / 2 * Pattern.SIZE + 
		Pattern.SIZE / 2 +
		Pattern.i.scrollDist.x).circle(Pattern.WIDTH * Pattern.SIZE) / Pattern.SIZE);
		var y = Std.int((pos.y + (Pattern.HEIGHT / 2 - Pattern.HEIGHT3 / 2) * Pattern.SIZE + 
		Pattern.SIZE / 2 +
		Pattern.i.scrollDist.y).circle(Pattern.HEIGHT * Pattern.SIZE) / Pattern.SIZE);
		if (layer >= 0 && Pattern.i.grid[x][y][layer]) {
			Particle.add(pos, Color.red.i, 50, 10, 40, 0, PI2, 5);
			Particle.add(pos, Color.magenta.i, 50, 3, 60, 0, PI2, 10);
			cube.remove();
			for (rc in roundCubes) rc.remove();
			Main.i.destroySe.play();
			Main.i.endGame();
			return false;
		}
		cube.xyz = pos;
		var a = ticks * 0.1;
		for (rc in roundCubes) {
			rc.x = pos.x + a.sin() * 5;
			rc.y = pos.y - 5;
			rc.z = pos.z + a.cos() * 5;
			rc.rotationY = a * 180 / PI;
			a += PI2 / 3;
		}
		ticks++;
		markPos.y = 293 + pos.z / Pattern.LAYER_HEIGHT * 204;
		mark.draw(markPos);
		Main.i.screen.drawText("UP", 12, 82);
		gauge.draw(gaugePos);
		Main.i.screen.drawText("DOWN", 14, 278);
		return true;
	}
}
class Bonus extends Actor {
	static var isFirst = true;
	var cubes:Array<Mesh>;
	var layer:Int;
	var message:Message;
	public function new() {
		super();
		cubes = new Array<Mesh>();
		layer = random.i(2);
		for (i in 0...2) {
			var c;
			if (layer == 0) {
				c = new Mesh(MeshType.Cube, 10, 10, 10, 0x777744, 0.7, false);
				pos.z = -Pattern.SIZE / 2;
			} else {
				c = new Mesh(MeshType.Cube, 10, 10, 10, 0x999977, 0.7, false);
				pos.z = -Pattern.LAYER_HEIGHT;
			}
			var grid = Pattern.i.grid;
			for (j in 0...20) {
				pos.x = random.n(50) * random.pm();
				pos.y = random.n(20, 130);
				var x = Std.int((pos.x + 
				Pattern.WIDTH / 2 * Pattern.SIZE +
				Pattern.i.scrollDist.x).circle(Pattern.WIDTH * Pattern.SIZE) / Pattern.SIZE);
				var y = Std.int((pos.y + 
				(Pattern.HEIGHT / 2 - Pattern.HEIGHT3 / 2) * Pattern.SIZE +
				Pattern.i.scrollDist.y).circle(Pattern.HEIGHT * Pattern.SIZE) / Pattern.SIZE);
				if (!grid[x][y][layer] && !grid[(x + 1) % Pattern.WIDTH][y][layer] &&
				!grid[x][(y + 1) % Pattern.HEIGHT][layer] &&
				!grid[(x + 1) % Pattern.WIDTH][(y + 1) % Pattern.HEIGHT][layer]) break;
			}
			cubes.push(c);
		}
	}
	override public function update():Bool {
		for (i in 0...2) {
			var c = cubes[i];
			c.rotationX += ((i * 2) - 1) * 4;
			c.rotationY -= ((i * 2) - 1) * 4;
			c.xyz = pos;
		}
		if (Main.i.isInGame && Player.i.layer == layer && 
		(pos.x - Player.i.pos.x).abs() < 10 &&
		(pos.y - Player.i.pos.y).abs() < 20) {
			Main.i.score += Main.i.bonusScore;
			var pp = Main.i.view.project(pos);
			Message.add(Std.string(Main.i.bonusScore), pp, 0, -30, 60);
			if (Main.i.bonusScore < 1000) Main.i.bonusScore += 100;
			Particle.add(pos, Color.yellow.i, 20, 1, 30, 0, PI2, 5);
			remove();
			Main.i.bonusSe.play();
			return false;
		}
		if (isFirst && pos.y < 80) {
			message = Message.addOnce("GET ME!", pos);
			isFirst = false;
		}
		if (message != null) {
			message.pos.xy = Main.i.view.project(pos);
			message.pos.y -= 20;
		}
		if (pos.y > -120) return true;
		remove();
		Main.i.bonusScore = 100;
		return false;
	}
	override public function remove():Void {
		for (c in cubes) c.remove();
	}
}