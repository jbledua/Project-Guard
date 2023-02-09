package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class EndState extends FlxState
{
	private var blocked:Int = 0;
	private var scored:Int = 0;

	override public function new(_blocked:Int, _scored:Int, ?maxSize:Int)
	{
		this.blocked = _blocked;
		this.scored = _scored;

		super(maxSize);
	}

	override public function create()
	{
		var text:FlxText;
		var scoretext:FlxText;
		var blocktext:FlxText;
		var win:FlxText;

		text = new FlxText(0, 0, 0, "Game Over", 32);
		if (blocked >= 5)
		{
			win = new FlxText(0, 0, 0, "You WIN", 64);
			FlxTween.color(win, 1, FlxColor.WHITE, FlxColor.GREEN, {type: PINGPONG});
		}
		else
		{
			win = new FlxText(0, 0, 0, "You LOSE", 64);
			FlxTween.color(win, 1, FlxColor.WHITE, FlxColor.RED, {type: PINGPONG});
		}

		blocktext = new FlxText(0, 0, 0, "You Blocked " + blocked, 32);
		scoretext = new FlxText(0, 0, 0, "And Missed " + scored, 32);

		text.screenCenter(FlxAxes.X);
		text.y = FlxG.height / 3;

		win.screenCenter();

		blocktext.screenCenter(FlxAxes.X);
		blocktext.y = 2 * FlxG.height / 3;

		scoretext.screenCenter(FlxAxes.X);
		scoretext.y = 2 * FlxG.height / 3 + scoretext.height;

		add(scoretext);
		add(blocktext);
		add(text);
		add(win);

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
