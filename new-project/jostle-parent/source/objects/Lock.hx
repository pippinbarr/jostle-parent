package;

import box2D.common.math.B2Mat22;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Vec2;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Lock extends PhysicsSprite
{
	var locked:Bool;

	// public function new(X:Float,Y:Float,S:String,F:UInt = FlxObject.RIGHT)
	public function new(X:Float, Y:Float, W:Float, H:Float, ParentOnly:Bool = false)
	{
		if (ParentOnly)
		{
			super(X, Y, "", 1, 1, 1000, false, false, false, 0, 2, false, Std.int(W), Std.int(H), AssetPaths.bathroom_floor_tile__png, 1, false,
				Physics.PARENT_LOCK, Physics.PARENT);
		}
		else
		{
			super(X, Y, "", 1, 1, 1000, false, false, false, 0, 2, false, Std.int(W), Std.int(H), AssetPaths.bathroom_floor_tile__png, 1, false);
		}

		kind = LOCK;

		locked = true;
	}

	public function lock():Void
	{
		unhide();
		locked = true;
	}

	public function unlock():Void
	{
		hide();
		locked = false;
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
