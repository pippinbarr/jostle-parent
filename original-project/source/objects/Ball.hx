package;

import box2D.common.math.B2Vec2;



class Ball extends PhysicsSprite
{
	private static var BALL_IMPULSE:Float = 5;
	
	public function new(X:Float,Y:Float)
	{
		super(X,Y,AssetPaths.park_ball__png,1,1,0.1,true,false,true,1,1,false,0,0,"",8,false,Physics.PARENT,(Physics.SOLID | Physics.PARENT | Physics.PARENT_LOCK));

		kind = BALL;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}

	override private function handleImpact(Impact:Int,OtherSprite:PhysicsSprite):Void
	{
		super.handleImpact(Impact,OtherSprite);

		if (OtherSprite.kind == CHILD || OtherSprite.kind == PARENT) 
		{
			if (Math.abs(OtherSprite.body.getLinearVelocity().x) > Math.abs(OtherSprite.body.getLinearVelocity().y))
			{
				// body.applyImpulse(new B2Vec2((Math.random() * -BALL_IMPULSE),BALL_IMPULSE/2 - (Math.random() * BALL_IMPULSE)),body.getPosition());
				body.applyImpulse(new B2Vec2(0,BALL_IMPULSE/2 - (Math.random() * BALL_IMPULSE)),body.getPosition());
			}
			else
			{
				body.applyImpulse(new B2Vec2(BALL_IMPULSE/2 - (Math.random() * BALL_IMPULSE),0),body.getPosition());
			}
		}


	}

	override public function beginContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor,OtherSensor,TheOther);
	}

	override public function endContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,TheOther);
	}


	override public function kill():Void
	{		
		super.kill();
	}
}