package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class Bedroom extends Place
{
	private var dresser:PhysicsSprite;

	public var bed:BedChair;

	private var bedTrigger:FlxSprite;

	private var shower_water:Sortable;
	private var showerTrigger:FlxSprite;
	private var showerTimer:FlxTimer;

	private var showeringFrames:Int = 0;

	private static var SHOWER_MIN_FRAMES:Int = 120;

	private var showerSound:FlxSound;

	public var toHallway:Door;

	private static var JUMP_TIME_MIN:Float = 5;
	private static var JUMP_TIME_RANGE:Float = 20;
	private static var JUMP_DELAY_MIN:Float = 5;
	private static var JUMP_DELAY_RANGE:Float = 20;

	private var jumper:Child;

	private var parent:Parent;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup, TheParent:Parent):Void
	{
		ORIGIN_X = Std.int(1.5 * FlxG.width);
		ORIGIN_Y = Std.int(3 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 15 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 15 * 8;

		WIDTH = 51 * 8;
		HEIGHT = 34 * 8;

		location = BEDROOM;

		parent = TheParent;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.bedroom_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var topLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y, 17 * 8, 8, AssetPaths.bedroom_wall_tile__png);
		var topRightWall:Wall = new Wall(OFFSET_X + WIDTH - 22 * 8, OFFSET_Y, 22 * 8, 8, AssetPaths.bedroom_wall_tile__png);
		var bottomWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, WIDTH, 8, AssetPaths.bedroom_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.bedroom_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.bedroom_wall_tile__png);

		var floor:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y, AssetPaths.bedroom_floor_tile__png);
		floor.origin.x = floor.origin.y = 0;
		floor.scale.x = WIDTH;
		floor.scale.y = HEIGHT;

		// toHallway = new Door(topLeftWall.x + topLeftWall.width,topLeftWall.y + Door.UPPER_DOOR_PLACEMENT_MARGIN,ORIGIN_X,ORIGIN_Y,"bedroom2Hallway");
		// toHallway.setArrival(toHallway.x + toHallway.width/2,toHallway.y + Door.UPPER_DOOR_ARRIVAL_MARGIN);

		var bed_x:Int = OFFSET_X + 2 * 8;
		var bed_y:Int = OFFSET_Y + 19 * 8;

		if (FlxG.save.data.bedroom_dresser != null)
		{
			dresser = new PhysicsSprite(FlxG.save.data.bedroom_dresser.x, FlxG.save.data.bedroom_dresser.y, AssetPaths.bedroom_dresser__png, 1, 0.25, 40,
				true, false);

			bed_x = FlxG.save.data.bedroom_bed.x;
			bed_y = FlxG.save.data.bedroom_bed.y;
		}
		else
		{
			dresser = new PhysicsSprite(OFFSET_X + 2 * 8, OFFSET_Y + 2 * 8, AssetPaths.bedroom_dresser__png, 1, 0.25, 40, true, false);
		}

		bed = new BedChair(bed_x, bed_y, AssetPaths.bedroom_bed__png, 1, 0.25, 40, true, false, false, 1, 1, true, 15, 13, "", 8, false, Physics.SOLID,
			Physics.SOLID | Physics.PARENT, this, BED, PlayState.parent.parentColor, PlayState.parent.parentColor, PlayState.child1.childColor,
			PlayState.child2.childColor, PlayState.child3.childColor);
		bed.setupAnimation([0, 0], [1, 1], [2, 3], [4, 5], [6, 7], PlayState.parent.parentColor, PlayState.child1.childColor, PlayState.child2.childColor,
			PlayState.child3.childColor);
		bed.replaceColor(0xFF000000, PlayState.parent.parentColor);
		bed.replaceColor(0xFFFF0000, PlayState.child1.childColor);
		bed.replaceColor(0xFF00FFFF, PlayState.child2.childColor);
		bed.replaceColor(0xFF0000FF, PlayState.child3.childColor);

		bed.kind = BED;

		bed.animation.play("occupied");

		var toilet:PhysicsSprite = new PhysicsSprite(OFFSET_X + WIDTH - 8 * 8, OFFSET_Y + HEIGHT - 9 * 8, AssetPaths.bedroom_toilet__png, 1, 0.25, 10, false,
			false);
		var ensuite_left:PhysicsSprite = new PhysicsSprite(topRightWall.x, OFFSET_Y + 2 * 8, AssetPaths.bedroom_ensuite_left__png, 1, 1, 10, false, false);
		var shower:PhysicsSprite = new PhysicsSprite(ensuite_left.x + ensuite_left.width, OFFSET_Y + 2 * 8, AssetPaths.bedroom_shower__png, 1, 1, 10, false,
			false);
		showerTrigger = new FlxSprite(shower.x, shower.y + shower.height);
		showerTrigger.makeGraphic(Math.floor(shower.width), 2 * 8, 0xFFFF0000);
		showerTrigger.visible = false;

		var ensuite_right:PhysicsSprite = new PhysicsSprite(shower.x + shower.width, OFFSET_Y + 2 * 8, AssetPaths.bedroom_ensuite_right__png, 1, 1, 10, false,
			false);

		shower_water = new Sortable(0, 0);
		shower_water.loadGraphic(AssetPaths.bedroom_shower_water_anim__png, true, 7, 13);
		shower_water.origin.x = shower_water.origin.y = 0;
		shower_water.scale.x = shower_water.scale.y = 8;
		shower_water.width *= 8;
		shower_water.height *= 8;
		shower_water.x = shower.x + 1 * 8;
		shower_water.y = shower.y + 7 * 8;
		shower_water.animation.add("spray", [1, 2], 15, true);
		shower_water.animation.add("idle", [0], 0, false);
		shower_water.animation.play("spray");

		// if (FlxG.save.data.shower_running != null) shower_water.visible = FlxG.save.data.shower_running;
		shower_water.visible = false;

		shower.dispatcher.addEventListener("HARD", handleShowerJostle);

		showerSound = new FlxSound();
		showerSound.loadEmbedded(AssetPaths.shower__mp3, true, false);

		bedTrigger = new FlxSprite(bed.hit.x + bed.hit.width / 2 - 1 * 8, bed.hit.y - 1 * 8);
		bedTrigger.makeGraphic(2 * 8, Std.int(bed.hit.height + 2 * 8), 0xFFFF0000);
		bedTrigger.visible = false;
		bed.addTrigger(bedTrigger);

		toHallway = new Door(topLeftWall.x + topLeftWall.width, topLeftWall.y - 2 * 8, this, new FlxPoint(-1, topLeftWall.y + 3 * 8), "Bedroom.toHallway", UP);

		doors.push(toHallway);

		bg.add(bgTile);
		bg.add(floor);

		bg.add(topLeftWall);
		bg.add(topRightWall);
		bg.add(leftWall);
		bg.add(rightWall);
		bg.add(bottomWall);

		display.add(dresser);
		display.add(bed);
		display.add(toilet);
		display.add(ensuite_left);
		display.add(shower);
		display.add(shower_water);
		display.add(ensuite_right);

		bg.add(showerTrigger);
		bg.add(bedTrigger);

		bg.add(toHallway);

		showerTimer = new FlxTimer().start();
		showerTimer.start(0.5);

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}

	override public function destroy():Void
	{
		super.destroy();

		dresser.destroy();
		bed.destroy();
		bedTrigger.destroy();
		shower_water.destroy();
		showerTrigger.destroy();
		showerTimer.destroy();
		showerSound.destroy();
		toHallway.destroy();
	}

	override public function update():Void
	{
		// bedTrigger.x = bed.hit.x + bed.hit.width/2 - 1*8;
		// bedTrigger.y = bed.hit.y - 1*8;

		if (parent.place == this && showerIsRunning())
			showerSound.play();
		else
			showerSound.stop();

		if (PlayState.task != PUT_KIDS_TO_BED)
		{
			bed.checkUser(PlayState.child1);
			bed.checkUser(PlayState.child2);
			bed.checkUser(PlayState.child3);
		}

		if (PlayState.parent.place == this && PlayState.task == GO_TO_BED)
		{
			if (checkGoToBed(PlayState.parent))
			{
				PlayState.parent.setInBed(true);
				PlayState.parent.hide();
			}
		}
	}

	public function checkGoToBed(p:Parent):Bool
	{
		if (p.hit.overlaps(bedTrigger))
		{
			bed.animation.play("occupied");
			return true;
		}

		return false;
	}

	public function emptyBed():Void
	{
		bed.animation.play("empty");
	}

	private function handleShowerJostle(e:JostleEvent):Void
	{
		if (!showerTimer.finished)
			return;

		if (shower_water.visible == false)
		{
			shower_water.visible = true;

			showerTimer.start(2);
			showerSound.play();
		}
		else
		{
			shower_water.visible = false;

			showerTimer.start(2);
			showerSound.stop();
		}
	}

	public function showerIsRunning():Bool
	{
		return shower_water.visible;
	}

	public function hasFinishedShowering(S:PhysicsSprite):Bool
	{
		if (showeringFrames > SHOWER_MIN_FRAMES)
		{
			return true;
		}

		if (S.hit.overlaps(showerTrigger) && shower_water.visible)
		{
			showeringFrames++;
		}

		return false;
	}

	override public function save():Void
	{
		FlxG.save.data.bedroom_dresser = new FlxPoint(dresser.x, dresser.y);
		FlxG.save.data.bedroom_bed = new FlxPoint(bed.x, bed.y);
		FlxG.save.data.shower_running = shower_water.visible;
	}
}
