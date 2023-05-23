package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Park extends Place
{
	public var toBeach:Door;

	private var table:PhysicsSprite;
	private var picnicBasket:PhysicsSprite;
	private var picnicBasketOnTable:Sortable;
	private var ball:PhysicsSprite;

	private var tableWasJostled:Bool = false;
	private var tableJostleForce:FlxPoint;

	private var basketWasJostled:Bool = false;
	private var basketJostleForce:FlxPoint;

	private static var TOTAL_FOODS:Int = 10;
	private static var FOOD_STORAGE_X:Int = -2 * 640;
	private static var FOOD_STORAGE_Y:Int = -4 * 480;

	private var freeFoods:Array<Food>;
	private var foods:FlxGroup;

	public var lock:Lock;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(4.5 * FlxG.width);
		ORIGIN_Y = Std.int(1.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 4 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 4 * 8;

		WIDTH = 72 * 8;
		HEIGHT = 52 * 8;

		location = PARK;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.park_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var floorTile:FlxSprite = new FlxSprite(OFFSET_X, OFFSET_Y, AssetPaths.park_floor_tile__png);
		floorTile.origin.x = floorTile.origin.y = 0;
		floorTile.scale.x = WIDTH;
		floorTile.scale.y = HEIGHT;

		var topWall:Wall = new Wall(OFFSET_X, OFFSET_Y, WIDTH, 8, AssetPaths.park_wall_tile__png);
		// var topLeftWall:Wall = new Wall(OFFSET_X,OFFSET_Y,Std.int((WIDTH - DOOR_WIDTH)/2),8,AssetPaths.park_wall_tile__png);
		// var topRightWall:Wall = new Wall(Std.int(topLeftWall.x + topLeftWall.width + DOOR_WIDTH),OFFSET_Y,Std.int((WIDTH - DOOR_WIDTH)/2),8,AssetPaths.park_wall_tile__png);
		var leftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.park_wall_tile__png);
		var rightWall:Wall = new Wall(OFFSET_X + WIDTH - 8, OFFSET_Y + 8, 8, HEIGHT - 2 * 8, AssetPaths.park_wall_tile__png);
		var bottomLeftWall:Wall = new Wall(OFFSET_X, OFFSET_Y + HEIGHT - 8, Std.int((WIDTH - DOOR_WIDTH) / 2), 8, AssetPaths.park_wall_tile__png);
		var bottomRightWall:Wall = new Wall(Std.int(bottomLeftWall.x + bottomLeftWall.width + DOOR_WIDTH), OFFSET_Y + HEIGHT - 8,
			Std.int((WIDTH - DOOR_WIDTH) / 2), 8, AssetPaths.park_wall_tile__png);

		toBeach = new Door(bottomLeftWall.x + bottomLeftWall.width, bottomLeftWall.y + 2 * 8, this, new FlxPoint(-1, bottomLeftWall.y - 2 * 8),
			"Park.toBeach", DOWN, true);
		doors.push(toBeach);

		lock = new Lock(toBeach.x, toBeach.y, toBeach.width, toBeach.height, true);
		lock.lock();
		lock.visible = false;

		var leftFlowers:PhysicsSprite = new PhysicsSprite(OFFSET_X + 8, OFFSET_Y + 8, AssetPaths.park_left_flowers__png, 1, 1, 1, false);
		var rightFlowers:PhysicsSprite = new PhysicsSprite(OFFSET_X + WIDTH - leftFlowers.width - 8, OFFSET_Y + 8, AssetPaths.park_right_flowers__png, 1, 1,
			1, false);

		table = new PhysicsSprite(OFFSET_X + 30 * 8, OFFSET_Y + 24 * 8, AssetPaths.park_table__png, 1, 0.2, 1, false);

		var leftChair:PhysicsSprite = new PhysicsSprite(table.x - 5 * 8, table.y + -2 * 8, AssetPaths.park_left_chair__png, 1, 0.2, 1, false);
		var rightChair:PhysicsSprite = new PhysicsSprite(table.x + table.width + 1 * 8, table.y + -2 * 8, AssetPaths.park_right_chair__png, 1, 0.2, 1, false);

		if (FlxG.save.data.park_basket == null)
		{
			picnicBasketOnTable = new Sortable(table.x, table.y, AssetPaths.park_picnic_basket__png);
			picnicBasketOnTable.origin.x = picnicBasketOnTable.origin.y = 0;
			picnicBasketOnTable.scale.x = picnicBasketOnTable.scale.y = 8;
			picnicBasketOnTable.width *= picnicBasketOnTable.scale.x;
			picnicBasketOnTable.height *= picnicBasketOnTable.scale.y;

			picnicBasketOnTable.sortKey = table.sortKey;
			picnicBasketOnTable.x = table.x + 3 * 8;
			picnicBasketOnTable.y = table.y - picnicBasketOnTable.height;

			picnicBasket = new PhysicsSprite(FOOD_STORAGE_X, FOOD_STORAGE_Y, AssetPaths.park_picnic_basket__png, 1, 0.2, 1, true);

			table.dispatcher.addEventListener("MEDIUM", handleTableJostle);
			picnicBasket.hide();
		}
		else
		{
			picnicBasketOnTable = new Sortable(table.x, table.y, AssetPaths.park_picnic_basket__png);
			picnicBasketOnTable.origin.x = picnicBasketOnTable.origin.y = 0;
			picnicBasketOnTable.scale.x = picnicBasketOnTable.scale.y = 8;
			picnicBasketOnTable.width *= picnicBasketOnTable.scale.x;
			picnicBasketOnTable.height *= picnicBasketOnTable.scale.y;

			picnicBasketOnTable.sortKey = table.sortKey;
			picnicBasketOnTable.x = table.x + 3 * 8;
			picnicBasketOnTable.y = table.y - picnicBasketOnTable.height;

			picnicBasketOnTable.visible = false;

			picnicBasket = new PhysicsSprite(FlxG.save.data.park_basket.x, FlxG.save.data.park_basket.y, AssetPaths.park_picnic_basket__png, 1, 0.2, 1, true);
		}

		picnicBasket.dispatcher.addEventListener("MEDIUM", handleBasketJostle);

		if (FlxG.save.data.ball == null)
		{
			ball = new Ball(OFFSET_X + 50 * 8, OFFSET_Y + 30 * 8);
			// ball = new PhysicsSprite(OFFSET_X + 50*8,OFFSET_Y + 6*8,AssetPaths.park_ball__png,1,1,0.01,true,false,true,10,2);
		}
		else
		{
			ball = new Ball(FlxG.save.data.ball.x, FlxG.save.data.ball.y);
			// ball = new PhysicsSprite(FlxG.save.data.ball.x,FlxG.save.data.ball.y,AssetPaths.park_ball__png,1,1,0.01,true,false,true,10,2);
		}

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

			if ((i + 1) % 5 == 0)
			{
				foodStartX = FOOD_STORAGE_X;
				foodStartY += 8 * 8;
			}
		}

		if (FlxG.save.data.park_food_locations != null)
		{
			for (i in 0...FlxG.save.data.park_food_locations.length)
			{
				var food:Food = new Food(FlxG.save.data.park_food_locations[i].x, FlxG.save.data.park_food_locations[i].y, i, false);
				display.add(food);
				foods.add(food);
			}
		}

		bg.add(bgTile);
		bg.add(floorTile);
		bg.add(topWall);
		// bg.add(topLeftWall);
		// bg.add(topRightWall);
		bg.add(leftWall);
		bg.add(rightWall);
		bg.add(bottomLeftWall);
		bg.add(bottomRightWall);

		bg.add(leftFlowers);
		bg.add(rightFlowers);

		display.add(table);
		display.add(leftChair);
		display.add(rightChair);
		display.add(picnicBasket);
		display.add(picnicBasketOnTable);
		display.add(ball);

		bg.add(toBeach);
		bg.add(lock);

		for (i in 0...doors.length)
			Doors.add(doors[i]);

		DoorMovables.add(ball.hit);
	}

	override public function destroy():Void
	{
		super.destroy();

		toBeach.destroy();
		table.destroy();
		picnicBasket.destroy();
		picnicBasketOnTable.destroy();
		ball.destroy();
		foods.destroy();
		lock.destroy();

		for (i in 0...freeFoods.length)
			freeFoods[i].destroy();
	}

	override public function update():Void
	{
		if (PlayState.parent.place != this)
			return;

		if (PlayState.task != LEAVE_PARK)
		{
			if (!contains(PlayState.child1) && PlayState.child1.alive)
				PlayState.child1.die(Global.strings.PlayState.got_lost);
			if (!contains(PlayState.child2) && PlayState.child2.alive)
				PlayState.child2.die(Global.strings.PlayState.got_lost);
			if (!contains(PlayState.child3) && PlayState.child3.alive)
				PlayState.child3.die(Global.strings.PlayState.got_lost);
		}

		if (tableWasJostled)
		{
			picnicBasketOnTable.visible = false;

			if (tableJostleForce.y > 0)
			{
				picnicBasket.moveTo(table.hit.x + table.width / 2 - picnicBasket.width / 2, table.y - picnicBasket.height, this);
				picnicBasket.body.applyImpulse(new box2D.common.math.B2Vec2(0, -2 * tableJostleForce.y), picnicBasket.body.getPosition());
			}
			else
			{
				picnicBasket.moveTo(table.hit.x + table.hit.width / 2 - picnicBasket.width / 2, table.hit.y + table.hit.height, this);
				picnicBasket.body.applyImpulse(new box2D.common.math.B2Vec2(0, -2 * tableJostleForce.y), picnicBasket.body.getPosition());
			}

			picnicBasket.unhide();
			tableWasJostled = false;
		}

		if (basketWasJostled)
		{
			basketWasJostled = false;

			var numFoods:Int = Math.floor(Math.random() * 5) + 2;

			for (i in 0...numFoods)
			{
				var food:Food = freeFoods.pop();
				if (food != null)
				{
					food.moveTo(picnicBasket.x + 40 - Math.random() * 80, picnicBasket.hit.y + 20 - Math.random() * 40, this);
					foods.add(food);
				}
			}
		}
	}

	private function handleTableJostle(e:JostleEvent):Void
	{
		tableWasJostled = true;
		tableJostleForce = new FlxPoint(e.velocityX, e.velocityY);

		table.dispatcher.removeEventListener("MEDIUM", handleTableJostle);
	}

	private function handleBasketJostle(e:JostleEvent):Void
	{
		basketWasJostled = true;
		basketJostleForce = new FlxPoint(e.velocityX, e.velocityY);
	}

	public function getBall():PhysicsSprite
	{
		return ball;
	}

	public function foodAvailable():Bool
	{
		return (foods.getFirstAlive() != null);
	}

	override public function save():Void
	{
		if (!picnicBasket.hidden)
		{
			FlxG.save.data.park_basket = new FlxPoint(picnicBasket.x, picnicBasket.y);
		}

		// FlxG.save.data.ball = new FlxPoint(ball.x,ball.y);

		var foodLocations:Array<FlxPoint> = new Array();
		for (i in 0...foods.members.length)
		{
			var f:Food = cast(foods.members[i], Food);
			if (foods.members[i].alive)
				foodLocations.push(new FlxPoint(f.x, f.y));
		}
		FlxG.save.data.park_room_food_locations = foodLocations;
	}
}
