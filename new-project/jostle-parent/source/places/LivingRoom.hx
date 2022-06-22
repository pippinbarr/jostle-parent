package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class LivingRoom extends Place
{
	public var toHallway:Door;
	public var toGarden:Door;
	public var toFrontOfHouse:Door;

	// public static var frontDoorLock:Lock;
	public static var kitchenElectricity:FlxSprite;

	private var tv:PhysicsSprite;
	private var tvZone:FlxSprite;
	private var tvTimer:FlxTimer;
	private var coffee_table:PhysicsSprite;
	private var sofa:PhysicsSprite;
	private var sideboard:PhysicsSprite;
	private var dining_table:PhysicsSprite;
	private var dining_chair1:BedChair;
	private var dining_chair2:BedChair;
	private var dining_chair3:BedChair;
	private var dining_chair4:BedChair;
	private var fridge:PhysicsSprite;
	private var stove:PhysicsSprite;
	private var drawers:PhysicsSprite;

	private static var TOTAL_FOODS:Int = 30;
	private static var MAX_SINGLE_FOOD_SESSION:Int = 15;
	private static var FOOD_STORAGE_X:Int = -2 * 640;
	private static var FOOD_STORAGE_Y:Int = -4 * 480 + 240;

	private var freeFoods:Array<Food>;
	private var foodEmitted:Int = 0;
	private var foods:FlxGroup;
	private var fridgeJostled:Bool = false;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup, Child1:Child, Child2:Child, Child3:Child):Void
	{
		ORIGIN_X = Std.int(3 * FlxG.width);
		ORIGIN_Y = Std.int(1.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 7 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 1 * 8;
		WIDTH = 65 * 8;
		HEIGHT = 58 * 8;

		location = LIVING_ROOM;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.living_room_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		// var topLeftWall:Wall = new Wall(OFFSET_X + 27*8,OFFSET_Y,17*8,8,AssetPaths.living_room_wall_tile__png);
		// var topRightWall:Wall = new Wall(Std.int(topLeftWall.x + topLeftWall.width) + DOOR_WIDTH,Std.int(topLeftWall.y),9*8,8, AssetPaths.living_room_wall_tile__png);

		var topLeftWall:Wall = new Wall(OFFSET_X + 27 * 8, OFFSET_Y, 9 * 8, 8, AssetPaths.living_room_wall_tile__png);
		var topRightWall:Wall = new Wall(Std.int(topLeftWall.x + topLeftWall.width) + DOOR_WIDTH, Std.int(topLeftWall.y), 17 * 8, 8,
			AssetPaths.living_room_wall_tile__png);

		var upperLeftWall:Wall = new Wall(Std.int(topLeftWall.x), Std.int(topLeftWall.y) + 8, 8, 23 * 8, AssetPaths.living_room_wall_tile__png);
		var lowerLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 25 * 8, 8, 32 * 8, AssetPaths.living_room_wall_tile__png);

		var middleLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 24 * 8, 7 * 8, 8, AssetPaths.living_room_wall_tile__png);
		var middleRightWall:Wall = new Wall(Std.int(middleLeftWall.x + middleLeftWall.width + DOOR_WIDTH), Std.int(middleLeftWall.y), 9 * 8, 8,
			AssetPaths.living_room_wall_tile__png);

		var bottomLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, 27 * 8, 8, AssetPaths.living_room_wall_tile__png);
		var bottomRightWall:Wall = new Wall(Std.int(bottomLeftWall.x + bottomLeftWall.width + DOOR_WIDTH), Std.int(bottomLeftWall.y), 26 * 8, 8,
			AssetPaths.living_room_wall_tile__png);

		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.living_room_wall_tile__png);

		toHallway = new Door(middleLeftWall.x + middleLeftWall.width, middleLeftWall.y - 2 * 8, this, new FlxPoint(-1, middleLeftWall.y + 2 * 8),
			"LivingRoom.toHallway", UP);
		doors.push(toHallway);

		toGarden = new Door(topLeftWall.x + topLeftWall.width, topLeftWall.y - 2 * 8, this, new FlxPoint(-1, topLeftWall.y + 2 * 8), "LivingRoom.toGarden",
			UP);
		doors.push(toGarden);

		toFrontOfHouse = new Door(bottomLeftWall.x + bottomLeftWall.width, bottomLeftWall.y + 2 * 8, this, new FlxPoint(-1, bottomLeftWall.y - 2 * 8),
			"LivingRoom.toFrontOfHouse", DOWN);
		doors.push(toFrontOfHouse);

		var kitchen_floor:FlxSprite = new FlxSprite(Std.int(topLeftWall.x), OFFSET_Y, AssetPaths.kitchen_floor__png);
		kitchen_floor.origin.x = kitchen_floor.origin.y = 0;
		kitchen_floor.scale.x = 8;
		kitchen_floor.scale.y = 8;

		var living_room_floor:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y + 24 * 8, AssetPaths.living_room_floor_tile__png);
		living_room_floor.origin.x = living_room_floor.origin.y = 0;
		living_room_floor.scale.x = WIDTH;
		living_room_floor.scale.y = 34 * 8;

		var dining_chair1_x:Int = OFFSET_X + 41 * 8;
		var dining_chair1_y:Int = OFFSET_Y + 27 * 8;

		var dining_chair2_x:Int = OFFSET_X + 41 * 8;
		var dining_chair2_y:Int = OFFSET_Y + 34 * 8;

		var dining_chair3_x:Int = OFFSET_X + 59 * 8;
		var dining_chair3_y:Int = OFFSET_Y + 27 * 8;

		var dining_chair4_x:Int = OFFSET_X + 59 * 8;
		var dining_chair4_y:Int = OFFSET_Y + 34 * 8;

		if (FlxG.save.data.living_room_tv != null)
		{
			foodEmitted = FlxG.save.data.foodEmitted;

			tv = new PhysicsSprite(FlxG.save.data.living_room_tv.x, FlxG.save.data.living_room_tv.y, AssetPaths.living_room_tv__png, 1, 0.25, 40, true, false,
				false, 1, 1, true, 9, 10);
			tv.animation.add("off", [1, 1], 1, false);
			tv.animation.add("on", [0, 2, 3, 4], 10, true);

			tv.dispatcher.addEventListener("MEDIUM", handleTVJostle);

			coffee_table = new PhysicsSprite(FlxG.save.data.living_room_coffee_table.x, FlxG.save.data.living_room_coffee_table.y,
				AssetPaths.living_room_coffee_table__png, 1, 0.25, 20, true);
			sofa = new PhysicsSprite(FlxG.save.data.living_room_sofa.x, FlxG.save.data.living_room_sofa.y, AssetPaths.living_room_sofa__png, 1, 0.25, 30,
				true);
			sideboard = new PhysicsSprite(FlxG.save.data.living_room_sideboard.x, FlxG.save.data.living_room_sideboard.y,
				AssetPaths.dining_room_sideboard__png, 1, 0.25, 30, true);
			dining_table = new PhysicsSprite(FlxG.save.data.living_room_dining_table.x, FlxG.save.data.living_room_dining_table.y,
				AssetPaths.dining_room_table__png, 1, 0.25, 20, true);
			dining_chair1_x = FlxG.save.data.living_room_dining_chair1.x;
			dining_chair1_y = FlxG.save.data.living_room_dining_chair1.y;
			dining_chair2_x = FlxG.save.data.living_room_dining_chair2.x;
			dining_chair2_y = FlxG.save.data.living_room_dining_chair2.y;
			dining_chair3_x = FlxG.save.data.living_room_dining_chair3.x;
			dining_chair3_y = FlxG.save.data.living_room_dining_chair3.y;
			dining_chair4_x = FlxG.save.data.living_room_dining_chair4.x;
			dining_chair4_y = FlxG.save.data.living_room_dining_chair4.y;
			// dining_chair1 = new PhysicsSprite(FlxG.save.data.living_room_dining_chair1.x,FlxG.save.data.living_room_dining_chair1.y,AssetPaths.dining_room_chair_right__png,1,0.25,15,true);
			// dining_chair2 = new PhysicsSprite(FlxG.save.data.living_room_dining_chair2.x,FlxG.save.data.living_room_dining_chair2.y,AssetPaths.dining_room_chair_right__png,1,0.25,15,true);
			// dining_chair3 = new PhysicsSprite(FlxG.save.data.living_room_dining_chair3.x,FlxG.save.data.living_room_dining_chair3.y,AssetPaths.dining_room_chair_left__png,1,0.25,15,true);
			// dining_chair4 = new PhysicsSprite(FlxG.save.data.living_room_dining_chair4.x,FlxG.save.data.living_room_dining_chair4.y,AssetPaths.dining_room_chair_left__png,1,0.25,15,true);
			fridge = new PhysicsSprite(FlxG.save.data.living_room_fridge.x, FlxG.save.data.living_room_fridge.y, AssetPaths.kitchen_fridge__png, 1, 0.25, 60,
				true);
			stove = new PhysicsSprite(FlxG.save.data.living_room_stove.x, FlxG.save.data.living_room_stove.y, AssetPaths.kitchen_stove__png, 1, 0.25, 60,
				true);
			drawers = new PhysicsSprite(FlxG.save.data.living_room_drawers.x, FlxG.save.data.living_room_drawers.y, AssetPaths.kitchen_drawers__png, 1, 0.25,
				60, true);
		}
		else
		{
			tv = new PhysicsSprite(OFFSET_X + 8 * 8, OFFSET_Y + 31 * 8, AssetPaths.living_room_tv__png, 1, 0.25, 40, true, false, false, 1, 1, true, 9, 10);
			tv.animation.add("off", [1, 1], 1, false);
			tv.animation.add("on", [0, 2, 3, 4], 10, true);

			tv.dispatcher.addEventListener("MEDIUM", handleTVJostle);

			coffee_table = new PhysicsSprite(OFFSET_X + 3 * 8, OFFSET_Y + 43 * 8, AssetPaths.living_room_coffee_table__png, 1, 0.25, 20, true);
			sofa = new PhysicsSprite(OFFSET_X + 2 * 8, OFFSET_Y + 48 * 8, AssetPaths.living_room_sofa__png, 1, 0.25, 30, true);
			sideboard = new PhysicsSprite(OFFSET_X + 41 * 8, OFFSET_Y + 47 * 8, AssetPaths.dining_room_sideboard__png, 1, 0.25, 30, true);
			dining_table = new PhysicsSprite(OFFSET_X + 45 * 8, OFFSET_Y + 35 * 8, AssetPaths.dining_room_table__png, 1, 0.25, 20, true);
			// dining_chair1 = new PhysicsSprite(OFFSET_X + 41*8,OFFSET_Y + 30*8,AssetPaths.dining_room_chair_right__png,1,0.25,15,true);
			// dining_chair2 = new PhysicsSprite(OFFSET_X + 41*8,OFFSET_Y + 37*8,AssetPaths.dining_room_chair_right__png,1,0.25,15,true);
			// dining_chair3 = new PhysicsSprite(OFFSET_X + 59*8,OFFSET_Y + 30*8,AssetPaths.dining_room_chair_left__png,1,0.25,15,true);
			// dining_chair4 = new PhysicsSprite(OFFSET_X + 59*8,OFFSET_Y + 37*8,AssetPaths.dining_room_chair_left__png,1,0.25,15,true);
			// fridge = new PhysicsSprite(OFFSET_X + 57*8,OFFSET_Y + 2*8,AssetPaths.kitchen_fridge__png,1,0.25,30,true);
			// stove = new PhysicsSprite(OFFSET_X + 29*8,OFFSET_Y + 10*8,AssetPaths.kitchen_stove__png,1,0.25,30,true);
			// drawers = new PhysicsSprite(OFFSET_X + 29*8,OFFSET_Y + 2*8,AssetPaths.kitchen_drawers__png,1,0.25,20,true);
			fridge = new PhysicsSprite(OFFSET_X + 29 * 8, OFFSET_Y + 2 * 8, AssetPaths.kitchen_fridge__png, 1, 0.25, 60, true);
			stove = new PhysicsSprite(OFFSET_X + 57 * 8, OFFSET_Y + 10 * 8, AssetPaths.kitchen_stove__png, 1, 0.25, 60, true);
			drawers = new PhysicsSprite(OFFSET_X + 48 * 8, OFFSET_Y + 2 * 8, AssetPaths.kitchen_drawers__png, 1, 0.25, 60, true);
		}

		dining_chair1 = new BedChair(dining_chair1_x, dining_chair1_y, AssetPaths.dining_room_chair_right__png, 1, 0.25, 15, true, false, false, 1, 1, true,
			4, 8, "", 8, false, Physics.SOLID, Physics.SOLID | Physics.PARENT, this, FURNITURE, PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child1.childColor, PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair1.setupAnimation([0, 0], [0, 0], [1, 1], [2, 2], [3, 3], PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair1.replaceColor(0xFFFF0000, PlayState.child1.childColor);
		dining_chair1.replaceColor(0xFF00FFFF, PlayState.child2.childColor);
		dining_chair1.replaceColor(0xFF0000FF, PlayState.child3.childColor);

		dining_chair1.animation.play("empty");
		var dining_chair1Trigger:FlxSprite = new FlxSprite();
		dining_chair1Trigger.makeGraphic(1, Std.int(dining_chair1.hit.height * 3), 0xFFFF0000);
		dining_chair1Trigger.visible = false;
		dining_chair1.addTrigger(dining_chair1Trigger);

		dining_chair2 = new BedChair(dining_chair2_x, dining_chair2_y, AssetPaths.dining_room_chair_right__png, 1, 0.25, 15, true, false, false, 1, 1, true,
			4, 8, "", 8, false, Physics.SOLID, Physics.SOLID | Physics.PARENT, this, FURNITURE, PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child1.childColor, PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair2.setupAnimation([0, 0], [0, 0], [1, 1], [2, 2], [3, 3], PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair2.replaceColor(0xFFFF0000, PlayState.child1.childColor);
		dining_chair2.replaceColor(0xFF00FFFF, PlayState.child2.childColor);
		dining_chair2.replaceColor(0xFF0000FF, PlayState.child3.childColor);

		dining_chair2.animation.play("empty");
		var dining_chair2Trigger:FlxSprite = new FlxSprite();
		dining_chair2Trigger.makeGraphic(1, Std.int(dining_chair2.hit.height * 3), 0xFFFF0000);
		dining_chair2Trigger.visible = false;
		dining_chair2.addTrigger(dining_chair2Trigger);

		dining_chair3 = new BedChair(dining_chair3_x, dining_chair3_y, AssetPaths.dining_room_chair_left__png, 1, 0.25, 15, true, false, false, 1, 1, true, 4,
			8, "", 8, false, Physics.SOLID, Physics.SOLID | Physics.PARENT, this, FURNITURE, PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child1.childColor, PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair3.setupAnimation([0, 0], [0, 0], [1, 1], [2, 2], [3, 3], PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair3.replaceColor(0xFFFF0000, PlayState.child1.childColor);
		dining_chair3.replaceColor(0xFF00FFFF, PlayState.child2.childColor);
		dining_chair3.replaceColor(0xFF0000FF, PlayState.child3.childColor);

		dining_chair3.animation.play("empty");
		var dining_chair3Trigger:FlxSprite = new FlxSprite();
		dining_chair3Trigger.makeGraphic(1, Std.int(dining_chair3.hit.height * 3), 0xFFFF0000);
		dining_chair3Trigger.visible = false;
		dining_chair3.addTrigger(dining_chair3Trigger);

		dining_chair4 = new BedChair(dining_chair4_x, dining_chair4_y, AssetPaths.dining_room_chair_left__png, 1, 0.25, 15, true, false, false, 1, 1, true, 4,
			8, "", 8, false, Physics.SOLID, Physics.SOLID | Physics.PARENT, this, FURNITURE, PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child1.childColor, PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair4.setupAnimation([0, 0], [0, 0], [1, 1], [2, 2], [3, 3], PlayState.child1.childColor, PlayState.child1.childColor,
			PlayState.child2.childColor, PlayState.child3.childColor);
		dining_chair4.replaceColor(0xFFFF0000, PlayState.child1.childColor);
		dining_chair4.replaceColor(0xFF00FFFF, PlayState.child2.childColor);
		dining_chair4.replaceColor(0xFF0000FF, PlayState.child3.childColor);

		dining_chair4.animation.play("empty");
		var dining_chair4Trigger:FlxSprite = new FlxSprite();
		dining_chair4Trigger.makeGraphic(1, Std.int(dining_chair4.hit.height * 3), 0xFFFF0000);
		dining_chair4Trigger.visible = false;
		dining_chair4.addTrigger(dining_chair4Trigger);

		// replaceColors(dining_chair1);
		// replaceColors(dining_chair2);
		// replaceColors(dining_chair3);
		// replaceColors(dining_chair4);

		// var kitchen_bench_left:PhysicsSprite = new PhysicsSprite(OFFSET_X + 29*8,OFFSET_Y + 20*8,AssetPaths.kitchen_bench_left__png,1,0.25,5,false);
		var kitchen_bench_left:PhysicsSprite = new PhysicsSprite(OFFSET_X + 48 * 8, OFFSET_Y + 20 * 8, AssetPaths.kitchen_bench_left__png, 1, 0.25, 5, false);

		kitchenElectricity = new FlxSprite(kitchen_bench_left.x + 2 * 8, kitchen_bench_left.y + kitchen_bench_left.height);
		kitchenElectricity.makeGraphic(1 * 8, 1 * 8, 0xFFFF0000);
		kitchenElectricity.visible = false;

		var electricity:Sortable = new Sortable(kitchen_bench_left.x + 3 * 8, kitchen_bench_left.y + 3 * 8);
		electricity.loadGraphic(AssetPaths.electricity__png, true, 1, 1, false);
		electricity.origin.x = electricity.origin.y = 0;
		electricity.scale.x = electricity.scale.y = 8;
		electricity.sortKey = electricity.y + 2 * 8;
		electricity.animation.add("electrified", [0, 1, 2], 10, true);
		electricity.animation.play("electrified");

		// var kitchen_bench_right:PhysicsSprite = new PhysicsSprite(OFFSET_X + 56*8,OFFSET_Y + 20*8,AssetPaths.kitchen_bench_right__png,1,0.25,5,false);
		var kitchen_bench_right:PhysicsSprite = new PhysicsSprite(OFFSET_X + 29 * 8, OFFSET_Y + 20 * 8, AssetPaths.kitchen_bench_right__png, 1, 0.25, 5,
			false);

		if (FlxG.save.data.living_room_tv_on != null && FlxG.save.data.living_room_tv_on == true)
			tv.animation.play("on");
		else
			tv.animation.play("off");

		// Setup the area in which kids will just stop
		tvZone = new FlxSprite(tv.x + tv.width / 2 - 2 * 8, tv.y + tv.height + 2 * 8);
		tvZone.makeGraphic(Std.int(4 * 8), Std.int(tv.height - 2 * 8), 0xFFFF0000);
		tvZone.visible = false;

		tvTimer = new FlxTimer().start();
		tvTimer.finished = true;

		// Set up for food
		fridge.dispatcher.addEventListener("MEDIUM", handleFridgeJostle);

		foods = new FlxGroup();
		freeFoods = new Array();

		var foodStartX:Int = FOOD_STORAGE_X;
		var foodStartY:Int = FOOD_STORAGE_Y;

		for (i in 0...TOTAL_FOODS)
		{
			var X:Int = foodStartX + (i % 5) * 8 * 8;
			var Y:Int = foodStartY;

			var food:Food = new Food(X, Y, i, false);
			display.add(food);
			freeFoods.push(food);
			DoorMovables.add(food.hit);

			if ((i + 1) % 5 == 0)
			{
				foodStartX = FOOD_STORAGE_X;
				foodStartY += 8 * 8;
			}
		}

		if (FlxG.save.data.living_room_food_locations != null)
		{
			for (i in 0...FlxG.save.data.living_room_food_locations.length)
			{
				var food:Food = new Food(FlxG.save.data.living_room_food_locations[i].x, FlxG.save.data.living_room_food_locations[i].y, i, false);
				display.add(food);
				foods.add(food);
				DoorMovables.add(food.hit);
			}
		}

		bg.add(bgTile);
		bg.add(living_room_floor);
		bg.add(kitchen_floor);

		display.add(topLeftWall);
		display.add(topRightWall);
		display.add(upperLeftWall);
		display.add(lowerLeftWall);
		display.add(middleLeftWall);
		display.add(middleRightWall);
		display.add(bottomLeftWall);
		display.add(bottomRightWall);
		display.add(rightWall);

		display.add(tv);
		display.add(coffee_table);
		display.add(sofa);
		display.add(dining_table);
		display.add(sideboard);
		display.add(dining_chair1);
		display.add(dining_chair2);
		display.add(dining_chair3);
		display.add(dining_chair4);
		display.add(kitchen_bench_left);
		display.add(kitchen_bench_right);
		display.add(stove);
		display.add(fridge);
		display.add(drawers);

		display.add(electricity);

		bg.add(tvZone);
		bg.add(kitchenElectricity);
		bg.add(toHallway);
		bg.add(toGarden);
		bg.add(toFrontOfHouse);
		bg.add(dining_chair1Trigger);
		bg.add(dining_chair2Trigger);
		bg.add(dining_chair3Trigger);
		bg.add(dining_chair4Trigger);

		// display.add(frontDoorLock);

		for (i in 0...doors.length)
			Doors.add(doors[i]);

		// for (i in 0...foods.members.length) if (foods.members[i] != null) DoorMovables.add(cast(foods.members[i],Food).hit);

		DoorMovables.add(tv.hit);
		DoorMovables.add(dining_chair1.hit);
		DoorMovables.add(dining_chair2.hit);
		DoorMovables.add(dining_chair3.hit);
		DoorMovables.add(dining_chair4.hit);
		DoorMovables.add(fridge.hit);
		DoorMovables.add(stove.hit);
	}

	override public function destroy():Void
	{
		super.destroy();

		toHallway.destroy();
		toGarden.destroy();
		toFrontOfHouse.destroy();
		kitchenElectricity.destroy();
		tv.destroy();
		tvZone.destroy();
		tvTimer.destroy();
		coffee_table.destroy();
		sofa.destroy();
		sideboard.destroy();
		dining_table.destroy();
		dining_chair1.destroy();
		dining_chair2.destroy();
		dining_chair3.destroy();
		dining_chair4.destroy();
		fridge.destroy();
		stove.destroy();
		drawers.destroy();
		foods.destroy();

		for (i in 0...freeFoods.length)
			freeFoods[i].destroy();
	}

	override public function update():Void
	{
		if (PlayState.parent.place != this && PlayState.child1.place != this && PlayState.child2.place != this && PlayState.child3.place != this)
			return;

		// updateElectricity();

		tvZone.x = tv.x + tv.width / 2 - 2 * 8;
		tvZone.y = tv.y + tv.height + 2 * 8;

		checkElectrocution(PlayState.child1);
		checkElectrocution(PlayState.child2);
		checkElectrocution(PlayState.child3);

		dining_chair1.checkUser(PlayState.child1);
		dining_chair1.checkUser(PlayState.child2);
		dining_chair1.checkUser(PlayState.child3);

		dining_chair2.checkUser(PlayState.child1);
		dining_chair2.checkUser(PlayState.child2);
		dining_chair2.checkUser(PlayState.child3);

		dining_chair3.checkUser(PlayState.child1);
		dining_chair3.checkUser(PlayState.child2);
		dining_chair3.checkUser(PlayState.child3);

		dining_chair4.checkUser(PlayState.child1);
		dining_chair4.checkUser(PlayState.child2);
		dining_chair4.checkUser(PlayState.child3);
	}

	private function overlapped(d:Dynamic, b:Dynamic):Void
	{
		// trace("FlxG.overlap.");
	}

	private function handleFridgeJostle(e:JostleEvent):Void
	{
		fridgeJostled = true;
	}

	public function fridgeWasJostled():Bool
	{
		var returnValue:Bool = fridgeJostled;
		fridgeJostled = false;
		return returnValue;
	}

	public function foodRemaining():Bool
	{
		return foodEmitted < MAX_SINGLE_FOOD_SESSION;
	}

	public function resetFoodRemaining():Void
	{
		foodEmitted = 0;
	}

	public function fridgeEmitFood():Void
	{
		// Don't emit food over the limit
		if (foodEmitted > MAX_SINGLE_FOOD_SESSION)
			return;

		// Work out how much food to emit randomly within the limit
		var numFoods:Int = Math.floor(Math.random() * 5);
		if (numFoods > MAX_SINGLE_FOOD_SESSION - foodEmitted)
		{
			numFoods = MAX_SINGLE_FOOD_SESSION - foodEmitted;
		}

		// Make and emit the food
		for (i in 0...numFoods)
		{
			var food:Food = freeFoods.pop();
			if (food != null)
			{
				food.moveTo(fridge.x + fridge.width + 20, fridge.hit.y - 20 + (Math.random() * 40), fridge.place);
				foods.add(food);
			}
		}

		// Updated the statistic
		foodEmitted += numFoods;
	}

	public function foodAvailable():Bool
	{
		return (foods.getFirstAlive() != null);
		// return (foodEmitted < MAX_SINGLE_FOOD_SESSION);
	}

	private function handleTVJostle(e:JostleEvent):Void
	{
		if (!tvTimer.finished)
			return;

		if (tv.animation.frameIndex == 1)
		{
			FlxG.save.data.living_room_tv_on = true;
			FlxG.save.flush();
			tv.animation.play("on");
			tvTimer.start(1);
		}
		else
		{
			FlxG.save.data.living_room_tv_on = false;
			FlxG.save.flush();
			tv.animation.play("off");
			tvTimer.start(1);
		}
	}

	public function checkElectrocution(c:Child):Void
	{
		if (c.hit.overlaps(kitchenElectricity))
		{
			c.startDying(ELECTROCUTING);
		}
		else
		{
			c.stopDying(ELECTROCUTING);
		}
	}

	public function updateElectricity():Void
	{
		// if (People.child1 != null)
		// {
		// 	if (FlxG.overlap(People.child1.hit,LivingRoom.kitchenElectricity)) People.child1.electrocution();
		// }
		// if (People.child2 != null)
		// {
		// 	if (FlxG.overlap(People.child2.hit,LivingRoom.kitchenElectricity)) People.child2.electrocution();
		// }
		// if (People.child3 != null)
		// {
		// 	if (FlxG.overlap(People.child3.hit,LivingRoom.kitchenElectricity)) People.child3.electrocution();
		// }
	}

	override public function save():Void
	{
		FlxG.save.data.living_room_tv = new FlxPoint(tv.x, tv.y);
		FlxG.save.data.living_room_coffee_table = new FlxPoint(coffee_table.x, coffee_table.y);
		FlxG.save.data.living_room_sofa = new FlxPoint(sofa.x, sofa.y);
		FlxG.save.data.living_room_sideboard = new FlxPoint(sideboard.x, sideboard.y);
		FlxG.save.data.living_room_dining_table = new FlxPoint(dining_table.x, dining_table.y);
		FlxG.save.data.living_room_dining_chair1 = new FlxPoint(dining_chair1.x, dining_chair1.y);
		FlxG.save.data.living_room_dining_chair2 = new FlxPoint(dining_chair2.x, dining_chair2.y);
		FlxG.save.data.living_room_dining_chair3 = new FlxPoint(dining_chair3.x, dining_chair3.y);
		FlxG.save.data.living_room_dining_chair4 = new FlxPoint(dining_chair4.x, dining_chair4.y);
		FlxG.save.data.living_room_fridge = new FlxPoint(fridge.x, fridge.y);
		FlxG.save.data.living_room_stove = new FlxPoint(stove.x, stove.y);
		FlxG.save.data.living_room_drawers = new FlxPoint(drawers.x, drawers.y);

		var foodLocations:Array<FlxPoint> = new Array();
		for (i in 0...foods.members.length)
		{
			var f:Food = cast(foods.members[i], Food);
			if (foods.members[i].alive)
				foodLocations.push(new FlxPoint(f.x, f.y));
		}
		FlxG.save.data.living_room_food_locations = foodLocations;
		FlxG.save.data.foodEmitted = foodEmitted;
	}
}
