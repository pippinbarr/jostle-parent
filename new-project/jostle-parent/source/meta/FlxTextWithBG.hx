package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

enum TweenState
{
	NO_TWEEN;
	TWEEN_IN;
	TWEEN_IN_DELAY;
	TWEENED_IN;
	TWEEN_OUT;
	TWEENED_OUT;
}

class FlxTextWithBG extends FlxGroup
{
	private var _x:Float;
	private var _y:Float;
	private var _alpha:Float;
	private var _velocityX:Float;

	public var x(get, set):Float;
	public var y(get, set):Float;
	public var alpha(get, set):Float;
	public var velocityX(get, set):Float;

	public var width:Float;
	public var height:Float;

	public var text:FlxText;
	public var bg:FlxSprite;

	private var size:Int;
	private var align:String;
	private var color:UInt;
	private var bgColor:UInt;

	private var tweens:Bool;
	private var tweenDir:Enums.Direction;
	private var tweenState:TweenState = NO_TWEEN;

	private static var TWEEN_SPEED:Float = 250;

	private var tweenInTimer:FlxTimer;

	public var theAlpha:Float;
	public var indent:Int;

	public function new(X:Float, Y:Float, W:Float, T:String, S:Int, A:String, TextColor:UInt, BGColor:UInt, Tweens:Bool = false,
			TweenDir:Enums.Direction = null, Alpha:Float = 0.6, Indent:Int = 8)
	{
		super();

		_x = X;
		_y = Y;
		_alpha = 1;
		bgColor = BGColor;
		color = TextColor;
		size = S;
		align = A;
		tweens = Tweens;
		tweenDir = TweenDir;
		theAlpha = Alpha;
		indent = Indent;

		// text = new FlxText(X + indent, Y, Std.int(W - indent * 2), T, S, false);
		text = new FlxText(X + indent, Y, Std.int(W - indent * 2), T, S);
		text.alignment = A;
		text.color = TextColor;

		if (Tweens)
		{
			text.moves = true;
			text.scrollFactor.x = 0;
			text.scrollFactor.y = 0;
		}

		bg = new FlxSprite(X, Y);
		bg.makeGraphic(Std.int(W), Std.int(text.height), BGColor);
		bg.alpha = theAlpha;

		if (Tweens)
		{
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0;
		}

		width = bg.width;
		height = bg.height;

		add(bg);
		add(text);

		tweenInTimer = new FlxTimer().start();
		tweenInTimer.finished = true;

		tweenState = NO_TWEEN;
	}

	override public function destroy():Void
	{
		super.destroy();

		bg.destroy();
		text.destroy();
		tweenInTimer.destroy();
	}

	public function tweenIn(S:String, Force:Bool = false):Void
	{
		if (!tweens)
			return;
		if (S == text.text && !isTweenedOut())
			return;

		setText(S);

		if (tweenDir == RIGHT)
		{
			x = -width;
			velocityX = TWEEN_SPEED;
		}
		else
		{
			x = FlxG.width;
			velocityX = -TWEEN_SPEED;
		}

		tweenState = TWEEN_IN;
	}

	public function tweenOut(Instant:Bool = false):Void
	{
		if (!tweens)
			return;
		tweenInTimer.cancel();

		if (tweenDir == RIGHT)
		{
			if (Instant)
			{
				x -= width;
			}

			velocityX = -TWEEN_SPEED;
		}
		else
		{
			if (Instant)
			{
				x += width;
			}

			velocityX = TWEEN_SPEED;
		}

		tweenState = TWEEN_OUT;
	}

	public function isTweeningIn():Bool
	{
		return (tweenState == TWEEN_IN);
	}

	public function isTweenedIn():Bool
	{
		return (tweenState == TWEENED_IN);
	}

	public function isTweeningOut():Bool
	{
		return (tweenState == TWEEN_OUT);
	}

	public function isTweenedOut():Bool
	{
		return (tweenState == TWEENED_OUT || tweenState == NO_TWEEN);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!tweens)
			return;

		switch (tweenState)
		{
			case NO_TWEEN:

			case TWEEN_IN:
				if (tweenDir == RIGHT && x >= 0)
				{
					velocityX = 0;
					x = 0;
					tweenState = TWEENED_IN;
					// tweenState = TWEEN_IN_DELAY;
					// tweenInTimer.start(0);
				}
				else if (tweenDir == LEFT && x + width < FlxG.width)
				{
					velocityX = 0;
					x = FlxG.width - width;
					tweenState = TWEENED_IN;
					// tweenState = TWEEN_IN_DELAY;
					// tweenInTimer.start(0);
				}

			case TWEEN_IN_DELAY:
				if (tweenInTimer.finished)
					tweenState = TWEENED_IN;

			case TWEENED_IN:

			case TWEEN_OUT:
				if (tweenDir == RIGHT && x + width < 0)
				{
					velocityX = 0;
					tweenState = TWEENED_OUT;
				}
				else if (tweenDir == LEFT && x > FlxG.width)
				{
					velocityX = 0;
					tweenState = TWEENED_OUT;
				}

			case TWEENED_OUT:
		}
	}

	public function get_x():Float
	{
		return bg.x;
	}

	public function set_x(value:Float):Float
	{
		_x = value;
		bg.x = value;
		text.x = value + indent;
		// setAll("x",_x);
		return value;
	}

	public function get_y():Float
	{
		return bg.y;
	}

	public function set_y(value:Float):Float
	{
		_y = value;
		text.y = _y;
		bg.y = _y;
		return value;
	}

	public function get_alpha():Float
	{
		return _alpha;
	}

	public function set_alpha(value:Float):Float
	{
		_alpha = value;
		text.alpha = _alpha;
		bg.alpha = _alpha;
		return value;
		// setAll("alpha", _alpha);
		// return value;
	}

	public function get_velocityX():Float
	{
		return _velocityX;
	}

	public function set_velocityX(value:Float):Float
	{
		_velocityX = value;
		text.velocity.x = value;
		bg.velocity.x = value;
		return value;
	}

	public function setText(S:String):Void
	{
		remove(text);
		remove(bg);

		text = new FlxText(this.x + indent, this.y, Std.int(this.width - indent * 2), S, this.size);
		text.alignment = align;
		text.color = color;
		text.moves = true;

		bg = new FlxSprite(this.x, this.y);
		bg.makeGraphic(Std.int(width), Std.int(text.height), bgColor);
		width = bg.width;
		height = bg.height;

		if (tweens)
		{
			text.scrollFactor.x = text.scrollFactor.y = 0;
			bg.scrollFactor.x = bg.scrollFactor.y = 0;
		}

		add(bg);
		add(text);

		visible = true;

		bg.alpha = theAlpha;
		text.alpha = 1;
	}
}
