package;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxPoint;

class Bathroom extends Place
{
	public var toHallway:Door;

	public function new(bg:FlxGroup,display:FlxTypedGroup<Sortable>,Doors:FlxGroup,DoorMovables:FlxGroup):Void
	{		
		ORIGIN_X = 3 * FlxG.width;
		ORIGIN_Y = 0 * FlxG.height;

		OFFSET_X = Std.int(ORIGIN_X) + 26 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 14 * 8;
		WIDTH = 27 * 8;
		HEIGHT = 34 * 8;

		location = BATHROOM;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X,ORIGIN_Y,AssetPaths.bathroom_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var topWall:Wall = new Wall(OFFSET_X,OFFSET_Y,WIDTH,8,AssetPaths.bathroom_wall_tile__png);
		var bottomLeftWall:Wall = new Wall(OFFSET_X,OFFSET_Y + HEIGHT - 8,7*8,8,AssetPaths.bathroom_wall_tile__png);
		var bottomRightWall:Wall = new Wall(OFFSET_X + WIDTH - 8*8,OFFSET_Y + HEIGHT - 8,8*8,8,AssetPaths.bathroom_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X,OFFSET_Y + 8,8,HEIGHT - 2*8,AssetPaths.bathroom_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8,OFFSET_Y + 8,8,HEIGHT - 2*8,AssetPaths.bathroom_wall_tile__png);

		toHallway = new Door(bottomLeftWall.x + bottomLeftWall.width,bottomLeftWall.y + 2*8,this,new FlxPoint(-1,bottomLeftWall.y - 2*8),"Bathroom.toHallway",DOWN);
		doors.push(toHallway);


		var floor:FlxSprite = new FlxSprite(OFFSET_X,OFFSET_Y,AssetPaths.bathroom_floor_tile__png);
		floor.origin.x = floor.origin.y = 0;
		floor.scale.x = WIDTH;
		floor.scale.y = HEIGHT;

		var mirror:PhysicsSprite = new PhysicsSprite(OFFSET_X + 3*8,OFFSET_Y + 3*8,AssetPaths.bathroom_mirror__png,1,0.25,10,true);
		var bath:PhysicsSprite = new PhysicsSprite(OFFSET_X + 13*8,OFFSET_Y + 2*8,AssetPaths.bathroom_bath__png,1,0.25,10,false);
		var sink:PhysicsSprite = new PhysicsSprite(OFFSET_X + 1*8,OFFSET_Y + 24*8,AssetPaths.bathroom_sink__png,1,0.2,5,false);
		var toilet:PhysicsSprite = new PhysicsSprite(OFFSET_X + 19*8,OFFSET_Y + 25*8,AssetPaths.bathroom_toilet__png,1,0.25,10,false);

		bg.add(bgTile);
		bg.add(floor);

		display.add(bottomLeftWall);
		display.add(bottomRightWall);
		display.add(leftWall);
		display.add(rightWall);
		display.add(topWall);

		display.add(mirror);
		display.add(bath);
		display.add(sink);
		display.add(toilet);

		bg.add(toHallway);


		for (i in 0...doors.length) Doors.add(doors[i]);
	}


	override public function destroy():Void
	{
		super.destroy();
		
		toHallway.destroy();
	}
}