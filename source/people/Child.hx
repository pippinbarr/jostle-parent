package;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.util.FlxTimer;


enum MovementMode {
	STILL;
	WANDER;
	WANDER_UP;
	WANDER_FOLLOW;
	FOLLOW;
	CHASE;
	CHASE_WANDER;
	POST_DOOR_STILL;
	JITTER;
}

enum ChildState {
	PAUSED;
	NORMAL;
	ELECTROCUTING;
	CHOKING;
	POISONING;
	DROWNING;
	DEAD;
}


class Child extends Person
{
	// Constants
	// private static var NORMAL_SPEED:Float = 0.25;
	// private static var CHASE_SPEED:Float = 0.4;
	// private static var NORMAL_SPEED:Float = 0.12;
	private static var NORMAL_SPEED:Float = 0.2;
	private static var CHASE_SPEED:Float = 0.4;

	private static var PAUSE_TIME:Float = 2;

	private static var NORMAL_FRAME:Int = 0;
	private static var KNOCKED_DOWN_FRAME:Int = 1;
	private static var ARMS_UP_FRAME:Int = 2;
	private static var DEAD_FRAME:Int = 3;

	private static var CHANCE_OF_CHOKING:Float = 0.01; //0.05;
	private static var CHANCE_OF_TOY_CHOKING:Float = 0.001; //0.05;
	private static var CHANCE_OF_POISONING:Float = 0.1;

	// Movement variables
	public var movementMode:MovementMode;

	private var paused:Bool = false;
	private var pauseTimer:FlxTimer;

	private var wanderTimer:FlxTimer;
	private var wanderDirection:Enums.Direction;
	private static var WANDER_MIN_TIME:Float = 1;
	private static var WANDER_RANGE_TIME:Float = 1;

	private var lastChaseX:Float = -1;
	private var lastChaseY:Float = -1;
	private var staticChaseFrames:Int = 0;
	private var chaseWanderTimer:FlxTimer;
	private static var MAX_STATIC_CHASE_FRAMES:Int = 240;

	private var postDoorTimer:FlxTimer;

	private var wanderFollowTimer:FlxTimer;
	private var currentWanderFollow:Child.MovementMode;
	private static var WANDER_FOLLOW_TIME_RANGE:Float = 5;
	private static var WANDER_FOLLOW_MIN_TIME:Float = 5;
	private var lastFollowX:Float = -1;
	private var lastFollowY:Float = -1;
	private var staticFollowFrames:Int = 0;
	private static var MAX_STATIC_FOLLOW_FRAMES:Int = 120;


	private var target:PhysicsSprite;
	public var parent:Parent;
	public var child1:Child;
	public var child2:Child;
	public var child3:Child;
	
	// Food
	private var hungry:Bool = false;
	private var foodEaten:Int = 0;
	private var MIN_FOOD:Int = 2;

	// Sleep
	private var tired:Bool = false;
	public var inBed:Bool = false;

	// TV
	private var watchingTV:Bool = false;

	// Playground
	private var watchedFrames:Int = 0;

	// Death
	private var didJustDie:Bool = false;
	private var causeOfDeath:String = "";
	public var dying:Bool = false;
	private var justStartedDying:Bool = false;

	private var dyingTimer:FlxTimer;

	// Status
	public var statusText:FlxTextWithBG;
	public var state:ChildState;

	// Input
	private var controllable:Bool;

	// Colour
	public var childColor:Int = 0xFFFF0000;
	public var number:Int = -1;
	


	public function new(X:Float,Y:Float,ui:FlxGroup,Name:String,Number:Int,Color:Int,Controllable:Bool = false)
	{
		super(X,Y,AssetPaths.child_frames__png,1,0.25,7,7,0.5);

		kind = CHILD;

		controllable = Controllable;
		name = Name;
		childColor = Color;
		number = Number;

		loadGraphic(AssetPaths.child_frames__png,true,7,7,true);
		origin.x = origin.y = 0;
		this.scale.x = 8;
		this.scale.y = 8;
		this.width *= this.scale.x;
		this.height *= this.scale.y;
		replaceColor(0xFF000000,childColor);
		
		
		// Set up animations
		animation.add("normal",[NORMAL_FRAME],30,false);
		animation.add("choking",[NORMAL_FRAME,ARMS_UP_FRAME],8,true);
		animation.add("drowning",[NORMAL_FRAME,ARMS_UP_FRAME],8,true);
		animation.add("poisoned",[NORMAL_FRAME,ARMS_UP_FRAME],8,true);
		animation.add("arms_up",[ARMS_UP_FRAME],8,true);
		animation.add("knocked_down",[KNOCKED_DOWN_FRAME],30,false);
		animation.add("dead",[DEAD_FRAME],30,false);

		animation.play("normal");


		// Set up wandering
		wanderTimer = new FlxTimer();
		wanderTimer.finished = true;
		wanderDirection = NONE;

		// Set up pausing
		pauseTimer = new FlxTimer();
		pauseTimer.finished = true;

		// Set up chasing
		chaseWanderTimer = new FlxTimer();

		// Set up door timer
		postDoorTimer = new FlxTimer();

		// Set up wander follow
		wanderFollowTimer = new FlxTimer();
		// currentWanderFollow = FOLLOW;

		dyingTimer = new FlxTimer();

		// Set up movement
		setMovementMode(WANDER_FOLLOW);

		if (!controllable) MOVEMENT_IMPULSE = NORMAL_SPEED;
		else MOVEMENT_IMPULSE = NORMAL_SPEED * 4;

		// Set up status
		statusText = new FlxTextWithBG(X,Y,100,"",12,"center",0xFFFFFFFF,0xff000000,false);
		ui.add(statusText);

		// statusText.visible = false;


		state = NORMAL;
	}



	override public function destroy():Void
	{
		super.destroy();

		wanderTimer.destroy();
		pauseTimer.destroy();
		chaseWanderTimer.destroy();
		postDoorTimer.destroy();
		wanderFollowTimer.destroy();
		dyingTimer.destroy();
		statusText.destroy();
	}



	public function setParent(p:Parent):Void
	{
		parent = p;
		target = p;
	}

	public function setChildren(c1:Child,c2:Child,c3:Child):Void
	{
		child1 = c1;
		child2 = c2;
		child3 = c3;
	}



	override public function update():Void
	{
		super.update();

		if (!controllable) updateMovement();
		if (!controllable) updateStatus();

		if (controllable) handleInput();
	}



	public function die(CauseOfDeath:String):Void
	{
		if (!alive) return;
	
		statusText.visible = false;

		animation.play("dead");
		cancelTimers();

		causeOfDeath = CauseOfDeath;

		alive = false;
		active = false;
		paused = true;
		dying = false;
		place = null;
		state = DEAD;
		body.setActive(false);

		didJustDie = true;
	}


	public function justDied():Bool
	{
		return didJustDie;
	}


	public function didJustStartDying():Bool
	{
		if (justStartedDying)
		{
			justStartedDying = false;
			return true;
		}
		else
		{
			return false;
		}
	}


	public function getCauseOfDeath():String
	{
		return causeOfDeath;
	}


	private function cancelTimers():Void
	{
		dyingTimer.cancel();
		wanderTimer.cancel();
		chaseWanderTimer.cancel();
		wanderFollowTimer.cancel();
		pauseTimer.cancel();
		postDoorTimer.cancel();

		paused = false;
	}


	public function setMovementMode(M:Child.MovementMode):Void
	{
		if (!alive || hidden || dying) return;

		// trace("setMovementMode(" + M + ")");

		cancelTimers();

		switch(M)
		{
			case WANDER, WANDER_UP:
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case WANDER_FOLLOW:
			currentWanderFollow = FOLLOW;
			MOVEMENT_IMPULSE = NORMAL_SPEED;
			wanderFollowTimer.start(Math.random() * WANDER_FOLLOW_TIME_RANGE + WANDER_FOLLOW_MIN_TIME,wanderFollowTimerFinished);

			case CHASE:
			MOVEMENT_IMPULSE = CHASE_SPEED;

			case CHASE_WANDER:
			MOVEMENT_IMPULSE = NORMAL_SPEED;	
			chaseWanderTimer.start(3,chaseWanderTimerFinished);		

			case FOLLOW:
			MOVEMENT_IMPULSE = NORMAL_SPEED;

			case STILL:
			MOVEMENT_IMPULSE = 0;

			case POST_DOOR_STILL:
			MOVEMENT_IMPULSE = 0;
			postDoorTimer.start(5,postDoorTimerFinished);

			case JITTER:
			idle();
			MOVEMENT_IMPULSE = NORMAL_SPEED;
		}

		movementMode = M;
	}


	private function chaseWanderTimerFinished(t:FlxTimer):Void
	{
		setMovementMode(CHASE);
	}


	private function postDoorTimerFinished(t:FlxTimer):Void
	{
		setMovementMode(WANDER_FOLLOW);
		switchWanderFollow();
	}


	private function switchWanderFollow():Void
	{
		if (currentWanderFollow == WANDER) 
		{
			if (Math.random() > 0.3)
			{
				currentWanderFollow = FOLLOW;
			}
		}
		else 
		{
			if (Math.random() > 0.3)
			{
				currentWanderFollow = WANDER;
			}
		}
	}


	public function setHungry(val:Bool):Void
	{
		if (!alive || !active) return;

		hungry = val;
		foodEaten = 0;
	}


	public function isHungry():Bool
	{
		return hungry;
	}


	public function setTired(val:Bool):Void
	{
		if (!alive || !active) return;

		tired = val;
	}


	public function isTired():Bool
	{
		return tired;
	}


	public function setInBed(val:Bool):Void
	{
		if (!alive) return;

		inBed = val;
	}


	public function isInBed():Bool
	{
		return (!alive || inBed);
	}


	public function isDrowning():Bool
	{
		return state == DROWNING;
	}


	public function showName():Void
	{		
		statusText.setText(name);
		new FlxTimer(10,hideName);
	}


	public function showingName():Bool
	{
		return (statusText.visible && statusText.text.text == name);
	}


	private function hideName(t:FlxTimer):Void
	{
		if (statusText.text.text == name) statusText.visible = false;
	}




	private function updateStatus():Void
	{
		// if (statusText.visible) trace(x + "," + y + ", statusText.x=" + statusText.x + ",y=" + statusText.y);

		if (hidden) return;
		
		switch (state)
		{
			case PAUSED:
			if (statusText.text.text != "PAUSED") statusText.setText("PAUSED");		
			statusText.visible = false;

			case NORMAL:
			if (hungry && (statusText.text.text != "HUNGRY"  || !statusText.visible)) 
			{
				statusText.setText("HUNGRY");
			}
			else if (!hungry && statusText.visible && statusText.text.text != name) 
			{
				statusText.visible = false;
			}

			case ELECTROCUTING:
			if (statusText.text.text != "ELECTROCUTING" || !statusText.visible) statusText.setText("ELECTROCUTING");

			case CHOKING:
			if (statusText.text.text != "CHOKING" || !statusText.visible) statusText.setText("CHOKING");

			case POISONING:
			if (statusText.text.text != "POISONED" || !statusText.visible) statusText.setText("POISONED");

			case DROWNING:
			if (statusText.text.text != "DROWNING" || !statusText.visible) statusText.setText("DROWNING");

			case DEAD:
			if (statusText.text.text != "DEAD" || !statusText.visible) statusText.setText("DEAD");		
			statusText.visible = false;
		}

		statusText.x = x + width/2 - statusText.width/2;
		statusText.y = y - statusText.height - 8;

		// statusText.x = 0;
		// statusText.y = 0;
	}


	// HANDLE MOVEMENT

	public function setTarget(T:PhysicsSprite):Void
	{
		target = T;
	}



	private function updateMovement():Void
	{
		if (paused) return;
		if (!alive) return;

		if (watchingTV && movementMode != JITTER) return;
		
		switch (movementMode)
		{
			case STILL,POST_DOOR_STILL:
			idle();

			case WANDER:
			wander();

			// Randomly WANDER or FOLLOW, but if the target isn't present, then WANDER
			case WANDER_FOLLOW:
			if (currentWanderFollow == WANDER)
			{
				wander();
			}
			else if (currentWanderFollow == FOLLOW)
			{
				follow();
			}

			case WANDER_UP:
			wanderUp();

			case FOLLOW:
			follow();

			case CHASE:
			chase();

			case CHASE_WANDER:
			wander();

			case JITTER:
			jitter();
		}
	}


	// REACT TO IMPACT


	override private function handleImpact(Impact:Int,OtherSprite:PhysicsSprite):Void
	{
		super.handleImpact(Impact,OtherSprite);

		if (!alive || hidden) return;

		switch (OtherSprite.kind)
		{
			// If it's a car then will die if it's moving
			case CAR:
			if (Math.abs(OtherSprite.body.getLinearVelocity().x) > 1) 
			{
				// trace("Car linear v is " + OtherSprite.body.getLinearVelocity().x);
				die("was hit by a car");
			}

			// If it's poison then may get poisoned
			case POISON:
			if (Math.random() < CHANCE_OF_POISONING) startDying(POISONING);

			// If it's food then eat it (if not dying)
			case FOOD:
			if (dying) return;
			if (hungry && !watchingTV) eat(OtherSprite);

			// If it's the parent then they can affect movement and choking
			case PARENT:
			if (!dying && Impact > Physics.ANY) setMovementMode(WANDER_FOLLOW);
			if (state == CHOKING && Impact > Physics.MEDIUM) stopDying(CHOKING);

			// Otherwise it's just whether the impact will dislodge food
			case FURNITURE, UNKNOWN, WALL, LOCK, TOY, ELECTRICITY, BALL, POISON, BED, CHILD:
			if (state == CHOKING && Impact > Physics.MEDIUM) stopDying(CHOKING);
		}
	}


	private function eat(s:PhysicsSprite):Void
	{
		s.kill();

		// Choking doesn't count as eating, so you can't choke to complete a task! FUCK YOU!
		if (Math.random() < CHANCE_OF_CHOKING)
		{
			startDying(CHOKING);
		}
		else
		{
			foodEaten++;
			if (foodEaten >= MIN_FOOD)
			{
				hungry = false;
			}
		}
	}


	public function pause():Void
	{
		cancelTimers();
		idle();
		paused = true;
		pauseTimer.start(PAUSE_TIME,pauseTimerFinished);
	}


	private function pauseTimerFinished(t:FlxTimer):Void
	{
		// trace(name + "'s pause timer finished.");

		paused = false;
		if (movementMode != CHASE && movementMode != CHASE_WANDER && movementMode != FOLLOW) 
		{
			cancelTimers();
			setMovementMode(WANDER_FOLLOW);
			// wanderFollowTimer.start(Math.random() * WANDER_FOLLOW_TIME_RANGE + WANDER_FOLLOW_MIN_TIME,wanderFollowTimerFinished);
		}
	}



	private function wanderFollowTimerFinished(t:FlxTimer):Void
	{
		switchWanderFollow();
		wanderFollowTimer.start(Math.random() * WANDER_FOLLOW_TIME_RANGE + WANDER_FOLLOW_MIN_TIME,wanderFollowTimerFinished);
	}


	public function isFinishedPlaying():Bool
	{
		// Need to have some kind of "quota" of play... maybe they want to try every piece of equipment?
		// But they also just want to be watched playing... (esp. on rider, seesaw, swing...)
		// BUT this can also just fail - should be possible for it to end either way
		// and for the quota to be met either way
		return false;
	}



	public function watchTV(Value:Bool):Void
	{
		watchingTV = Value;
		if (watchingTV) idle();

	}




	// DEATHS

	public function startDying(Death:Child.ChildState):Void
	{
		if (dying) return;
		if (!alive) return;

		justStartedDying = true;

		cancelTimers();

		var duration:Int = 0;

		switch (Death)
		{
			case DROWNING:
			animation.play("drowning");
			duration = 10;
			setMovementMode(STILL);

			case CHOKING:
			animation.play("choking");
			duration = 10;
			setMovementMode(STILL);

			case POISONING:
			animation.play("poisoned");
			duration = 5;
			setTarget(parent);
			setMovementMode(CHASE);

			case ELECTROCUTING:
			animation.play("normal");
			setMovementMode(JITTER);
			duration = 5;

			// These "can't" happen
			case PAUSED,NORMAL,DEAD:
		}

		dyingTimer.start(duration,dyingTimerFinished);
		state = Death;
		dying = true;
	}


	public function stopDying(Death:Child.ChildState):Void
	{
		if (Death != state) return;

		// statusText.text.text = "UNDEAD";

		cancelTimers();

		animation.play("normal");

		idle();
		paused = true;
		pauseTimer.start(PAUSE_TIME,pauseTimerFinished);

		state = NORMAL;

		dying = false;
	}


	private function dyingTimerFinished(t:FlxTimer):Void
	{
		switch (state)
		{
			case DROWNING:
			die("drowned");

			case ELECTROCUTING:
			die("was electrocuted");

			case CHOKING:
			die("choked");

			case POISONING:
			die("was poisoned");

			case PAUSED,NORMAL,DEAD:
		}
	}


	public function isDying():Bool
	{
		return dying;
	}





	// MOVEMENT METHODS


	private function wander():Void
	{
		if (!wanderTimer.finished)
		{
			// If the wander timer is still running they try to keep moving in the
			// same direction as before.

			var canContinue:Bool = false;

			if (wanderDirection == LEFT) canContinue = moveLeft();
			else if (wanderDirection == RIGHT) canContinue = moveRight();
			else if (wanderDirection == UP) canContinue = moveUp();
			else if (wanderDirection == DOWN) canContinue = moveDown();
			else if (wanderDirection == NONE) canContinue = idle();

			if (canContinue) return;
		}

		// Either the timer has stopped and they need to choose a new direction,
		// or they discovered they couldn't continue in their set direction.

		if (upBlocks > 0 && downBlocks > 0 && leftBlocks > 0 && rightBlocks > 0)
		{
			// Can't move at all.
			wanderDirection = NONE;
		}
		else
		{
			// Keep trying directions until you get one that isn't blocked.
			var foundDir:Bool = false;
			while (!foundDir)
			{
				wanderDirection = getRandomDirection();
				if (wanderDirection == LEFT && leftBlocks > 0) continue;
				if (wanderDirection == RIGHT && rightBlocks > 0) continue;
				if (wanderDirection == DOWN && downBlocks > 0) continue;
				if (wanderDirection == UP && upBlocks > 0) continue;

				foundDir = true;
			}
		}

		// Start the timer for changing directions
		wanderTimer.start(WANDER_MIN_TIME + WANDER_RANGE_TIME * Math.random(),1);
	}



	private function getRandomDirection():Enums.Direction
	{
		var random:Float = Math.random();

		if (random < 0.25) return LEFT;
		else if (random < 0.5) return RIGHT;
		else if (random < 0.75) return UP;
		else return DOWN;
	}


	private function wanderUp():Void
	{
		if (!wanderTimer.finished)
		{
			// If the wander timer is still running they try to keep moving in the
			// same direction as before.

			var canContinue:Bool = false;

			if (wanderDirection == LEFT) canContinue = moveLeft();
			else if (wanderDirection == RIGHT) canContinue = moveRight();
			else if (wanderDirection == UP) canContinue = moveUp();
			else if (wanderDirection == DOWN) canContinue = moveDown();
			else if (wanderDirection == NONE) canContinue = idle();

			if (canContinue) return;
		}

		// Either the timer has stopped and they need to choose a new direction,
		// or they discovered they couldn't continue in their set direction.

		if (upBlocks > 0 && downBlocks > 0 && leftBlocks > 0 && rightBlocks > 0)
		{
			// Can't move at all.
			wanderDirection = NONE;
		}
		else
		{
			// Keep trying directions until you get one that isn't blocked.
			var foundDir:Bool = false;
			while (!foundDir)
			{
				wanderDirection = getUpBiasedDirection();
				if (wanderDirection == LEFT && leftBlocks > 0) continue;
				if (wanderDirection == RIGHT && rightBlocks > 0) continue;
				if (wanderDirection == DOWN && downBlocks > 0) continue;
				if (wanderDirection == UP && upBlocks > 0) continue;

				foundDir = true;
			}
		}

		// Start the timer for changing directions
		wanderTimer.start(WANDER_MIN_TIME + WANDER_RANGE_TIME * Math.random(),1);
	}



	private function getUpBiasedDirection():Enums.Direction
	{
		var random:Float = Math.random();

		if (random < 0.22) return LEFT;
		else if (random < 0.44) return RIGHT;
		else if (random < 0.66) return DOWN;
		else return UP;
	}



	private function follow():Void
	{
		var currentTarget:FlxSprite = target.hit;

		if (target == null) return;
		if (target.place != place)
		{
			currentTarget = null;

			if (place.doors.length == 0)
			{
				return;
			}
			else if (place.doors.length == 1)
			{
				currentTarget = place.doors[0];
			}
			else
			{
				for (i in 0...place.doors.length)
				{
					if (place.doors[i].toDoor.place == target.place)
					{
						currentTarget = place.doors[i];
						break;
					}
				}
			}

			if (currentTarget == null) 
			{
				if (place.doors.length == 0) return;
				else currentTarget = (place.doors[Math.floor(Math.random() * place.doors.length)]);
			}
		}

		if (lastFollowX == -1 && lastFollowY == -1)
		{
			lastFollowX = x;
			lastFollowY = y;
			staticFollowFrames = 0;
		}

		if (Math.abs(lastFollowX - x) < 2 &&
			Math.abs(lastFollowY - y) < 2 )
		{
			staticFollowFrames++;
		}
		else
		{
			staticFollowFrames = 0;
		}

		lastFollowX = x;
		lastFollowY = y;


		var success:Bool = false;


		if (Math.abs((hit.x + hit.width/2) - (target.x + target.width/2)) > Math.abs((hit.y + hit.height/2) - (target.y + target.height/2)))
		{
			success = followX(currentTarget,false);
			if (!success) followY(currentTarget,false);
		}
		else
		{
			success = followY(currentTarget,false);
			if (!success) followX(currentTarget,false);
		}

	}


	private function followY(currentTarget:FlxSprite,IgnoreBlocks:Bool = false):Bool
	{
		if (hit.y + hit.height/2 < currentTarget.y + currentTarget.height/2 - 4) 
		{
			return moveDown();
		}
		else if (hit.y + hit.height/2 >= currentTarget.y + currentTarget.height/2 + 4) 
		{
			return moveUp();
		}

		return false;
	}


	private function followX(currentTarget:FlxSprite,IgnoreBlocks:Bool = false):Bool
	{

		if (hit.x + hit.width/2 < currentTarget.x + currentTarget.width/2 - 4) 
		{
			return moveRight();
		}
		else if (hit.x + hit.width/2 >= currentTarget.x + currentTarget.width/2 + 4) 
		{
			return moveLeft();
		}
		
		return false;

	}	


	private function chase():Void
	{
		if (target == null) return;

		if (lastChaseX == -1 && lastChaseY == -1)
		{
			lastChaseX = x;
			lastChaseY = y;
			staticChaseFrames = 0;
		}

		if (Math.abs(lastChaseX - x) < 2 &&
			Math.abs(lastChaseY - y) < 2 )
		{
			staticChaseFrames++;
		}
		else
		{
			staticChaseFrames = 0;
		}

		lastChaseX = x;
		lastChaseY = y;

		if (staticChaseFrames > MAX_STATIC_CHASE_FRAMES)
		{
			lastChaseX = -1;
			lastChaseY = -1;
			setMovementMode(CHASE_WANDER);
			return;
		}


		var success:Bool = false;


		if (Math.abs((hit.x + hit.width/2) - (target.hit.x + target.hit.width/2)) > Math.abs((hit.y + hit.height/2) - (target.hit.y + target.hit.height/2)))
		{
			success = chaseX(false);
			if (!success) chaseY(true);
		}
		else
		{
			success = chaseY(false);
			if (!success) chaseX(true);
		}
	}


	private function chaseY(IgnoreBlocks:Bool = false):Bool
	{
		if (hit.y + hit.height/2 < target.hit.y + target.hit.height/2) 
		{
			return moveDown(IgnoreBlocks);
		}
		else if (hit.y + hit.height/2 >= target.hit.y + target.hit.height/2) 
		{
			return moveUp(IgnoreBlocks);	
		}

		return false;
	}


	private function chaseX(IgnoreBlocks:Bool = false):Bool
	{
		if (hit.x + hit.width/2 < target.hit.x + target.hit.width/2) 
		{
			return moveRight(IgnoreBlocks);
		}
		else if (hit.x + hit.width/2 >= target.hit.x + target.hit.width/2) 
		{
			return moveLeft(IgnoreBlocks);
		}

		return false;
	}	


	// HANDLE MOVEMENT WITH BLOCKS

	override public function moveLeft(IgnoreBlocks:Bool = false):Bool
	{
		if (!controllable && !IgnoreBlocks && leftBlocks > 0) 
		{
			return false;
		}
		else if (IgnoreBlocks)
		{
			super.moveLeft();
			return leftBlocks == 0;
		}
		else 
		{
			return super.moveLeft();
		}
	}


	override function moveRight(IgnoreBlocks:Bool = false):Bool
	{
		if (!controllable && !IgnoreBlocks && rightBlocks > 0) 
		{
			return false;
		}
		else if (IgnoreBlocks)
		{
			super.moveRight();
			return rightBlocks == 0;
		}
		else 
		{
			return super.moveRight();
		}
	}


	override public function moveUp(IgnoreBlocks:Bool = false):Bool
	{		
		if (!controllable && !IgnoreBlocks && upBlocks > 0) 
		{
			return false;
		}
		else if (IgnoreBlocks)
		{
			super.moveUp();
			return upBlocks == 0;
		}
		else 
		{
			return super.moveUp();
		}
	}


	override public function moveDown(IgnoreBlocks:Bool = false):Bool
	{
		if (!controllable && !IgnoreBlocks && downBlocks > 0) 
		{
			return false;
		}
		else if (IgnoreBlocks)
		{
			super.moveDown();
			return downBlocks == 0;
		}
		else 
		{
			return super.moveDown();
		}
	}



	// HANDLE PHYSICS IMPACTS

	override public function beginContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor,OtherSensor,TheOther);
	}


	override public function endContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,TheOther);
	}


	// HIDING

	override public function hide(Log:Bool = true):Void
	{
		super.hide(Log);
		statusText.setText("HIDDEN");
		statusText.visible = false;
		// state = PAUSED;
	}

	override public function unhide():Void
	{
		super.unhide();
		// statusText.visible = true;
		// state = NORMAL; // ???
	}


	private function jitter():Void
	{
		x += 2 - (Math.random() * 4);
	}


	// INPUT

	public function handleInput():Void
	{			
		if (FlxG.keys.pressed.A)
		{
			moveLeft();
		}
		else if (FlxG.keys.pressed.D)
		{
			moveRight();
		}
		else
		{
			idleX();
		}

		if (FlxG.keys.pressed.W)
		{
			moveUp();
		}
		else if (FlxG.keys.pressed.S)
		{
			moveDown();
		}
		else
		{
			idleY();
		}
	}
}