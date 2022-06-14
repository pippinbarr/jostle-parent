package;

import box2D.common.math.B2Vec2;



class Food extends PhysicsSprite
{
	private static var FOOD_IMPULSE:Int = 4;
	private static var foodPNGs:Array<String> = [
	AssetPaths.kitchen_food_1__png,
	AssetPaths.kitchen_food_2__png,
	AssetPaths.kitchen_food_3__png,
	AssetPaths.kitchen_food_4__png,
	AssetPaths.kitchen_food_5__png];

	public function new(X:Float,Y:Float,T:Int,Impulse:Bool = true)
	{
		var s:String = foodPNGs[T % foodPNGs.length];

		super(X,Y,s,0.5,0.5,0.1,true,false,true,5,1);

		kind = FOOD;

		Physics.WORLD.step(0,0,0);

		if (Impulse) body.applyImpulse(new B2Vec2((Math.random() * -FOOD_IMPULSE),FOOD_IMPULSE/2 - (Math.random() * FOOD_IMPULSE)),body.getPosition());
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
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