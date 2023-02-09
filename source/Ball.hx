import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import haxe.Log;

class Ball extends FlxSprite
{
	private var z:Float = 2;
	private var zSpeed:Float = 1;

	private var target:FlxPoint;

	private var size:Int = 100;

	private var signal:FlxSignal;

	public function new(_x:Float = 0, _y:Float = 0, _z:Float = 10)
	{
		var _width:Int = 100;
		var _width:Int = 100;

		var _size:Int = 100;

		// 500
		// var _scale:Float = this.z = _z;

		this.target = new FlxPoint((FlxG.width / 2) - Std.int(_size / 2), Std.int(FlxG.height / 2) - Std.int(_size / 2));

		super(_x, _y);

		// makeGraphic(Std.int(_size * _z), Std.int(_size * _z), FlxColor.RED);
		// makeGraphic(_size, _size, FlxColor.RED);

		loadGraphic("assets/images/ball.png", true, _size, _size);

		animation.add("spin", [0, 1, 2]);
		///this.kill();

		var _duration:Float = _z / zSpeed / 5;

		/*
			FlxTween.tween(this, {
				x: this.target.x,
				y: this.target.y,
				"scale.x": 0.5,
				"scale.y": 0.5
			}, _duration);
			// */

		// signal = new FlxSignal();
	}

	public function setSignal(_signal:FlxSignal)
	{
		this.signal = _signal;
	}

	public function setTarget(_x:Float, _y:Float):FlxPoint
	{
		var _target:FlxPoint = new FlxPoint(_x - Std.int(this.size / 2), _y - Std.int(this.size / 2));

		this.target = _target;

		return _target;
	}

	public function kick(_x:Float, _y:Float)
	{
		this.setTarget(_x, _y);

		var _duration:Float = 2;

		animation.play("spin");

		FlxTween.tween(this, {
			x: this.target.x,
			y: this.target.y,
			"scale.x": 0.35,
			"scale.y": 0.35
		}, _duration);
	}

	private function randomNumber(_min:Float, _max:Float)
	{
		return Math.random() * (_max - _min) + _min;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (z > 0)
		{
			// Log.trace("elapsed:" + elapsed);

			// this.scale.set(Std.int(this.z / 10) + 1, Std.int(this.z / 10) + 1);
			this.z -= elapsed * zSpeed;
		}
		else
		{
			this.signal.dispatch();

			Log.trace("Signal Sent");
			// Log.trace("Ball Killed");
			// Log.trace("Ball Killed");
			this.kill();
		}
	}
}
