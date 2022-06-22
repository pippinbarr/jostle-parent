package;

import box2D.common.math.B2Vec2;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class BedChair extends PhysicsSprite
{
	private static var USE_TIME_MIN:Float = 3;
	private static var USE_TIME_RANGE:Float = 5;
	private static var USE_DELAY_MIN:Float = 5;
	private static var USE_DELAY_RANGE:Float = 15;

	private var user:Child = null;
	private var useTimer:FlxTimer;
	private var trigger:FlxSprite;

	// private var place:Place;

	public function new(X:Float = 0, Y:Float = 0, Sprite:String, HitXRatio:Float, HitYRatio:Float, Mass:Float, IsDynamic:Bool = false, HasSensor:Bool = false,
			Ignore:Bool = false, Friction:Float = 1, Restitution:Float = 2, Animated:Bool = false, W:Int = 0, H:Int = 0, T:String = "", Scale:Float = -1,
			CenterHitBox:Bool = false, CategoryBits:Int = -1, MaskBits:Int = -1, ThePlace:Place = null, TheKind:Enums.Kind = null,
			black:FlxColor = FlxColor.GREEN, white:FlxColor = FlxColor.GREEN, red:FlxColor = FlxColor.GREEN, cyan:FlxColor = FlxColor.GREEN,
			blue:FlxColor = FlxColor.GREEN)
	{
		super(X, Y, Sprite, HitXRatio, HitYRatio, Mass, IsDynamic, HasSensor, Ignore, Friction, Restitution, Animated, W, H, T, Scale, CenterHitBox,
			CategoryBits, MaskBits, black, white, red, cyan, blue);

		place = ThePlace;
		kind = TheKind;

		useTimer = new FlxTimer().start();
		useTimer.start(1);

		dispatcher.addEventListener("MEDIUM", handleJostle);
	}

	public function setupAnimation(EmptyFrames:Array<Int>, OccupiedFrames:Array<Int>, Child1Frames:Array<Int>, Child2Frames:Array<Int>,
			Child3Frames:Array<Int>, BlackColour:Int = -1, RedColour:Int = -1, CyanColour:Int = -1, BlueColour:Int = -1):Void
	{
		animation.add("empty", EmptyFrames, 1, false);
		animation.add("occupied", OccupiedFrames, 1, false);
		animation.add("1", Child1Frames, 5, true);
		animation.add("2", Child2Frames, 5, true);
		animation.add("3", Child3Frames, 5, true);
	}

	override public function destroy():Void
	{
		super.destroy();

		useTimer.destroy();
		trigger.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		trigger.x = hit.x + hit.width / 2 - trigger.width / 2;
		trigger.y = hit.y + hit.height / 2 - trigger.height / 2;
	}

	override private function handleImpact(Impact:Int, OtherSprite:PhysicsSprite):Void
	{
		super.handleImpact(Impact, OtherSprite);
	}

	public function addTrigger(t:FlxSprite):Void
	{
		trigger = t;
	}

	public function checkUser(c:Child):Void
	{
		if (c.statusText.text.text == c.name)
			return;
		if (c.active && c.hit.overlaps(trigger) && animation.frameIndex == 0 && user == null && useTimer.finished)
		{
			user = c;
			c.hide(false);
			animation.play(Std.string(c.number));
			useTimer.start(USE_TIME_MIN + Math.random() * USE_TIME_RANGE, useTimerFinished);
		}
	}

	private function useTimerFinished(t:FlxTimer):Void
	{
		user.unhide();
		dismount(user);
		user = null;
		animation.play("empty");
		useTimer.start(USE_DELAY_MIN + Math.random() * USE_DELAY_RANGE);
	}

	private function handleJostle(e:JostleEvent):Void
	{
		if (user == null)
			return;
		if (!useTimer.finished && useTimer.elapsedTime < 2)
			return;

		useTimer.cancel();
		user.unhide();
		dismount(user);
		user = null;
		animation.play("empty");
		useTimer.start(USE_DELAY_MIN + Math.random() * USE_DELAY_RANGE);
	}

	private function dismount(c:Child):Void
	{
		if (hit.y + hit.height / 2 < place.ORIGIN_Y + FlxG.height / 2)
		{
			c.moveTo(hit.x + hit.width / 2 - hit.width / 2, hit.y + hit.height - c.height + c.hit.height, this.place);
		}
		else
		{
			c.moveTo(hit.x + hit.width / 2 - c.hit.width / 2, hit.y - c.height, this.place);
		}

		c.setTarget(c.parent);
		c.setMovementMode(WANDER_FOLLOW);
	}

	override public function beginContact(Sensor:Int, OtherSensor:Int, TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor, OtherSensor, TheOther);
	}

	override public function endContact(Sensor:Int, OtherSensor:Int, TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor, OtherSensor, TheOther);
	}

	override public function kill():Void
	{
		super.kill();
	}
}
