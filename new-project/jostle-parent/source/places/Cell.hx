package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;

class Cell extends Place
{
	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = 0 * FlxG.width;
		ORIGIN_Y = 3 * FlxG.height;

		OFFSET_X = ORIGIN_X + 25 * 8;
		OFFSET_Y = ORIGIN_Y + 15 * 8;
		WIDTH = 30 * 8;
		HEIGHT = 30 * 8;

		location = CELL;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.cell_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var topWall:Wall = new Wall(OFFSET_X, OFFSET_Y, WIDTH, 8, AssetPaths.cell_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.cell_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.cell_wall_tile__png);
		var bottomWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, WIDTH, 8, AssetPaths.cell_wall_tile__png);

		var floor:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y, AssetPaths.cell_floor_tile__png);
		floor.origin.x = floor.origin.y = 0;
		floor.scale.x = WIDTH;
		floor.scale.y = HEIGHT;

		var door:FlxSprite = new FlxSprite(OFFSET_X + 10 * 8, OFFSET_Y + HEIGHT - 8, AssetPaths.cell_door__png);
		door.origin.x = door.origin.y = 0;
		door.scale.x = door.scale.y = 8;

		var bed:PhysicsSprite = new PhysicsSprite(OFFSET_X + 18 * 8, OFFSET_Y + 3 * 8, AssetPaths.cell_bed__png, 1, 0.25, 1, false);
		var sink:PhysicsSprite = new PhysicsSprite(OFFSET_X + 2 * 8, OFFSET_Y + 3 * 8, AssetPaths.cell_sink__png, 1, 0.25, 1, false);
		var toilet:PhysicsSprite = new PhysicsSprite(OFFSET_X + 2 * 8, OFFSET_Y + 20 * 8, AssetPaths.cell_toilet__png, 1, 0.25, 1, false);
		var desk:PhysicsSprite = new PhysicsSprite(OFFSET_X + 18 * 8, OFFSET_Y + 20 * 8, AssetPaths.cell_desk_and_chair__png, 1, 0.25, 1, false);

		bg.add(bgTile);
		bg.add(floor);
		bg.add(topWall);
		bg.add(leftWall);
		bg.add(rightWall);
		bg.add(bottomWall);
		bg.add(door);

		display.add(bed);
		display.add(sink);
		display.add(toilet);
		display.add(desk);

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}
}
