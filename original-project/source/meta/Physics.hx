package;

import flixel.FlxSprite;

import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2DebugDraw;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;

import box2D.common.math.B2Vec2;


import flash.display.Sprite;


class Physics
{
	public static var DEADLY_THRESHOLD:Float = 30;
	public static var HARD_THRESHOLD:Float = 14;
	public static var MEDIUM_THRESHOLD:Float = 7;
	public static var SOFT_THRESHOLD:Float = 0.1;

	public static var DEADLY:Int = 7;
	public static var HARD:Int = 5;
	public static var MEDIUM:Int = 3;
	public static var SOFT:Int = 1;
	public static var ANY:Int = 2;
	public static var NONE:Int = 0;

	public static var DRAW_DEBUG:Bool = false;

	public static var UP_SENSOR:Int = 0x0002;
	public static var DOWN_SENSOR:Int = 0x0004;
	public static var LEFT_SENSOR:Int = 0x0008;
	public static var RIGHT_SENSOR:Int = 0x0010;

	public static var SOLID:Int = 0x0020;
	public static var IGNORE:Int = 0x0040;
	public static var PARENT:Int = 0x0080;
	public static var PARENT_LOCK:Int = 0x0100;
	
	public static var WORLD:B2World;
	public static var SCALE:Float = 1/30;

	public static var DEBUG:B2DebugDraw;
	public static var DEBUG_SPRITE:Sprite;

	public static var AVATAR:UInt = 1;
	public static var PERSON:UInt = 2;
	public static var CHAIR:UInt = 3;
	public static var TABLE:UInt = 4;
	public static var COUNTER:UInt = 5;
	public static var WALL:UInt = 6;


	public static function dynamicBodyFromSprite(
		S:FlxSprite,
		Mass:Float,
		Friction:Float,
		Restitution:Float,
		IsDynamic:Bool = true,
		HasSensor:Bool = false,
		Ignore:Bool = false,
		CategoryBits:Int = -1,
		MaskBits:Int = -1):B2Body
	{

		var categoryBits:Int = (CategoryBits == -1) ? (SOLID) : CategoryBits;
		var maskBits:Int = (MaskBits == -1) ? (SOLID | PARENT | PARENT_LOCK) : MaskBits;

		// if (Ignore) categoryBits = IGNORE;

		var bodyDefinition = new B2BodyDef();

		bodyDefinition.position.set(
			Physics.screenToWorld(S.x + S.width/2), 
			Physics.screenToWorld(S.y + S.height/2)
			);
		bodyDefinition.type = B2Body.b2_dynamicBody;

		bodyDefinition.bullet = true;

		var hitShape = new B2PolygonShape();
		hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/2));

		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		fixtureDef.shape = hitShape;
		fixtureDef.restitution = Restitution;
		fixtureDef.friction = Friction;


		// fixtureDef.filter.categoryBits = Ignore ? Physics.IGNORE : Physics.SOLID;
		fixtureDef.filter.categoryBits = categoryBits;
		fixtureDef.filter.maskBits = maskBits;

		Physics.WORLD.step(1 / 30, 1, 1);
		var body:B2Body = WORLD.createBody(bodyDefinition);

		var fixture:B2Fixture = body.createFixture(fixtureDef);

		if (HasSensor)
		{
			// UP SENSOR

			hitShape = new B2PolygonShape();

			hitShape.setAsOrientedBox(
				Physics.screenToWorld(S.width/2.1), 
				Physics.screenToWorld(S.height/2),
				new B2Vec2(0,Physics.screenToWorld(-S.height/2)));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = UP_SENSOR;

			fixture = body.createFixture(fixtureDef);


			// DOWN SENSOR

			hitShape = new B2PolygonShape();

			hitShape.setAsOrientedBox(
				Physics.screenToWorld(S.width/2.1), 
				Physics.screenToWorld(S.height/2),
				new B2Vec2(0,Physics.screenToWorld(S.height/2)));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = DOWN_SENSOR;

			fixture = body.createFixture(fixtureDef);

			// LEFT SENSOR

			hitShape = new B2PolygonShape();

			hitShape.setAsOrientedBox(
				Physics.screenToWorld(S.width/2.4), 
				Physics.screenToWorld(S.height/2.1),
				new B2Vec2(Physics.screenToWorld(-S.width/2),0));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = LEFT_SENSOR;

			fixture = body.createFixture(fixtureDef);

			// RIGHT SENSOR

			hitShape = new B2PolygonShape();

			hitShape.setAsOrientedBox(
				Physics.screenToWorld(S.width/2.4), 
				Physics.screenToWorld(S.height/2.1),
				new B2Vec2(Physics.screenToWorld(S.width/2),0));

			fixtureDef = new B2FixtureDef();
			fixtureDef.shape = hitShape;
			fixtureDef.isSensor = true;
			fixtureDef.filter.categoryBits = RIGHT_SENSOR;

			fixture = body.createFixture(fixtureDef);
		}

		var mass:B2MassData = new B2MassData();
		mass.mass = Mass;		
		// mass.mass = 10;
		body.setMassData(mass);
		body.setLinearDamping(10);

		return body;
	}


	public static function staticBodyFromSprite(S:FlxSprite,CategoryBits:Int = -1,MaskBits:Int = -1):B2Body
	{
		var categoryBits:Int = (CategoryBits == -1) ? (SOLID) : CategoryBits;
		var maskBits:Int = (MaskBits == -1) ? (SOLID | PARENT | PARENT_LOCK) : MaskBits;


		var bodyDefinition = new B2BodyDef();

		bodyDefinition.position.set(
			Physics.screenToWorld(S.x + S.width/2), 
			Physics.screenToWorld(S.y + S.height/2)
			);
		bodyDefinition.type = B2Body.b2_staticBody;

		var hitShape = new B2PolygonShape();
		hitShape.setAsBox(Physics.screenToWorld(S.width/2), Physics.screenToWorld(S.height/2));

		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		fixtureDef.shape = hitShape;
		fixtureDef.restitution = 1.0;
		fixtureDef.friction = 0.0;

		fixtureDef.filter.categoryBits = categoryBits;
		fixtureDef.filter.maskBits = maskBits;
		
		var body:B2Body = Physics.WORLD.createBody(bodyDefinition);
		body.createFixture(fixtureDef);

		var mass:B2MassData = new B2MassData();
		mass.mass = 1;
		body.setMassData(mass);
		body.setLinearDamping(10);

		return body;
	}


	public static function worldToScreen(N:Float):Float
	{
		return (N / SCALE);
	}


	public static function screenToWorld(N:Float):Float
	{
		return (N * SCALE);
	}


	// public static function getImpact(impulse:Float):Int
	// {
	// 	if (impulse > 25)
	// 	{
	// 		return HARD;
	// 	}
	// 	else if (impulse > 15)
	// 	{
	// 		trace("MEDIUM IMPACT");
	// 		return MEDIUM;
	// 	}
	// 	else if (impulse > 0)
	// 	{
	// 		trace("SOFT IMPACT");
	// 		return SOFT;
	// 	}
	// 	else
	// 	{
	// 		trace("NO IMPACT");
	// 		return NONE;
	// 	}
	// }
}