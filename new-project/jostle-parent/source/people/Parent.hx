package;

import box2D.dynamics.B2ContactImpulse;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Parent extends Person
{
	private var NORMAL_SPEED:Float = 2; // 5;

	// private var SPRINT_SPEED:Float = 12;
	private var HUG_TIME_MIN:Float = 2;
	private var HUG_TIME_RANGE:Float = 2;
	private var HUG_DELAY_MIN:Float = 20;
	private var HUG_DELAY_RANGE:Float = 120;

	private var playingBall:Bool = true;
	private var playingBallTouches:Int = 0;

	private var dead:Bool = false;
	private var didJustDie:Bool = false;
	private var inBed:Bool = false;
	private var drowning:Bool = false;
	private var dying:Bool = false;

	private var causeOfDeath:String = "";

	private var drowningTimer:FlxTimer;

	public var child1:Child;
	public var child2:Child;
	public var child3:Child;

	public var hugger:Child = null;

	private var hugTimer:FlxTimer;

	public var parentColor:Int = 0xFF000000;

	public function new(X:Float, Y:Float, C1:Child, C2:Child, C3:Child, C:Int)
	{
		super(X, Y, AssetPaths.parent_frames__png, 1, 0.25, 7, 10, 1, Physics.PARENT, (Physics.SOLID | Physics.PARENT | Physics.PARENT_LOCK));
		// super(X,Y,AssetPaths.parent_frames__png,1,0.25,7,0,1,Physics.PARENT,(Physics.SOLID | Physics.PARENT | Physics.PARENT_LOCK));

		kind = PARENT;

		parentColor = C;
		loadGraphic(AssetPaths.parent_frames__png, true, 7, 10, true);

		origin.x = origin.y = 0;
		this.scale.x = 8;
		this.scale.y = 8;
		this.width *= this.scale.x;
		this.height *= this.scale.y;

		child1 = C1;
		child2 = C2;
		child3 = C3;

		animation.add("normal", [0, 0], 1, false);
		animation.add("drowning", [0, 1], 5, true);
		animation.add("dead", [2, 2], 1, false);
		animation.add("child1hug", [3, 3], 1, false);
		animation.add("child2hug", [4, 4], 1, false);
		animation.add("child3hug", [5, 5], 1, false);
		animation.play("normal");

		drowningTimer = new FlxTimer().start();

		hugger = null;
		hugTimer = new FlxTimer().start();
		hugTimer.finished = true;

		MOVEMENT_IMPULSE = NORMAL_SPEED;

		active = true;
	}

	override public function destroy():Void
	{
		super.destroy();

		hugTimer.destroy();
		drowningTimer.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (didJustDie)
			return;

		handleHugs();
		handleInput();
	}

	public function startDrowning():Void
	{
		// animation.play("drowning");
		drowningTimer.start(10, drowningTimerFinished);
		drowning = true;
		dying = true;
	}

	public function stopDrowning():Void
	{
		// animation.play("normal");
		drowningTimer.cancel();
		drowning = false;
		dying = false;
	}

	public function isDying():Bool
	{
		return dying;
	}

	private function drowningTimerFinished(t:FlxTimer):Void
	{
		// drowning = false;
		die(Global.strings.Parent.drowned);
	}

	public function isDrowning():Bool
	{
		return drowning;
	}

	public function die(Cause:String):Void
	{
		causeOfDeath = Cause;
		body.setActive(false);
		idle();
		animation.play("dead");
		dead = true;
		didJustDie = true;
		dying = false;
	}

	public function isDead():Bool
	{
		return dead;
	}

	public function justDied():Bool
	{
		var val:Bool = didJustDie;
		// didJustDie = false;
		return val;
	}

	public function setDead():Void
	{
		dead = true;
		alpha = 0.5;

		// body.getFixtureList().get(0).setSensor(true);
		var f:box2D.dynamics.B2Fixture;
		f = body.getFixtureList();
		while (f != null)
		{
			f.setSensor(true);
			f = f.m_next;
		}
	}

	public function setInBed(val:Bool):Void
	{
		if (!alive || !active)
			return;

		inBed = val;
	}

	public function isInBed():Bool
	{
		return (!alive || inBed);
	}

	public function handleInput():Void
	{
		if (FlxG.keys.pressed.ALT || FlxG.keys.pressed.CONTROL || FlxG.keys.pressed.SHIFT)
			FlxG.keys.reset();

		if (hugger != null && hugTimer.elapsedTime < 1)
			return;
		if (hugger != null && FlxG.keys.pressed.ANY)
			hugTimerFinished(null);

		if (FlxG.keys.pressed.LEFT)
		{
			moveLeft();
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			moveRight();
		}
		else
		{
			idleX();
		}

		if (FlxG.keys.pressed.UP)
		{
			moveUp();
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			moveDown();
		}
		else
		{
			idleY();
		}

		if (FlxG.keys.pressed.LEFT)
		{
			moveLeft();
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			moveRight();
		}
		else
		{
			idleX();
		}

		if (FlxG.keys.pressed.UP)
		{
			moveUp();
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			moveDown();
		}
		else
		{
			idleY();
		}
	}

	override public function postSolve(OtherSprite:PhysicsSprite, Impulse:B2ContactImpulse):Void
	{
		// trace(Impulse.normalImpulses[0]);

		super.postSolve(OtherSprite, Impulse);
	}

	override private function handleImpact(Impact:Int, OtherSprite:PhysicsSprite):Void
	{
		super.handleImpact(Impact, OtherSprite);

		switch (OtherSprite.kind)
		{
			case BALL:
				if (playingBall)
					playingBallTouches++;

			case CHILD:
				if (playingBall)
					playingBallTouches++;
				if (hugger == null && hugTimer.finished)
				{
					if (place.location == BEACH)
						return; // No hugging at the beach (too weird in the water)
					if (Math.abs(x - OtherSprite.x) < 8 && y < OtherSprite.y)
						hug(cast(OtherSprite, Child));
				}

			case CAR:
				if (Impact == Physics.DEADLY)
				{
					if (hugger != null)
					{
						hugTimer.cancel();
						hugger.unhide();
						hugger.die(Global.strings.Parent.hugger_hit_by_car);
						hugger = null;
					}
					die(Global.strings.Parent.hit_by_car);
				}

			case PARENT, FURNITURE, WALL, LOCK, UNKNOWN, FOOD, TOY, ELECTRICITY, POISON, BED:
		}
	}

	private function hug(c:Child):Void
	{
		// If anyone is dying then we don't start
		if (child1.dying || child2.dying || child3.dying || c.showingName())
		{
			hugTimer.start(HUG_DELAY_MIN + Math.random() * HUG_DELAY_RANGE);
			return;
		}

		hugger = c;
		c.hide(false);
		animation.play("child" + Std.string(c.number) + "hug");
		hugTimer.start(HUG_TIME_MIN + Math.random() * HUG_TIME_RANGE, hugTimerFinished);
	}

	private function hugTimerFinished(t:FlxTimer):Void
	{
		hugger.unhide();
		hugger = null;
		animation.play("normal");

		hugTimer.start(HUG_DELAY_MIN + Math.random() * HUG_DELAY_RANGE); // Start it againt to delay any future hugs
	}

	private function handleHugs():Void
	{
		if (hugger == null)
			return;

		if (child1.dying || child2.dying || child3.dying)
		{
			hugger.unhide();
			if (!dead)
				animation.play("normal");
		}
	}

	public function getCauseOfDeath():String
	{
		return causeOfDeath;
	}

	public function startPlayingBall():Void
	{
		playingBall = true;
		playingBallTouches = 0;
	}

	public function stopPlayingBall():Void
	{
		playingBall = false;
	}

	public function getPlayingBallTotal():Int
	{
		return playingBallTouches;
	}
}
