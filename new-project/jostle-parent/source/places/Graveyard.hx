package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

class Graveyard extends Place
{
	private var childGravestone1:PhysicsSprite;
	private var childGrave1:FlxSprite;
	private var childGravestone2:PhysicsSprite;
	private var childGrave2:FlxSprite;
	private var childGravestone3:PhysicsSprite;
	private var childGrave3:FlxSprite;

	private var parentGravestone:PhysicsSprite;
	private var parentGrave:FlxSprite;

	private var parentGraveTrigger:FlxSprite;

	private static var MAX_RAIN:Int = 200;

	private var rain:FlxGroup;
	private var rainSound:FlxSound;

	public function new(bg:FlxGroup, display:FlxTypedGroup<Sortable>, fg:FlxGroup, Doors:FlxGroup, DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = Std.int(1.5 * FlxG.width);
		ORIGIN_Y = Std.int(4.5 * FlxG.height);

		OFFSET_X = Std.int(ORIGIN_X) + 1 * 8;
		OFFSET_Y = Std.int(ORIGIN_Y) + 1 * 8;

		WIDTH = 80 * 8;
		HEIGHT = 60 * 8;

		location = GRAVEYARD;

		super();

		var bgSprite:FlxSprite = new FlxSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.graveyard_bg__png);
		bgSprite.origin.x = bgSprite.origin.y = 0;
		bgSprite.scale.x = bgSprite.scale.y = 8;

		var graveyardWall:PhysicsSprite = new PhysicsSprite(ORIGIN_X, ORIGIN_Y, AssetPaths.graveyard_wall__png, 1, 1, 1, false);

		childGravestone1 = new PhysicsSprite(ORIGIN_X + 30 * 8, ORIGIN_Y + 14 * 8, AssetPaths.graveyard_gravestone__png, 1, 0.2, 1, false);
		childGrave1 = new FlxSprite(childGravestone1.x - 8, childGravestone1.y + childGravestone1.height, AssetPaths.graveyard_gravestone_shadow__png);
		childGrave1.origin.x = childGrave1.origin.y = 0;
		childGrave1.scale.x = childGrave1.scale.y = 8;

		childGravestone2 = new PhysicsSprite(ORIGIN_X + 38 * 8, ORIGIN_Y + 14 * 8, AssetPaths.graveyard_gravestone__png, 1, 0.2, 1, false);
		childGrave2 = new FlxSprite(childGravestone2.x - 8, childGravestone2.y + childGravestone2.height, AssetPaths.graveyard_gravestone_shadow__png);
		childGrave2.origin.x = childGrave2.origin.y = 0;
		childGrave2.scale.x = childGrave2.scale.y = 8;

		childGravestone3 = new PhysicsSprite(ORIGIN_X + 46 * 8, ORIGIN_Y + 14 * 8, AssetPaths.graveyard_gravestone__png, 1, 0.2, 1, false);
		childGrave3 = new FlxSprite(childGravestone3.x - 8, childGravestone3.y + childGravestone3.height, AssetPaths.graveyard_gravestone_shadow__png);
		childGrave3.origin.x = childGrave3.origin.y = 0;
		childGrave3.scale.x = childGrave3.scale.y = 8;

		parentGravestone = new PhysicsSprite(ORIGIN_X + 20 * 8, ORIGIN_Y + 11 * 8, AssetPaths.graveyard_parent_gravestone__png, 1, 0.2, 1, false);
		parentGrave = new FlxSprite(parentGravestone.x - 8, parentGravestone.y + parentGravestone.height, AssetPaths.graveyard_parent_gravestone_shadow__png);
		parentGrave.origin.x = parentGrave.origin.y = 0;
		parentGrave.scale.x = parentGrave.scale.y = 8;

		parentGraveTrigger = new FlxSprite(parentGravestone.x + parentGravestone.width / 2 - 1 * 8, parentGravestone.y + parentGravestone.height);
		parentGraveTrigger.makeGraphic(2 * 8, 2 * 8, 0xFFFF0000);
		parentGraveTrigger.visible = false;

		rain = new FlxGroup();
		for (i in 0...MAX_RAIN)
		{
			var X:Int = ORIGIN_X + Math.floor(Math.random() * FlxG.width / 8) * 8;
			var Y:Int = ORIGIN_Y + Math.floor(Math.random() * FlxG.height / 8) * 8;
			var drop:FlxSprite = new FlxSprite(X, Y, AssetPaths.raindrop__png);
			drop.origin.x = drop.origin.y = 0;
			drop.scale.x = drop.scale.y = 8;
			drop.width *= drop.scale.x;
			drop.height *= drop.scale.y;

			drop.alpha = 0.6;

			drop.velocity.y = Math.floor(Math.random() * 60) * 8 + 60 * 8;

			rain.add(drop);
		}
		fg.add(rain);

		rainSound = new FlxSound();
		rainSound.loadEmbedded(AssetPaths.shower__wav, true, false);

		bg.add(bgSprite);
		bg.add(childGrave1);
		bg.add(childGrave2);
		bg.add(childGrave3);
		bg.add(parentGrave);

		bg.add(parentGraveTrigger);

		display.add(graveyardWall);
		display.add(childGravestone1);
		display.add(childGravestone2);
		display.add(childGravestone3);
		display.add(parentGravestone);

		childGravestone1.hide();
		childGrave1.visible = false;
		childGravestone2.hide();
		childGrave2.visible = false;
		childGravestone3.hide();
		childGrave3.visible = false;
		parentGravestone.hide();
		parentGrave.visible = false;

		for (i in 0...doors.length)
			Doors.add(doors[i]);
	}

	override public function destroy():Void
	{
		super.destroy();

		childGravestone1.destroy();
		childGrave1.destroy();
		childGravestone2.destroy();
		childGrave2.destroy();
		childGravestone3.destroy();
		childGrave3.destroy();
		parentGravestone.destroy();
		parentGrave.destroy();
		parentGraveTrigger.destroy();
		rain.destroy();
		rainSound.destroy();
	}

	override public function update():Void
	{
		if (PlayState.parent.place != this)
			return;

		for (i in 0...rain.members.length)
		{
			if (rain.members[i] == null)
				continue;

			var drop:FlxSprite = cast(rain.members[i], FlxSprite);
			if (drop.y > ORIGIN_Y + FlxG.height || (drop.y > ORIGIN_Y + FlxG.height / 2 && Math.random() > 0.95))
			{
				var X:Int = ORIGIN_X + Math.floor(Math.random() * FlxG.width / 8) * 8;

				drop.y = ORIGIN_Y - drop.height - Math.floor(Math.random() * 4) * 8;
				drop.x = X;
			}
		}

		rainSound.play();
	}

	public function setupGravestones(NumChildStones:Int, ParentStone:Bool):Void
	{
		if (NumChildStones >= 1)
		{
			childGravestone2.unhide();
			childGrave2.visible = true;
		}

		if (NumChildStones >= 2)
		{
			childGravestone3.unhide();
			childGrave3.visible = true;
		}

		if (NumChildStones >= 3)
		{
			childGravestone1.unhide();
			childGrave1.visible = true;
		}

		if (ParentStone)
		{
			switch (NumChildStones)
			{
				case 0:
					parentGravestone.unhide();
					parentGravestone.moveTo(ORIGIN_X + FlxG.width / 2 - parentGravestone.width / 2, parentGravestone.y, this);
					parentGrave.visible = true;

					parentGrave.x = parentGravestone.x - 8;
					parentGrave.y = parentGravestone.y + parentGravestone.height;

				case 1:
					parentGravestone.unhide();
					parentGravestone.moveTo(childGravestone2.x - 4 * 8 - parentGravestone.width, parentGravestone.y, this);
					parentGrave.visible = true;
					parentGrave.x = parentGravestone.x - 8;
					parentGrave.y = parentGravestone.y + parentGravestone.height;

				case 2:
					parentGravestone.unhide();
					parentGravestone.moveTo(childGravestone2.x - 4 * 8 - parentGravestone.width, parentGravestone.y, this);
					parentGrave.visible = true;
					parentGrave.x = parentGravestone.x - 8;
					parentGrave.y = parentGravestone.y + parentGravestone.height;

				case 3:
					parentGravestone.unhide();
					parentGravestone.moveTo(childGravestone1.x - 4 * 8 - parentGravestone.width, parentGravestone.y, this);
					parentGrave.visible = true;
					parentGrave.x = parentGravestone.x - 8;
					parentGrave.y = parentGravestone.y + parentGravestone.height;
			}

			if (parentGravestone.visible)
			{
				parentGraveTrigger.x = parentGravestone.x + parentGravestone.width / 2 - 1 * 8;
				parentGraveTrigger.y = parentGravestone.y + parentGravestone.height;
			}
		}
	}

	public function checkParentGraveTrigger(p:Parent):Bool
	{
		return (parentGrave.visible && p.hit.overlaps(parentGraveTrigger));
	}
}
