import flixel.FlxSprite;

import flixel.util.FlxPoint;


class Sortable extends FlxSprite
{
	public var sortKey:Float;

	
	public function new(X:Float, Y:Float, S:Dynamic=null, ScaleX:Int = 8, ScaleY:Int = 8):Void
	{
		super(X,Y,S);
	}
}