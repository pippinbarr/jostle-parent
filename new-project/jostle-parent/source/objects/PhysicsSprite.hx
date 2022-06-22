package;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2ContactImpulse;
import flash.events.EventDispatcher;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class PhysicsSprite extends Sortable
{
	public var kind:Enums.Kind = UNKNOWN;

	// Physics properties
	public var hit:HitSprite;
	public var body:B2Body;
	public var contacts:FlxGroup;
	public var isDynamic:Bool;
	public var isDeadly:Bool = false;
	public var name:String = "";
	public var place:Place;
	public var centerHitBox:Bool;
	public var ignore:Bool;

	// public var location:Enums.Location;
	public var hidden:Bool = false;

	// Event property
	public var dispatcher:flash.events.EventDispatcher;

	public var _black:FlxColor = FlxColor.GREEN;
	public var _white:FlxColor = FlxColor.GREEN;
	public var _red:FlxColor = FlxColor.GREEN;
	public var _cyan:FlxColor = FlxColor.GREEN;
	public var _blue:FlxColor = FlxColor.GREEN;

	public function new(X:Float = 0, Y:Float = 0, Sprite:String, HitXRatio:Float, HitYRatio:Float, Mass:Float, IsDynamic:Bool = false, HasSensor:Bool = false,
			Ignore:Bool = false, Friction:Float = 1, Restitution:Float = 2, Animated:Bool = false, W:Int = 0, H:Int = 0, T:String = "", Scale:Float = -1,
			CenterHitBox:Bool = false, CategoryBits:Int = -1, MaskBits:Int = -1, black:FlxColor = FlxColor.GREEN, white:FlxColor = FlxColor.GREEN,
			red:FlxColor = FlxColor.GREEN, cyan:FlxColor = FlxColor.GREEN, blue:FlxColor = FlxColor.GREEN)
	{
		super(Std.int(X), Std.int(Y));

		setRecolors(black, white, red, cyan, blue);

		// location = UNKNOWN;

		isDynamic = IsDynamic;
		kind = UNKNOWN;
		centerHitBox = CenterHitBox;
		ignore = Ignore;
		dispatcher = new EventDispatcher();

		if (Sprite != "")
		{
			if (!Animated)
			{
				this.loadGraphic(Sprite, false, 0, 0, false);
			}
			else
			{
				this.loadGraphic(Sprite, true, W, H, false);
			}

			// this.loadGraphic(Sprite);
			this.origin.x = this.origin.y = 0;
			this.scale.x = (Scale == -1) ? 8 : Scale;
			this.scale.y = (Scale == -1) ? 8 : Scale;
			this.width *= this.scale.x;
			this.height *= this.scale.y;
		}
		else
		{
			this.loadGraphic(T, false);
			this.origin.x = this.origin.y = 0;
			this.scale.x = W;
			this.scale.y = H;
			this.width *= this.scale.x;
			this.height *= this.scale.y;
		}

		contacts = new FlxGroup();

		hit = new HitSprite(Std.int(X), Std.int(Y));
		hit.makeGraphic(Math.floor(this.width * HitXRatio), Math.floor(this.height * HitYRatio), 0xFFFF0000);

		if (!centerHitBox)
		{
			hit.x = this.x;
		}
		else
		{
			hit.x = this.x + this.width / 2 - hit.width / 2;
		}

		hit.y = this.y + this.height - hit.height;

		hit.parent = this;
		hit.visible = false;

		if (isDynamic)
		{
			body = Physics.dynamicBodyFromSprite(hit, Mass, Friction, Restitution, IsDynamic, HasSensor, Ignore, CategoryBits, MaskBits);
		}
		else
		{
			body = Physics.staticBodyFromSprite(hit, CategoryBits, MaskBits);
		}

		body.setUserData(this);

		updatePosition();
	}

	override public function destroy():Void
	{
		super.destroy();

		hit.destroy();
		contacts.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		if (isDynamic)
			updatePosition();

		// sortKey = Physics.worldToScreen(body.getPosition().y);

		sortKey = hit.y;

		super.update(elapsed);
	}

	public function updatePosition():Void
	{
		if (hit == null || body == null)
			return;

		// if (!centerHitBox)
		// {
		hit.x = Math.round(Physics.worldToScreen(body.getPosition().x) - hit.width / 2);
		hit.y = Math.round(Physics.worldToScreen(body.getPosition().y) - hit.height / 2);

		// hit.x = Physics.worldToScreen(body.getPosition().x) - hit.width/2;
		// hit.y = Physics.worldToScreen(body.getPosition().y);

		// }
		// else
		// {
		// hit.x = Math.round(Physics.worldToScreen(body.getPosition().x) + hit.width/2 - this.width/2);
		// }

		if (centerHitBox)
		{
			this.x = hit.x + hit.width / 2 - this.width / 2;
		}
		else
		{
			this.x = hit.x;
		}

		this.y = Math.round(Physics.worldToScreen(body.getPosition().y) + hit.height / 2 - this.height);

		// if (!centerHitBox)
		// {
		// 	hit.x = this.x;
		// }
		// else
		// {
		// 	hit.x = this.x + this.width/2 - hit.width/2;
		// }

		sortKey = hit.y;
	}

	public function updatePositionOld():Void
	{
		if (hit == null || body == null)
			return;

		if (!centerHitBox)
		{
			this.x = Math.round(Physics.worldToScreen(body.getPosition().x) - hit.width / 2);
		}
		else
		{
			this.x = Math.round(Physics.worldToScreen(body.getPosition().x) + hit.width / 2 - this.width / 2);
		}

		this.y = Math.round(Physics.worldToScreen(body.getPosition().y) + hit.height / 2 - this.height);

		if (!centerHitBox)
		{
			hit.x = this.x;
		}
		else
		{
			hit.x = this.x + this.width / 2 - hit.width / 2;
		}

		hit.y = this.y + this.height - hit.height;

		sortKey = hit.y;
	}

	public function moveTo(X:Float, Y:Float, P:Place):Void
	{
		// trace("PhysicsSprite moveTo from " + Physics.worldToScreen(body.getPosition().x) + "," + Physics.worldToScreen(body.getPosition().y) + " -> " + X + "," + Y);

		if (!alive)
			return;

		place = P;
		body.setPosition(new B2Vec2(Physics.screenToWorld(X + hit.width / 2), Physics.screenToWorld(Y + height - hit.height / 2)));
		body.setLinearVelocity(new B2Vec2(0, 0));
		updatePosition();
	}

	public function beginContact(Sensor:Int, OtherSensor:Int, Other:PhysicsSprite):Void
	{
		// else if (kind == CHILD)
		// {
		// 	if (place == Other.place)
		// 	{
		// 		PlayState.justJostled = true;
		// 	}
		// }
	}

	public function hide(Log:Bool = true):Void
	{
		// Only log as hidden if told (default)
		if (Log)
			hidden = true;

		body.setActive(false);
		visible = false;
		active = false;
	}

	public function unhide():Void
	{
		if (!alive)
			return;

		hidden = false;

		body.setActive(true);
		visible = true;
		active = true;
	}

	public function endContact(Sensor:Int, OtherSensor:Int, Other:PhysicsSprite):Void {}

	public function postSolve(OtherSprite:PhysicsSprite, impulse:B2ContactImpulse):Void
	{
		// trace(impulse.normalImpulses[0]);

		var impact:Int = Physics.NONE;

		if (impulse.normalImpulses[0] > Physics.DEADLY_THRESHOLD)
		{
			impact = Physics.DEADLY;
		}
		else if (impulse.normalImpulses[0] > Physics.HARD_THRESHOLD)
		{
			impact = Physics.HARD;
			dispatcher.dispatchEvent(new JostleEvent("HARD", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("MEDIUM", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("SOFT", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("ANY", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
		}
		else if (impulse.normalImpulses[0] > Physics.MEDIUM_THRESHOLD)
		{
			impact = Physics.MEDIUM;
			dispatcher.dispatchEvent(new JostleEvent("MEDIUM", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("SOFT", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("ANY", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
		}
		else if (impulse.normalImpulses[0] > Physics.SOFT_THRESHOLD)
		{
			impact = Physics.SOFT;
			dispatcher.dispatchEvent(new JostleEvent("SOFT", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
			dispatcher.dispatchEvent(new JostleEvent("ANY", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
		}
		else if (impulse.normalImpulses[0] > 0)
		{
			impact = Physics.ANY;
			dispatcher.dispatchEvent(new JostleEvent("ANY", 1, OtherSprite.body.getLinearVelocity().x, OtherSprite.body.getLinearVelocity().y));
		}
		else
		{
			impact = Physics.NONE;
		}

		handleImpact(impact, OtherSprite);

		if (kind == PARENT && impulse.normalImpulses[0] >= 3)
		{
			if (OtherSprite.kind == FOOD || OtherSprite.kind == TOY || OtherSprite.kind == BALL)
			{
				// trace("SOFT.");
				PlayState.justJostled = PlayState.JostleStrength.SOFT;
			}
			else
			{
				// trace("NORMAL");
				PlayState.justJostled = PlayState.JostleStrength.NORMAL;
			}
		}
	}

	private function handleImpact(Impact:Int, OtherSprite:PhysicsSprite):Void {}

	public function handleHardJostle():Void {}

	public function setRecolors(black:FlxColor, white:FlxColor, red:FlxColor, cyan:FlxColor, blue:FlxColor)
	{
		_black = black;
		_white = white;
		_red = red;
		_cyan = cyan;
		_blue = blue;
	}

	// override public function graphicLoaded():Void
	// {
	// 	super.graphicLoaded();
	// 	if (_black != FlxColor.GREEN)
	// 	{
	// 		this.replaceColor(FlxColor.BLACK, _black);
	// 	}
	// 	if (_white != FlxColor.GREEN)
	// 	{
	// 		this.replaceColor(FlxColor.WHITE, _white);
	// 	}
	// 	if (_red != FlxColor.GREEN)
	// 	{
	// 		this.replaceColor(0xFFFF0000, _red);
	// 	}
	// 	if (_cyan != FlxColor.GREEN)
	// 	{
	// 		this.replaceColor(FlxColor.CYAN, _cyan);
	// 	}
	// 	if (_blue != FlxColor.GREEN)
	// 	{
	// 		this.replaceColor(FlxColor.BLUE, _blue);
	// 	}
	// }

	override public function kill():Void
	{
		body.setActive(false);
		super.kill();
	}
}
