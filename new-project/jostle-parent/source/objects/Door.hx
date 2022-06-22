package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class Door extends FlxSprite
{
	public static var STANDARD_DOOR_WIDTH:Int = 12 * 8;
	public static var STANDARD_DOOR_HEIGHT:Int = 1 * 8;

	// public static var LOWER_DOOR_PLACEMENT_MARGIN:Int = 1 * 8 * 1;
	// public static var LOWER_DOOR_ARRIVAL_MARGIN:Int = -1 * 8 * 6;
	// public static var UPPER_DOOR_PLACEMENT_MARGIN:Int = -1 * 8 * 2;
	// public static var UPPER_DOOR_ARRIVAL_MARGIN:Int = 1 * 8 * 7;
	public var toDoor:Door; // The door this door is connected to
	public var place:Place; // Place this door is in (gets us location enum too)
	public var arrival:FlxPoint; // Arrival relative to the door's origin
	public var name:String; // Name of the door for debugging
	public var hides:Bool = false;
	public var orientation:Enums.Direction;

	public function new(X:Float, Y:Float, P:Place, Arrival:FlxPoint, Name:String, Orientation:Enums.Direction, Hides:Bool = false, W:Float = 12 * 8,
			H:Float = 1 * 8)
	{
		super(Std.int(X), Std.int(Y));
		makeGraphic(Std.int(W), Std.int(H), 0xFFFF0000);

		place = P;
		name = Name;
		arrival = Arrival;
		hides = Hides;
		orientation = Orientation;

		visible = false;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function handleOverlap(o:PhysicsSprite):Bool
	{
		if (o.kind == PARENT && cast(o, Parent).isDead())
			return false;

		if (o.active && o.hit.overlaps(this))
		{
			if (hides)
			{
				o.place = null;
				o.hide();
				return true;
			}

			if (arrival.x == -1)
			{
				if (o.kind == PARENT)
				{
					o.moveTo(toDoor.x + (o.x - this.x), toDoor.arrival.y - o.height + o.hit.height, toDoor.place);
				}
				else
				{
					if (orientation == UP)
					{
						o.moveTo(toDoor.x + (o.x - this.x), toDoor.arrival.y - o.height + o.hit.height - 4 * 8, toDoor.place);
					}
					else if (orientation == DOWN)
					{
						o.moveTo(toDoor.x + (o.x - this.x), toDoor.arrival.y - o.height + o.hit.height + 4 * 8, toDoor.place);
					}
					else
					{
						o.moveTo(toDoor.x + (o.x - this.x), toDoor.arrival.y - o.height + o.hit.height, toDoor.place);
					}
				}
			}
			else if (arrival.y == -1)
			{
				// Don't think this can ever happen?
				o.moveTo(toDoor.arrival.x, toDoor.y + (o.y - this.y) - o.height + o.hit.height, toDoor.place);
			}
			else
			{
				if (o.kind == PARENT)
				{
					o.moveTo(toDoor.arrival.x, toDoor.arrival.y - o.height + o.hit.height, toDoor.place);
				}
				else
				{
					if (orientation == UP)
					{
						o.moveTo(toDoor.arrival.x, toDoor.arrival.y - o.height + o.hit.height - 4 * 8, toDoor.place);
					}
					else if (orientation == DOWN)
					{
						o.moveTo(toDoor.arrival.x, toDoor.arrival.y - o.height + o.hit.height + 4 * 8, toDoor.place);
					}
					else
					{
						o.moveTo(toDoor.arrival.x, toDoor.arrival.y - o.height + o.hit.height, toDoor.place);
					}
				}
			}

			if (o.kind == PARENT)
				FlxG.camera.focusOn(toDoor.place.FOCUS_POINT);
			if (o.kind == CHILD)
				cast(o, Child).setMovementMode(POST_DOOR_STILL);

			return true;
		}
		else
		{
			return false;
		}
	}
}
