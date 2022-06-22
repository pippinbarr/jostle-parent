package;

import flixel.FlxSprite;

import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.B2Fixture;


class JostleContactListener extends B2ContactListener
{
	public function new() 
	{
		super();
	}


	override public function beginContact(contact:B2Contact):Void 
	{		
		super.beginContact(contact);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		var sensorA:Int = fixtureA.getFilterData().categoryBits;
		var sensorB:Int = fixtureB.getFilterData().categoryBits;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		// if (spriteA.active && !spriteB.ignore) spriteA.beginContact(sensorA,sensorB,spriteB);
		// if (spriteB.active && !spriteA.ignore) spriteB.beginContact(sensorB,sensorA,spriteA);

		if (spriteA.active) spriteA.beginContact(sensorA,sensorB,spriteB);
		if (spriteB.active) spriteB.beginContact(sensorB,sensorA,spriteA);

	}


	override public function endContact(contact:B2Contact):Void 
	{		
		super.endContact(contact);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		var sensorA:Int = fixtureA.getFilterData().categoryBits;
		var sensorB:Int = fixtureB.getFilterData().categoryBits;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		// if (spriteA.active && !spriteB.ignore) spriteA.endContact(sensorA,sensorB,spriteB);
		// if (spriteB.active && !spriteA.ignore) spriteB.endContact(sensorB,sensorA,spriteA);

		if (spriteA.active) spriteA.endContact(sensorA,sensorB,spriteB);
		if (spriteB.active) spriteB.endContact(sensorB,sensorA,spriteA);

	}

	override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void
	{
		super.postSolve(contact,impulse);

		var fixtureA:B2Fixture = contact.getFixtureA();
		var fixtureB:B2Fixture = contact.getFixtureB();

		if (fixtureA.isSensor() || fixtureB.isSensor()) return;

		var spriteA:PhysicsSprite = contact.getFixtureA().getBody().getUserData();
		var spriteB:PhysicsSprite = contact.getFixtureB().getBody().getUserData();

		// if (spriteA.active && !spriteB.ignore) spriteA.postSolve(spriteB,impulse);		
		// if (spriteB.active && !spriteA.ignore) spriteB.postSolve(spriteA,impulse);		

		if (spriteA.active) spriteA.postSolve(spriteB,impulse);		
		if (spriteB.active) spriteB.postSolve(spriteA,impulse);		

	}



}