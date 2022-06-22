package;

// import flixel.FlxSound;
import flixel.FlxBasic;
import flixel.system.FlxSound;

enum Tempo
{
	SLOW;
	MEDIUM;
	FAST;
}

class Music extends FlxBasic
{
	private static var NUM_KICKS:Int = 7;
	private static var NUM_SNARES:Int = 5;
	private static var NUM_HIHATS:Int = 6;
	private static var NUM_SPLASHES:Int = 3;

	private static var TEMPO:Tempo = SLOW;
	// private static var FRAMES_PER_BEAT:Int = 8;
	private static var FRAMES_PER_BEAT:Int = 4;
	private static var BEATS_PER_BAR:Int = 8;

	private static var BLANK_TRACK_LINE:Array<String> = [""];

	private static var BLANK_MELODY_LINE:Array<Int> = [-1,];

	private static var ARRESTED:Array<String> = [
		"k", "", "k", "", "k",  "", "k", "",
		"k", "", "k", "", "k",  "", "k", "",
		"k", "", "k", "", "k",  "", "k", "",
		"k", "", "k", "", "k", "k", "k", "k",
	];

	private static var COMPLETED:Array<String> = [
		"k", "", "s", "", "k", "k", "s", "",
		"k", "", "s", "", "k", "k", "s", "",
		"k", "", "s", "", "k", "k", "s", "",
		"k", "", "s", "", "k", "k", "s", "",
	];

	private static var TRACK_1:Array<String> = [
		"k",  "h", "k",  "h", "k",  "h",  "k", "h",
		"k", "sh", "k", "sh", "k", "sh",  "k", "p",
		"k",  "h", "k",  "h", "k",  "h",  "k", "h",
		"k", "sh", "k", "sh", "k", "ph", "ph", "p",
	];

	private static var TRACK_2:Array<String> = [
		"kh",   "", "ksh",  "", "kh",  "", "ksh",   "",
		"kh", "sk",   "k", "s", "kh",  "",   "k", "sp",
		"kh",  "k", "skh",  "", "kh", "k", "shk",   "",
		"kh",  "s",  "kh", "s", "kh", "h", "kph", "ph",
	];

	private static var TRACK_3:Array<String> = [
		"k", "", "skh",  "h", "k", "k",    "s",   "h",
		"k", "", "ksh", "ph", "k", "k",   "sh",  "sh",
		"k", "", "ksh",  "h", "k", "k",    "s",   "h",
		"k", "", "ksh", "ph", "k", "k", "ksph", "ksph",
	];

	private static var TRACK_4:Array<String> = [
		"k",  "h", "ks", "h", "k",  "h",  "ks",  "h",
		"k", "hs", "ks", "h", "k",  "h",  "kh", "hp",
		"k",  "h", "ks", "h", "k",  "h",  "ks",  "h",
		"k", "hs", "ks", "h", "k", "hs", "khs", "ps",
	];

	private static var TRACK_5:Array<String> = [
		"k", "s", "", "h", "kp", "",  "s", "h",
		"k", "s", "",  "",  "k", "",  "s",  "",
		"k", "s", "",  "", "kp", "", "sh", "h",
		"k", "s", "", "s",  "k", "", "sp", "sp",
	];

	private static var TRACK_6:Array<String> = [
		"k", "",  "", "s", "k", "",   "", "s",
		"k", "", "h", "h", "k", "",  "k", "s",
		"k", "",  "", "s", "k", "",   "", "s",
		"k", "", "h", "h", "k", "", "ks", "ps",
	];

	private static var TRACK_7:Array<String> = [
		"k",  "", "s", "sh",  "k",  "",   "", "sh",
		"k", "s",  "",  "h", "kp", "s",   "",  "h",
		"k",  "", "s", "sh",  "k",  "",   "", "sh",
		"k", "s",  "",  "h", "kp",  "", "kp", "sp",
	];

	private static var TRACK_8:Array<String> = [
		 "k", "", "s", "h", "kp",  "",  "s",  "",
		 "k", "", "s", "h",  "k", "k",  "s", "s",
		 "k", "", "s", "h", "kp",  "",  "s",  "",
		"kp", "", "h", "h", "kp", "k", "ps", "s",
	];

	private static var TRACKS:Array<Array<String>> = [TRACK_1, TRACK_2, TRACK_3, TRACK_4]; // ,TRACK_5,TRACK_6,TRACK_7,TRACK_8];

	private var frames:Int = 0;
	private var beats:Int = 0;
	private var bars:Int = 0;

	private var track:Array<String>;
	private var index:Int = 0;

	// private var kick:FlxSound;
	// private var snare:FlxSound;
	// private var hihat:FlxSound;
	// private var splash:FlxSound;
	private var kicks:Array<FlxSound>;
	private var snares:Array<FlxSound>;
	private var hihats:Array<FlxSound>;
	private var splashes:Array<FlxSound>;

	private var jostle:FlxSound;
	private var softJostle:FlxSound;

	private var volume:Float = 0;
	private var volumeIncrement:Float = 0;

	public var playing:Bool = false;

	private var switchTrack:Bool = false;

	public function new():Void
	{
		super();

		jostle = new FlxSound();
		jostle.loadEmbedded(AssetPaths.jostle__mp3, false, false);
		jostle.volume = 0.5;

		softJostle = new FlxSound();
		softJostle.loadEmbedded(AssetPaths.jostle__mp3, false, false);
		softJostle.volume = 0.2;

		createInstruments();
		switchTheTrack();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		frames++;

		// trace(PlayState.justJostled);

		if (PlayState.justJostled != NONE && frames == FRAMES_PER_BEAT)
		{
			// trace(PlayState.justJostled);

			if (PlayState.justJostled == NORMAL)
				jostle.play(true);
			else if (PlayState.justJostled == SOFT)
				softJostle.play(true);

			PlayState.justJostled = NONE;
		}

		if (!playing)
			return;

		setVolumes();

		if (frames >= FRAMES_PER_BEAT)
		{
			beats++;

			// trace("Playing music.");

			if (track[index].indexOf("k") != -1)
				kicks[Math.floor(Math.random() * kicks.length)].play(true);
			// if (track[index].indexOf("s") != -1) snares[Math.floor(Math.random() * snares.length)].play(true);
			// if (track[index].indexOf("k") != -1) kicks[0].play(true);
			// if (track[index].indexOf("s") != -1) snares[0].play(true);
			if (track[index].indexOf("h") != -1)
				hihats[Math.floor(Math.random() * hihats.length)].play(true);
			if (track[index].indexOf("p") != -1)
				splashes[Math.floor(Math.random() * splashes.length)].play(true);

			frames = 0;
			index = (index + 1) % track.length;

			if (beats == BEATS_PER_BAR)
			{
				beats = 0;
				bars++;
			}

			if (bars == 8)
			{
				if (Math.random() < 0.25)
					return;
				index = 0;
				switchTheTrack();
			}
		}
	}

	private function setVolumes():Void
	{
		if (volumeIncrement == 0)
			return;

		volume += volumeIncrement;
		if (volume < 0)
		{
			volume = 0;
			volumeIncrement = 0;
		}
		if (volume > 1)
		{
			volume = 1;
			volumeIncrement = 0;
		}

		for (i in 0...kicks.length)
			kicks[i].volume = volume;
		for (i in 0...snares.length)
			snares[i].volume = volume;
		for (i in 0...hihats.length)
			hihats[i].volume = volume;
		for (i in 0...splashes.length)
			splashes[i].volume = volume;
	}

	private function switchTheTrack():Void
	{
		if (track == COMPLETED)
			return;

		frames = 0;
		beats = 0;
		bars = 0;

		track = TRACKS[Math.floor(Math.random() * TRACKS.length)];
	}

	override public function destroy():Void
	{
		super.destroy();

		jostle.destroy();
		softJostle.destroy();
		for (i in 0...kicks.length)
			kicks[i].destroy();
		for (i in 0...snares.length)
			snares[i].destroy();
		for (i in 0...hihats.length)
			hihats[i].destroy();
		for (i in 0...splashes.length)
			splashes[i].destroy();
	}

	public function fadeIn(t:Float):Void
	{
		playing = true;
		volume = 0;
		volumeIncrement = 1 / (t * 30);
	}

	public function fadeOut(t:Float):Void
	{
		volumeIncrement = -1 / (t * 30);
	}

	private function generateRandomDrumTrack(Hits:Int):Array<String>
	{
		var rTrack:Array<String> = new Array();
		for (i in 0...Hits)
		{
			var t:String = "";
			if (Math.random() < 0.25)
				t += "k";
			if (Math.random() < 0.2)
				t += "s";
			if (Math.random() < 0.3)
				t += "h";
			if (Math.random() < 0.1)
				t += "p";
			rTrack.push(t);
		}

		return rTrack;
	}

	private function createInstruments():Void
	{
		kicks = new Array();
		kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone0__mp3, false, false));
		kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone1__mp3, false, false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone2__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone3__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone4__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone5__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone6__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone7__mp3,false,false));
		// kicks.push(new FlxSound().loadEmbedded(AssetPaths.tone8__mp3,false,false));

		snares = new Array();
		snares.push(new FlxSound().loadEmbedded(AssetPaths.snare1__mp3, false, false));
		// snares.push(new FlxSound().loadEmbedded(AssetPaths.snare2__mp3,false,false));
		snares.push(new FlxSound().loadEmbedded(AssetPaths.snare3__mp3, false, false));

		hihats = new Array();
		// hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone0__mp3,false,false));
		// hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone1__mp3,false,false));
		// hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone2__mp3,false,false));
		// hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone3__mp3,false,false));
		hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone4__mp3, false, false));
		hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone5__mp3, false, false));
		hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone6__mp3, false, false));
		hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone7__mp3, false, false));
		hihats.push(new FlxSound().loadEmbedded(AssetPaths.tone8__mp3, false, false));

		splashes = new Array();
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone0__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone1__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone2__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone3__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone4__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone5__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone6__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone7__mp3, false, false));
		splashes.push(new FlxSound().loadEmbedded(AssetPaths.tone8__mp3, false, false));
	}
}
