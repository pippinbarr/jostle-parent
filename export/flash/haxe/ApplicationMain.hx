#if !macro


@:access(lime.Assets)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new lime.app.Application ();
		app.create (config);
		openfl.Lib.application = app;
		
		#if !flash
		var stage = new openfl.display.Stage (app.window.width, app.window.height, config.background);
		stage.addChild (openfl.Lib.current);
		app.addModule (stage);
		#end
		
		var display = new Preloader ();
		
		preloader = new openfl.display.Preloader (display);
		preloader.onComplete = init;
		preloader.create (config);
		
		#if (js && html5)
		var urls = [];
		var types = [];
		
		
		urls.push ("assets/data/data-goes-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/images/bathroom/bathroom_bath.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_mirror.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_sink.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_toilet.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bathroom/bathroom_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_full_fence.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_left_cliff.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_left_fence.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_right_cliff.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_right_fence.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_towels.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_umbrella.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/beach/beach_water_strip.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_bed.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_debris.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_dresser.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_ensuite_left.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_ensuite_right.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_shower.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_shower_water_anim.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_toilet.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/bedroom/bedroom_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_bed.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_bg.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_desk_and_chair.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_door.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_sink.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_toilet.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/cell/cell_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_bottom_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_bus.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_bus_stop.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_car1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_car2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_car3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_car4.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_doorstep.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_left_fence.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_right_fence.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/front_of_house_road.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/front_of_house/road.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_bottom_left_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_bottom_right_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_door_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_doorstep.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_lawnmower.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_lower_left_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_middle_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_mowed_grass_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_poison.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_right_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_tool_area.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_top_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_unmowed_grass_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/garden/garden_upper_left_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_bg.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_gravestone.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_gravestone_shadow.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_parent_gravestone.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_parent_gravestone_shadow.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/graveyard_wall.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/graveyard/raindrop.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/hallway/hallway_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/hallway/hallway_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/hallway/hallway_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_chair.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_desk.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_dresser.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_single_bed.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_table.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_toy_1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_toy_2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_toy_3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_toy_4.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_toy_5.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_tv.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_tv_box.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/kids_bedroom/kids_bedroom_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/dining_room_chair_left.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/dining_room_chair_right.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/dining_room_sideboard.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/dining_room_table.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/electricity.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_bench_left.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_bench_right.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_drawers.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_floor.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_food_1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_food_2.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_food_3.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_food_4.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_food_5.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_fridge.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/kitchen_stove.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_coffee_table.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_door_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_sofa.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_tv.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/living_room/living_room_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_-.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_A.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_C.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_E.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_F.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_J.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_L.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_M.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_N.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_O.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_P.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_R.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_S.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_T.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/menu/menu_V.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/meta/hit_door.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/meta/pixel.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_ball.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_left_chair.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_left_flowers.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_picnic_basket.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_right_chair.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_right_flowers.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_table.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/park/park_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/people/child_frames.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/people/child_jumping_frames.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/people/parent_frames.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/people/person_frames.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_bg_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_floor_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_seesaw.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_slide.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_spring_rider.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_swing.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_teeter_totter.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/playground/playground_wall_tile.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/preloader/click.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/preloader/loaded.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/preloader/loading.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/music/music-goes-here.txt");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/sounds/alarm.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/bus.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/car.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/jostle.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/kick1.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/kick2.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/kick2.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/mower.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/shower.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/snare1.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/snare2.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/snare3.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/snare3.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone0.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone0.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone1.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone1.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone2.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone2.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone3.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone3.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone4.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone4.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone5.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone5.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone6.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone6.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone7.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone7.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/tone8.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/tone8.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/beep.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/flixel.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		
		if (config.assetsPrefix != null) {
			
			for (i in 0...urls.length) {
				
				if (types[i] != lime.Assets.AssetType.FONT) {
					
					urls[i] = config.assetsPrefix + urls[i];
					
				}
				
			}
			
		}
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if (sys && !nodejs && !emscripten)
		Sys.exit (result);
		#end
		
	}
	
	
	public static function init ():Void {
		
		var loaded = 0;
		var total = 0;
		var library_onLoad = function (__) {
			
			loaded++;
			
			if (loaded == total) {
				
				start ();
				
			}
			
		}
		
		preloader = null;
		
		
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (0),
			background: Std.int (0),
			borderless: false,
			company: "Pippin Barr",
			depthBuffer: false,
			file: "JostleParent",
			fps: Std.int (30),
			fullscreen: false,
			height: Std.int (480),
			orientation: "portrait",
			packageName: "com.example.myapp",
			resizable: true,
			stencilBuffer: true,
			title: "JostleParent",
			version: "1.0",
			vsync: true,
			width: Std.int (640),
			
		}
		
		#if (js && html5)
		#if (munit || utest)
		openfl.Lib.embed (null, 640, 480, "000000");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		var hasMain = false;
		var entryPoint = Type.resolveClass ("Main");
		
		for (methodName in Type.getClassFields (entryPoint)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		lime.Assets.initialize ();
		
		if (hasMain) {
			
			Reflect.callMethod (entryPoint, Reflect.field (entryPoint, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		
	}
	
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends Main {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
