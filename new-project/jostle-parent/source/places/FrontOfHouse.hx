package;

import box2D.common.math.B2Vec2;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class FrontOfHouse extends Place
{
	private static var CAR_IMPULSE:Float = 10000;
	private static var BUS_IMPULSE:Float = 2000;
	private static var CAR_PNGS:Array<String> = [
		AssetPaths.front_of_house_car1__png,
		AssetPaths.front_of_house_car2__png,
		AssetPaths.front_of_house_car4__png,
		AssetPaths.front_of_house_car4__png
	];

	private var crossingTrigger:FlxSprite;
	private var crossing:FlxGroup;

	private var car1Sound:FlxSound;
	private var car2Sound:FlxSound;
	private var busSound:FlxSound;

	public var toLivingRoom:Door;

	private var bus:PhysicsSprite;
	private var busTrigger:FlxSprite;
	private var boarded:Array<Child>;
	private var busDeparting:Bool = false;

	private var car1:PhysicsSprite;
	private var car2:PhysicsSprite;

	private var car1Timer:FlxTimer;
	private var car2Timer:FlxTimer;

	public var moveCars:Bool = true;

	private var parent:Parent;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, Doors:FlxGroup, DoorMovables:FlxGroup, TheParent:Parent):Void
	{
		ORIGIN_X = 3 * FlxG.width;
		ORIGIN_Y = 3 * FlxG.height;

		OFFSET_X = Std.int(ORIGIN_X) + 0 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 7 * 8;

		WIDTH = 80 * 8;
		HEIGHT = 44 * 8;

		location = FRONT_OF_HOUSE;
		parent = TheParent;

		super();

		// Sounds

		car1Sound = new FlxSound();
		car1Sound.loadEmbedded(AssetPaths.car__wav, false, false);
		car1Sound.volume = 0.5;
		// car1Sound.play();

		car2Sound = new FlxSound();
		car2Sound.loadEmbedded(AssetPaths.car__wav, false, false);
		car2Sound.volume = 0.5;

		busSound = new FlxSound();
		busSound.loadEmbedded(AssetPaths.bus__wav, false, false);

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.front_of_house_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;

		var leftFence:PhysicsSprite = new PhysicsSprite(OFFSET_X, OFFSET_Y, AssetPaths.front_of_house_left_fence__png, 1, 1, 1, false);
		var doorstep:FlxSprite = new FlxSprite(leftFence.x + leftFence.width, OFFSET_Y, AssetPaths.front_of_house_doorstep__png);
		doorstep.origin.x = doorstep.origin.y = 0;
		doorstep.scale.x = doorstep.scale.y = 8;
		var rightFence:PhysicsSprite = new PhysicsSprite(OFFSET_X + leftFence.width + DOOR_WIDTH, OFFSET_Y, AssetPaths.front_of_house_right_fence__png, 1, 1,
			1, false);

		toLivingRoom = new Door(leftFence.x + leftFence.width, leftFence.y - 2 * 8, this, new FlxPoint(-1, leftFence.y + 2 * 8), "FrontOfHouse.toLivingRoom",
			UP);
		doors.push(toLivingRoom);

		var roadAndPavement:FlxSprite = new FlxSprite(OFFSET_X, leftFence.y + leftFence.height, AssetPaths.front_of_house_road__png);
		roadAndPavement.origin.x = roadAndPavement.origin.y = 0;
		roadAndPavement.scale.x = roadAndPavement.scale.y = 8;
		roadAndPavement.width *= 8;
		roadAndPavement.height *= 8;

		var bottomWall:PhysicsSprite = new PhysicsSprite(OFFSET_X, roadAndPavement.y + roadAndPavement.height, AssetPaths.front_of_house_bottom_wall__png, 1,
			1, 1, false);

		var leftLock:Lock = new Lock(ORIGIN_X - 8, ORIGIN_Y, 8, FlxG.height, true);
		leftLock.visible = false;
		var rightLock:Lock = new Lock(ORIGIN_X + FlxG.width, ORIGIN_Y, 8, FlxG.height, true);
		rightLock.visible = false;

		var busStop:PhysicsSprite = new PhysicsSprite(OFFSET_X + 68.5 * 8, OFFSET_Y + 24 * 8, AssetPaths.front_of_house_bus_stop__png, 0.1, 0.1, 1, false,
			false, false, 1, 1, false, 0, 0, "", 8, true);

		bus = new PhysicsSprite(OFFSET_X + 31 * 8, OFFSET_Y + 21 * 8, AssetPaths.front_of_house_bus__png, 1, 0.25, 1000, true, false, false, 1, 1, true, 43,
			16, "", -1, false, -1, -1, 0xFF008000, PlayState.parent.parentColor, PlayState.child1.childColor, PlayState.child2.childColor,
			PlayState.child3.childColor);
		bus.name = "bus";
		bus.animation.add("everyone", [6], 1, false);

		busTrigger = new FlxSprite(bus.x + 36 * 8, bus.y + bus.height);
		busTrigger.makeGraphic(1 * 8, 1 * 8, 0xFFFF0000);
		busTrigger.visible = false;

		boarded = new Array();

		car1 = new PhysicsSprite(OFFSET_X, OFFSET_Y + 18 * 8, AssetPaths.front_of_house_car4__png, 1, 0.25, 1000, true);
		car1.kind = CAR;
		car1.moveTo(OFFSET_X - car1.width, OFFSET_Y + 18 * 8, this);
		// bg.add(car1.hit);

		car1Timer = new FlxTimer().start().start();
		car1Timer.start(Math.random() * 5);

		car2 = new PhysicsSprite(OFFSET_X + 30 * 8, OFFSET_Y + 10 * 8, AssetPaths.front_of_house_car3__png, 1, 0.25, 1000, true);
		car2.kind = CAR;
		car2.moveTo(OFFSET_X + FlxG.width + car2.width * 2, OFFSET_Y + 10 * 8, this);
		car2.flipX = true;

		car2Timer = new FlxTimer().start().start();
		car2Timer.start(Math.random() * 5);

		crossingTrigger = new FlxSprite(OFFSET_X + 22 * 8, OFFSET_Y + 11 * 8);
		crossingTrigger.makeGraphic(6 * 8, 30 * 8, 0xFFFF0000);
		crossingTrigger.visible = false;

		crossing = new FlxGroup();

		bg.add(bgTile);
		bg.add(doorstep);
		bg.add(roadAndPavement);

		bg.add(leftLock);
		bg.add(rightLock);

		bg.add(crossingTrigger);
		bg.add(busTrigger);
		// bg.add(bus.hit);

		display.add(leftFence);
		display.add(rightFence);
		display.add(bottomWall);
		display.add(busStop);
		display.add(bus);
		display.add(car1);
		display.add(car2);

		bg.add(toLivingRoom);

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}

	override public function destroy():Void
	{
		super.destroy();

		crossingTrigger.destroy();
		crossing.destroy();
		car1Sound.destroy();
		car2Sound.destroy();
		busSound.destroy();
		toLivingRoom.destroy();
		bus.destroy();
		busTrigger.destroy();
		car1.destroy();
		car2.destroy();
		car1Timer.destroy();
		car2Timer.destroy();
	}

	public var clicks:Int = 0;

	override public function update():Void
	{
		if (PlayState.parent.place != this)
		{
			busSound.stop();
			car1Sound.stop();
			car2Sound.stop();
		}

		if (car1.body.getLinearVelocity().x == 0)
			car1Sound.stop();
		if (car2.body.getLinearVelocity().x == 0)
			car2Sound.stop();
		if (bus.body.getLinearVelocity().x == 0)
			busSound.stop();

		if (PlayState.parent.place != this && PlayState.child1.place != this && PlayState.child2.place != this && PlayState.child3.place != this)
			return;

		var numLivingChildren:Int = 0;
		if (PlayState.child1.alive)
			numLivingChildren++;
		if (PlayState.child2.alive)
			numLivingChildren++;
		if (PlayState.child3.alive)
			numLivingChildren++;

		if (PlayState.parent.place == this)
		{
			checkCrossing(PlayState.parent);
			if (PlayState.task == PUT_KIDS_ON_BUS)
				checkBus(PlayState.parent, numLivingChildren);
		}
		if (PlayState.child1.place == this)
		{
			checkCrossing(PlayState.child1);
			if (PlayState.task == PUT_KIDS_ON_BUS)
				checkBus(PlayState.child1, numLivingChildren);
			if (!contains(PlayState.child1))
				PlayState.child1.die(Global.strings.PlayState.got_lost);
		}
		if (PlayState.child2.place == this)
		{
			checkCrossing(PlayState.child2);
			if (PlayState.task == PUT_KIDS_ON_BUS)
				checkBus(PlayState.child2, numLivingChildren);
			if (!contains(PlayState.child2))
				PlayState.child2.die(Global.strings.PlayState.got_lost);
		}
		if (PlayState.child3.place == this)
		{
			checkCrossing(PlayState.child3);
			if (PlayState.task == PUT_KIDS_ON_BUS)
				checkBus(PlayState.child3, numLivingChildren);
			if (!contains(PlayState.child3))
				PlayState.child3.die(Global.strings.PlayState.got_lost);
		}

		if (!moveCars)
			return;

		updateCars();
		updateBus();
	}

	public function stopCars():Void
	{
		moveCars = false;
		car1.body.setLinearVelocity(new B2Vec2(0, 0));
		car2.body.setLinearVelocity(new B2Vec2(0, 0));
		bus.body.setLinearVelocity(new B2Vec2(0, 0));
	}

	private function updateCars():Void
	{
		if (crossing.getFirstAlive() != null
			&& car1.x + car1.width >= crossingTrigger.x - 8 * 8
			&& car1.x + car1.width <= crossingTrigger.x - 3 * 8)
		{
			car1.body.setLinearVelocity(new B2Vec2(0, 0));
			// if (car2.body.getLinearVelocity().x == 0) car1Sound.stop();
			car1Sound.stop();
		}
		else
		{
			moveCar(car1);
		}

		if (crossing.getFirstAlive() != null
			&& car2.x <= crossingTrigger.x + crossingTrigger.width + 8 * 8
			&& car2.x >= crossingTrigger.x + crossingTrigger.width + 3 * 8)
		{
			// trace("Car 2 stoping for crossing.");
			car2.body.setLinearVelocity(new B2Vec2(0, 0));
			// if (car1.body.getLinearVelocity().x == 0) car1Sound.stop();
			car2Sound.stop();
		}
		else
		{
			moveCar(car2);
		}
	}

	private function updateBus():Void
	{
		busTrigger.x = bus.x + 36 * 8;
		busTrigger.y = bus.y + bus.height;

		if (!busDeparting)
			return;

		if (bus.x > OFFSET_X + FlxG.width)
		{
			// Bus is offscreen now, so it's gone.
			bus.body.setLinearVelocity(new B2Vec2(0, 0));
			// car1Sound.fadeOut(1);
			bus.hide();
			busDeparting = false;
			busSound.fadeOut(1);
			return;
		}

		if (car1.body.getLinearVelocity().x != 0)
			return;

		// We can leave!
		bus.body.applyImpulse(new B2Vec2(BUS_IMPULSE, 0), bus.body.getPosition());
		if (!busSound.playing)
		{
			busSound.play(true);
			// busSound.fadeIn(0.5,0,0.5);
		}
	}

	private function moveCar(c:PhysicsSprite):Void
	{
		if (c == car1)
		{
			if (car1.x + car1.width <= ORIGIN_X && busDeparting)
			{
				car1.moveTo(OFFSET_X - car1.width - 16, car1.y, this);
				// if (car2.body.getLinearVelocity().x == 0) car1Sound.stop();
				car1Sound.stop();
			}
			else if (car1Timer.finished)
			{
				var carWasMoving:Bool = car1.body.getLinearVelocity().x != 0;

				car1.body.applyImpulse(new B2Vec2(CAR_IMPULSE, 0), car1.body.getPosition());

				if (car1.x > OFFSET_X + FlxG.width)
				{
					car1.moveTo(OFFSET_X - car1.width - 16, car1.y, this);
					car1.loadGraphic(CAR_PNGS[Math.floor(Math.random() * CAR_PNGS.length)]);
					car1.origin.x = car1.origin.y = 0;
					car1.scale.x = car1.scale.y = 8;
					car1.width *= car1.scale.x;
					car1.height *= car1.scale.y;

					car1Timer.start(1 + Math.random() * 5);
				}
				else if (car1.x > OFFSET_X + FlxG.width - car1.width)
				{
					// Fade out if other car is not moving
					if (car1Sound.getActualVolume() == 0.5)
					{
						car1Sound.fadeOut(0.5, 0);
					}
				}
				else if (!carWasMoving)
				{
					car1Sound.play(true);
					car1Sound.fadeIn(0.5, 0, 0.5);
				}
				else if (!car1Sound.playing)
				{
					car1Sound.play(true);
				}
			}
		}

		if (c == car2 && car2Timer.finished)
		{
			var carWasMoving:Bool = car2.body.getLinearVelocity().x != 0;

			// trace("Car 2 apply impulse.");
			car2.body.applyImpulse(new B2Vec2(-CAR_IMPULSE, 0), car2.body.getPosition());

			if (car2.x + car2.width < OFFSET_X)
			{
				// trace("Car 2 resetting to other side.");
				car2.moveTo(OFFSET_X + FlxG.width + 16, car2.y, this);
				car2.loadGraphic(CAR_PNGS[Math.floor(Math.random() * CAR_PNGS.length)]);
				car2.origin.x = car2.origin.y = 0;
				car2.scale.x = car2.scale.y = 8;
				car2.width *= car2.scale.x;
				car2.height *= car2.scale.y;

				car2Timer.start(1 + Math.random() * 5);
			}
			else if (car2.x < ORIGIN_X + car2.width)
			{
				if (car2Sound.getActualVolume() == 0.5)
				{
					car2Sound.fadeOut(0.5, 0);
				}
			}
			else if (!carWasMoving)
			{
				car2Sound.play(true);
				car2Sound.fadeIn(0.5, 0, 0.5);
			}
			else if (!car2Sound.playing)
			{
				car2Sound.play(true);
			}
		}
	}

	public function checkCrossing(p:PhysicsSprite):Void
	{
		if (p.hit.overlaps(crossingTrigger))
		{
			crossing.add(p);
		}
		else
		{
			crossing.remove(p);
		}
	}

	public function checkBus(p:PhysicsSprite, totalChildren:Int = 3):Void
	{
		if (!p.hit.overlaps(busTrigger))
			return;
		if (!p.active)
			return;

		if (busDeparting)
			return;

		if (p.kind == CHILD)
		{
			boardChild(cast(p, Child));
		}
		else if (p.kind == PARENT && boarded.length == totalChildren && p.active)
		{
			// trace("Here.");
			// Parent can get in and off we go

			boardParent(cast(p, Parent), totalChildren);

			busDeparting = true;
		}
	}

	public function boardChild(c:Child):Void
	{
		// It's a kid, so put them in
		boarded.push(c);

		bus.loadGraphic(AssetPaths.front_of_house_bus__png, true, 43, 16, true);
		if (boarded.length > 0)
			bus.replaceColor(0xFFFF0000, boarded[0].childColor);
		if (boarded.length > 1)
			bus.replaceColor(0xFF00FFFF, boarded[1].childColor);
		if (boarded.length > 2)
			bus.replaceColor(0xFF0000FF, boarded[2].childColor);

		bus.origin.x = bus.origin.y = 0;
		bus.scale.x = bus.scale.y = 8;
		bus.width *= bus.scale.x;
		bus.height *= bus.scale.y;

		bus.animation.frameIndex = boarded.length;

		c.hide(false);
	}

	public function boardParent(p:Parent, totalChildren):Void
	{
		bus.loadGraphic(AssetPaths.front_of_house_bus__png, true, 43, 16, true);
		if (boarded.length > 0)
			bus.replaceColor(0xFFFF0000, boarded[0].childColor);
		if (boarded.length > 1)
			bus.replaceColor(0xFF00FFFF, boarded[1].childColor);
		if (boarded.length > 2)
			bus.replaceColor(0xFF0000FF, boarded[2].childColor);
		bus.replaceColor(0xFFFFFF00, p.parentColor);

		bus.origin.x = bus.origin.y = 0;
		bus.scale.x = bus.scale.y = 8;
		bus.width *= bus.scale.x;
		bus.height *= bus.scale.y;

		if (totalChildren == 0)
			bus.animation.frameIndex = 7;
		else
			bus.animation.frameIndex = 3 + totalChildren;

		p.hide();
	}

	public function resetBusNoPassengers():Void
	{
		bus.unhide();
		bus.animation.frameIndex = 0;
		bus.moveTo(OFFSET_X + 31 * 8, OFFSET_Y + 21 * 8, this);

		busDeparting = true;
	}

	public function busDeparted():Bool
	{
		return bus.hidden;
	}
}
