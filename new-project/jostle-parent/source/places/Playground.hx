package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Playground extends Place
{
	public var toPark:Door;
	public var lock:Lock;

	private var swing:PhysicsSprite;
	private var swingTrigger:FlxSprite;
	private var swinger:Child;
	private var swingZone:FlxSprite;

	private var seesaw:PhysicsSprite;
	private var seesawLeftTrigger:FlxSprite;
	private var seesawRightTrigger:FlxSprite;
	private var leftSeesawer:Child;
	private var rightSeesawer:Child;
	private var seesawZone:FlxSprite;

	private var springRider:PhysicsSprite;
	private var springRiderTrigger:FlxSprite;
	private var springRiderer:Child;
	private var springRiderZone:FlxSprite;

	private var slide:PhysicsSprite;
	private var slideTrigger:FlxSprite;
	private var slider:Child;
	private var slideZone:FlxSprite;

	private static var MIN_WATCH_TIME:Int = 4;

	private var latestMountedEquipment:PhysicsSprite;
	private var currentWatchedEquipment:PhysicsSprite = null;
	private var currentWatchedFrames:Int = 0;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(0 * FlxG.width);
		ORIGIN_Y = Std.int(1.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 2 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 2 * 8;

		WIDTH = 76 * 8;
		HEIGHT = 56 * 8;

		location = PLAYGROUND;

		super();

		var bgTile:FlxSprite = new FlxSprite(Std.int(ORIGIN_X), Std.int(ORIGIN_Y), AssetPaths.playground_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var floorTile:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y, AssetPaths.playground_floor_tile__png);
		floorTile.origin.x = floorTile.origin.y = 0;
		floorTile.scale.x = WIDTH;
		floorTile.scale.y = HEIGHT;

		var topWall:Wall = new Wall(OFFSET_X, OFFSET_Y, WIDTH, 8, AssetPaths.playground_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.playground_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.playground_wall_tile__png);
		var bottomLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, Std.int((WIDTH - DOOR_WIDTH) / 2), 8, AssetPaths.playground_wall_tile__png);
		var bottomRightWall:Wall = new Wall(Std.int(bottomLeftWall.x + bottomLeftWall.width + DOOR_WIDTH), OFFSET_Y + HEIGHT - 8,
			Std.int((WIDTH - DOOR_WIDTH) / 2), 8, AssetPaths.playground_wall_tile__png);

		toPark = new Door(bottomLeftWall.x + bottomLeftWall.width, bottomLeftWall.y + 2 * 8, this, new FlxPoint(-1, -1), "Playground.toPark", DOWN, true);
		doors.push(toPark);

		lock = new Lock(toPark.x, toPark.y, toPark.width, toPark.height, true);
		lock.lock();
		lock.visible = false;

		// SWINGS

		// swing = new PhysicsSprite(OFFSET_X + 8*8,OFFSET_Y + 6*8,AssetPaths.playground_swing__png,0.65,0.2,1,false,false,false,1,1,true,17,16,"",8,true);
		swing = new PhysicsSprite(OFFSET_X + 50 * 8, OFFSET_Y + 6 * 8, AssetPaths.playground_swing__png, 0.65, 0.2, 1, false, false, false, 1, 1, true, 17,
			16, "", 8, true);
		swing.animation.add("empty", [0, 0], 1, false);
		swing.animation.add("occupied", [6, 6], 1, false);
		swing.animation.add("swinging", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10, true);

		swing.animation.play("empty");

		swingTrigger = new FlxSprite(swing.hit.x + swing.hit.width / 3, swing.hit.y - swing.hit.height);
		swingTrigger.makeGraphic(Std.int(swing.hit.width / 3), Std.int(swing.hit.height * 3), 0xFFFF0000);
		swingTrigger.visible = false;

		swingZone = new FlxSprite(swing.hit.x - 4 * 8, swing.hit.y - 4 * 8);
		swingZone.makeGraphic(Std.int(swing.hit.width + 8 * 8), Std.int(swing.hit.height + 8 * 8), 0xFFFF0000);
		swingZone.visible = false;

		// SLIDE

		// slide = new PhysicsSprite(OFFSET_X + 37*8,OFFSET_Y + 5*8,AssetPaths.playground_slide__png,1,0.2,1,false,false,false,1,1,true,28,17);
		slide = new PhysicsSprite(OFFSET_X + 8 * 8, OFFSET_Y + 5 * 8, AssetPaths.playground_slide__png, 1, 0.2, 1, false, false, false, 1, 1, true, 28, 17);
		slide.animation.add("empty", [0, 0], 1, false);
		slide.animation.add("sliding", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11], 10, false);

		slide.animation.play("empty");

		slideTrigger = new FlxSprite(slide.hit.x, slide.hit.y - slide.hit.height);
		slideTrigger.makeGraphic(Std.int(5 * 8), Std.int(slide.hit.height * 3), 0xFFFF0000);
		slideTrigger.visible = false;

		slideZone = new FlxSprite(slide.hit.x, slide.hit.y - 4 * 8);
		slideZone.makeGraphic(Std.int(5 * 8), Std.int(slide.hit.height + 8 * 8), 0xFFFF0000);
		slideZone.visible = false;

		// SEESAW

		seesaw = new PhysicsSprite(OFFSET_X + 46 * 8, OFFSET_Y + 32 * 8, AssetPaths.playground_seesaw__png, 1, 0.2, 1, false, false, false, 1, 1, true, 19,
			13);
		seesaw.animation.add("empty", [0, 0], 1, false);
		seesaw.animation.add("left occupied", [4, 4], 1, false);
		seesaw.animation.add("right occupied", [5, 5], 1, false);
		seesaw.animation.add("seesawing", [2, 1, 3, 1], 10, true);

		seesaw.animation.play("empty");

		seesawLeftTrigger = new FlxSprite(seesaw.hit.x, seesaw.hit.y - seesaw.hit.height);
		seesawLeftTrigger.makeGraphic(Std.int(seesaw.hit.width / 4), Std.int(seesaw.hit.height * 3), 0xFFFF0000);
		seesawLeftTrigger.visible = false;

		seesawRightTrigger = new FlxSprite(seesaw.hit.x + seesaw.width - seesaw.hit.width / 4, seesaw.hit.y - seesaw.hit.height);
		seesawRightTrigger.makeGraphic(Std.int(seesaw.hit.width / 4), Std.int(seesaw.hit.height * 3), 0xFFFF0000);
		seesawRightTrigger.visible = false;

		seesawZone = new FlxSprite(seesaw.hit.x - 4 * 8, seesaw.hit.y - 4 * 8);
		seesawZone.makeGraphic(Std.int(seesaw.hit.width + 8 * 8), Std.int(seesaw.hit.height + 8 * 8), 0xFFFF0000);
		seesawZone.visible = false;

		// SPRING RIDER

		springRider = new PhysicsSprite(OFFSET_X + 12 * 8, OFFSET_Y + 32 * 8, AssetPaths.playground_spring_rider__png, 0.6, 0.2, 1, false, false, false, 1, 1,
			true, 8, 12, "", 8, true);
		springRider.animation.add("empty", [0, 0], 1, false);
		springRider.animation.add("occupied", [1, 1], 1, false);
		springRider.animation.add("springing", [1, 2, 3, 4], 10, true);

		springRider.animation.play("empty");

		springRiderTrigger = new FlxSprite(springRider.hit.x, springRider.hit.y - springRider.hit.height);
		springRiderTrigger.makeGraphic(Std.int(springRider.hit.width), Std.int(springRider.hit.height * 3), 0xFFFF0000);
		springRiderTrigger.visible = false;

		springRiderZone = new FlxSprite(springRider.hit.x - 4 * 8, springRider.hit.y - 4 * 8);
		springRiderZone.makeGraphic(Std.int(springRider.hit.width + 8 * 8), Std.int(springRider.hit.height + 8 * 8), 0xFFFF0000);
		springRiderZone.visible = false;

		bg.add(bgTile);
		bg.add(floorTile);
		bg.add(topWall);
		bg.add(leftWall);
		bg.add(rightWall);
		bg.add(bottomLeftWall);
		bg.add(bottomRightWall);

		display.add(swing);
		// display.add(swing.hit);
		display.add(seesaw);
		display.add(springRider);
		display.add(slide);

		// bg.add(swingTrigger);
		// bg.add(slideTrigger);
		// bg.add(seesawLeftTrigger);
		// bg.add(seesawRightTrigger);
		// bg.add(springRiderTrigger);
		bg.add(swingZone);
		bg.add(seesawZone);
		bg.add(springRiderZone);
		bg.add(slideZone);

		bg.add(toPark);
		bg.add(lock);

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}

	override public function destroy():Void
	{
		super.destroy();

		toPark.destroy();
		lock.destroy();
		swing.destroy();
		swingTrigger.destroy();
		swingZone.destroy();
		seesaw.destroy();
		seesawLeftTrigger.destroy();
		seesawRightTrigger.destroy();
		seesawZone.destroy();
		springRider.destroy();
		springRiderTrigger.destroy();
		springRiderZone.destroy();
		slide.destroy();
		slideTrigger.destroy();
		slideZone.destroy();
	}

	override public function update():Void
	{
		if (PlayState.parent.place != this)
			return;

		checkEquipment(PlayState.child1, PlayState.parent);
		checkEquipment(PlayState.child2, PlayState.parent);
		checkEquipment(PlayState.child3, PlayState.parent);

		if (PlayState.task != LEAVE_PLAYGROUND)
		{
			if (!contains(PlayState.child1) && PlayState.child1.alive)
				PlayState.child1.die(Global.strings.PlayState.got_lost);
			if (!contains(PlayState.child2) && PlayState.child2.alive)
				PlayState.child2.die(Global.strings.PlayState.got_lost);
			if (!contains(PlayState.child3) && PlayState.child3.alive)
				PlayState.child3.die(Global.strings.PlayState.got_lost);
		}

		if (slider != null)
		{
			if (slide.animation.frameIndex == 4 && !slider.parent.hit.overlaps(slideZone))
			{
				// Slider might fall and die unsupervised
				slider.unhide();
				slider.die("died falling off the slide");
				slide.animation.play("empty");
				slider = null;
			}
			else if (slide.animation.finished)
			{
				slide.animation.play("empty");
				slider.unhide();
				slider.moveTo(slide.x + slide.width, slide.hit.y - slider.height + slider.hit.height, this);
				slider = null;
			}
		}
	}

	public function getNewestTask():String
	{
		if (latestMountedEquipment != null && currentWatchedEquipment == null)
		{
			var task:String = "";
			var name1:String = "";
			var name2:String = "";

			if (latestMountedEquipment == springRider && springRiderer != null)
			{
				currentWatchedEquipment = springRider;
				task = Global.strings.Playground.supervise_spring_rider;
				name1 = springRiderer.name;
			}
			else if (latestMountedEquipment == swing && swinger != null)
			{
				currentWatchedEquipment = swing;
				task = Global.strings.Playground.supervise_swing;
				name1 = swinger.name;
			}
			else if (latestMountedEquipment == seesaw && leftSeesawer != null && rightSeesawer != null)
			{
				currentWatchedEquipment = seesaw;
				task = Global.strings.Playground.supervise_seesaw;
				name1 = leftSeesawer.name;
				name2 = rightSeesawer.name;
			}

			if (name1 != "")
			{
				var regex1 = ~/%(NAME1)%/g;
				task = regex1.replace(task, name1);
			}
			if (name2 != "")
			{
				var regex2 = ~/%(NAME2)%/g;
				task = regex2.replace(task, name2);
			}

			return task;
		}

		// If we're here it's because no one is on equipment
		// or because there's a current task already running and unfinished
		// So the empty string means "nope"
		return "";
	}

	public function checkTaskComplete():Bool
	{
		if (currentWatchedFrames > MIN_WATCH_TIME * FlxG.updateFramerate)
		{
			currentWatchedEquipment = null;
			currentWatchedFrames = 0;
			return true;
		}

		return false;
	}

	public function checkEquipment(c:Child, p:Parent):Void
	{
		checkSlide(c, p);
		checkSwing(c, p);
		checkSpringRider(c, p);
		checkSeesaw(c, p);
	}

	public function checkSlide(c:Child, p:Parent):Void
	{
		if (!c.alive || c.hidden)
			return;

		if (c.hit.overlaps(slideTrigger) && slider == null)
		{
			slider = c;
			c.hide(false);

			slide.loadGraphic(AssetPaths.playground_slide__png, true, 28, 17, true);
			slide.origin.x = 0;
			slide.origin.y = 0;
			slide.scale.x = slide.scale.y = 8;
			slide.width *= slide.scale.x;
			slide.height *= slide.scale.y;
			slide.animation.add("empty", [0, 0], 1, false);
			slide.animation.add("sliding", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11], 10, false);

			slide.replaceColor(0xFF000000, c.childColor);

			slide.animation.play("sliding");
		}
	}

	public function checkSpringRider(c:Child, p:Parent):Void
	{
		if (!c.alive || c.hidden)
			return;

		if (c.hit.overlaps(springRiderTrigger) && springRiderer == null && springRider.active)
		{
			springRiderer = c;
			c.hide(false);

			springRider.loadGraphic(AssetPaths.playground_spring_rider__png, true, 8, 12, true);
			springRider.origin.x = 0;
			springRider.origin.y = 0;
			springRider.animation.add("empty", [0, 0], 1, false);
			springRider.animation.add("occupied", [1, 1], 1, false);
			springRider.animation.add("springing", [1, 2, 3, 4], 10, true);

			var col:Int = 0xFFFF0000;
			springRider.replaceColor(0xFF000000, c.childColor);

			// springRider.updatePosition();

			springRider.animation.play("springing");

			latestMountedEquipment = springRider;

			new FlxTimer().start(2 + Math.random() * 2, dismountSpringRider);
		}

		if (currentWatchedEquipment == springRider && springRiderer == c && p.hit.overlaps(springRiderZone))
		{
			currentWatchedFrames++;
		}

		if (currentWatchedFrames > MIN_WATCH_TIME * FlxG.updateFramerate && currentWatchedEquipment == springRider)
		{
			currentWatchedEquipment = null;

			dismountSpringRider(null);
		}
	}

	public function checkSwing(c:Child, p:Parent):Void
	{
		if (!c.alive || c.hidden)
			return;

		if (c.hit.overlaps(swingTrigger) && swinger == null && swing.active)
		{
			swinger = c;
			c.hide(false);

			swing.loadGraphic(AssetPaths.playground_swing__png, true, 17, 16, true);
			swing.origin.x = 0;
			swing.origin.y = 0;
			// swing.scale.x = swing.scale.y = 8;
			// swing.width *= swing.scale.x;
			// swing.height *= swing.scale.y;
			swing.animation.add("empty", [0, 0], 1, false);
			swing.animation.add("occupied", [6, 6], 1, false);
			swing.animation.add("swinging", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10, true);

			swing.replaceColor(0xFF000000, c.childColor);

			swing.animation.play("swinging");

			latestMountedEquipment = swing;

			new FlxTimer().start(10 + Math.random() * 10, dismountSwing);
		}

		if (currentWatchedEquipment == swing)
		{
			if (swinger == c && p.hit.overlaps(swingZone))
			{
				currentWatchedFrames++;
			}

			if (currentWatchedFrames > MIN_WATCH_TIME * FlxG.updateFramerate)
			{
				currentWatchedEquipment = null;

				dismountSwing(null);
			}
		}
	}

	public function checkSeesaw(c:Child, p:Parent):Void
	{
		if (!c.alive || c.hidden)
			return;

		if (c.hit.overlaps(seesawLeftTrigger) && leftSeesawer == null && seesaw.active)
		{
			leftSeesawer = c;
			leftSeesawer.hide(false);

			seesaw.loadGraphic(AssetPaths.playground_seesaw__png, true, 19, 13, true);
			seesaw.origin.x = 0;
			seesaw.origin.y = 0;
			seesaw.animation.add("empty", [0, 0], 1, false);
			seesaw.animation.add("left occupied", [4, 4], 1, false);
			seesaw.animation.add("right occupied", [5, 5], 1, false);
			seesaw.animation.add("seesawing", [2, 1, 3, 1], 10, true);

			if (leftSeesawer != null)
				seesaw.replaceColor(0xFF000000, leftSeesawer.childColor);
			if (rightSeesawer != null)
				seesaw.replaceColor(0xFFFFFFFF, rightSeesawer.childColor);

			if (rightSeesawer == null)
			{
				seesaw.animation.play("left occupied");
			}
			else
			{
				seesaw.animation.play("seesawing");
			}

			latestMountedEquipment = seesaw;

			new FlxTimer().start(10 + Math.random() * 10, dismountLeftSeesaw);
		}

		if (c.hit.overlaps(seesawRightTrigger) && rightSeesawer == null && seesaw.active)
		{
			rightSeesawer = c;
			c.hide(false);

			seesaw.loadGraphic(AssetPaths.playground_seesaw__png, true, 19, 13, true);
			seesaw.origin.x = 0;
			seesaw.origin.y = 0;
			seesaw.animation.add("empty", [0, 0], 1, false);
			seesaw.animation.add("left occupied", [4, 4], 1, false);
			seesaw.animation.add("right occupied", [5, 5], 1, false);
			seesaw.animation.add("seesawing", [2, 1, 3, 1], 10, true);

			if (leftSeesawer != null)
				seesaw.replaceColor(0xFF000000, leftSeesawer.childColor);
			if (rightSeesawer != null)
				seesaw.replaceColor(0xFFFFFFFF, rightSeesawer.childColor);

			if (leftSeesawer == null)
			{
				seesaw.animation.play("right occupied");
			}
			else
			{
				seesaw.animation.play("seesawing");
			}

			latestMountedEquipment = seesaw;

			new FlxTimer().start(10 + Math.random() * 10, dismountRightSeesaw);
		}

		if (currentWatchedEquipment == seesaw && (leftSeesawer == c || rightSeesawer == c) && p.hit.overlaps(seesawZone))
		{
			currentWatchedFrames++;
		}

		if (currentWatchedFrames > MIN_WATCH_TIME * FlxG.updateFramerate && currentWatchedEquipment == seesaw)
		{
			// trace("Finished watching seesaw");
			currentWatchedEquipment = null;

			dismountLeftSeesaw(null);
			dismountRightSeesaw(null);
		}
	}

	private function dismountLeftSeesaw(t:FlxTimer):Void
	{
		if (currentWatchedEquipment == seesaw || leftSeesawer == null)
			return; // Can't get off if parent is watching (until done)

		leftSeesawer.unhide();
		leftSeesawer = null;

		seesaw.loadGraphic(AssetPaths.playground_seesaw__png, true, 19, 13, true);
		seesaw.origin.x = 0;
		seesaw.origin.y = 0;
		seesaw.animation.add("empty", [0, 0], 1, false);
		seesaw.animation.add("left occupied", [4, 4], 1, false);
		seesaw.animation.add("right occupied", [5, 5], 1, false);
		seesaw.animation.add("seesawing", [2, 1, 3, 1], 10, true);

		if (leftSeesawer != null)
			seesaw.replaceColor(0xFF000000, leftSeesawer.childColor);
		if (rightSeesawer != null)
			seesaw.replaceColor(0xFFFFFFFF, rightSeesawer.childColor);

		if (rightSeesawer != null)
			seesaw.animation.play("right occupied");
		else
			seesaw.animation.play("empty");

		seesaw.active = false;

		new FlxTimer().start(5, activateSeesaw);

		if (latestMountedEquipment == seesaw && rightSeesawer == null)
			latestMountedEquipment = null;
	}

	private function dismountRightSeesaw(t:FlxTimer):Void
	{
		if (currentWatchedEquipment == seesaw || rightSeesawer == null)
			return;

		rightSeesawer.unhide();
		rightSeesawer = null;

		seesaw.loadGraphic(AssetPaths.playground_seesaw__png, true, 19, 13, true);
		seesaw.origin.x = 0;
		seesaw.origin.y = 0;
		seesaw.animation.add("empty", [0, 0], 1, false);
		seesaw.animation.add("left occupied", [4, 4], 1, false);
		seesaw.animation.add("right occupied", [5, 5], 1, false);
		seesaw.animation.add("seesawing", [2, 1, 3, 1], 10, true);

		if (leftSeesawer != null)
			seesaw.replaceColor(0xFF000000, leftSeesawer.childColor);
		if (rightSeesawer != null)
			seesaw.replaceColor(0xFFFFFFFF, rightSeesawer.childColor);

		if (leftSeesawer != null)
			seesaw.animation.play("left occupied");
		else
			seesaw.animation.play("empty");
		seesaw.active = false;

		new FlxTimer().start(5, activateSeesaw);

		if (latestMountedEquipment == seesaw && leftSeesawer == null)
			latestMountedEquipment = null;
	}

	private function activateSeesaw(t:FlxTimer):Void
	{
		seesaw.active = true;
	}

	private function dismountSpringRider(t:FlxTimer):Void
	{
		if (currentWatchedEquipment == springRider || springRiderer == null)
			return;

		springRiderer.unhide();
		springRiderer = null;
		springRider.animation.play("empty");
		springRider.active = false;

		new FlxTimer().start(5, activateSpringRider);

		if (latestMountedEquipment == springRider)
			latestMountedEquipment = null;
	}

	private function activateSpringRider(t:FlxTimer):Void
	{
		springRider.active = true;
	}

	private function dismountSwing(t:FlxTimer):Void
	{
		if (currentWatchedEquipment == swing || swinger == null)
			return;

		swinger.unhide();
		swinger = null;
		swing.animation.play("empty");
		swing.active = false;

		new FlxTimer().start(5, activateSwing);

		if (latestMountedEquipment == swing)
			latestMountedEquipment = null;
	}

	private function activateSwing(t:FlxTimer):Void
	{
		swing.active = true;
	}
}
