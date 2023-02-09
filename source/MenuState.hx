package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	override public function create()
	{
		var text:FlxText;
		var starttext:FlxText;

		text = new FlxText(0, 0, 0, "Keeper", 64);
		starttext = new FlxText(0, 0, 0, "Press space to start", 32);

		FlxTween.color(starttext, 1, FlxColor.WHITE, FlxColor.RED, {type: PINGPONG});

		text.screenCenter();
		// text.s
		starttext.screenCenter(FlxAxes.X);
		starttext.y = FlxG.height - 100;
		add(starttext);
		add(text);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new PlayState());
		}
	}
}
