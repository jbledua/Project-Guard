import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Log;

class Ball extends FlxSprite
{
	private var z:Float = 100;
	private var zSpeed:Float = 1;

	private var target:FlxPoint;

	public function new(_x:Float = 0, _y:Float = 0, minTargetX:Float = 0, minTargetY:Float = 0, maxTargetX:Float = 100, maxTargetY:Float = 100)
	{
		var _width:Int = 100;
		var _height:Int = 100;

		super(_x - Std.int(_width / 2), _y - Std.int(_height / 2));

		target = new FlxPoint(randomNumber(minTargetY, maxTargetY), randomNumber(minTargetY, maxTargetY)); // Replace with Ball Graphic

		makeGraphic(_width, _height, FlxColor.RED);

		this.kill();
	}

	override public function revive()
	{
		// velocity.x = 200;

		FlxTween.tween(this, {
			x: target.x,
			y: target.y,
			"scale.x": 0.5,
			"scale.y": 0.5
		}, 2);

		super.revive();
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
			Log.trace("Z:" + this.z);

			// this.scale.set(Std.int(this.z / 10) + 1, Std.int(this.z / 10) + 1);
			this.z -= zSpeed;
		}
		else
		{
			Log.trace("Goal");
			// this.scale.set(1, 1);
			this.destroy();
		}
	}
}
