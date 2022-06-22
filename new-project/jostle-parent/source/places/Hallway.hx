package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Hallway extends Place
{
	public var toBedroom:Door;
	public var toKidsBedroom:Door;
	public var toBathroom:Door;
	public var toLivingRoom:Door;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(1.5 * FlxG.width);
		ORIGIN_Y = Std.int(1.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 1 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 23 * 8;
		WIDTH = 78 * 8;
		HEIGHT = 15 * 8;

		location = HALLWAY;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.hallway_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var topLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y, 17 * 8, 8, AssetPaths.hallway_wall_tile__png);
		var topMiddleWall:Wall = new Wall(Std.int(topLeftWall.x + topLeftWall.width) + Door.STANDARD_DOOR_WIDTH, Std.int(topLeftWall.y), 29 * 8, 8,
			AssetPaths.hallway_wall_tile__png);
		var topRightWall:Wall = new Wall(Std.int(topMiddleWall.x + topMiddleWall.width) + Door.STANDARD_DOOR_WIDTH, Std.int(topMiddleWall.y), 8 * 8, 8,
			AssetPaths.hallway_wall_tile__png);
		var leftWall:Wall = new Wall(Std.int(topLeftWall.x), Std.int(topLeftWall.y) + 8, 8, 13 * 8, AssetPaths.hallway_wall_tile__png);
		var bottomLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, 17 * 8, 8, AssetPaths.hallway_wall_tile__png);
		var bottomMiddleWall:Wall = new Wall(Std.int(topLeftWall.x + topLeftWall.width) + Door.STANDARD_DOOR_WIDTH, Std.int(topLeftWall.y + HEIGHT - 8),
			29 * 8, 8, AssetPaths.hallway_wall_tile__png);
		var bottomRightWall:Wall = new Wall(Std.int(topMiddleWall.x + topMiddleWall.width) + Door.STANDARD_DOOR_WIDTH, Std.int(topMiddleWall.y + HEIGHT - 8),
			8 * 8, 8, AssetPaths.hallway_wall_tile__png);
		var rightWall:Wall = new Wall(Std.int(topRightWall.x + topRightWall.width - 8), Std.int(topRightWall.y) + 8, 8, 13 * 8,
			AssetPaths.hallway_wall_tile__png);

		var floor:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y, AssetPaths.hallway_floor_tile__png);
		floor.origin.x = floor.origin.y = 0;
		floor.scale.x = WIDTH;
		floor.scale.y = HEIGHT;

		toBedroom = new Door(bottomLeftWall.x + bottomLeftWall.width, bottomLeftWall.y + 2 * 8, this, new FlxPoint(-1, bottomLeftWall.y - 2 * 8),
			"Hallway.toBedroom", DOWN);
		doors.push(toBedroom);

		toKidsBedroom = new Door(topLeftWall.x + topLeftWall.width, topLeftWall.y - 2 * 8, this, new FlxPoint(-1, topLeftWall.y + 2 * 8),
			"Hallway.toKidsBedroom", UP);
		doors.push(toKidsBedroom);

		toBathroom = new Door(topMiddleWall.x + topMiddleWall.width, topMiddleWall.y - 2 * 8, this, new FlxPoint(-1, topMiddleWall.y + 2 * 8),
			"Hallway.toBathroom", UP);
		doors.push(toBathroom);

		toLivingRoom = new Door(bottomMiddleWall.x + bottomMiddleWall.width, bottomMiddleWall.y + 2 * 8, this, new FlxPoint(-1, bottomMiddleWall.y - 2 * 8),
			"Hallway.toLivingRoom", DOWN);
		doors.push(toLivingRoom);

		bg.add(bgTile);
		bg.add(floor);

		display.add(topLeftWall);
		display.add(topMiddleWall);
		display.add(topRightWall);
		display.add(leftWall);
		display.add(bottomLeftWall);
		display.add(bottomMiddleWall);
		display.add(bottomRightWall);
		display.add(rightWall);

		bg.add(toBedroom);
		bg.add(toKidsBedroom);
		bg.add(toBathroom);
		bg.add(toLivingRoom);

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}

	override public function destroy():Void
	{
		super.destroy();

		toBedroom.destroy();
		toKidsBedroom.destroy();
		toBathroom.destroy();
		toLivingRoom.destroy();
	}
}
