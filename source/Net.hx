import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Log;

class Net extends FlxSprite
{
	public function new(_x:Float = 0, _y:Float = 0, _width:Int = 800, _height:Int = 400)
	{
		super(_x - Std.int(_width / 2), _y - Std.int(_height / 2));

		// Replace with Net Graphic
		makeGraphic(_width, _height, FlxColor.TRANSPARENT);
		// loadGraphic("assets/images/net1.png", false, 800, 800);

		Log.trace("Net (" + this.x + "," + this.y + "),(" + this.getBottomCorner().x + "," + this.getBottomCorner().y + ")");
	}

	public function getBottomCorner():FlxPoint
	{
		var _point:FlxPoint = new FlxPoint(this.x + this.width, this.y + this.height);

		return _point;
	}
}
