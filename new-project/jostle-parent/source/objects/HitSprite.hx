package;

import flixel.FlxSprite;

class HitSprite extends Sortable
{
	public var parent:PhysicsSprite;

	public function new(X:Float = 0, Y:Float = 0, P:PhysicsSprite = null)
	{
		super(Std.int(X), Std.int(Y));

		parent = P;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
