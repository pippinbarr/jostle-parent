package;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import haxe.Serializer;
import haxe.Unserializer;

enum PlayStateState
{
	MENU;

	MENU_TO_BLACK;
	ALARM;
	BLACK_TO_PLAY;
	PLAY;
	DEAD_PLAY;
	PLAY_TO_DEATH_NOTICE;
	DEATH_NOTICE_TO_BLACK;
	BLACK_TO_GRAVEYARD;
	GRAVEYARD;
	GRAVEYARD_TO_BLACK;
	BLACK_TO_MENU;
	PLAY_TO_GAME_OVER;
	GAME_OVER;
}

enum TaskState
{
	GET_UP;
	TURN_ON_SHOWER;
	SHOWER;
	GO_TO_KIDS_ROOM;
	WAKE_KIDS;
	TAKE_KIDS_TO_LIVING_ROOM;
	GET_BREAKFAST_FROM_FRIDGE;
	FEED_KIDS_BREAKFAST;
	TAKE_KIDS_TO_GARDEN;
	MOW_THE_LAWN;
	TAKE_KIDS_INSIDE_FROM_GARDEN;
	TAKE_KIDS_TO_FRONT_OF_HOUSE;
	PUT_KIDS_ON_BUS;
	AT_PLAYGROUND;
	LEAVE_PLAYGROUND;
	AT_PARK;
	FEED_KIDS_LUNCH;
	LEAVE_PARK;
	AT_BEACH;
	LEAVE_BEACH;
	TAKE_KIDS_INSIDE_HOUSE;
	GET_DINNER_FROM_FRIDGE;
	FEED_KIDS_DINNER;
	TAKE_KIDS_TO_BEDROOM;
	PUT_KIDS_TO_BED;
	GO_TO_BED;
	NONE;
}

enum JostleStrength
{
	NONE;
	SOFT;
	NORMAL;
}

class PlayState extends FlxState
{
	// MUSIC
	private var music:Music;

	public static var justJostled:JostleStrength = NONE;

	private var alarm:FlxSound;

	// DISPLAY GROUPS
	private var bg:FlxGroup;
	private var display:FlxTypedGroup<Sortable>;
	private var fg:FlxGroup;
	private var ui:FlxGroup;

	private var doors:FlxGroup;
	private var doorMovables:FlxGroup;

	// PLACES
	private var places:Array<Place>;

	private var bedroom:Bedroom;
	private var hallway:Hallway;
	private var kidsRoom:KidsRoom;
	private var bathroom:Bathroom;
	private var livingRoom:LivingRoom;
	private var garden:Garden;

	private var frontOfHouse:FrontOfHouse;
	private var playground:Playground;
	private var park:Park;
	private var beachLeft:BeachLeft;
	private var beachMiddle:BeachMiddle;
	private var beachRight:BeachRight;

	private var graveyard:Graveyard;
	private var cell:Cell;

	private var menu:Menu;

	// PEOPLE
	public static var parent:Parent;
	public static var child1:Child;
	public static var child2:Child;
	public static var child3:Child;

	private var testChild:Child;

	// TASKS
	private static var MIN_PLAYGROUND_WATCHINGS:Int = 1;

	private var playgroundWatchingsComplete:Int = 0;

	private static var MIN_PLAYING_BALL_TOUCHES:Int = 200;

	private static var MIN_TOTAL_SWIM_TIME:Float = 120;

	private var totalSwimTime:Float = 0;

	// TEXTS
	private var blackBG:FlxSprite;

	private var taskText:FlxTextWithBG;
	private var dangerText:FlxTextWithBG;
	private var dangerText2:FlxTextWithBG;
	private var deathNoticeText:FlxTextWithBG;

	private var childNames:Array<String> = [
		"Jane", "John", "Sally", "Jenny", "Joey", "Frank", "Laila", "Sue", "Pippin", "Valerie", "David", "Peter", "Louise", "Gordon", "Ana", "Anne", "Nicole",
		"Alex", "Bettina", "Rami", "Costa", "Elena", "Davey", "Leigh", "Cara", "Liz", "Jenn", "Jim", "Mary", "George", "Hector", "Amy", "Andy", "Phil",
		"Ashley"
	];

	private static var FADE_TIME:Float = 2;
	private static var DEATH_FADE_TIME:Float = 4;

	// STATE
	private var state:PlayStateState;

	public static var task:TaskState;

	override public function create():Void
	{
		// FlxG.stage.displayState = FULL_SCREEN_INTERACTIVE;

		FlxG.save.bind("JostleParentSave");
		// FlxG.save.erase();

		FlxG.mouse.visible = false;

		super.create();

		FlxG.worldBounds.x = 0;
		FlxG.worldBounds.y = 0;
		FlxG.worldBounds.width = 6 * FlxG.width;
		FlxG.worldBounds.height = 6 * FlxG.height;

		music = new Music();
		add(music);

		alarm = new FlxSound();
		alarm.loadEmbedded(AssetPaths.alarm__wav, true, false);

		// Create display groups
		bg = new FlxGroup();
		display = new FlxTypedGroup();
		fg = new FlxGroup();
		ui = new FlxGroup();

		doors = new FlxGroup();
		doorMovables = new FlxGroup();

		add(bg);
		add(display);
		add(fg);
		add(ui);

		// Create physics
		createPhysics();

		// Create people

		FlxG.random.shuffle(childNames);

		var child1Name:String;
		if (FlxG.save.data.child1name != null)
			child1Name = FlxG.save.data.child1name;
		else
			child1Name = childNames.pop();

		child1 = new Child(-1000, -1000, ui, child1Name, 1, 0xFF85FF60);
		display.add(child1);
		doorMovables.add(child1.hit);

		var child2Name:String;
		if (FlxG.save.data.child2name != null)
			child2Name = FlxG.save.data.child2name;
		else
			child2Name = childNames.pop();

		child2 = new Child(-1000, -1000, ui, child2Name, 2, 0xFFF75671);
		display.add(child2);
		doorMovables.add(child2.hit);

		var child3Name:String;
		if (FlxG.save.data.child1name != null)
			child3Name = FlxG.save.data.child3name;
		else
			child3Name = childNames.pop();

		child3 = new Child(-1000, -1000, ui, child3Name, 3, 0xFFFBBB5E);
		display.add(child3);
		doorMovables.add(child3.hit);

		// parent = new Parent(0, 1.5 * FlxG.width, child1, child2, child3, 0xFF7655FF);
		parent = new Parent(-2000, -2000, child1, child2, child3, 0xFF7655FF);
		display.add(parent);
		doorMovables.add(parent.hit);

		child1.setParent(parent);
		child1.setChildren(child1, child2, child3);
		child2.setParent(parent);
		child2.setChildren(child1, child2, child3);
		child3.setParent(parent);
		child3.setChildren(child1, child2, child3);

		parent.replaceColor(FlxColor.RED, child1.childColor);
		parent.replaceColor(FlxColor.CYAN, child2.childColor);
		parent.replaceColor(FlxColor.BLUE, child3.childColor);
		parent.replaceColor(FlxColor.BLACK, parent.parentColor);

		// Create places
		bedroom = new Bedroom(bg, display, doors, doorMovables, parent);
		hallway = new Hallway(bg, display, doors, doorMovables);
		kidsRoom = new KidsRoom(bg, display, child1.alive, child2.alive, child3.alive, doors, doorMovables, child1, child2, child3);
		bathroom = new Bathroom(bg, display, doors, doorMovables);
		livingRoom = new LivingRoom(bg, display, doors, doorMovables, child1, child2, child3);
		garden = new Garden(bg, display, doors, doorMovables);

		frontOfHouse = new FrontOfHouse(bg, display, doors, doorMovables, parent);
		playground = new Playground(bg, display, doors, doorMovables);
		park = new Park(bg, display, doors, doorMovables);
		beachLeft = new BeachLeft(bg, display, fg, doors, doorMovables);
		beachMiddle = new BeachMiddle(bg, display, doors, doorMovables);
		beachRight = new BeachRight(bg, display, fg, doors, doorMovables);

		graveyard = new Graveyard(bg, display, fg, doors, doorMovables);
		cell = new Cell(bg, display, doors, doorMovables);

		menu = new Menu(bg, display, doors, doorMovables);

		places = [
			bedroom, hallway, kidsRoom, bathroom, livingRoom, garden, frontOfHouse, playground, park, beachLeft, beachRight, beachMiddle, graveyard, cell, menu
		];

		connectDoors(bedroom.toHallway, hallway.toBedroom);
		connectDoors(bathroom.toHallway, hallway.toBathroom);
		connectDoors(kidsRoom.toHallway, hallway.toKidsBedroom);
		connectDoors(livingRoom.toHallway, hallway.toLivingRoom);
		connectDoors(livingRoom.toGarden, garden.toLivingRoom);
		connectDoors(livingRoom.toFrontOfHouse, frontOfHouse.toLivingRoom);

		taskText = new FlxTextWithBG(-240, 2 * 8, 240, "", 12, "left", 0xffffffff, 0xff000000, true, RIGHT);
		ui.add(taskText);

		dangerText = new FlxTextWithBG(FlxG.width, 2 * 8, 240, "", 12, "left", 0xff000000, 0xffff0000, true, LEFT);
		ui.add(dangerText);

		dangerText2 = new FlxTextWithBG(FlxG.width, 2 * 8, 240, "", 12, "left", 0xff000000, 0xffff0000, true, LEFT);
		ui.add(dangerText2);

		deathNoticeText = new FlxTextWithBG(0, 80, FlxG.width, Global.strings.PlayState.death, 24, "center", 0xFFFFFFFF, 0xFF000000, true, LEFT, 1, 24);
		// deathNoticeText.setFormat(null,24,0xFFFFFFFF,"center");
		// deathNoticeText.scrollFactor.x = 0; deathNoticeText.scrollFactor.y = 0;
		deathNoticeText.visible = false;

		blackBG = new FlxSprite(0, 0);
		blackBG.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		blackBG.scrollFactor.x = 0;
		blackBG.scrollFactor.y = 0;
		blackBG.visible = false;

		ui.add(blackBG);
		ui.add(deathNoticeText);

		if (FlxG.save.data.currentTask != null && FlxG.save.data.currentTask != Std.string(GET_UP))
		{
			state = PLAY;
			task = Type.createEnum(PlayState.TaskState, FlxG.save.data.currentTask);

			loadWorld();
		}
		else
		{
			state = BLACK_TO_MENU;
			task = GET_UP;

			// DEBUG to get to any scene
			// state = PLAY;
			// task = AT_PLAYGROUND;
			// parent.moveTo(playground.FOCUS_POINT.x, playground.FOCUS_POINT.y, playground);
			// FlxG.camera.focusOn(playground.FOCUS_POINT);

			newWorld();

			if (FlxG.save.data.parentDead != null && FlxG.save.data.parentDead)
			{
				parent.setDead();
			}
		}

		if (state == BLACK_TO_MENU)
		{
			// parent.moveTo(menu.FOCUS_POINT.x - 220,menu.FOCUS_POINT.y,menu);
			parent.moveTo(menu.FOCUS_POINT.x - 220, menu.FOCUS_POINT.y, menu);

			var living:Array<Child> = new Array();
			if (child1.alive)
				living.push(child1);
			if (child2.alive)
				living.push(child2);
			if (child3.alive)
				living.push(child3);

			var livingX:Float = parent.x + parent.width + 8;
			var livingY:Float = parent.y + parent.height - child1.height;

			for (i in 0...living.length)
			{
				living[i].unhide();
				living[i].setMovementMode(STILL);
				living[i].moveTo(livingX, livingY, menu);
				livingX += child1.width + 8;
			}

			if (FlxG.save.data.camera_focus_x == null)
				taskText.tweenIn(Global.strings.PlayState.start_instructions);

			FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToMenu);
			music.fadeIn(FADE_TIME);

			FlxG.camera.focusOn(menu.FOCUS_POINT);

			if (parent.isDead())
				FlxG.camera.follow(parent);
		}
		else if (state == PLAY)
		{
			FlxG.camera.fade(0xFF000000, FADE_TIME, true);
		}

		// FlxG.camera.follow(parent);
	}

	private function newWorld():Void
	{
		// Set locations

		// trace("New world");

		var currentPlace:Place = null;

		switch (task)
		{
			case GET_UP:
				currentPlace = bedroom;

				// parent.hide();
				child1.hide();
				child2.hide();
				child3.hide();

				// trace("Setting children in bed.");

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case TURN_ON_SHOWER:
				currentPlace = bedroom;

				child1.hide();
				child2.hide();
				child3.hide();

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case SHOWER:
				currentPlace = bedroom;

				child1.hide();
				child2.hide();
				child3.hide();

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case GO_TO_KIDS_ROOM:
				currentPlace = bedroom;

				child1.hide();
				child2.hide();
				child3.hide();

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case WAKE_KIDS:
				currentPlace = kidsRoom;

				child1.hide();
				child2.hide();
				child3.hide();

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case TAKE_KIDS_TO_LIVING_ROOM:
				currentPlace = kidsRoom;

			case GET_BREAKFAST_FROM_FRIDGE:
				currentPlace = livingRoom;

				child1.setHungry(true);
				child2.setHungry(true);
				child3.setHungry(true);

			case FEED_KIDS_BREAKFAST:
				currentPlace = livingRoom;

				child1.setHungry(true);
				child2.setHungry(true);
				child3.setHungry(true);

			case TAKE_KIDS_TO_GARDEN:
				currentPlace = livingRoom;

			case MOW_THE_LAWN:
				currentPlace = garden;
				garden.lock.lock();

			case TAKE_KIDS_INSIDE_FROM_GARDEN:
				currentPlace = garden;

			case TAKE_KIDS_TO_FRONT_OF_HOUSE:
				currentPlace = livingRoom;

			case PUT_KIDS_ON_BUS:
				currentPlace = frontOfHouse;

			case AT_PLAYGROUND:
				currentPlace = playground;

			case LEAVE_PLAYGROUND:
				currentPlace = playground;

			case AT_PARK:
				currentPlace = park;

				child1.setTarget(park.getBall());
				child2.setTarget(park.getBall());
				child3.setTarget(park.getBall());

				child1.setMovementMode(CHASE);
				child2.setMovementMode(CHASE);
				child3.setMovementMode(CHASE);

			case FEED_KIDS_LUNCH:
				currentPlace = park;

				child1.setHungry(true);
				child2.setHungry(true);
				child3.setHungry(true);

				child1.setTarget(park.getBall());
				child2.setTarget(park.getBall());
				child3.setTarget(park.getBall());

				child1.setMovementMode(CHASE);
				child2.setMovementMode(CHASE);
				child3.setMovementMode(CHASE);

			case LEAVE_PARK:
				currentPlace = park;

			case AT_BEACH:
				currentPlace = beachMiddle;
				child1.setMovementMode(WANDER_UP);
				child2.setMovementMode(WANDER_UP);
				child3.setMovementMode(WANDER_UP);

			case LEAVE_BEACH:
				currentPlace = beachMiddle;

			case TAKE_KIDS_INSIDE_HOUSE:
				currentPlace = frontOfHouse;

			case GET_DINNER_FROM_FRIDGE:
				currentPlace = livingRoom;

			case FEED_KIDS_DINNER:
				currentPlace = livingRoom;

			case TAKE_KIDS_TO_BEDROOM:
				currentPlace = livingRoom;

			case PUT_KIDS_TO_BED:
				currentPlace = kidsRoom;

			case GO_TO_BED:
				currentPlace = bedroom;

				child1.hide();
				child2.hide();
				child3.hide();

				child1.setInBed(true);
				child2.setInBed(true);
				child3.setInBed(true);

			case NONE:
		}

		parent.moveTo(currentPlace.FOCUS_POINT.x, currentPlace.FOCUS_POINT.y, currentPlace);

		if (task == PUT_KIDS_ON_BUS)
		{
			child1.moveTo(frontOfHouse.FOCUS_POINT.x + 80, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 120, frontOfHouse);
			child2.moveTo(frontOfHouse.FOCUS_POINT.x - 80, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 120, frontOfHouse);
			child3.moveTo(frontOfHouse.FOCUS_POINT.x, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 120, frontOfHouse);
		}
		else if (task == TAKE_KIDS_INSIDE_HOUSE)
		{
			child1.moveTo(frontOfHouse.FOCUS_POINT.x + 80, frontOfHouse.FOCUS_POINT.y - 140, frontOfHouse);
			child2.moveTo(frontOfHouse.FOCUS_POINT.x - 80, frontOfHouse.FOCUS_POINT.y - 140, frontOfHouse);
			child3.moveTo(frontOfHouse.FOCUS_POINT.x, frontOfHouse.FOCUS_POINT.y - 140, frontOfHouse);
		}
		else
		{
			child1.moveTo(currentPlace.FOCUS_POINT.x, currentPlace.FOCUS_POINT.y, currentPlace);
			child2.moveTo(currentPlace.FOCUS_POINT.x, currentPlace.FOCUS_POINT.y, currentPlace);
			child3.moveTo(currentPlace.FOCUS_POINT.x, currentPlace.FOCUS_POINT.y, currentPlace);
		}

		if (FlxG.save.data.child1_alive != null)
			child1.alive = FlxG.save.data.child1_alive;
		if (FlxG.save.data.child1_alive != null)
			child2.alive = FlxG.save.data.child2_alive;
		if (FlxG.save.data.child1_alive != null)
			child3.alive = FlxG.save.data.child3_alive;

		if (task != GET_UP)
			bedroom.emptyBed();

		if (task != GET_UP && task != TURN_ON_SHOWER && task != SHOWER && task != WAKE_KIDS && task != GO_TO_BED)
		{
			kidsRoom.emptyBunkBed();
			kidsRoom.emptySingleBed();
		}
		else
		{
			kidsRoom.setupBeds(child1.alive, child2.alive, child3.alive);
		}
	}

	private function loadWorld():Void
	{
		// trace("Load world");

		// Load if the children are dead
		child1.alive = FlxG.save.data.child1_alive;
		child2.alive = FlxG.save.data.child2_alive;
		child3.alive = FlxG.save.data.child3_alive;

		child1.setMovementMode(Type.createEnum(Child.MovementMode, FlxG.save.data.child1_movement_mode));
		child2.setMovementMode(Type.createEnum(Child.MovementMode, FlxG.save.data.child2_movement_mode));
		child2.setMovementMode(Type.createEnum(Child.MovementMode, FlxG.save.data.child3_movement_mode));

		// Load if the parent is dead
		if (FlxG.save.data.parentDead)
			parent.setDead();

		// If the parent isn't located in the MENU then we're somewhere in the game itself
		// This will be fine for graveyard because the game is never saved post the moment of a death
		if (Type.createEnum(Enums.Location, FlxG.save.data.parentLocation) != Enums.Location.MENU)
		{
			// So get the TASK
			task = Type.createEnum(PlayState.TaskState, FlxG.save.data.currentTask);

			if (task == AT_PARK || task == FEED_KIDS_LUNCH || task == LEAVE_PARK)
			{
				child1.setTarget(park.getBall());
				child2.setTarget(park.getBall());
				child3.setTarget(park.getBall());
			}

			if (task == MOW_THE_LAWN)
				garden.lock.lock();

			// Move the parent to where they were at the moment of saving
			parent.moveTo(FlxG.save.data.parentPosition.x, FlxG.save.data.parentPosition.y,
				locationToPlace(Type.createEnum(Enums.Location, FlxG.save.data.parentLocation)));

			// Move the children to where they were at the moment of saving
			child1.moveTo(FlxG.save.data.child1Position.x, FlxG.save.data.child1Position.y,
				locationToPlace(Type.createEnum(Enums.Location, FlxG.save.data.child1Location)));
			child2.moveTo(FlxG.save.data.child2Position.x, FlxG.save.data.child2Position.y,
				locationToPlace(Type.createEnum(Enums.Location, FlxG.save.data.child2Location)));
			child3.moveTo(FlxG.save.data.child3Position.x, FlxG.save.data.child3Position.y,
				locationToPlace(Type.createEnum(Enums.Location, FlxG.save.data.child3Location)));

			// Hide the children if they were hidden or dead
			if (FlxG.save.data.child1_hidden || !child1.alive)
				child1.hide();
			if (FlxG.save.data.child2_hidden || !child2.alive)
				child2.hide();
			if (FlxG.save.data.child3_hidden || !child3.alive)
				child3.hide();

			// If the children would still be in bed given the task, then set the beds appropriately
			if (task == GET_UP || task == TURN_ON_SHOWER || task == SHOWER || task == GO_TO_KIDS_ROOM || task == WAKE_KIDS || task == GO_TO_BED)
			{
				kidsRoom.setupBeds(child1.alive && FlxG.save.data.child1_in_bed, child2.alive && FlxG.save.data.child2_in_bed, child3.alive && FlxG.save.data.child3_in_bed);
				if (child1.alive && FlxG.save.data.child1_in_bed)
					child1.setInBed(true);
				if (child2.alive && FlxG.save.data.child2_in_bed)
					child2.setInBed(true);
				if (child3.alive && FlxG.save.data.child3_in_bed)
					child3.setInBed(true);
			}
			// Otherwise the beds would be empty
			else
			{
				kidsRoom.emptySingleBed();
				kidsRoom.emptyBunkBed();
			}

			if (task != GET_UP)
			{
				bedroom.emptyBed();
				music.fadeIn(2);
			}

			// trace("Camera focus on saved point.");

			if (parent.place == null)
			{
				FlxG.camera.focusOn(new FlxPoint(-100, -100));
			}
			else
			{
				switch (parent.place.location)
				{
					case MENU:
						FlxG.camera.focusOn(menu.FOCUS_POINT);
					case BEDROOM:
						FlxG.camera.focusOn(bedroom.FOCUS_POINT);
					case HALLWAY:
						FlxG.camera.focusOn(hallway.FOCUS_POINT);
					case KIDS_ROOM:
						FlxG.camera.focusOn(kidsRoom.FOCUS_POINT);
					case BATHROOM:
						FlxG.camera.focusOn(bathroom.FOCUS_POINT);
					case LIVING_ROOM:
						FlxG.camera.focusOn(livingRoom.FOCUS_POINT);
					case GARDEN:
						FlxG.camera.focusOn(garden.FOCUS_POINT);
					case FRONT_OF_HOUSE:
						FlxG.camera.focusOn(frontOfHouse.FOCUS_POINT);
					case PLAYGROUND:
						FlxG.camera.focusOn(playground.FOCUS_POINT);
					case PARK:
						FlxG.camera.focusOn(park.FOCUS_POINT);
					case BEACH:
						FlxG.camera.focusOn(beachMiddle.FOCUS_POINT);
					case GRAVEYARD:
						FlxG.camera.focusOn(graveyard.FOCUS_POINT);
					case CELL:
						FlxG.camera.focusOn(cell.FOCUS_POINT);
					case UNKNOWN:
						FlxG.camera.focusOn(new FlxPoint(-100, -100));
				}
			}
		}
			// If the parent IS in the menu then we're starting the game over again from GET_UP
		// But obviously all of the rooms will be loaded in terms of their physical appearance and locations of furniture etc.
		else
		{
			task = GET_UP;
			state = BLACK_TO_MENU;

			child1.hide();
			child2.hide();
			child3.hide();

			kidsRoom.setupBeds(child1.alive, child2.alive, child3.alive);

			parent.moveTo(menu.FOCUS_POINT.x, menu.FOCUS_POINT.y, menu);
			parent.hide();

			// FlxG.camera.follow(parent);
			// trace("Camera focus on menu.");
			FlxG.camera.focusOn(menu.FOCUS_POINT);
			FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToMenu);
		}

		if (FlxG.save.data.child1_dying)
			child1.startDying(Type.createEnum(Child.ChildState, FlxG.save.data.child1_dying_state));
		if (FlxG.save.data.child2_dying)
			child2.startDying(Type.createEnum(Child.ChildState, FlxG.save.data.child2_dying_state));
		if (FlxG.save.data.child3_dying)
			child3.startDying(Type.createEnum(Child.ChildState, FlxG.save.data.child3_dying_state));
	}

	private function createPhysics():Void
	{
		// Physics.DEBUG_SPRITE = new Sprite();
		// FlxG.stage.addChild(Physics.DEBUG_SPRITE);

		Physics.WORLD = new B2World(new B2Vec2(0, 0), true);
		// Physics.DEBUG = new B2DebugDraw ();

		var contactListener:JostleContactListener = new JostleContactListener();
		Physics.WORLD.setContactListener(contactListener);

		// Physics.DEBUG.setSprite(Physics.DEBUG_SPRITE);
		// Physics.DEBUG.setDrawScale(1/Physics.SCALE);
		// Physics.DEBUG.setFlags(B2DebugDraw.e_shapeBit);
		// Physics.DEBUG_SPRITE.visible = true;

		// Physics.WORLD.setDebugDraw(Physics.DEBUG);
	}

	override public function destroy():Void
	{
		super.destroy();

		alarm.destroy();
		music.destroy();

		for (i in 0...places.length)
		{
			places[i].destroy();
		}

		bg.destroy();
		display.destroy();
		fg.destroy();
		ui.destroy();

		taskText.destroy();
		dangerText.destroy();
		dangerText2.destroy();
		deathNoticeText.destroy();

		music.destroy();

		parent.destroy();
		child1.destroy();
		child2.destroy();
		child3.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// trace(parent.location);

		display.sort(sortBySortKey);

		// Reset the whole shebang
		// RESET THE ENTIRE GAME
		if (FlxG.keys.justPressed.R)
		{
			FlxG.save.erase();
			FlxG.save.flush();
			FlxG.switchState(new PlayState());
		}

		switch (state)
		{
			case BLACK_TO_MENU:
				updatePhysics();
				display.sort(sortBySortKey);

				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
				{
					if (!parent.isDead())
					{
						child1.setMovementMode(FOLLOW);
						child2.setMovementMode(FOLLOW);
						child3.setMovementMode(FOLLOW);
					}
				}

			case MENU:
				if (FlxG.keys.justPressed.F)
				{
					FlxG.scaleMode = new flixel.system.scaleModes.FillScaleMode();
					FlxG.fullscreen = true;
				}

				if (taskText.isTweenedOut())
				{
					// taskText.tweenIn("Walk off the screen to begin playing.");
				}

				updatePhysics();
				display.sort(sortBySortKey);

				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
				{
					child1.setMovementMode(FOLLOW);
					child2.setMovementMode(FOLLOW);
					child3.setMovementMode(FOLLOW);
				}

				if (!menu.contains(parent))
				{
					if (!parent.isDead())
					{
						task = GET_UP;
					}
					else
					{
						// Parent is dead
						task = NONE;
						dangerText.visible = false;
						// parent.moveTo(graveyard.FOCUS_POINT.x,graveyard.FOCUS_POINT.y);
					}

					// Parent is off screen, so we can move on.
					parent.idle();
					parent.active = false;

					state = MENU_TO_BLACK;

					taskText.tweenOut();

					FlxG.camera.fade(0xff000000, FADE_TIME, false, menuFadedToBlack);
					music.fadeOut(FADE_TIME);
				}

			case MENU_TO_BLACK:
				updatePhysics();

			case ALARM:

			case BLACK_TO_PLAY:
				updatePhysics();
				updateTask();
				updatePlaces();
				checkDoors();

			case PLAY:
				updatePhysics();
				updateTask();
				updateJostles();
				updateDanger();
				updatePlaces();
				updateDeath();

				checkDoors();

			case DEAD_PLAY:
				updatePhysics();
				updatePlaces();

				if (graveyard.checkParentGraveTrigger(parent))
				{
					parent.hide();
					state = PLAY_TO_GAME_OVER;

					new FlxTimer().start().start(1, playFadedToGameOver);

					// FlxG.camera.fade(0xFF000000,1,false,playFadedToGameOver);
				}

			case PLAY_TO_DEATH_NOTICE:
				updatePhysics();
				updatePlaces();

			case DEATH_NOTICE_TO_BLACK:
				updatePhysics();
				updatePlaces();
				graveyard.update();

			case BLACK_TO_GRAVEYARD:
				updatePhysics();
				graveyard.update();

			case GRAVEYARD:
				updatePhysics();
				// updateTask();
				if (taskText.isTweenedOut())
				{
					var deadChildren:Array<Child> = new Array();
					if (!child1.alive)
						deadChildren.push(child1);
					if (!child2.alive)
						deadChildren.push(child2);
					if (!child3.alive)
						deadChildren.push(child3);

					var regex1 = ~/%(NAME1)%/g;
					var regex2 = ~/%(NAME2)%/g;
					var regex3 = ~/%(NAME3)%/g;
					var mournString = "THIS SHOULD NOT BE POSSIBLE";

					if (numDeadChildren() == 1)
					{
						mournString = Global.strings.PlayState.mourn1;
						mournString = regex1.replace(mournString, deadChildren[0].name);
					}
					else if (numDeadChildren() == 2)
					{
						mournString = Global.strings.PlayState.mourn2;
						mournString = regex1.replace(mournString, deadChildren[0].name);
						mournString = regex2.replace(mournString, deadChildren[1].name);
					}
					else if (numDeadChildren() == 3)
					{
						mournString = Global.strings.PlayState.mourn3;
						mournString = regex1.replace(mournString, deadChildren[0].name);
						mournString = regex2.replace(mournString, deadChildren[1].name);
						mournString = regex3.replace(mournString, deadChildren[2].name);
					}

					taskText.tweenIn(mournString);
				}
				graveyard.update();

				if (!taskText.isTweenedIn())
					return;

				if (!graveyard.contains(parent))
				{
					taskText.tweenOut();
					state = GRAVEYARD_TO_BLACK;

					FlxG.camera.fade(0xFF000000, DEATH_FADE_TIME, false, graveyardFadedToBlack);
				}

			case GRAVEYARD_TO_BLACK:
				graveyard.update(); // For the rain

			case PLAY_TO_GAME_OVER:

			case GAME_OVER:
				if (FlxG.keys.justPressed.SPACE)
				{
					// RESET THE ENTIRE GAME
					FlxG.save.erase();
					FlxG.save.flush();

					FlxG.switchState(new PlayState());
				}
		}

		// Save testing
		// if (FlxG.keys.justPressed.ONE)
		// {
		// 	save();
		// }
		// if (FlxG.keys.justPressed.TWO)
		// {
		// 	FlxG.save.erase();
		// 	FlxG.save.bind("JostleParentSave");
		// }
		// if (FlxG.keys.justPressed.THREE)
		// {
		// 	FlxG.switchState(new PlayState());
		// }
		// if (FlxG.keys.justPressed.FOUR)
		// {
		// 	frontOfHouse.resetBusNoPassengers();
		// }

		// // Death testing
		// if (FlxG.keys.justPressed.SEVEN)
		// {
		// 	child1.die("was killed by a keystroke");
		// }
		// if (FlxG.keys.justPressed.EIGHT)
		// {
		// 	child2.die("was killed by a keystroke");
		// }
		// if (FlxG.keys.justPressed.NINE)
		// {
		// 	child3.die("was killed by a keystroke");
		// 	// child3.startDying(ELECTROCUTING);
		// }
		// if (FlxG.keys.justPressed.ZERO)
		// {
		// 	parent.die("were killed by a keystroke");
		// 	// parent.location = MENU;
		// 	// task = GET_UP;
		// 	// save();
		// 	// FlxG.switchState(new PlayState());
		// }

		// // Debug testing
		// if (FlxG.keys.justPressed.M)
		// {
		// 	garden.autoMow();
		// }
	}

	private function updatePhysics():Void
	{
		Physics.WORLD.step(1 / 30, 30, 30);
		// Physics.WORLD.step(1 / 30, 1, 1);
		Physics.WORLD.clearForces();

		// Physics.DRAW_DEBUG ? Physics.WORLD.drawDebugData() : false;
	}

	private function updateTask():Void
	{
		var processedTask:PlayState.TaskState = task;

		switch (task)
		{
			case GET_UP:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.get_up_instructions);
				}

				// if (!taskText.isTweenedIn()) return;

				if (parent.place == bedroom
					&& (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN || FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT))
				{
					alarm.stop();
					music.fadeIn(2);

					parent.unhide();

					bedroom.emptyBed();
					taskText.tweenOut();

					if (numLivingChildren() > 0)
						task = TURN_ON_SHOWER;
					else
						task = GO_TO_KIDS_ROOM;
				}

			case TURN_ON_SHOWER:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.turn_on_shower_instructions);
				}

				if (!taskText.isTweenedIn())
					return;

				if (bedroom.showerIsRunning())
				{
					taskText.tweenOut();
					task = SHOWER;
				}

			case SHOWER:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.shower_instructions);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!bedroom.showerIsRunning())
				{
					taskText.tweenOut();
					task = TURN_ON_SHOWER;
				}
				else if (bedroom.hasFinishedShowering(parent))
				{
					taskText.tweenOut();
					if ((child1.alive && child1.inBed) || (child2.alive && child2.inBed) || (child3.alive && child3.inBed))
						task = GO_TO_KIDS_ROOM;
					else
						task = TAKE_KIDS_TO_LIVING_ROOM;
				}

			case GO_TO_KIDS_ROOM:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.go_to_kids_instructions);
				}

				if (!taskText.isTweenedIn())
					return;

				if (kidsRoom.contains(parent))
				{
					taskText.tweenOut();
					if (numLivingChildren() > 0)
						task = WAKE_KIDS;
					else
						task = GET_BREAKFAST_FROM_FRIDGE;
				}

			case WAKE_KIDS:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.wake_up_kids_instructions);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((!child1.alive || child1.active) && (!child2.alive || child2.active) && (!child3.alive || child3.active) && taskText.isTweenedIn())
				{
					taskText.tweenOut();
					task = TAKE_KIDS_TO_LIVING_ROOM;
				}

			case TAKE_KIDS_TO_LIVING_ROOM:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.go_to_living_room_instructions);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((livingRoom.contains(child1) || !child1.alive)
					&& (livingRoom.contains(child2) || !child2.alive)
					&& (livingRoom.contains(child3) || !child3.alive)
					&& livingRoom.contains(parent))
				{
					taskText.tweenOut();
					task = GET_BREAKFAST_FROM_FRIDGE;
				}

			case GET_BREAKFAST_FROM_FRIDGE:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.get_breakfast_for_kids);
					else
						taskText.tweenIn(Global.strings.PlayState.get_breakfast_alone);

					child1.setHungry(true);
					child2.setHungry(true);
					child3.setHungry(true);
				}

				if (!taskText.isTweenedIn())
					return;

				if (livingRoom.foodAvailable())
				{
					taskText.tweenOut();
					if (numLivingChildren() > 0)
						task = FEED_KIDS_BREAKFAST;
					else
						task = TAKE_KIDS_TO_GARDEN;
				}

			case FEED_KIDS_BREAKFAST:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.feed_the_kids);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!child1.isHungry() && !child2.isHungry() && !child3.isHungry())
				{
					taskText.tweenOut();
					task = TAKE_KIDS_TO_GARDEN;
				}

			case TAKE_KIDS_TO_GARDEN:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.take_kids_to_garden);
					else
						taskText.tweenIn(Global.strings.PlayState.go_to_garden);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((garden.contains(child1) || !child1.alive)
					&& (garden.contains(child2) || !child2.alive)
					&& (garden.contains(child3) || !child3.alive)
					&& garden.contains(parent))
				{
					taskText.tweenOut();
					task = TAKE_KIDS_INSIDE_FROM_GARDEN;
					// garden.lock.lock();
				}

			case MOW_THE_LAWN:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.start_mow_lawn);
				}

				if (!taskText.isTweenedIn())
					return;

				if (garden.grassMowed())
				{
					taskText.tweenOut();
					task = TAKE_KIDS_INSIDE_FROM_GARDEN;
					garden.lock.unlock();
				}

			case TAKE_KIDS_INSIDE_FROM_GARDEN:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.mow_lawn);
					else
						taskText.tweenIn(Global.strings.PlayState.mow_lawn_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((!garden.contains(child1) || !child1.alive)
					&& (!garden.contains(child2) || !child2.alive)
					&& (!garden.contains(child3) || !child3.alive)
					&& !garden.contains(parent))
				{
					taskText.tweenOut();
					task = TAKE_KIDS_TO_FRONT_OF_HOUSE;
				}

			case TAKE_KIDS_TO_FRONT_OF_HOUSE:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.go_to_front);
					else
						taskText.tweenIn(Global.strings.PlayState.go_to_front_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((frontOfHouse.contains(child1) || !child1.alive)
					&& (frontOfHouse.contains(child2) || !child2.alive)
					&& (frontOfHouse.contains(child3) || !child3.alive)
					&& frontOfHouse.contains(parent))
				{
					taskText.tweenOut();
					task = PUT_KIDS_ON_BUS;
				}

			case PUT_KIDS_ON_BUS:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.get_on_bus);
					else
						taskText.tweenIn(Global.strings.PlayState.get_on_bus_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if (frontOfHouse.busDeparted())
				{
					taskText.tweenOut();
					task = NONE;

					FlxG.camera.fade(0xFF000000, FADE_TIME, false, frontOfHouseFadedToBlack);
				}

			case AT_PLAYGROUND:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
					{
						var taskString:String = playground.getNewestTask();
						if (taskString != "")
						{
							taskText.tweenIn(taskString);
						}
					}
					else
					{
						taskText.tweenIn(Global.strings.PlayState.remember);
					}
				}

				if (!taskText.isTweenedIn())
					return;

				if (numLivingChildren() > 0)
				{
					if (playground.checkTaskComplete())
					{
						taskText.tweenOut();
						playgroundWatchingsComplete++;
					}

					if (playgroundWatchingsComplete > MIN_PLAYGROUND_WATCHINGS)
					{
						taskText.tweenOut();
						task = LEAVE_PLAYGROUND;
					}
				}
				else
				{
					taskText.tweenOut();
					task = LEAVE_PLAYGROUND;
				}

			case LEAVE_PLAYGROUND:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.leave_playground);
					else
						taskText.tweenIn(Global.strings.PlayState.leave_playground_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!playground.contains(child1) && !playground.contains(child2) && !playground.contains(child3))
				{
					playground.lock.unlock();
				}

				if (!playground.contains(parent))
				{
					taskText.tweenOut();
					task = NONE;

					FlxG.camera.fade(0xFF000000, FADE_TIME, false, playgroundFadedToBlack);
				}

			case AT_PARK:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
					{
						taskText.tweenIn(Global.strings.PlayState.play_ball);
						parent.startPlayingBall();
						child1.setMovementMode(CHASE);
						child1.setTarget(park.getBall());
						child2.setMovementMode(CHASE);
						child2.setTarget(park.getBall());
						child3.setMovementMode(CHASE);
						child3.setTarget(park.getBall());
					}
					else
					{
						taskText.tweenIn(Global.strings.PlayState.remember);
					}
				}

				if (!taskText.isTweenedIn())
					return;

				if (numDeadChildren() == 3 || parent.getPlayingBallTotal() > MIN_PLAYING_BALL_TOUCHES)
				{
					taskText.tweenOut();

					child1.setHungry(true);
					child2.setHungry(true);
					child3.setHungry(true);

					if (numLivingChildren() > 0)
						task = FEED_KIDS_LUNCH;
					else
						task = LEAVE_PARK;
				}

			case FEED_KIDS_LUNCH:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.have_lunch);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!child1.isHungry() && !child2.isHungry() && !child3.isHungry())
				{
					taskText.tweenOut();
					task = LEAVE_PARK;
				}

			case LEAVE_PARK:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.leave_park);
					else
						taskText.tweenIn(Global.strings.PlayState.leave_park_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!park.contains(child1) && !park.contains(child2) && !park.contains(child3))
				{
					child1.setTarget(parent);
					child1.setMovementMode(WANDER_FOLLOW);
					child2.setTarget(parent);
					child2.setMovementMode(WANDER_FOLLOW);
					child3.setTarget(parent);
					child3.setMovementMode(WANDER_FOLLOW);

					park.lock.unlock();
				}

				if (!park.contains(parent))
				{
					taskText.tweenOut();

					task = NONE;

					FlxG.camera.fade(0xFF000000, FADE_TIME, false, parkFadedToBlack);
				}

			case AT_BEACH:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.supervise_swimming);
					else
						taskText.tweenIn(Global.strings.PlayState.remember);
				}

				if (!taskText.isTweenedIn())
					return;

				if (numDeadChildren() == 3 || totalSwimTime > MIN_TOTAL_SWIM_TIME)
				{
					taskText.tweenOut();
					task = LEAVE_BEACH;
				}

			case LEAVE_BEACH:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.leave_beach);
					else
						taskText.tweenIn(Global.strings.PlayState.leave_beach_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!beachLeft.contains(child1) && !beachMiddle.contains(child1) && !beachRight.contains(child1) && !beachLeft.contains(child2)
					&& !beachMiddle.contains(child2) && !beachRight.contains(child2) && !beachLeft.contains(child3) && !beachMiddle.contains(child3)
					&& !beachRight.contains(child3))
				{
					beachMiddle.lock.unlock();
				}

				if (!beachLeft.contains(parent) && !beachMiddle.contains(parent) && !beachRight.contains(parent))
				{
					taskText.tweenOut();

					task = NONE;

					FlxG.camera.fade(0xFF000000, FADE_TIME, false, beachFadedToBlack);
				}

			case TAKE_KIDS_INSIDE_HOUSE:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.go_inside);
					else
						taskText.tweenIn(Global.strings.PlayState.go_inside_alone);
					// frontOfHouse.resetBusNoPassengers();
				}

				if (!taskText.isTweenedIn())
					return;

				// NOTE THIS WILL WORK IF YOU WALK OFF SCREEN, SO IT'S NOT GOOD ENOUGH.
				if ((!child1.alive || child1.place != frontOfHouse)
					&& (!child2.alive || child2.place != frontOfHouse)
					&& (!child3.alive || child3.place != frontOfHouse)
					&& parent.place == livingRoom)
				{
					taskText.tweenOut();

					livingRoom.resetFoodRemaining();

					if (!livingRoom.foodAvailable())
					{
						task = GET_DINNER_FROM_FRIDGE;
					}
					else
					{
						task = FEED_KIDS_DINNER;
					}
				}

			case GET_DINNER_FROM_FRIDGE:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.get_dinner);
					else
						taskText.tweenIn(Global.strings.PlayState.get_dinner_alone);

					child1.setHungry(true);
					child2.setHungry(true);
					child3.setHungry(true);
				}

				if (!taskText.isTweenedIn())
					return;

				if (livingRoom.foodAvailable())
				{
					taskText.tweenOut();
					if (numLivingChildren() > 0)
						task = FEED_KIDS_DINNER;
					else
						task = TAKE_KIDS_TO_BEDROOM;
				}

			case FEED_KIDS_DINNER:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.feed_the_kids);

					child1.setHungry(true);
					child2.setHungry(true);
					child3.setHungry(true);
				}

				if (!taskText.isTweenedIn())
					return;

				if (!child1.isHungry() && !child2.isHungry() && !child3.isHungry())
				{
					taskText.tweenOut();

					task = TAKE_KIDS_TO_BEDROOM;
				}

			case TAKE_KIDS_TO_BEDROOM:
				if (taskText.isTweenedOut())
				{
					if (numLivingChildren() > 0)
						taskText.tweenIn(Global.strings.PlayState.go_to_bedroom);
					else
						taskText.tweenIn(Global.strings.PlayState.go_to_bedroom_alone);
				}

				if (!taskText.isTweenedIn())
					return;

				if ((kidsRoom.contains(child1) || !child1.alive)
					&& (kidsRoom.contains(child2) || !child2.alive)
					&& (kidsRoom.contains(child3) || !child3.alive)
					&& kidsRoom.contains(parent))
				{
					taskText.tweenOut();

					if (numLivingChildren() > 0)
						task = PUT_KIDS_TO_BED;
					else
						task = GO_TO_BED;
				}

			case PUT_KIDS_TO_BED:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.put_kids_to_bed);

					child1.setTired(true);
					child2.setTired(true);
					child3.setTired(true);
				}

				if (!taskText.isTweenedIn())
					return;

				if (child1.isInBed() && child2.isInBed() && child3.isInBed())
				{
					taskText.tweenOut();

					task = GO_TO_BED;
				}

			case GO_TO_BED:
				if (taskText.isTweenedOut())
				{
					taskText.tweenIn(Global.strings.PlayState.go_to_bed);
				}

				if (!taskText.isTweenedIn())
					return;

				if (parent.isInBed())
				{
					taskText.tweenOut();
					task = NONE;
					state = PLAY_TO_GAME_OVER;

					new FlxTimer().start().start(1, playFadedToGameOver);
				}

			case NONE:
		}

		if (task != processedTask && task != NONE)
		{
			// trace("Saving after task completion.");
			save();
		}
	}

	private function updateDanger():Void
	{
		if (parent.place == null)
		{
			dangerText.tweenOut(true);
			dangerText2.tweenOut(true);
		}
		else
		{
			switch (parent.place.location)
			{
				case BEDROOM:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case HALLWAY:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case KIDS_ROOM:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case BATHROOM:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case LIVING_ROOM:
					dangerText.tweenIn(Global.strings.PlayState.electricity_danger);
					if (livingRoom.foodAvailable())
					{
						dangerText2.y = dangerText.y + dangerText.height + 8;
						dangerText2.tweenIn(Global.strings.PlayState.choking_danger);
					}
					else
					{
						dangerText2.tweenOut();
					}

				case GARDEN:
					dangerText.tweenIn(Global.strings.PlayState.poison_danger);
					dangerText2.tweenOut(true);

				case FRONT_OF_HOUSE:
					dangerText.tweenIn(Global.strings.PlayState.traffic_danger);
					dangerText2.y = dangerText.y + dangerText.height + 8;
					dangerText2.tweenIn(Global.strings.PlayState.keep_in_sight);

				case PLAYGROUND:
					dangerText.tweenIn(Global.strings.PlayState.slide_danger);
					if (task == AT_PLAYGROUND)
					{
						dangerText2.y = dangerText.y + dangerText.height + 8;
						dangerText2.tweenIn(Global.strings.PlayState.playground_area_danger);
					}

				case PARK:
					if (task == AT_PARK || task == FEED_KIDS_LUNCH)
					{
						dangerText.tweenIn(Global.strings.PlayState.park_area_danger);
					}
					else
					{
						dangerText.tweenOut();
					}

					if (park.foodAvailable())
					{
						dangerText2.y = dangerText.y + dangerText.height + 8;
						dangerText2.tweenIn(Global.strings.PlayState.choking_danger);
					}
					else
					{
						dangerText2.tweenOut(true);
					}

				case BEACH:
					dangerText.tweenIn(Global.strings.PlayState.swimming_danger);

					if (task == AT_BEACH)
					{
						dangerText2.y = dangerText.y + dangerText.height + 8;
						dangerText2.tweenIn(Global.strings.PlayState.beach_area_danger);
					}

				case MENU:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case GRAVEYARD:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case CELL:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);

				case UNKNOWN:
					dangerText.tweenOut(true);
					dangerText2.tweenOut(true);
			}
		}
	}

	private function updateJostles():Void
	{
		if (kidsRoom.contains(parent) && (task == WAKE_KIDS || task == GET_UP || task == TURN_ON_SHOWER || task == SHOWER))
		{
			if (kidsRoom.singleBedWasJostled())
			{
				if (child1.hidden && child1.alive)
				{
					kidsRoom.wakeFromSingleBed(child1);
				}
			}

			if (kidsRoom.bunkBedWasJostled())
			{
				kidsRoom.emptyBunkBed();

				if (child2.hidden && child2.alive)
				{
					kidsRoom.wakeFromBunkbed(child2, 0);
				}

				if (child3.hidden && child3.alive)
				{
					kidsRoom.wakeFromBunkbed(child3, Std.int(child3.hit.width));
				}
			}
		}

		if (livingRoom.contains(parent))
		{
			if (livingRoom.fridgeWasJostled() && livingRoom.foodRemaining())
			{
				livingRoom.fridgeEmitFood();
			}
		}
	}

	private function updatePlaces():Void
	{
		for (i in 0...places.length)
		{
			places[i].update();
		}

		// I'm leaving the beach stuff here because it's complicated by the three place split.
		if (parent.place == beachMiddle)
		{
			if (!parent.isDead())
			{
				if (beachLeft.contains(parent))
					FlxG.camera.focusOn(beachLeft.FOCUS_POINT);
				if (beachMiddle.contains(parent))
					FlxG.camera.focusOn(beachMiddle.FOCUS_POINT);
				if (beachRight.contains(parent))
					FlxG.camera.focusOn(beachRight.FOCUS_POINT);
			}

			if (task == AT_BEACH)
			{
				totalSwimTime += beachLeft.checkSwimming(child1) + beachLeft.checkSwimming(child2) + beachLeft.checkSwimming(child3);
				totalSwimTime += beachMiddle.checkSwimming(child1) + beachMiddle.checkSwimming(child2) + beachMiddle.checkSwimming(child3);
				totalSwimTime += beachRight.checkSwimming(child1) + beachRight.checkSwimming(child2) + beachRight.checkSwimming(child3);
			}

			if (state == PLAY)
			{
				beachMiddle.checkDrowning(parent);
				beachMiddle.checkDrowning(child1);
				beachMiddle.checkDrowning(child2);
				beachMiddle.checkDrowning(child3);
			}

			if (task != LEAVE_BEACH)
			{
				if (child1.alive && (!beachLeft.contains(child1) && !beachMiddle.contains(child1) && !beachRight.contains(child1)))
				{
					child1.die(Global.strings.PlayState.got_lost);
				}
				if (child2.alive && (!beachLeft.contains(child2) && !beachMiddle.contains(child2) && !beachRight.contains(child2)))
				{
					child2.die(Global.strings.PlayState.got_lost);
				}
				if (child3.alive && (!beachLeft.contains(child3) && !beachMiddle.contains(child3) && !beachRight.contains(child3)))
				{
					child3.die(Global.strings.PlayState.got_lost);
				}
			}
		}
	}

	private function updateDeath():Void
	{
		// If one of the kids just started dying from something then we save so they can't get out of it
		// by just reloading the game.

		if (!music.playing && !child1.isDying() && !child2.isDying() && !child3.isDying() && !parent.isDying())
		{
			// trace("Restarting music due to no one dying.");
			music.playing = true;
		}

		if (child1.didJustStartDying() || child2.didJustStartDying() || child3.didJustStartDying())
		{
			save();

			// trace("Stopping music due to someone starting to die...");
			music.playing = false;
		}

		// Now we check if anyone is actually dead.

		if (child1.justDied() || child2.justDied() || child3.justDied() || parent.justDied())
		{
			frontOfHouse.stopCars();

			if (child1.isDying() || child2.isDying() || child3.isDying() || parent.isDying())
				return;

			// Save on death to make sure we can restart from the beginning
			// task = GET_UP;
			// Need to reset other stuff before restart, like the fridge
			// livingRoom.resetFoodRemaining();

			// save();

			// trace("Stopping music due to a death.");

			music.playing = false;

			child1.setHungry(false);
			child2.setHungry(false);
			child3.setHungry(false);

			deathSave();

			parent.active = false;

			child1.active = false;
			child2.active = false;
			child3.active = false;

			// Now go through the death notice etc.
			state = PLAY_TO_DEATH_NOTICE;
			// FlxG.camera.fade(0xFF000000,0.5,false,playFadedToDeathNotice);

			new FlxTimer().start().start(1, playFadedToDeathNotice);
		}
	}

	// private function playFadedToDeathNotice():Void
	private function playFadedToDeathNotice(t:FlxTimer):Void
	{
		// FlxG.camera.stopFX();

		dangerText.visible = false;
		dangerText2.visible = false;
		taskText.visible = false;
		taskText.tweenOut();

		// blackBG.visible = true;

		var text:String = "\n";

		var theDead:Array<Person> = new Array();
		if (parent.justDied())
			theDead.push(parent);
		if (child1.justDied())
			theDead.push(child1);
		if (child2.justDied())
			theDead.push(child2);
		if (child3.justDied())
			theDead.push(child3);

		for (i in 0...theDead.length)
		{
			var person = "Someone";
			var cause = "died";
			if (theDead[i].kind == PARENT)
			{
				person = Global.strings.PlayState.you;
				cause = cast(theDead[i], Parent).getCauseOfDeath();
			}
			else
			{
				person = cast(theDead[i], Child).name;
				cause = cast(theDead[i], Child).getCauseOfDeath();
			}
			text += person + " " + cause + ".\n";
		}

		text += "\n";

		deathNoticeText.setText(text);
		deathNoticeText.y = FlxG.height / 2 - deathNoticeText.height / 2;
		deathNoticeText.visible = true;

		new FlxTimer().start().start(5, deathNoticeTimerFinished);
	}

	private function deathNoticeTimerFinished(t:FlxTimer):Void
	{
		deathNoticeText.visible = false;

		state = DEATH_NOTICE_TO_BLACK;

		// FlxG.camera.stopFX();
		FlxG.camera.fade(0xFF000000, DEATH_FADE_TIME, false, deathNoticeFadedToBlack);
	}

	private function deathNoticeFadedToBlack():Void
	{
		// blackBG.visible = false;
		// deathNoticeText.visible = false;

		// If parent is dead we start a new game (with them dead)
		if (parent.isDead())
		{
			FlxG.switchState(new PlayState());
		}
		// If parent's still alive so we go to the graveyard
		else
		{
			child1.unhide();
			child2.unhide();
			child3.unhide();

			graveyard.setupGravestones(numDeadChildren(), false);

			parent.moveTo(graveyard.FOCUS_POINT.x, graveyard.FOCUS_POINT.y, graveyard);

			child1.moveTo(parent.x - child1.width, parent.y + parent.height, graveyard);
			child2.moveTo(parent.x, parent.y + parent.height, graveyard);
			child3.moveTo(parent.x + parent.width, parent.y + parent.height, graveyard);

			state = BLACK_TO_GRAVEYARD;

			FlxG.camera.focusOn(graveyard.FOCUS_POINT);

			FlxG.camera.stopFX();
			FlxG.camera.fade(0xFF000000, DEATH_FADE_TIME, true, blackFadedToGraveyard);
		}
	}

	private function blackFadedToGraveyard():Void
	{
		FlxG.camera.stopFX();
		state = GRAVEYARD;

		parent.active = true;

		child1.setTarget(parent);
		child2.setTarget(parent);
		child3.setTarget(parent);

		child1.setMovementMode(FOLLOW);
		child2.setMovementMode(FOLLOW);
		child3.setMovementMode(FOLLOW);

		// task = MOURN_CHILD;
		task = NONE;
		taskText.visible = true;
	}

	private function graveyardFadedToBlack():Void
	{
		parent.place = menu;

		task = GET_UP;

		save();

		FlxG.switchState(new PlayState());
	}

	private function blackFadedToMenu():Void
	{
		state = MENU;
		task = NONE;
	}

	public static inline function sortBySortKey(Order:Int, Sprite1:Sortable, Sprite2:Sortable):Int
	{
		return FlxSort.byValues(Order, Sprite1.sortKey, Sprite2.sortKey);
	}

	// TRANSITIONS

	private function menuFadedToBlack():Void
	{
		state = BLACK_TO_PLAY;

		child1.hide();
		child2.hide();
		child3.hide();

		if (!parent.isDead())
		{
			if (bedroom.bed.hit.y + bedroom.bed.hit.height / 2 < bedroom.ORIGIN_Y + FlxG.height / 2)
			{
				parent.moveTo(bedroom.bed.hit.x
					+ bedroom.bed.width
					- parent.width,
					bedroom.bed.hit.y
					+ bedroom.bed.hit.height
					- parent.height
					+ parent.hit.height, bedroom);
			}
			else
			{
				parent.moveTo(bedroom.bed.hit.x + bedroom.bed.width - parent.width, bedroom.bed.hit.y - parent.height, bedroom);
			}

			parent.hide();
			// parent.moveTo(bedroom.FOCUS_POINT.x,bedroom.FOCUS_POINT.y,BEDROOM);

			// trace("Camera focus on bedroom.");
			alarm.play(true);

			FlxG.camera.focusOn(bedroom.FOCUS_POINT);

			state = ALARM;

			new FlxTimer().start().start(2, alarmClockDelayTimer);

			// FlxG.camera.stopFX();
			// FlxG.camera.fade(0xff000000,FADE_TIME,true,blackFadedToPlay);
		}
		else
		{
			graveyard.setupGravestones(numDeadChildren(), true);
			parent.moveTo(graveyard.FOCUS_POINT.x, graveyard.FOCUS_POINT.y, bedroom);
			bedroom.emptyBed();

			FlxG.camera.stopFX();
			FlxG.camera.fade(0xff000000, FADE_TIME, true, blackFadedToPlay);
		}
	}

	private function alarmClockDelayTimer(t:FlxTimer):Void
	{
		state = BLACK_TO_PLAY;
		FlxG.camera.stopFX();
		FlxG.camera.fade(0xff000000, FADE_TIME, true, blackFadedToPlay);
	}

	private function blackFadedToPlay():Void
	{
		if (!parent.isDead())
		{
			state = PLAY;
		}
		else
		{
			state = DEAD_PLAY;
			taskText.tweenIn(Global.strings.PlayState.return_to_grave);
		}

		parent.active = true;
	}

	private function frontOfHouseFadedToBlack():Void
	{
		parent.unhide();
		child1.unhide();
		child2.unhide();
		child3.unhide();

		parent.active = false;
		child1.active = false;
		child2.active = false;
		child3.active = false;

		parent.moveTo(playground.FOCUS_POINT.x - parent.width / 2, playground.FOCUS_POINT.y + 120, playground);
		child1.moveTo(parent.x - child1.width, parent.hit.y - child1.height - 8, playground);
		child2.moveTo(parent.x, parent.hit.y - child2.height - 8, playground);
		child3.moveTo(parent.x + child1.width, parent.hit.y - child3.height - 8, playground);

		FlxG.camera.focusOn(playground.FOCUS_POINT);
		FlxG.camera.stopFX();
		FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToPlayground);
	}

	private function blackFadedToPlayground():Void
	{
		parent.active = true;

		child1.active = child1.alive;
		child2.active = child2.alive;
		child3.active = child3.alive;

		task = AT_PLAYGROUND;

		save();
	}

	private function playgroundFadedToBlack():Void
	{
		// trace("playgroundFadedToBlack");

		parent.unhide();

		child1.unhide();
		child2.unhide();
		child3.unhide();

		parent.active = false;

		child1.active = false;
		child2.active = false;
		child3.active = false;

		parent.moveTo(park.FOCUS_POINT.x, park.FOCUS_POINT.y + 100, park);
		child1.moveTo(park.FOCUS_POINT.x - 60, park.FOCUS_POINT.y + 80, park);
		child2.moveTo(park.FOCUS_POINT.x, park.FOCUS_POINT.y + 80, park);
		child3.moveTo(park.FOCUS_POINT.x + 60, park.FOCUS_POINT.y + 80, park);

		FlxG.camera.focusOn(park.FOCUS_POINT);
		FlxG.camera.stopFX();
		FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToPark);
	}

	private function blackFadedToPark():Void
	{
		// trace("blackFadedToPark");

		parent.active = true;

		child1.active = child1.alive;
		child2.active = child2.alive;
		child3.active = child3.alive;

		task = AT_PARK;

		save();
	}

	private function parkFadedToBlack():Void
	{
		parent.unhide();

		child1.unhide();
		child2.unhide();
		child3.unhide();

		parent.active = false;
		child1.active = false;
		child2.active = false;
		child3.active = false;

		parent.moveTo(beachMiddle.FOCUS_POINT.x, beachMiddle.FOCUS_POINT.y + 100, beachMiddle);
		child1.moveTo(beachMiddle.FOCUS_POINT.x - 60, beachMiddle.FOCUS_POINT.y + 80, beachMiddle);
		child2.moveTo(beachMiddle.FOCUS_POINT.x, beachMiddle.FOCUS_POINT.y + 80, beachMiddle);
		child3.moveTo(beachMiddle.FOCUS_POINT.x + 60, beachMiddle.FOCUS_POINT.y + 80, beachMiddle);

		FlxG.camera.focusOn(beachMiddle.FOCUS_POINT);
		FlxG.camera.stopFX();
		FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToBeach);
	}

	private function blackFadedToBeach():Void
	{
		parent.active = true;

		child1.active = child1.alive;
		child2.active = child2.alive;
		child3.active = child3.alive;

		task = AT_BEACH;

		save();
	}

	private function beachFadedToBlack():Void
	{
		parent.unhide();

		child1.unhide();
		child2.unhide();
		child3.unhide();

		parent.active = false;
		child1.active = false;
		child2.active = false;
		child3.active = false;

		parent.moveTo(frontOfHouse.FOCUS_POINT.x + 170, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 180, frontOfHouse);
		child1.moveTo(frontOfHouse.FOCUS_POINT.x + 120, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 160, frontOfHouse);
		child2.moveTo(frontOfHouse.FOCUS_POINT.x + 80, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 140, frontOfHouse);
		child3.moveTo(frontOfHouse.FOCUS_POINT.x + 40, frontOfHouse.FOCUS_POINT.y + FlxG.height / 2 - 120, frontOfHouse);

		child1.setTarget(parent);
		child1.setMovementMode(WANDER_FOLLOW);
		child2.setTarget(parent);
		child2.setMovementMode(WANDER_FOLLOW);
		child3.setTarget(parent);
		child3.setMovementMode(WANDER_FOLLOW);
		child1.pause();
		child2.pause();
		child3.pause();

		frontOfHouse.resetBusNoPassengers();

		FlxG.camera.focusOn(frontOfHouse.FOCUS_POINT);
		FlxG.camera.stopFX();
		FlxG.camera.fade(0xFF000000, FADE_TIME, true, blackFadedToFrontOfHouse);
	}

	private function blackFadedToFrontOfHouse():Void
	{
		parent.active = true;

		child1.active = child1.alive;
		child2.active = child2.alive;
		child3.active = child3.alive;

		task = TAKE_KIDS_INSIDE_HOUSE;

		save();
	}

	// private function playFadedToGameOver():Void
	private function playFadedToGameOver(t:FlxTimer):Void
	{
		// FlxG.camera.stopFX();

		// blackBG.visible = true;

		var gameOverText:FlxTextWithBG = new FlxTextWithBG(48, 80, FlxG.width - 96, "\n" + Global.strings.PlayState.game_over, 24, "center", 0xFFFFFFFF,
			0xFF000000, true, LEFT, 1, 24);
		var gameOverDetails:FlxTextWithBG = new FlxTextWithBG(48, 80, FlxG.width - 96, "", 12, "center", 0xFFFFFFFF, 0xFF000000, true, LEFT, 1, 24);

		// var gameOverText:FlxText = new FlxText(0,0,FlxG.width,"",24);
		// gameOverText.scrollFactor.x = 0;
		// gameOverText.scrollFactor.y = 0;
		// gameOverText.setFormat(null,24,0xFFFFFFFF,"center");

		var text:String = "";
		text += "\n";

		// text += "The game is over.\n\n";

		var deadChildren:Array<Child> = new Array();
		var livingChildren:Array<Child> = new Array();
		if (!child1.alive)
			deadChildren.push(child1);
		else
			livingChildren.push(child1);
		if (!child2.alive)
			deadChildren.push(child2);
		else
			livingChildren.push(child2);
		if (!child3.alive)
			deadChildren.push(child3);
		else
			livingChildren.push(child3);

		var regex1 = ~/%(NAME1)%/g;
		var regex2 = ~/%(NAME2)%/g;
		var regex3 = ~/%(NAME3)%/g;
		var deadString = "";

		if (parent.isDead())
		{
			deadString += Global.strings.PlayState.you_are_dead;

			if (numLivingChildren() == 3)
			{
				deadString += Global.strings.you_dead_3_children_survived;
				deadString = regex1.replace(deadString, child1.name);
				deadString = regex2.replace(deadString, child2.name);
				deadString = regex3.replace(deadString, child3.name);
			}
			else if (numLivingChildren() == 2)
			{
				deadString += Global.strings.you_dead_2_children_survived;
				deadString = regex1.replace(deadString, deadChildren[0].name);
				deadString = regex2.replace(deadString, livingChildren[0].name);
				deadString = regex3.replace(deadString, livingChildren[1].name);
			}
			else if (numLivingChildren() == 1)
			{
				deadString += Global.strings.you_dead_1_child_survived;
				deadString = regex1.replace(deadString, deadChildren[0].name);
				deadString = regex2.replace(deadString, deadChildren[1].name);
				deadString = regex3.replace(deadString, livingChildren[0].name);
			}
			else
			{
				deadString += Global.strings.you_dead_0_children_survived;
				deadString = regex1.replace(deadString, deadChildren[0].name);
				deadString = regex2.replace(deadString, deadChildren[1].name);
				deadString = regex3.replace(deadString, deadChildren[2].name);
			}
		}
		else if (numLivingChildren() == 3)
		{
			deadString = Global.strings.PlayState.you_lived_3_children_survived;
		}
		else if (numLivingChildren() == 2)
		{
			deadString += Global.strings.you_lived_2_children_survived;
			deadString = regex1.replace(deadString, deadChildren[0].name);
			deadString = regex2.replace(deadString, livingChildren[0].name);
			deadString = regex3.replace(deadString, livingChildren[1].name);
		}
		else if (numLivingChildren() == 1)
		{
			deadString += Global.strings.you_lived_1_child_survived;
			deadString = regex1.replace(deadString, deadChildren[0].name);
			deadString = regex2.replace(deadString, deadChildren[1].name);
			deadString = regex3.replace(deadString, livingChildren[0].name);
		}
		else
		{
			text += Global.strings.you_lived_0_children_survived;
		}

		text += "\n\n( " + Global.strings.PlayState.new_game + " )\n\n\n";

		gameOverDetails.setText(text);

		gameOverText.y = FlxG.height / 2 - (gameOverText.height + gameOverDetails.height) / 2;
		gameOverDetails.y = gameOverText.y + gameOverText.height;

		ui.add(gameOverText);
		ui.add(gameOverDetails);

		state = GAME_OVER;
	}

	private function numLivingChildren():Int
	{
		var num:Int = 0;
		if (child1.alive)
			num++;
		if (child2.alive)
			num++;
		if (child3.alive)
			num++;

		return num;
	}

	private function numDeadChildren():Int
	{
		return 3 - numLivingChildren();
	}

	private function save():Void
	{
		// trace("Normal save.");
		// Save people

		FlxG.save.data.camera_focus_x = FlxG.camera.x + FlxG.width / 2;
		FlxG.save.data.camera_focus_y = FlxG.camera.y + FlxG.height / 2;

		FlxG.save.data.parentPosition = new FlxPoint(parent.x, parent.y);
		FlxG.save.data.parentLocation = parent.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(parent.place.location);
		FlxG.save.data.parentDead = parent.isDead();

		FlxG.save.data.child1_alive = child1.alive;
		FlxG.save.data.child1_hidden = child1.hidden;
		FlxG.save.data.child1Position = new FlxPoint(child1.x, child1.y);
		FlxG.save.data.child1Location = child1.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child1.place.location);
		FlxG.save.data.child1name = child1.name;
		FlxG.save.data.child1_movement_mode = Std.string(child1.movementMode);
		FlxG.save.data.child1_in_bed = child1.isInBed();

		FlxG.save.data.child1_dying = child1.isDying();
		FlxG.save.data.child1_dying_state = Std.string(child1.state);

		FlxG.save.data.child2_alive = child2.alive;
		FlxG.save.data.child2_hidden = child2.hidden;
		FlxG.save.data.child2Position = new FlxPoint(child2.x, child2.y);
		FlxG.save.data.child2Location = child2.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child2.place.location);
		FlxG.save.data.child2name = child2.name;
		FlxG.save.data.child2_movement_mode = Std.string(child2.movementMode);
		FlxG.save.data.child2_in_bed = child2.isInBed();

		FlxG.save.data.child2_dying = child2.isDying();
		FlxG.save.data.child2_dying_state = Std.string(child2.state);

		FlxG.save.data.child3_alive = child3.alive;
		FlxG.save.data.child3_hidden = child3.hidden;
		FlxG.save.data.child3Position = new FlxPoint(child3.x, child3.y);
		FlxG.save.data.child3Location = child3.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child3.place.location);
		FlxG.save.data.child3name = child3.name;
		FlxG.save.data.child3_movement_mode = Std.string(child3.movementMode);
		FlxG.save.data.child3_in_bed = child3.isInBed();

		FlxG.save.data.child3_dying = child3.isDying();
		FlxG.save.data.child3_dying_state = Std.string(child3.state);

		// Save task status (this kind of save wants to maintain task status)

		FlxG.save.data.currentTask = Std.string(task);

		// Save places
		bedroom.save();
		kidsRoom.save();
		hallway.save();
		bathroom.save();
		livingRoom.save();
		garden.save();
		frontOfHouse.save();
		playground.save();
		park.save();
		beachLeft.save();
		beachMiddle.save();
		beachRight.save();

		menu.save();

		// Flush
		FlxG.save.flush();
	}

	private function deathSave():Void
	{
		// trace("Death save");

		FlxG.save.data.camera_focus_x = FlxG.camera.x + FlxG.width / 2;
		FlxG.save.data.camera_focus_y = FlxG.camera.y + FlxG.height / 2;

		// Save people
		FlxG.save.data.parentLocation = Std.string(MENU);
		FlxG.save.data.parentPosition = new FlxPoint(parent.x, parent.y);
		FlxG.save.data.parentDead = parent.isDead();

		FlxG.save.data.child1_alive = child1.alive;
		FlxG.save.data.child1_hidden = child1.hidden;
		FlxG.save.data.child1Position = new FlxPoint(child1.x, child1.y);
		FlxG.save.data.child1Location = child1.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child1.place.location);
		FlxG.save.data.child1name = child1.name;
		FlxG.save.data.child1_movement_mode = Std.string(child1.movementMode);
		FlxG.save.data.child1_in_bed = child1.isInBed();

		FlxG.save.data.child2_alive = child2.alive;
		FlxG.save.data.child2_hidden = child2.hidden;
		FlxG.save.data.child2Position = new FlxPoint(child2.x, child2.y);
		FlxG.save.data.child2Location = child2.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child2.place.location);
		FlxG.save.data.child2name = child2.name;
		FlxG.save.data.child2_movement_mode = Std.string(child2.movementMode);
		FlxG.save.data.child2_in_bed = child2.isInBed();

		FlxG.save.data.child3_alive = child3.alive;
		FlxG.save.data.child3_hidden = child3.hidden;
		FlxG.save.data.child3Position = new FlxPoint(child3.x, child3.y);
		FlxG.save.data.child3Location = child3.place == null ? Std.string(Enums.Location.UNKNOWN) : Std.string(child3.place.location);
		FlxG.save.data.child3name = child3.name;
		FlxG.save.data.child3_movement_mode = Std.string(child3.movementMode);
		FlxG.save.data.child3_in_bed = child3.isInBed();

		// Reset task status
		FlxG.save.data.currentTask = null;
		// FlxG.save.data.currentTask = NONE;

		// None of these require resets
		bedroom.save();
		kidsRoom.save();
		hallway.save();
		bathroom.save();

		livingRoom.resetFoodRemaining(); // Reset to allow dispensing again
		// Note that the existing food will still just be there (it's cumulative)
		// so you could end up with up to 90 piece of food in the living room? Too much?
		livingRoom.save();

		// Garden automatically resets grass
		garden.save();

		// Front of house automatically resets bus (has no save at all)
		frontOfHouse.save();

		// No save needed
		playground.save();

		// Need to reset the picnic basket
		FlxG.save.data.park_basket = null;
		park.save();

		// Nothing to save
		beachLeft.save();
		beachMiddle.save();
		beachRight.save();

		// Saves the letters - should they reset? No.
		menu.save();

		// Flush
		FlxG.save.flush();
	}

	private function connectDoors(d1:Door, d2:Door):Void
	{
		d1.toDoor = d2;
		d2.toDoor = d1;
	}

	private function checkDoors():Void
	{
		var startingParentPlace:Place = parent.place;

		FlxG.overlap(doorMovables, doors, null, handleDoorOverlap);
		// How fucking easy was that?!

		if (parent.place != startingParentPlace)
		{
			dangerText.tweenOut(true);
			dangerText2.tweenOut(true);
		}
	}

	private function handleDoorOverlap(o:Dynamic, d:Dynamic):Bool
	{
		var hitSprite:HitSprite = cast(o, HitSprite);
		var physicsSprite:PhysicsSprite = hitSprite.parent;
		var door:Door = cast(d, Door);

		door.handleOverlap(physicsSprite);

		return true;
	}

	private function locationToPlace(L:Enums.Location):Place
	{
		switch (L)
		{
			case BEDROOM:
				return bedroom;
			case HALLWAY:
				return hallway;
			case KIDS_ROOM:
				return kidsRoom;
			case BATHROOM:
				return bathroom;
			case LIVING_ROOM:
				return livingRoom;
			case GARDEN:
				return garden;
			case FRONT_OF_HOUSE:
				return frontOfHouse;
			case PLAYGROUND:
				return playground;
			case PARK:
				return park;
			case BEACH:
				return beachMiddle;
			case CELL:
				return cell;
			case GRAVEYARD:
				return graveyard;
			case MENU:
				return menu;
			case UNKNOWN:
				return null;
		}

		return null;
	}
}
