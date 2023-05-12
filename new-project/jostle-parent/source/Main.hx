package;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;

class Main extends Sprite
{
	public function new()
	{
		super();

		var urlRequest:URLRequest;
		if (Global.cn)
		{
			urlRequest = new URLRequest(AssetPaths.cn__json);
		}
		else
		{
			urlRequest = new URLRequest(AssetPaths.en__json);
		}
		urlRequest.method = URLRequestMethod.GET;
		var urlLoader:URLLoader = new URLLoader(urlRequest);
		urlLoader.addEventListener(Event.COMPLETE, function(e:Event)
		{
			var urlLoader:URLLoader = cast(e.target, URLLoader);
			Global.strings = haxe.Json.parse(urlLoader.data);
			addChild(new FlxGame(0, 0, PlayState));
		});
	}
}
