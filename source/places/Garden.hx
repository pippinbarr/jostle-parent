
package;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxPoint;

import flixel.group.FlxTypedGroup;
import flixel.group.FlxGroup;

import flixel.system.FlxSound;


class Garden extends Place
{

	public var toLivingRoom:Door;
	public var lock:Lock;

	public static var unmowedGrass:FlxGroup;

	private var lawnmower:PhysicsSprite;
	private var poison:PhysicsSprite;

	private var mowerSound:FlxSound;

	public function new(bg:FlxGroup,display:FlxTypedGroup<Sortable>,Doors:FlxGroup,DoorMovables:FlxGroup):Void
	{
		
		ORIGIN_X = Std.int(4.5 * FlxG.width);
		ORIGIN_Y = Std.int(0 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 1 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 1 * 8;
		WIDTH = 78 * 8;
		HEIGHT = 58 * 8;

		location = GARDEN;

		super();


		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X,ORIGIN_Y,AssetPaths.garden_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;


		var topWall:PhysicsSprite = new PhysicsSprite(OFFSET_X,OFFSET_Y,AssetPaths.garden_top_wall__png,1,1,1000,false);
		var upperLeftWall:PhysicsSprite = new PhysicsSprite(Std.int(topWall.x),Std.int(topWall.y + topWall.height),AssetPaths.garden_upper_left_wall__png,1,1,1000,false);
		var middleWall:PhysicsSprite = new PhysicsSprite(OFFSET_X,OFFSET_Y + 31*8,AssetPaths.garden_middle_wall__png,1,1,1000,false);
		var lowerLeftWall:PhysicsSprite = new PhysicsSprite(Std.int(middleWall.x + middleWall.width - 2*8),Std.int(middleWall.y + middleWall.height),AssetPaths.garden_lower_left_wall__png,1,1,1000,false);
		var bottomWallLeft:PhysicsSprite = new PhysicsSprite(Std.int(lowerLeftWall.x),Std.int(lowerLeftWall.y + lowerLeftWall.height),AssetPaths.garden_bottom_left_wall__png,1,1,1000,false);
		var bottomWallRight:PhysicsSprite = new PhysicsSprite(Std.int(bottomWallLeft.x + bottomWallLeft.width) + Door.STANDARD_DOOR_WIDTH,Std.int(bottomWallLeft.y),AssetPaths.garden_bottom_right_wall__png,1,1,1000,false);
		var rightWall:PhysicsSprite = new PhysicsSprite(Std.int(topWall.x + topWall.width) - 2*8,Std.int(topWall.y + topWall.height),AssetPaths.garden_right_wall__png,1,1,1000,false);


		toLivingRoom = new Door(bottomWallLeft.x + bottomWallLeft.width,bottomWallLeft.y + 2*8,this,new FlxPoint(-1,bottomWallLeft.y - 2*8),"Garden.toLivingRoom",DOWN);
		doors.push(toLivingRoom);

		lock = new Lock(toLivingRoom.x,toLivingRoom.y-2*8,toLivingRoom.width,toLivingRoom.height);
		lock.unlock();
		lock.visible = false;


		// toLivingRoom = new Door(bottomWallLeft.x + bottomWallLeft.width,bottomWallLeft.y + 1*8 + Door.LOWER_DOOR_PLACEMENT_MARGIN,ORIGIN_X,ORIGIN_Y);
		// toLivingRoom.setArrival(toLivingRoom.x + toLivingRoom.width/2,toLivingRoom.y + Door.LOWER_DOOR_ARRIVAL_MARGIN);

		// lock = new Lock(Std.int(bottomWallLeft.x + bottomWallLeft.width),Std.int(bottomWallRight.y) + 1*8,12*8,8,AssetPaths.garden_door_tile__png);
		// lock.lock();

		// Grass

		var grass1:FlxSprite = new FlxSprite(Std.int(topWall.x + 2*8),topWall.y + 2*8,AssetPaths.garden_mowed_grass_tile__png);
		grass1.origin.x = grass1.origin.y = 0;
		grass1.scale.x = 74*8;
		grass1.scale.y = 20*8;
		grass1.width *= grass1.scale.x;
		grass1.height *= grass1.scale.y;

		var grass2:FlxSprite = new FlxSprite(Std.int(middleWall.x + middleWall.width),Std.int(grass1.y + grass1.height),AssetPaths.garden_mowed_grass_tile__png);
		grass2.origin.x = grass2.origin.y = 0;
		grass2.scale.x = 32*8;
		grass2.scale.y = 34*8;
		grass2.width *= grass2.scale.x;
		grass2.height *= grass2.scale.y;

		// Create unmowed grass

		unmowedGrass = new FlxGroup();
		for (x in 0 ... Std.int(grass1.width/16))
		{
			for (y in 0 ... Std.int(grass1.height/16))
			{
				var unmowed:FlxSprite = new FlxSprite(grass1.x + x*16,grass1.y + y*16,AssetPaths.garden_unmowed_grass_tile__png);
				unmowedGrass.add(unmowed);
			}
		}
		for (x in 0 ... Std.int(grass2.width/16))
		{
			for (y in 0 ... Std.int(grass2.height/16))
			{
				var unmowed:FlxSprite = new FlxSprite(grass2.x + x*16,grass2.y + y*16,AssetPaths.garden_unmowed_grass_tile__png);
				unmowedGrass.add(unmowed);
			}
		}

		var doorstep:FlxSprite = new FlxSprite(Std.int(bottomWallLeft.x + bottomWallLeft.width),Std.int(bottomWallLeft.y),AssetPaths.garden_doorstep__png);
		doorstep.origin.x = doorstep.origin.y = 0;
		doorstep.scale.x = doorstep.scale.y = 8;

		var tool_area:FlxSprite = new FlxSprite(Std.int(upperLeftWall.x + upperLeftWall.width),OFFSET_Y + 22*8,AssetPaths.garden_tool_area__png);
		tool_area.origin.x = tool_area.origin.y = 0;
		tool_area.scale.x = tool_area.scale.y = 8;

		if (FlxG.save.data.garden_lawnmower != null)
		{
			lawnmower = new PhysicsSprite(
				FlxG.save.data.garden_lawnmower.x,
				FlxG.save.data.garden_lawnmower.y,
				AssetPaths.garden_lawnmower__png,
				1,0.3,0.5,true,false,false,10,1,false,0,0,"",8,false,Physics.PARENT,(Physics.SOLID | Physics.PARENT | Physics.PARENT_LOCK));

			poison = new PhysicsSprite(
				FlxG.save.data.garden_poison.x,
				FlxG.save.data.garden_poison.y,
				AssetPaths.garden_poison__png,
				1,0.25,8,true,false,true);
		}
		else
		{
			lawnmower = new PhysicsSprite(
				OFFSET_X + 32*8,
				OFFSET_Y + 24*8,
				AssetPaths.garden_lawnmower__png,
				1,0.3,0.5,true,false,false,1,1,false,0,0,"",8,false,Physics.PARENT,(Physics.SOLID | Physics.PARENT | Physics.PARENT_LOCK));

			poison = new PhysicsSprite(
				OFFSET_X + 3*8,
				OFFSET_Y + 24*8,
				AssetPaths.garden_poison__png,
				1,0.25,8,true,false,true);
		}

		poison.place = this;
		poison.kind = POISON;

		lawnmower.place = this;

		mowerSound = new FlxSound();
		mowerSound.loadEmbedded(AssetPaths.mower__mp3,true,false);
		mowerSound.volume = 0.3;

		bg.add(bgTile);
		bg.add(grass1);
		bg.add(grass2);
		bg.add(unmowedGrass);
		bg.add(doorstep);
		bg.add(tool_area);

		bg.add(topWall);
		bg.add(upperLeftWall);
		bg.add(middleWall);
		bg.add(lowerLeftWall);
		bg.add(bottomWallLeft);
		bg.add(bottomWallRight);
		bg.add(rightWall);

		bg.add(lawnmower.hit);

		display.add(lawnmower);
		display.add(poison);

		bg.add(toLivingRoom);
		bg.add(lock);

		// display.add(lock);


		for (i in 0...doors.length) Doors.add(doors[i]);
		DoorMovables.add(poison.hit);
		DoorMovables.add(lawnmower.hit);

	}


	override public function destroy():Void
	{
		super.destroy();

		toLivingRoom.destroy();
		lock.destroy();
		unmowedGrass.destroy();
		lawnmower.destroy();
		poison.destroy();
		mowerSound.destroy();
	}


	override public function update():Void
	{
		if (PlayState.parent.place != this &&
			PlayState.child1.place != this &&
			PlayState.child2.place != this &&
			PlayState.child3.place != this) 
		{
			mowerSound.stop();
			return;
		}

		updateMowing();

		// if (lawnmower.place != PlayState.parent.place) mowerSound.stop();
	}


	private function updateMowing():Void
	{
		// trace(lawnmower.body.getLinearVelocity().x + "," + lawnmower.body.getLinearVelocity().y);

		if (PlayState.parent.place == this && 
			(Math.abs(lawnmower.body.getLinearVelocity().x) >= 1 || Math.abs(lawnmower.body.getLinearVelocity().y) >= 1))
		{
			mowerSound.play(true);
		}
		else
		{
			mowerSound.stop();
		}

		FlxG.overlap(lawnmower.hit,unmowedGrass,handleGrassMowing);
	}


	private function handleGrassMowing(lm:Dynamic,g:Dynamic):Bool
	{
		var p:FlxSprite = cast(g,FlxSprite);
		p.kill();

		return true;
	}


	public function grassMowed():Bool
	{
		return (unmowedGrass.getFirstAlive() == null);
	}


	public function autoMow():Void
	{
		unmowedGrass.callAll("kill");
	}




	override public function save():Void
	{
		FlxG.save.data.garden_lawnmower = new FlxPoint(lawnmower.x,lawnmower.y);
		FlxG.save.data.garden_poison = new FlxPoint(poison.x,poison.y);
	}

}
