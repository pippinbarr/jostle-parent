
package;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.text.FlxText;

import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxPoint;


class Menu extends Place
{	
	private var letters:Array<PhysicsSprite>;

	public function new(bg:FlxGroup,display:FlxTypedGroup<Sortable>,Doors:FlxGroup,DoorMovables:FlxGroup):Void
	{
		ORIGIN_X = 0 * FlxG.width;
		ORIGIN_Y = 0 * FlxG.height;

		location = MENU;

		super();

		var bgTile:FlxSprite = new FlxSprite(ORIGIN_X,ORIGIN_Y,AssetPaths.menu_bg_tile__png);
		bgTile.origin.x = bgTile.origin.y = 0;
		bgTile.scale.x = FlxG.width;
		bgTile.scale.y = FlxG.height;


		var letterX:Float = ORIGIN_X + 100;
		var letterY:Int = ORIGIN_Y + 100;

		var l:PhysicsSprite;

		letters = new Array();
		var letterIndex:Int = 0;
		var titleStringUpper:String = "JOSTLE";
		for (i in 0...titleStringUpper.length)
		{
			
			if (FlxG.save.data.menu_letters != null)
			{
				l = new PhysicsSprite(
					FlxG.save.data.menu_letters[letterIndex + i].x,
					FlxG.save.data.menu_letters[letterIndex + i].y,
					"assets/images/menu/menu_" + titleStringUpper.charAt(i) + ".png",
					1,0.25,1,true,false,false,2,1,false,0,0,"",8);
			}
			else
			{
				l = new PhysicsSprite(
					letterX,letterY,
					"assets/images/menu/menu_" + titleStringUpper.charAt(i) + ".png",
					1,0.25,1,true,false,false,2,1,false,0,0,"",8);
			}
			letters.push(l);
			letterX = l.x + l.width + 10;
			display.add(l);
		}

		letterIndex += titleStringUpper.length;
		letterX = ORIGIN_X + 100;
		letterY += 64;

		var titleStringLower:String = "PARENT";
		for (i in 0...titleStringLower.length)
		{
			if (FlxG.save.data.menu_letters != null)
			{
				l = new PhysicsSprite(
					FlxG.save.data.menu_letters[letterIndex + i].x,
					FlxG.save.data.menu_letters[letterIndex + i].y,
					"assets/images/menu/menu_" + titleStringLower.charAt(i) + ".png",
					1,0.25,1,true,false,false,2,1,false,0,0,"",8);
			}
			else
			{
				l = new PhysicsSprite(
					letterX,letterY,
					"assets/images/menu/menu_" + titleStringLower.charAt(i) + ".png",
					1,0.25,1,true,false,false,2,1,false,0,0,"",8);				
			}
			letters.push(l);
			letterX = l.x + l.width + 10;
			display.add(l);
		}


		bg.add(bgTile);

		for (i in 0...doors.length) Doors.add(doors[i]);

	}


	override public function destroy():Void
	{
		super.destroy();

		for (i in 0...letters.length) letters[i].destroy();
	}


	override public function save():Void
	{
		FlxG.save.data.menu_letters = new Array();
		for (i in 0...letters.length)
		{
			FlxG.save.data.menu_letters.push(new FlxPoint(letters[i].x,letters[i].y));
		}
	}
}