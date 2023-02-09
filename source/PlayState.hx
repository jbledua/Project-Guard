package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxSpriteUtil;
import haxe.Log;
import haxe.macro.Expr.FunctionKind;
import openfl.geom.Point;

class PlayState extends FlxState
{
	private var center:FlxPoint;

	private var keeper:Keeper;
	private var ground:FlxSprite;
	private var balls:FlxTypedGroup<Ball>;
	private var net:Net;
	private var spawnTime:Int = 200;
	var spawnTimer:Float = 0;

	var blockText:FlxText;
	var blockCount:Int = 0;

	var scoreText:FlxText;
	var scoreCount:Int = 0;

	private var _time:Int = 0;

	private var signal:FlxSignal;

	override public function create()
	{
		super.create();

		// Calculate Screen Center
		this.center = new FlxPoint(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2));
		var _sky:FlxSprite = new FlxSprite().loadGraphic("assets/images/clouds.png");
		_sky.screenCenter();

		var _background:FlxSprite = new FlxSprite().loadGraphic("assets/images/net.png");
		_background.screenCenter(FlxAxes.X);
		_background.y = FlxG.height - _background.height;

		blockText = new FlxText(0, 0, 0, "Blocked: " + blockCount, 32);
		blockText.x = 4 * FlxG.width / 5 - blockText.width / 2;
		blockText.y = 1 * FlxG.height / 4 - blockText.height / 2;

		scoreText = new FlxText(0, 0, 0, "Scored: " + scoreText, 32);
		scoreText.x = 1 * FlxG.width / 5 - scoreText.width / 2;
		scoreText.y = 1 * FlxG.height / 4 - blockText.height / 2;

		/*
			// Center Horizontal
			var _line:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.TRANSPARENT);

			FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, 0, 0, {color: FlxColor.WHITE, thickness: 1});
			FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, FlxG.width, FlxG.height, {color: FlxColor.WHITE, thickness: 1});
			FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, 0, FlxG.height, {color: FlxColor.WHITE, thickness: 1});
			FlxSpriteUtil.drawLine(_line, this.center.x, this.center.y, FlxG.width, 0, {color: FlxColor.WHITE, thickness: 1});
			// */

		this.net = new Net(this.center.x, 275, 540, 350);
		// this.net.alpha = 0.5;

		// net.y = this.center.y - 50;

		keeper = new Keeper(this.center.x, 0);

		// Create the Gound
		ground = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 5), FlxColor.TRANSPARENT);
		ground.y = FlxG.height - Std.int(FlxG.height / 3);
		ground.immovable = true;

		balls = new FlxTypedGroup<Ball>(10);

		/*
			for (i in 0...balls.maxSize)
			{
				balls.add(new Ball(this.center.x, this.center.y, this.net.x, this.net.y, this.net.getBottomCorner().x, this.net.getBottomCorner().y));
			}
			// */

		this.add(_sky);
		this.add(_background);
		this.add(ground);
		this.add(net);
		// this.add(_line);
		this.add(keeper);

		this.add(balls);

		signal = new FlxSignal();
		signal.add(onReachNet);

		this.add(blockText);
		this.add(scoreText);
	}

	public function kickBall():Ball
	{
		var _ball:Ball = this.balls.getFirstAlive();

		return _ball;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		blockText.text = 'Blocked: $blockCount';
		scoreText.text = 'Scored: $scoreCount';
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

				_target = getRandomTarget(this.net.x, this.net.getBottomCorner().x, this.net.y, this.net.getBottomCorner().y);

				balls.members[balls.length - 1].setSignal(signal);
				balls.members[balls.length - 1].kick(_target.x, _target.y);

				this.keeper.animation.play("idle");

				Log.trace("Ball Created: " + balls.length);
			}
			else
			{
				FlxG.switchState(new EndState(this.blockCount, this.scoreCount));
				// this.switchTo();
			}
			// FlxSignal.
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

	private function onReachNet()
	{
		Log.trace("Net Reached");

		for (i in 0...balls.length)
		{
			if (balls.members[i].alive)
			{
				if (this.keeper.overlaps(balls.members[i]))
				{
					// Log.trace("Blocked");
					this.keeper.animation.play("idle-catch");
					FlxTween.color(blockText, 1, FlxColor.GREEN, FlxColor.WHITE);
					this.blockCount++;
				}
				else
				{
					FlxTween.color(scoreText, 1, FlxColor.RED, FlxColor.WHITE);
					this.scoreCount++;
				}
			}
		}
		// if (FlxG.overlap(this.keeper:Keeper, balls:FlxTypedGroup<Ball>))
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

	private function checkGoal(_ball:Ball)
	{
		Log.trace("In callback");
	}

	private function getRandomTarget(_minX:Float, _maxX:Float, _minY:Float, _maxY:Float):FlxPoint
	{
		var _randX = Math.floor((Math.random() * (_maxX - _minX) + _minX));
		var _randY = Math.floor((Math.random() * (_maxY - _minY) + _minY));

		var _point:FlxPoint = new FlxPoint(_randX, _randY);

		Log.trace("X:" + _randX + " Y:" + _randY);

		return _point;
	}

	public function keeperOnGround(_ground:FlxSprite, _keeper:Keeper)
	{
		_keeper.onGround();
	}
}
