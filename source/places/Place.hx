import flixel.util.FlxPoint;
import flixel.FlxG;

class Place
{
	public var ORIGIN_X:Int;
	public var ORIGIN_Y:Int;
	public var OFFSET_X:Int;
	public var OFFSET_Y:Int;
	public var WIDTH:Int;
	public var HEIGHT:Int;

	public var FOCUS_POINT:FlxPoint;

	public var DOOR_WIDTH:Int = 12 * 8;
	public var DOOR_HEIGHT:Int = 2 * 8;

	public var location:Enums.Location;



	public var doors:Array<Door>;


	public function new():Void
	{
		FOCUS_POINT = new FlxPoint(ORIGIN_X + FlxG.width/2,ORIGIN_Y + FlxG.height/2);

		doors = new Array();
	}


	public function save():Void
	{
		
	}


	public function contains(S:PhysicsSprite):Bool
	{
		return !S.hidden && S.alive && !(
			S.x > ORIGIN_X + FlxG.width ||
			S.x + S.width < ORIGIN_X ||
			S.y > ORIGIN_Y + FlxG.height ||
			S.y + S.height < ORIGIN_Y);
	}


	public function handlePlaceDoors(P:PhysicsSprite):Bool
	{
		var moved:Bool = false;

		if (P.place != this || !P.alive || !P.active) return false;

		for (i in 0...doors.length)
		{
			if (!moved) moved = doors[i].handleOverlap(P);
		}

		return moved;
	}


	public function update():Void
	{
		
	}


	public function destroy():Void
	{
		FOCUS_POINT.destroy();
	}
}