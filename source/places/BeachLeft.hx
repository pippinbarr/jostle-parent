package;


import flixel.FlxSprite;
import flixel.FlxG;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;


class BeachLeft extends Place
{

	private var swimZone:FlxSprite;


	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, fg:FlxGroup,Doors:FlxGroup,DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(3 * FlxG.width);
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


		var fence:PhysicsSprite = new PhysicsSprite(OFFSET_X,OFFSET_Y + HEIGHT - 3*8,AssetPaths.beach_full_fence__png,1,0.2,1,false);

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
		var cliff:PhysicsSprite = new PhysicsSprite(OFFSET_X,OFFSET_Y + 12*8,AssetPaths.beach_left_cliff__png,1,1,1,false);

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

		bg.add(bgTile);
		bg.add(leftUmbrellaTowels);
		bg.add(rightUmbrellaTowels);
		bg.add(swimZone);

		display.add(fence);
		display.add(leftUmbrella);
		display.add(rightUmbrella);
		
		fg.add(cliff);


		for (i in 0...doors.length) Doors.add(doors[i]);

	}


	override public function destroy():Void
	{
		super.destroy();

		swimZone.destroy();
	}


	public function checkSwimming(c:Child):Float
	{
		if (c.hit.overlaps(swimZone) && !c.isDrowning())
		{
			return FlxG.elapsed;
		}
		else 
		{
			return 0;
		}
	}

	
}