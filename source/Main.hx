package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		var _game:FlxGame = new FlxGame(0, 0, MenuState);
		addChild(_game);
	}
}
