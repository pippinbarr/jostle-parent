package;

import flixel.FlxG;
import flixel.FlxObject;

import flixel.text.FlxText;

import box2D.common.math.B2Vec2;


class Person extends PhysicsSprite
{
	private var MOVEMENT_IMPULSE:Float = 10.0;

	public var upBlocks:Int = 0;
	public var downBlocks:Int = 0;
	public var leftBlocks:Int = 0;
	public var rightBlocks:Int = 0;


	// public var anyBlocks:Int = 0;

	// public var upText:FlxText;
	// public var downText:FlxText;
	// public var leftText:FlxText;
	// public var rightText:FlxText;
	// public var anyText:FlxText;



	public function new(X:Float,Y:Float,Sprite:String,XHit:Float,YHit:Float,W:Int,H:Int,M:Float,CategoryBits:Int = -1,MaskBits:Int = -1)
	{
		super(X,Y,Sprite,XHit,YHit,M,true,true,false,10,1,true,W,H,"",8,false,CategoryBits,MaskBits);
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		// updateBlockerDebugDisplay();		
	}



	public function moveToSetPoint(X:Float,Y:Float):Void
	{
		body.setPosition(new B2Vec2(X,Y));
		updatePosition();
	}


	public function moveLeft(IgnoreBlocks:Bool = false):Bool
	{
		this.facing = FlxObject.LEFT;
		body.applyImpulse(new B2Vec2(-MOVEMENT_IMPULSE,0),body.getPosition());

		return true;
	}


	public function moveRight(IgnoreBlocks:Bool = false):Bool
	{		
		// if (body.getLinearVelocity().x > 0) return true;

		this.facing = FlxObject.RIGHT;
		body.applyImpulse(new B2Vec2(MOVEMENT_IMPULSE,0),body.getPosition());
		// body.setLinearVelocity(new B2Vec2(50,0));

		return true;
	}


	public function moveUp(IgnoreBlocks:Bool = false):Bool
	{		
		body.applyImpulse(new B2Vec2(0,-MOVEMENT_IMPULSE),body.getPosition());

		return true;
	}


	public function moveDown(IgnoreBlocks:Bool = false):Bool
	{
		body.applyImpulse(new B2Vec2(0,MOVEMENT_IMPULSE),body.getPosition());

		return true;
	}


	public function idleX():Void
	{
		body.setLinearVelocity(new B2Vec2(0,body.getLinearVelocity().y));
	}


	public function idleY():Void
	{
		body.setLinearVelocity(new B2Vec2(body.getLinearVelocity().x,0));
	}


	public function idle():Bool
	{
		body.setLinearVelocity(new B2Vec2(0,0));

		return true;
	}


	



	private function flee(Target:Person):Void
	{
		if (Target == null) return;

		if (Math.abs((x - Target.x)) >= Math.abs((y - Target.y)))
		{
			fleeX(Target);
		}
		else
		{
			fleeY(Target);
		}
	}


	private function fleeY(Target:Person):Void
	{
		if (y > Target.y)
		{
			if (downBlocks == 0) moveDown();
			else if (Math.random() > 0.5) moveRight();
			else moveLeft();
		}
		else if (y <= Target.y)
		{
			if (upBlocks == 0) moveUp();
			else if (Math.random() > 0.5) moveRight();
			else moveLeft();
		}
		else idle();
	}


	private function fleeX(Target:Person):Void
	{
		if (x > Target.x)
		{
			if (rightBlocks == 0) moveRight();
			else if (Math.random() > 0.5) moveUp();
			else moveDown();
		}
		else if (x <= Target.x)
		{
			if (leftBlocks == 0) moveLeft();
			else if (Math.random() > 0.5) moveUp();
			else moveDown();
		}
		else idle();
	}



	override private function handleImpact(Impact:Int,OtherSprite:PhysicsSprite):Void
	{
		super.handleImpact(Impact,OtherSprite);
	}

	
	override public function beginContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor,OtherSensor,TheOther);

		if (OtherSensor != Physics.SOLID) return;
		if (TheOther.ignore) return;

		if (Sensor == Physics.UP_SENSOR) upBlocks++;
		if (Sensor == Physics.DOWN_SENSOR) downBlocks++;
		if (Sensor == Physics.LEFT_SENSOR) leftBlocks++;
		if (Sensor == Physics.RIGHT_SENSOR) rightBlocks++;
	}




	override public function endContact(Sensor:Int,OtherSensor:Int,TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor,OtherSensor,TheOther);

		if (OtherSensor != Physics.SOLID) return;
		if (TheOther.ignore) return;
		
		if (Sensor == Physics.UP_SENSOR) upBlocks--;
		if (Sensor == Physics.DOWN_SENSOR) downBlocks--;
		if (Sensor == Physics.LEFT_SENSOR) leftBlocks--;
		if (Sensor == Physics.RIGHT_SENSOR) rightBlocks--;
	}


	override public function moveTo(X:Float,Y:Float,P:Place):Void
	{
		super.moveTo(X,Y,P);
	}


	// private function setupBlockerDebugDisplay():Void
	// {
	// 	upText = new FlxText(x + width/2,y - 10,10,"" + upBlocks);
	// 	downText = new FlxText(x + width/2,y + height + 2,10,"" + upBlocks);
	// 	leftText = new FlxText(x - 10,y + height/2,10,"" + upBlocks);
	// 	rightText = new FlxText(x + width + 10,y + height/2,10,"" + upBlocks);
	// 	anyText = new FlxText(x + width/2,y + height/2,10,"" + upBlocks, 20);
		
	// 	FlxG.state.add(upText);
	// 	FlxG.state.add(downText);
	// 	FlxG.state.add(leftText);
	// 	FlxG.state.add(rightText);
	// 	FlxG.state.add(anyText);
	// }

	// private function updateBlockerDebugDisplay():Void
	// {
	// 	upText.text = "" + upBlocks;
	// 	upText.x = x + width/2;
	// 	upText.y = y - 10;
	// 	leftText.text = "" + leftBlocks;
	// 	leftText.x = x - 10;
	// 	leftText.y = y + height/2;
	// 	rightText.text = "" + rightBlocks;
	// 	rightText.x = x + width + 10;
	// 	rightText.y = y + height/2;	
	// 	downText.text = "" + downBlocks;
	// 	downText.x = x + width/2;
	// 	downText.y = y + height + 10;		
	// 	anyText.text = "" + anyBlocks;
	// 	anyText.x = x + width/2;
	// 	anyText.y = y + height/2;	
	// }
}