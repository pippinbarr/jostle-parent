package;


import flixel.FlxSprite;
import flixel.FlxG;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxPoint;


class BeachMiddle extends Place
{

	public var toFrontOfHouse:Door;

	private var swimZone:FlxSprite;

	public var lock:Lock;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>,Doors:FlxGroup,DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(4 * FlxG.width);
		ORIGIN_Y = Std.int(4.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 0;
		OFFSET_Y = Std.int(ORIGIN_Y) + 0;

		WIDTH = 80 * 8;
		HEIGHT = 60 * 8;

		location = BEACH;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X,ORIGIN_Y,AssetPaths.beach_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;


		var leftFence:PhysicsSprite = new PhysicsSprite(OFFSET_X,OFFSET_Y + HEIGHT - 3*8,AssetPaths.beach_left_fence__png,1,0.2,1,false);
		var rightFence:PhysicsSprite = new PhysicsSprite(OFFSET_X + WIDTH - leftFence.width,OFFSET_Y + HEIGHT - 3*8,AssetPaths.beach_right_fence__png,1,0.2,1,false);

		toFrontOfHouse = new Door(leftFence.x + leftFence.width,leftFence.y + 2*8,this,new FlxPoint(-1,leftFence.y - 2*8),"BeachMiddle.toFrontOfHouse",DOWN,true,rightFence.x - leftFence.x - leftFence.width,1*8);
		doors.push(toFrontOfHouse);
		
		lock = new Lock(toFrontOfHouse.x,toFrontOfHouse.y,toFrontOfHouse.width,toFrontOfHouse.height,true);
		lock.lock();
		lock.visible = false;

		var leftUmbrella:PhysicsSprite = new PhysicsSprite(
			OFFSET_X + 11*8,OFFSET_Y + 33*8,
			AssetPaths.beach_umbrella__png,
			0.1,0.1,1,false,false,false,1,1,false,0,0,"",8,true);
		var leftUmbrellaTowels:FlxSprite = new FlxSprite(leftUmbrella.x - 8,leftUmbrella.y + 8*8,AssetPaths.beach_towels__png);
		leftUmbrellaTowels.origin.x = leftUmbrellaTowels.origin.y = 0;
		leftUmbrellaTowels.scale.x = leftUmbrellaTowels.scale.y = 8;

		var rightUmbrella:PhysicsSprite = new PhysicsSprite(
			OFFSET_X + 50*8,OFFSET_Y + 33*8,
			AssetPaths.beach_umbrella__png,
			0.1,0.1,1,false,false,false,1,1,false,0,0,"",8,true);
		var rightUmbrellaTowels:FlxSprite = new FlxSprite(rightUmbrella.x - 8,rightUmbrella.y + 8*8,AssetPaths.beach_towels__png);
		rightUmbrellaTowels.origin.x = rightUmbrellaTowels.origin.y = 0;
		rightUmbrellaTowels.scale.x = rightUmbrellaTowels.scale.y = 8;

		var waterY:Int = 0;
		for (i in 0...32)
		{
			var water:Sortable = new Sortable(OFFSET_X,OFFSET_Y + waterY,AssetPaths.beach_water_strip__png);
			water.origin.x = water.origin.y = 0;
			water.scale.x = water.scale.y = 8;

			water.sortKey = water.y + ((32 - i) * 2.5) - 10;

			display.add(water);

			waterY += 8;
		}

		swimZone = new FlxSprite(OFFSET_X,OFFSET_Y);
		swimZone.makeGraphic(Std.int(FlxG.width),Std.int(FlxG.height/2 - 8),0xFFFF0000);
		swimZone.visible = false;


		// Make invisible walls around the beach zone so the parent can't run off
		var leftWall:Wall = new Wall(ORIGIN_X - FlxG.width - 8,ORIGIN_Y,8,FlxG.height,AssetPaths.bathroom_floor_tile__png);
		leftWall.visible = false;
		var rightWall:Wall = new Wall(ORIGIN_X + 2*FlxG.width,ORIGIN_Y,8,FlxG.height,AssetPaths.bathroom_floor_tile__png);
		rightWall.visible = false;
		var topWall:Wall = new Wall(ORIGIN_X - FlxG.width - 8,ORIGIN_Y - 8,FlxG.width*3 + 2*8,8,AssetPaths.bathroom_floor_tile__png);
		topWall.visible = false;


		bg.add(leftWall);
		bg.add(rightWall);
		bg.add(topWall);

		bg.add(bgTile);
		bg.add(leftUmbrellaTowels);
		bg.add(rightUmbrellaTowels);
		bg.add(swimZone);

		display.add(leftFence);
		display.add(rightFence);
		display.add(leftUmbrella);
		display.add(rightUmbrella);

		bg.add(toFrontOfHouse);
		bg.add(lock);


		for (i in 0...doors.length) Doors.add(doors[i]);

	}


	override public function destroy():Void
	{
		super.destroy();

		swimZone.destroy();
		toFrontOfHouse.destroy();
		lock.destroy();
	}


	public function checkSwimming(c:Child):Float
	{
		if (c.hit.overlaps(swimZone) && !c.isDying())
		{
			return FlxG.elapsed;
		}
		else 
		{
			return 0;
		}
	}


	public function checkDrowning(p:Person):Void
	{
		if (!p.alive || p.hidden) return;
		
		if (p.kind == PARENT)
		{
			if (p.y < ORIGIN_Y + 40 && !cast(p,Parent).isDrowning())
			{
				cast(p,Parent).startDrowning();
			}
			else if (p.y >= ORIGIN_Y + 40 && cast(p,Parent).isDrowning())
			{
				cast(p,Parent).stopDrowning();
			}
		}
		else if (p.kind == CHILD)
		{
			if (p.y < ORIGIN_Y + 120 && !cast(p,Child).isDrowning())
			{
				cast(p,Child).startDying(DROWNING);
			}
			else if (p.y >= ORIGIN_Y + 120 && cast(p,Child).isDrowning())
			{
				cast(p,Child).stopDying(DROWNING);
			}
		}
	}
	
}