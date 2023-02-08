package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Log;
import openfl.geom.Point;

class PlayState extends FlxState
{
	private var center:FlxPoint;

	private var keeper:Keeper;
	private var ground:FlxSprite;
	private var balls:FlxTypedGroup<Ball>;
	private var spawnTime:Int = 100;
	var spawnTimer:Float = 0;

	override public function create()
	{
		super.create();

		// Calculate Screen Center
		this.center = new FlxPoint(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2));

		// Center Horizontal
		var _line:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.TRANSPARENT);

		FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, 0, 0, {color: FlxColor.WHITE, thickness: 1});
		FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, FlxG.width, FlxG.height, {color: FlxColor.WHITE, thickness: 1});
		FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, 0, FlxG.height, {color: FlxColor.WHITE, thickness: 1});
		FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, FlxG.width, 0, {color: FlxColor.WHITE, thickness: 1});

		var _net:Net = new Net(this.center.x, this.center.y);
		keeper = new Keeper(this.center.x, this.center.y);

		// Create the Gound
		ground = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 5), FlxColor.BROWN);
		ground.y = FlxG.height - Std.int(FlxG.height / 5);
		ground.immovable = true;

		balls = new FlxTypedGroup<Ball>(20);

		/*
			for (i in 0...balls.maxSize)
			{
				balls.add(new Ball(this.center.x, this.center.y, _net.x, _net.y, _net.getBottomCorner().x, _net.getBottomCorner().y));
			}
			// */

		this.add(ground);
		this.add(_line);
		this.add(_net);
		this.add(keeper);

		this.add(balls);
	}

	public function kickBall():Ball
	{
		var _ball:Ball = this.balls.getFirstAlive();

		return _ball;
	}

	private var _time:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		/*
			spawnTimer += elapsed * 5;
			if (spawnTimer > 1)
			{
				spawnTimer--;
				balls.add(balls.recycle(Ball.new));
				// Log.trace("In recycle");
			}
			// */
		//*
		if (_time > 0)
		{
			_time--;
		}
		else
		{
			_time = spawnTime;

			if (balls.length < balls.maxSize)
			{
				// balls.add(balls.recycle(Ball.new));

				// Crea new spawn point
				var _point:FlxPoint = getRandomSpawn();
				var _target:FlxPoint = new FlxPoint(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2));

				// Create Point
				balls.add(new Ball(_point.x, _point.y));

				balls.members[balls.length - 1].kick(_target.x, _target.y);

				Log.trace("Ball Created: " + balls.length);
			}

			//
		}

		// = this.spawnTime;
		// */
		FlxG.collide(ground, keeper, keeperOnGround);

		if (((FlxG.keys.justPressed.SPACE) || (FlxG.keys.justPressed.W)) || (FlxG.keys.justPressed.UP))
		{
			this.keeper.jump();
		}

		if ((FlxG.keys.pressed.LEFT) || (FlxG.keys.pressed.A))
		{
			this.keeper.moveLeft();
		}

		if ((FlxG.keys.pressed.RIGHT) || (FlxG.keys.pressed.D))
		{
			this.keeper.moveRight();
		}
	}

	private function getRandomSpawn():FlxPoint
	{
		var _x = Std.int(Math.floor((Math.random() * 3)));

		var _point:FlxPoint = new FlxPoint();

		Log.trace("Spawn " + _x);
		switch _x
		{
			case 0:
				_point = new FlxPoint(0, FlxG.height);
			case 1:
				_point = new FlxPoint(Std.int(FlxG.width / 2), FlxG.height);
			case 2:
				_point = new FlxPoint(FlxG.width, FlxG.height);
			default:
				_point = new FlxPoint(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2));
		}

		return _point;
	}

	public function keeperOnGround(_ground:FlxSprite, _keeper:Keeper)
	{
		_keeper.onGround();
	}
}
