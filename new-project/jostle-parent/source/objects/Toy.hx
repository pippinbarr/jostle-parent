package;

import box2D.common.math.B2Vec2;

class Toy extends PhysicsSprite
{
	private static var toyPNGs:Array<String> = [
		AssetPaths.kids_bedroom_toy_1__png,
		AssetPaths.kids_bedroom_toy_2__png,
		AssetPaths.kids_bedroom_toy_3__png,
		AssetPaths.kids_bedroom_toy_4__png,
		AssetPaths.kids_bedroom_toy_5__png
	];

	public function new(X:Float, Y:Float, T:Int)
	{
		var s:String = toyPNGs[T % toyPNGs.length];

		super(X, Y, s, 0.5, 0.5, 0.1, true, false, true, 5, 1);

		kind = TOY;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	override public function beginContact(Sensor:Int, OtherSensor:Int, TheOther:PhysicsSprite):Void
	{
		super.beginContact(Sensor, OtherSensor, TheOther);
	}

	override public function endContact(Sensor:Int, OtherSensor:Int, TheOther:PhysicsSprite):Void
	{
		super.endContact(Sensor, OtherSensor, TheOther);
	}

	override public function kill():Void
	{
		super.kill();
	}
}
