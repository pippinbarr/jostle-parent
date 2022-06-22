import flash.events.Event;

class JostleEvent extends Event
{
	public var strength:Float;
	public var velocityX:Float;
	public var velocityY:Float;

	public function new(label:String, strength:Float, velocityX:Float = 0, velocityY:Float = 0, bubbles:Bool = false, cancelable:Bool = false ) 
	{
		super(label,bubbles,cancelable);
		this.strength = strength;
		this.velocityX = velocityX;
		this.velocityY = velocityY;
	}

}