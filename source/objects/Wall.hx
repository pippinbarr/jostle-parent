package;


class Wall extends PhysicsSprite
{

	// public function new(X:Float,Y:Float,S:String,F:UInt = FlxObject.RIGHT)
	public function new(X:Int,Y:Int,W:Int,H:Int,T:String)
	{
		super(X,Y,"",1,1,1000,false,false,false,0,2,false,W,H,T);

		kind = WALL;
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}
}
