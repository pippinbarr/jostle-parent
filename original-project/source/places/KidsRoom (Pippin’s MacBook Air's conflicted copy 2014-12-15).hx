package;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;



class KidsRoom extends Place
{

	public var toHallway:Door;

	private var table:PhysicsSprite;
	private var dresser1:PhysicsSprite;
	private var dresser2:PhysicsSprite;
	private var desk1:PhysicsSprite;
	private var chair1:PhysicsSprite;
	private var desk2:PhysicsSprite;
	private var chair2:PhysicsSprite;
	private var desk3:PhysicsSprite;
	private var chair3:PhysicsSprite;
	private var tv:PhysicsSprite;
	private var tvZone:FlxSprite;
	private var tvTimer:FlxTimer;
	private var tv_box:PhysicsSprite;
	private var bunk_bed:PhysicsSprite;
	private var single_bed:PhysicsSprite;

	private var singleBedTrigger:FlxSprite;
	private var bunkBedTrigger:FlxSprite;

	private var singleBedJostled:Bool = false;
	private var bunkBedJostled:Bool = false;

	private var child1InBed:Bool = false;
	private var child2InBed:Bool = false;
	private var child3InBed:Bool = false;

	private static var JUMP_TIME_MIN:Float = 5;
	private static var JUMP_TIME_RANGE:Float = 20;
	private static var JUMP_DELAY_MIN:Float = 5;
	private static var JUMP_DELAY_RANGE:Float = 20;
	private var jumper:Child;
	private var jumpTimer:FlxTimer;


	private static var TOTAL_TOYS:Int = 10;
	private static var TOY_STORAGE_X:Int = 100;
	private static var TOY_STORAGE_Y:Int = 100;
	private var toys:Array<Toy>;


	public function new(
		bg:FlxGroup,display:FlxTypedGroup<Sortable>,
		Child1InBed:Bool,Child2InBed:Bool,Child3InBed:Bool,
		Doors:FlxGroup,DoorMovables:FlxGroup,
		Child1:Child,Child2:Child,Child3:Child):Void
	{
		ORIGIN_X = Std.int(1.5 * FlxG.width);
		ORIGIN_Y = Std.int(0 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 15 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 15 * 8;
		WIDTH = 51 * 8;
		HEIGHT = 34 * 8;

		location = KIDS_ROOM;

		super();

		child1InBed = Child1InBed;
		child2InBed = Child2InBed;
		child3InBed = Child3InBed;


		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X,ORIGIN_Y,AssetPaths.kids_bedroom_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var topWall:Wall = new Wall(OFFSET_X,OFFSET_Y,WIDTH,8,AssetPaths.kids_bedroom_wall_tile__png);
		var bottomLeftWall:Wall = new Wall(OFFSET_X,OFFSET_Y + HEIGHT - 8,17*8,8,AssetPaths.kids_bedroom_wall_tile__png);
		var bottomRightWall:Wall = new Wall(OFFSET_X + WIDTH - 22*8,OFFSET_Y + HEIGHT - 8,22*8,8,AssetPaths.kids_bedroom_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X,OFFSET_Y + 8,8,HEIGHT - 2*8,AssetPaths.kids_bedroom_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8,OFFSET_Y + 8,8,HEIGHT - 2*8,AssetPaths.kids_bedroom_wall_tile__png);

		toHallway = new Door(bottomLeftWall.x + bottomLeftWall.width,bottomLeftWall.y + 2*8,this,new FlxPoint(-1,bottomLeftWall.y - 2*8),"KidsRoom.toHallway",DOWN);
		doors.push(toHallway);


		var floor:FlxSprite = new FlxSprite(OFFSET_X,OFFSET_Y,AssetPaths.kids_bedroom_floor_tile__png);
		floor.origin.x = floor.origin.y = 0;
		floor.scale.x = WIDTH;
		floor.scale.y = HEIGHT;

		// Default positions
		var bunk_bed_x:Int = OFFSET_X + WIDTH - 15*8;
		var bunk_bed_y:Int = OFFSET_Y + 2*8;

		var single_bed_x:Int = OFFSET_X + WIDTH - 15*8;
		var single_bed_y:Int = OFFSET_Y + HEIGHT - 16*8;

		var chair1_x:Int = OFFSET_X + 6*8;
		var chair1_y:Int = OFFSET_Y + 13*8;

		var chair2_x:Int = OFFSET_X + 6*8;
		var chair2_y:Int = OFFSET_Y + 19*8;

		var chair3_x:Int = OFFSET_X + 6*8;
		var chair3_y:Int = OFFSET_Y + 25*8;


		if (FlxG.save.data.kids_room_bunk_bed != null)
		{
			bunk_bed_x = FlxG.save.data.kids_room_bunk_bed.x;
			bunk_bed_y = FlxG.save.data.kids_room_bunk_bed.y;
			single_bed_x = FlxG.save.data.kids_room_single_bed.x;
			single_bed_y = FlxG.save.data.kids_room_single_bed.y;

			table = new PhysicsSprite(
				FlxG.save.data.kids_room_table.x,
				FlxG.save.data.kids_room_table.y,
				AssetPaths.kids_bedroom_table__png,
				1,0.2,10,true,false);

			dresser1 = new PhysicsSprite(
				FlxG.save.data.kids_room_dresser1.x,
				FlxG.save.data.kids_room_dresser1.y,
				AssetPaths.kids_bedroom_dresser__png,
				1,0.25,40,true,false);

			dresser2 = new PhysicsSprite(
				FlxG.save.data.kids_room_dresser2.x,
				FlxG.save.data.kids_room_dresser2.y,
				AssetPaths.kids_bedroom_dresser__png,
				1,0.25,40,true,false);

			desk1 = new PhysicsSprite(
				FlxG.save.data.kids_room_desk1.x,
				FlxG.save.data.kids_room_desk1.y,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			chair1_x = FlxG.save.data.kids_room_chair1.x;
			chair1_y = FlxG.save.data.kids_room_chair1.y;

			desk2 = new PhysicsSprite(
				FlxG.save.data.kids_room_desk2.x,
				FlxG.save.data.kids_room_desk2.y,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			chair2_x = FlxG.save.data.kids_room_chair2.x;
			chair2_y = FlxG.save.data.kids_room_chair2.y;

			desk3 = new PhysicsSprite(
				FlxG.save.data.kids_room_desk3.x,
				FlxG.save.data.kids_room_desk3.y,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			chair3_x = FlxG.save.data.kids_room_chair3.x;
			chair3_y = FlxG.save.data.kids_room_chair3.y;

			tv = new PhysicsSprite(
				FlxG.save.data.kids_room_tv.x,
				FlxG.save.data.kids_room_tv.y,
				AssetPaths.kids_bedroom_tv__png,
				1,0.25,40,true,false,false,1,1,true,10,10);

			tv.animation.add("off",[0,0],1,false);
			tv.animation.add("on",[1,2,3,4],10,true);

			tv.dispatcher.addEventListener("MEDIUM",handleTVJostle);


			tv_box = new PhysicsSprite(
				FlxG.save.data.kids_room_tv_box.x,
				FlxG.save.data.kids_room_tv_box.y,
				AssetPaths.kids_bedroom_tv_box__png,
				1,0.25,20,true,false);
		}
		else
		{
			table = new PhysicsSprite(
				OFFSET_X + WIDTH - 13*8,
				OFFSET_Y + 18*8,
				AssetPaths.kids_bedroom_table__png,
				1,0.2,10,true,false);

			dresser1 = new PhysicsSprite(
				OFFSET_X + 2*8,
				OFFSET_Y + 4*8,
				AssetPaths.kids_bedroom_dresser__png,
				1,0.25,40,true,false);

			dresser2 = new PhysicsSprite(
				OFFSET_X + 9*8,
				OFFSET_Y + 4*8,
				AssetPaths.kids_bedroom_dresser__png,
				1,0.25,40,true,false);

			desk1 = new PhysicsSprite(
				OFFSET_X + 2*8,
				OFFSET_Y + 16*8,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			desk2 = new PhysicsSprite(
				OFFSET_X + 2*8,
				OFFSET_Y + 22*8,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			desk3 = new PhysicsSprite(
				OFFSET_X + 2*8,
				OFFSET_Y + 28*8,
				AssetPaths.kids_bedroom_desk__png,
				1,0.25,15,true,false);

			chair3 = new PhysicsSprite(
				OFFSET_X + 6*8,
				OFFSET_Y + 28*8,
				AssetPaths.kids_bedroom_chair__png,
				1,0.25,15,true,false);

			tv = new PhysicsSprite(
				OFFSET_X + 16*8,
				OFFSET_Y + 2*8,
				AssetPaths.kids_bedroom_tv__png,
				1,0.25,40,true,false,false,1,1,true,10,10);

			tv.animation.add("off",[0,0],1,false);
			tv.animation.add("on",[1,2,3,4],10,true);
			tv.dispatcher.addEventListener("MEDIUM",handleTVJostle);

			tv_box = new PhysicsSprite(
				OFFSET_X + 27*8,
				OFFSET_Y + 7*8,
				AssetPaths.kids_bedroom_tv_box__png,
				1,0.25,20,true,false);			
		}

		// Setup the area in which kids will just stop
		tvZone = new FlxSprite(tv.x + tv.width/2 - 2*8,tv.y + tv.height + 4*8);
		tvZone.makeGraphic(Std.int(4*8),Std.int(tv.height - 6*8),0xFFFF0000);
		tvZone.visible = false;
		tvTimer = new FlxTimer();
		tvTimer.finished = true;

		chair1 = new PhysicsSprite(
			chair1_x,
			chair1_y,
			AssetPaths.kids_bedroom_chair__png,
			1,0.25,15,true,false,false,1,1,true,4,7);
		chair1.animation.add("empty",[0,0],1,false);
		chair1.animation.add("1",[1,1],1,false);
		chair1.animation.add("2",[2,2],1,false);
		chair1.animation.add("3",[3,3],1,false);
		chair1.replaceColor(0xFFFF0000,Child1.childColor);
		chair1.replaceColor(0xFF00FFFF,Child2.childColor);
		chair1.replaceColor(0xFF0000FF,Child3.childColor);

		chair2 = new PhysicsSprite(
			chair2_x,
			chair2_y,
			AssetPaths.kids_bedroom_chair__png,
			1,0.25,15,true,false,false,1,1,true,4,7);
		chair2.animation.add("empty",[0,0],1,false);
		chair2.animation.add("1",[1,1],1,false);
		chair2.animation.add("2",[2,2],1,false);
		chair2.animation.add("3",[3,3],1,false);
		chair2.replaceColor(0xFFFF0000,Child1.childColor);
		chair2.replaceColor(0xFF00FFFF,Child2.childColor);
		chair2.replaceColor(0xFF0000FF,Child3.childColor);

		chair3 = new PhysicsSprite(
			chair3_x,
			chair3_y,
			AssetPaths.kids_bedroom_chair__png,
			1,0.25,15,true,false,false,1,1,true,4,7);
		chair3.animation.add("empty",[0,0],1,false);
		chair3.animation.add("1",[1,1],1,false);
		chair3.animation.add("2",[2,2],1,false);
		chair3.animation.add("3",[3,3],1,false);
		chair3.replaceColor(0xFFFF0000,Child1.childColor);
		chair3.replaceColor(0xFF00FFFF,Child2.childColor);
		chair3.replaceColor(0xFF0000FF,Child3.childColor);

		bunk_bed = new PhysicsSprite(
			bunk_bed_x,
			bunk_bed_y,
			AssetPaths.kids_bedroom_bunk_bed__png,
			1,0.25,10,true,false,false,1,1,true,13,12);

		bunk_bed.animation.add("both",[1,1],1,false);
		bunk_bed.animation.add("child2",[2,2],1,false);
		bunk_bed.animation.add("child3",[3,3],1,false);
		bunk_bed.animation.add("empty",[0,0],1,false);


		bunk_bed.dispatcher.addEventListener("ANY",handleBunkBedJostle,false);


		bunk_bed.replaceColor(0xFF000000,Child2.childColor);
		bunk_bed.replaceColor(0xFFFFFFFF,Child3.childColor);


		single_bed = new PhysicsSprite(
			single_bed_x,
			single_bed_y,
			AssetPaths.kids_bedroom_single_bed__png,
			1,0.25,10,true,false,false,1,1,true,13,11);

		single_bed.animation.add("occupied",[1,1],1,false);
		single_bed.animation.add("empty",[0,0],1,false);
		single_bed.animation.add("1",[2,3],5,true);
		single_bed.animation.add("2",[4,5],5,true);
		single_bed.animation.add("3",[6,7],5,true);

		single_bed.replaceColor(0xFF000000,Child1.childColor);
		single_bed.replaceColor(0xFFFF0000,Child1.childColor);
		single_bed.replaceColor(0xFF00FFFF,Child2.childColor);
		single_bed.replaceColor(0xFF0000FF,Child3.childColor);



		setupBeds(Child1.alive,Child2.alive,Child3.alive);

		// if (FlxG.save.data.child1_alive != null && FlxG.save.data.child1_alive == false) single_bed.animation.play("empty");
		// else single_bed.animation.play("occupied");

		single_bed.dispatcher.addEventListener("ANY",handleSingleBedJostle,false);
		single_bed.dispatcher.addEventListener("ANY",handleSingleBedJumpJostle,false);

		singleBedTrigger = new FlxSprite(single_bed.x + single_bed.width/2 - 1*8,single_bed.hit.y - 1*8);
		singleBedTrigger.makeGraphic(2*8,Std.int(single_bed.hit.height + 2*8),0xFFFF0000);
		singleBedTrigger.visible = false;

		bunkBedTrigger = new FlxSprite(bunk_bed.x + bunk_bed.width/2 - 1*8,bunk_bed.hit.y - 1*8);
		bunkBedTrigger.makeGraphic(2*8,Std.int(bunk_bed.hit.height + 2*8),0xFFFF0000);
		bunkBedTrigger.visible = false;


		jumpTimer = new FlxTimer();
		jumpTimer.start(2 + Math.random() * 4);


		if (FlxG.save.data.kids_room_tv_on != null && FlxG.save.data.kids_room_tv_on == true) tv.animation.play("on");
		else tv.animation.play("off");

		// Set up toys
		toys = new Array();
		var toy:Toy;
		for (i in 0...TOTAL_TOYS)
		{
			if (FlxG.save.data.kids_room_toy_locations != null)
			{
				toy = new Toy(FlxG.save.data.kids_room_toy_locations[i].x,FlxG.save.data.kids_room_toy_locations[i].y,i);				
			}
			else
			{
				toy = new Toy(FOCUS_POINT.x + 30 - Math.random()*60,FOCUS_POINT.y + 40 - Math.random()*50,i);				
			}
			display.add(toy);
			toys.push(toy);			
		}


		bg.add(bgTile);
		bg.add(floor);

		display.add(bottomLeftWall);
		display.add(bottomRightWall);
		display.add(leftWall);
		display.add(rightWall);
		display.add(topWall);

		display.add(bunk_bed);
		display.add(single_bed);
		display.add(table);
		display.add(dresser1);
		display.add(dresser2);
		display.add(desk1);
		display.add(chair1);
		display.add(desk2);
		display.add(chair2);
		display.add(desk3);
		display.add(chair3);
		display.add(tv);
		display.add(tv_box);

		bg.add(tvZone);
		bg.add(singleBedTrigger);
		bg.add(bunkBedTrigger);
		bg.add(toHallway);


		for (i in 0...doors.length) Doors.add(doors[i]);
		
		for (i in 0...toys.length) DoorMovables.add(toys[i].hit);
		DoorMovables.add(desk1.hit); DoorMovables.add(chair1.hit);
		DoorMovables.add(desk2.hit); DoorMovables.add(chair2.hit);
		DoorMovables.add(desk3.hit); DoorMovables.add(chair3.hit);
		DoorMovables.add(tv.hit); DoorMovables.add(tv_box.hit);
		DoorMovables.add(dresser1.hit);
		DoorMovables.add(dresser2.hit);
		DoorMovables.add(table.hit);
	}


	override public function update():Void
	{
		tvZone.x = tv.x + tv.width/2 - 2*8;
		tvZone.y = tv.y + tv.height + 4*8;

		singleBedTrigger.x = single_bed.x + single_bed.width/2 - 1*8;
		singleBedTrigger.y = single_bed.hit.y - 1*8;

		bunkBedTrigger.x = bunk_bed.x + bunk_bed.width/2 - 1*8;
		bunkBedTrigger.y = bunk_bed.hit.y - 1*8;

		if (PlayState.child1.location == this.location) checkTV(PlayState.child1);
		if (PlayState.child2.location == this.location) checkTV(PlayState.child2);
		if (PlayState.child3.location == this.location) checkTV(PlayState.child3);

		if (PlayState.task != PUT_KIDS_TO_BED)
		{
			checkJumpOnBed(PlayState.child1);
			checkJumpOnBed(PlayState.child2);
			checkJumpOnBed(PlayState.child3);
		}

		if (PlayState.task == PUT_KIDS_TO_BED && PlayState.parent.location == KIDS_ROOM)
		{
			checkPutChild1InSingleBed(PlayState.child1);
			checkPutChild2InBunkBed(PlayState.child2);
			checkPutChild3InBunkBed(PlayState.child3);
		}
	}


	private function checkJumpOnBed(c:Child):Void
	{
		if (c.hit.overlaps(singleBedTrigger) && single_bed.animation.frameIndex == 0 && jumper == null && jumpTimer.finished)
		{
			jumper = c;
			c.hide(false);
			single_bed.animation.play(Std.string(c.number));
			jumpTimer.start(JUMP_TIME_MIN + Math.random() * JUMP_TIME_RANGE,jumpTimerFinished);
		}
	}


	private function jumpTimerFinished(t:FlxTimer):Void
	{
		jumper.unhide();
		dismountBed(jumper);
		jumper = null;
		single_bed.animation.play("empty");
		jumpTimer.start(JUMP_DELAY_MIN + Math.random() * JUMP_DELAY_RANGE);
	}


	private function handleSingleBedJumpJostle(e:JostleEvent):Void
	{
		if (jumper == null) return;

		jumpTimer.cancel();
		jumper.unhide();
		dismountBed(jumper);
		jumper = null;
		single_bed.animation.play("empty");
		jumpTimer.start(JUMP_DELAY_MIN + Math.random() * JUMP_DELAY_RANGE);
	}


	private function dismountBed(c:Child):Void
	{
		if (single_bed.hit.y + single_bed.hit.height/2 < ORIGIN_Y + FlxG.height/2)
		{
			c.moveTo(single_bed.hit.x + single_bed.hit.width/2 - c.hit.width/2,single_bed.hit.y + single_bed.hit.height - c.height + c.hit.height,KIDS_ROOM);
		}
		else
		{
			c.moveTo(single_bed.hit.x + single_bed.hit.width/2 - c.hit.width/2,single_bed.hit.y - c.height,KIDS_ROOM);
		}
	}


	public function setupBeds(Child1InBed:Bool,Child2InBed:Bool,Child3InBed:Bool):Void
	{
		child1InBed = Child1InBed;
		child2InBed = Child2InBed;
		child3InBed = Child3InBed;

		// trace("setupBeds(" + Child1InBed + "," + Child2InBed + "," + Child3InBed + ");");

		if (!Child2InBed && !Child3InBed) bunk_bed.animation.play("empty");
		else if (Child2InBed && Child3InBed) bunk_bed.animation.play("both");
		else if (Child2InBed) bunk_bed.animation.play("child2");
		else bunk_bed.animation.play("child3");	

		if (Child1InBed) single_bed.animation.play("occupied");
		else single_bed.animation.play("empty");
	}


	private function handleBunkBedJostle(e:JostleEvent):Void
	{
		// trace("Bunkbed jostled!");

		bunkBedJostled = true;
		bunk_bed.dispatcher.removeEventListener("ANY",handleBunkBedJostle);
	}



	private function handleSingleBedJostle(e:JostleEvent):Void
	{
		// trace("Single bed jostled!");

		singleBedJostled = true;
		single_bed.dispatcher.removeEventListener("ANY",handleSingleBedJostle);
	}


	public function singleBedWasJostled():Bool
	{
		var returnValue:Bool = singleBedJostled;
		singleBedJostled = false;
		return returnValue;
	}


	public function bunkBedWasJostled():Bool
	{
		var returnValue:Bool = bunkBedJostled;
		bunkBedJostled = false;
		return returnValue;
	}


	public function emptyBunkBed():Void
	{
		bunk_bed.animation.play("empty");
		child2InBed = false;
		child3InBed = false;
	}


	public function emptySingleBed():Void
	{
		single_bed.animation.play("empty");
		child1InBed = false;
	}


	public function checkPutChild1InSingleBed(c:Child):Bool
	{
		if (c.hit.overlaps(singleBedTrigger)) 
		{
			child1InBed = true;
			c.setInBed(true);
			c.hide();
			single_bed.animation.play("occupied");
			return true;
		}

		return false;
	}


	public function checkPutChild2InBunkBed(c:Child):Bool
	{
		if (c.hit.overlaps(bunkBedTrigger)) 
		{
			child2InBed = true;
			c.setInBed(true);
			c.hide();
			if (child3InBed) bunk_bed.animation.play("both");
			else bunk_bed.animation.play("child2");
			return true;
		}

		return false;
	}

	public function checkPutChild3InBunkBed(c:Child):Bool
	{
		if (c.hit.overlaps(bunkBedTrigger)) 
		{
			child3InBed = true;
			c.setInBed(true);
			c.hide();
			if (child2InBed) bunk_bed.animation.play("both");
			else bunk_bed.animation.play("child3");
			return true;
		}

		return false;	
	}


	public function wakeFromBunkbed(c:Child,offset:Int):Void
	{
		c.unhide();
		c.setInBed(false);

		if (bunk_bed.hit.y + bunk_bed.hit.height/2 < ORIGIN_Y + FlxG.height/2)
		{
			c.moveTo(bunk_bed.hit.x + offset,bunk_bed.hit.y + bunk_bed.hit.height - c.height + c.hit.height,KIDS_ROOM);
		}
		else
		{
			c.moveTo(bunk_bed.hit.x + offset,bunk_bed.hit.y - c.height,KIDS_ROOM);
		}

		emptyBunkBed();

		c.showName();
	}


	public function wakeFromSingleBed(c:Child):Void
	{
		c.unhide();
		c.setInBed(false);

		if (single_bed.hit.y + single_bed.hit.height/2 < ORIGIN_Y + FlxG.height/2)
		{
			c.moveTo(single_bed.hit.x + single_bed.hit.width/2 - c.hit.width/2,single_bed.hit.y + single_bed.hit.height - c.height + c.hit.height,KIDS_ROOM);
		}
		else
		{
			c.moveTo(single_bed.hit.x + single_bed.hit.width/2 - c.hit.width/2,single_bed.hit.y - c.height,KIDS_ROOM);
		}

		emptySingleBed();

		c.showName();
	}


	private function handleTVJostle(e:JostleEvent):Void
	{
		if (!tvTimer.finished) return;

		if (tv.animation.frameIndex == 0) 
		{
			FlxG.save.data.kids_room_tv_on = true;
			FlxG.save.flush();
			tv.animation.play("on");
			tvTimer.start(1);
		}
		else 
		{
			FlxG.save.data.kids_room_tv_on = false;
			FlxG.save.flush();
			tv.animation.play("off");
			tvTimer.start(1);
		}
	}


	public function checkTV(c:Child):Void
	{
		c.watchTV(tv.animation.frameIndex != 0 && c.hit.overlaps(tvZone));
	}


	override public function save():Void
	{
		FlxG.save.data.kids_room_table = new FlxPoint(table.x,table.y);
		FlxG.save.data.kids_room_dresser1 = new FlxPoint(dresser1.x,dresser1.y);
		FlxG.save.data.kids_room_dresser2 = new FlxPoint(dresser2.x,dresser2.y);
		FlxG.save.data.kids_room_desk1 = new FlxPoint(desk1.x,desk1.y);
		FlxG.save.data.kids_room_chair1 = new FlxPoint(chair1.x,chair1.y);
		FlxG.save.data.kids_room_desk2 = new FlxPoint(desk2.x,desk2.y);
		FlxG.save.data.kids_room_chair2 = new FlxPoint(chair2.x,chair2.y);
		FlxG.save.data.kids_room_desk3 = new FlxPoint(desk3.x,desk3.y);
		FlxG.save.data.kids_room_chair3 = new FlxPoint(chair3.x,chair3.y);
		FlxG.save.data.kids_room_tv = new FlxPoint(tv.x,tv.y);
		FlxG.save.data.kids_room_tv_box = new FlxPoint(tv_box.x,tv_box.y);
		FlxG.save.data.kids_room_bunk_bed = new FlxPoint(bunk_bed.x,bunk_bed.y);
		FlxG.save.data.kids_room_single_bed = new FlxPoint(single_bed.x,single_bed.y);

		var toyLocations:Array<FlxPoint> = new Array();
		for (i in 0...toys.length)
		{
			toyLocations.push(new FlxPoint(toys[i].x,toys[i].y));
		}
		FlxG.save.data.kids_room_toy_locations = toyLocations;
	}
}
