package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Preloader;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.text.Font;
import lime.utils.ByteArray;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("assets/data/data-goes-here.txt", __ASSET__assets_data_data_goes_here_txt);
		type.set ("assets/data/data-goes-here.txt", AssetType.TEXT);
		className.set ("assets/images/bathroom/bathroom_bath.png", __ASSET__assets_images_bathroom_bathroom_bath_png);
		type.set ("assets/images/bathroom/bathroom_bath.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_bg_tile.png", __ASSET__assets_images_bathroom_bathroom_bg_tile_png);
		type.set ("assets/images/bathroom/bathroom_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_floor_tile.png", __ASSET__assets_images_bathroom_bathroom_floor_tile_png);
		type.set ("assets/images/bathroom/bathroom_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_mirror.png", __ASSET__assets_images_bathroom_bathroom_mirror_png);
		type.set ("assets/images/bathroom/bathroom_mirror.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_sink.png", __ASSET__assets_images_bathroom_bathroom_sink_png);
		type.set ("assets/images/bathroom/bathroom_sink.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_toilet.png", __ASSET__assets_images_bathroom_bathroom_toilet_png);
		type.set ("assets/images/bathroom/bathroom_toilet.png", AssetType.IMAGE);
		className.set ("assets/images/bathroom/bathroom_wall_tile.png", __ASSET__assets_images_bathroom_bathroom_wall_tile_png);
		type.set ("assets/images/bathroom/bathroom_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_bg_tile.png", __ASSET__assets_images_beach_beach_bg_tile_png);
		type.set ("assets/images/beach/beach_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_full_fence.png", __ASSET__assets_images_beach_beach_full_fence_png);
		type.set ("assets/images/beach/beach_full_fence.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_left_cliff.png", __ASSET__assets_images_beach_beach_left_cliff_png);
		type.set ("assets/images/beach/beach_left_cliff.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_left_fence.png", __ASSET__assets_images_beach_beach_left_fence_png);
		type.set ("assets/images/beach/beach_left_fence.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_right_cliff.png", __ASSET__assets_images_beach_beach_right_cliff_png);
		type.set ("assets/images/beach/beach_right_cliff.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_right_fence.png", __ASSET__assets_images_beach_beach_right_fence_png);
		type.set ("assets/images/beach/beach_right_fence.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_towels.png", __ASSET__assets_images_beach_beach_towels_png);
		type.set ("assets/images/beach/beach_towels.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_umbrella.png", __ASSET__assets_images_beach_beach_umbrella_png);
		type.set ("assets/images/beach/beach_umbrella.png", AssetType.IMAGE);
		className.set ("assets/images/beach/beach_water_strip.png", __ASSET__assets_images_beach_beach_water_strip_png);
		type.set ("assets/images/beach/beach_water_strip.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_bed.png", __ASSET__assets_images_bedroom_bedroom_bed_png);
		type.set ("assets/images/bedroom/bedroom_bed.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_bg_tile.png", __ASSET__assets_images_bedroom_bedroom_bg_tile_png);
		type.set ("assets/images/bedroom/bedroom_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_debris.png", __ASSET__assets_images_bedroom_bedroom_debris_png);
		type.set ("assets/images/bedroom/bedroom_debris.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_dresser.png", __ASSET__assets_images_bedroom_bedroom_dresser_png);
		type.set ("assets/images/bedroom/bedroom_dresser.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_ensuite_left.png", __ASSET__assets_images_bedroom_bedroom_ensuite_left_png);
		type.set ("assets/images/bedroom/bedroom_ensuite_left.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_ensuite_right.png", __ASSET__assets_images_bedroom_bedroom_ensuite_right_png);
		type.set ("assets/images/bedroom/bedroom_ensuite_right.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_floor_tile.png", __ASSET__assets_images_bedroom_bedroom_floor_tile_png);
		type.set ("assets/images/bedroom/bedroom_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_shower.png", __ASSET__assets_images_bedroom_bedroom_shower_png);
		type.set ("assets/images/bedroom/bedroom_shower.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_shower_water_anim.png", __ASSET__assets_images_bedroom_bedroom_shower_water_anim_png);
		type.set ("assets/images/bedroom/bedroom_shower_water_anim.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_toilet.png", __ASSET__assets_images_bedroom_bedroom_toilet_png);
		type.set ("assets/images/bedroom/bedroom_toilet.png", AssetType.IMAGE);
		className.set ("assets/images/bedroom/bedroom_wall_tile.png", __ASSET__assets_images_bedroom_bedroom_wall_tile_png);
		type.set ("assets/images/bedroom/bedroom_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_bed.png", __ASSET__assets_images_cell_cell_bed_png);
		type.set ("assets/images/cell/cell_bed.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_bg.png", __ASSET__assets_images_cell_cell_bg_png);
		type.set ("assets/images/cell/cell_bg.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_bg_tile.png", __ASSET__assets_images_cell_cell_bg_tile_png);
		type.set ("assets/images/cell/cell_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_desk_and_chair.png", __ASSET__assets_images_cell_cell_desk_and_chair_png);
		type.set ("assets/images/cell/cell_desk_and_chair.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_door.png", __ASSET__assets_images_cell_cell_door_png);
		type.set ("assets/images/cell/cell_door.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_floor_tile.png", __ASSET__assets_images_cell_cell_floor_tile_png);
		type.set ("assets/images/cell/cell_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_sink.png", __ASSET__assets_images_cell_cell_sink_png);
		type.set ("assets/images/cell/cell_sink.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_toilet.png", __ASSET__assets_images_cell_cell_toilet_png);
		type.set ("assets/images/cell/cell_toilet.png", AssetType.IMAGE);
		className.set ("assets/images/cell/cell_wall_tile.png", __ASSET__assets_images_cell_cell_wall_tile_png);
		type.set ("assets/images/cell/cell_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_bg_tile.png", __ASSET__assets_images_front_of_house_front_of_house_bg_tile_png);
		type.set ("assets/images/front_of_house/front_of_house_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_bottom_wall.png", __ASSET__assets_images_front_of_house_front_of_house_bottom_wall_png);
		type.set ("assets/images/front_of_house/front_of_house_bottom_wall.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_bus.png", __ASSET__assets_images_front_of_house_front_of_house_bus_png);
		type.set ("assets/images/front_of_house/front_of_house_bus.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_bus_stop.png", __ASSET__assets_images_front_of_house_front_of_house_bus_stop_png);
		type.set ("assets/images/front_of_house/front_of_house_bus_stop.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_car1.png", __ASSET__assets_images_front_of_house_front_of_house_car1_png);
		type.set ("assets/images/front_of_house/front_of_house_car1.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_car2.png", __ASSET__assets_images_front_of_house_front_of_house_car2_png);
		type.set ("assets/images/front_of_house/front_of_house_car2.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_car3.png", __ASSET__assets_images_front_of_house_front_of_house_car3_png);
		type.set ("assets/images/front_of_house/front_of_house_car3.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_car4.png", __ASSET__assets_images_front_of_house_front_of_house_car4_png);
		type.set ("assets/images/front_of_house/front_of_house_car4.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_doorstep.png", __ASSET__assets_images_front_of_house_front_of_house_doorstep_png);
		type.set ("assets/images/front_of_house/front_of_house_doorstep.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_left_fence.png", __ASSET__assets_images_front_of_house_front_of_house_left_fence_png);
		type.set ("assets/images/front_of_house/front_of_house_left_fence.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_right_fence.png", __ASSET__assets_images_front_of_house_front_of_house_right_fence_png);
		type.set ("assets/images/front_of_house/front_of_house_right_fence.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/front_of_house_road.png", __ASSET__assets_images_front_of_house_front_of_house_road_png);
		type.set ("assets/images/front_of_house/front_of_house_road.png", AssetType.IMAGE);
		className.set ("assets/images/front_of_house/road.png", __ASSET__assets_images_front_of_house_road_png);
		type.set ("assets/images/front_of_house/road.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_bg_tile.png", __ASSET__assets_images_garden_garden_bg_tile_png);
		type.set ("assets/images/garden/garden_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_bottom_left_wall.png", __ASSET__assets_images_garden_garden_bottom_left_wall_png);
		type.set ("assets/images/garden/garden_bottom_left_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_bottom_right_wall.png", __ASSET__assets_images_garden_garden_bottom_right_wall_png);
		type.set ("assets/images/garden/garden_bottom_right_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_door_tile.png", __ASSET__assets_images_garden_garden_door_tile_png);
		type.set ("assets/images/garden/garden_door_tile.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_doorstep.png", __ASSET__assets_images_garden_garden_doorstep_png);
		type.set ("assets/images/garden/garden_doorstep.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_lawnmower.png", __ASSET__assets_images_garden_garden_lawnmower_png);
		type.set ("assets/images/garden/garden_lawnmower.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_lower_left_wall.png", __ASSET__assets_images_garden_garden_lower_left_wall_png);
		type.set ("assets/images/garden/garden_lower_left_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_middle_wall.png", __ASSET__assets_images_garden_garden_middle_wall_png);
		type.set ("assets/images/garden/garden_middle_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_mowed_grass_tile.png", __ASSET__assets_images_garden_garden_mowed_grass_tile_png);
		type.set ("assets/images/garden/garden_mowed_grass_tile.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_poison.png", __ASSET__assets_images_garden_garden_poison_png);
		type.set ("assets/images/garden/garden_poison.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_right_wall.png", __ASSET__assets_images_garden_garden_right_wall_png);
		type.set ("assets/images/garden/garden_right_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_tool_area.png", __ASSET__assets_images_garden_garden_tool_area_png);
		type.set ("assets/images/garden/garden_tool_area.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_top_wall.png", __ASSET__assets_images_garden_garden_top_wall_png);
		type.set ("assets/images/garden/garden_top_wall.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_unmowed_grass_tile.png", __ASSET__assets_images_garden_garden_unmowed_grass_tile_png);
		type.set ("assets/images/garden/garden_unmowed_grass_tile.png", AssetType.IMAGE);
		className.set ("assets/images/garden/garden_upper_left_wall.png", __ASSET__assets_images_garden_garden_upper_left_wall_png);
		type.set ("assets/images/garden/garden_upper_left_wall.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_bg.png", __ASSET__assets_images_graveyard_graveyard_bg_png);
		type.set ("assets/images/graveyard/graveyard_bg.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_gravestone.png", __ASSET__assets_images_graveyard_graveyard_gravestone_png);
		type.set ("assets/images/graveyard/graveyard_gravestone.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_gravestone_shadow.png", __ASSET__assets_images_graveyard_graveyard_gravestone_shadow_png);
		type.set ("assets/images/graveyard/graveyard_gravestone_shadow.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_parent_gravestone.png", __ASSET__assets_images_graveyard_graveyard_parent_gravestone_png);
		type.set ("assets/images/graveyard/graveyard_parent_gravestone.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_parent_gravestone_shadow.png", __ASSET__assets_images_graveyard_graveyard_parent_gravestone_shadow_png);
		type.set ("assets/images/graveyard/graveyard_parent_gravestone_shadow.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/graveyard_wall.png", __ASSET__assets_images_graveyard_graveyard_wall_png);
		type.set ("assets/images/graveyard/graveyard_wall.png", AssetType.IMAGE);
		className.set ("assets/images/graveyard/raindrop.png", __ASSET__assets_images_graveyard_raindrop_png);
		type.set ("assets/images/graveyard/raindrop.png", AssetType.IMAGE);
		className.set ("assets/images/hallway/hallway_bg_tile.png", __ASSET__assets_images_hallway_hallway_bg_tile_png);
		type.set ("assets/images/hallway/hallway_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/hallway/hallway_floor_tile.png", __ASSET__assets_images_hallway_hallway_floor_tile_png);
		type.set ("assets/images/hallway/hallway_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/hallway/hallway_wall_tile.png", __ASSET__assets_images_hallway_hallway_wall_tile_png);
		type.set ("assets/images/hallway/hallway_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_bg_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_bg_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_bunk_bed_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_chair.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_chair_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_chair.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_desk.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_desk_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_desk.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_dresser.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_dresser_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_dresser.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_floor_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_floor_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_single_bed.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_single_bed_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_single_bed.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_table.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_table_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_table.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_1.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_1_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_1.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_2.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_2_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_2.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_3.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_3_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_3.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_4.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_4_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_4.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_5.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_5_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_5.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_tv.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_tv.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_tv_box.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_box_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_tv_box.png", AssetType.IMAGE);
		className.set ("assets/images/kids_bedroom/kids_bedroom_wall_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_wall_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/dining_room_chair_left.png", __ASSET__assets_images_living_room_dining_room_chair_left_png);
		type.set ("assets/images/living_room/dining_room_chair_left.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/dining_room_chair_right.png", __ASSET__assets_images_living_room_dining_room_chair_right_png);
		type.set ("assets/images/living_room/dining_room_chair_right.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/dining_room_sideboard.png", __ASSET__assets_images_living_room_dining_room_sideboard_png);
		type.set ("assets/images/living_room/dining_room_sideboard.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/dining_room_table.png", __ASSET__assets_images_living_room_dining_room_table_png);
		type.set ("assets/images/living_room/dining_room_table.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/electricity.png", __ASSET__assets_images_living_room_electricity_png);
		type.set ("assets/images/living_room/electricity.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_bench_left.png", __ASSET__assets_images_living_room_kitchen_bench_left_png);
		type.set ("assets/images/living_room/kitchen_bench_left.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_bench_right.png", __ASSET__assets_images_living_room_kitchen_bench_right_png);
		type.set ("assets/images/living_room/kitchen_bench_right.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_drawers.png", __ASSET__assets_images_living_room_kitchen_drawers_png);
		type.set ("assets/images/living_room/kitchen_drawers.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_floor.png", __ASSET__assets_images_living_room_kitchen_floor_png);
		type.set ("assets/images/living_room/kitchen_floor.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_food_1.png", __ASSET__assets_images_living_room_kitchen_food_1_png);
		type.set ("assets/images/living_room/kitchen_food_1.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_food_2.png", __ASSET__assets_images_living_room_kitchen_food_2_png);
		type.set ("assets/images/living_room/kitchen_food_2.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_food_3.png", __ASSET__assets_images_living_room_kitchen_food_3_png);
		type.set ("assets/images/living_room/kitchen_food_3.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_food_4.png", __ASSET__assets_images_living_room_kitchen_food_4_png);
		type.set ("assets/images/living_room/kitchen_food_4.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_food_5.png", __ASSET__assets_images_living_room_kitchen_food_5_png);
		type.set ("assets/images/living_room/kitchen_food_5.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_fridge.png", __ASSET__assets_images_living_room_kitchen_fridge_png);
		type.set ("assets/images/living_room/kitchen_fridge.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/kitchen_stove.png", __ASSET__assets_images_living_room_kitchen_stove_png);
		type.set ("assets/images/living_room/kitchen_stove.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_bg_tile.png", __ASSET__assets_images_living_room_living_room_bg_tile_png);
		type.set ("assets/images/living_room/living_room_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_coffee_table.png", __ASSET__assets_images_living_room_living_room_coffee_table_png);
		type.set ("assets/images/living_room/living_room_coffee_table.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_door_tile.png", __ASSET__assets_images_living_room_living_room_door_tile_png);
		type.set ("assets/images/living_room/living_room_door_tile.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_floor_tile.png", __ASSET__assets_images_living_room_living_room_floor_tile_png);
		type.set ("assets/images/living_room/living_room_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_sofa.png", __ASSET__assets_images_living_room_living_room_sofa_png);
		type.set ("assets/images/living_room/living_room_sofa.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_tv.png", __ASSET__assets_images_living_room_living_room_tv_png);
		type.set ("assets/images/living_room/living_room_tv.png", AssetType.IMAGE);
		className.set ("assets/images/living_room/living_room_wall_tile.png", __ASSET__assets_images_living_room_living_room_wall_tile_png);
		type.set ("assets/images/living_room/living_room_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_-.png", __ASSET__assets_images_menu_menu___png);
		type.set ("assets/images/menu/menu_-.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_A.png", __ASSET__assets_images_menu_menu_a_png);
		type.set ("assets/images/menu/menu_A.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_bg_tile.png", __ASSET__assets_images_menu_menu_bg_tile_png);
		type.set ("assets/images/menu/menu_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_C.png", __ASSET__assets_images_menu_menu_c_png);
		type.set ("assets/images/menu/menu_C.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_E.png", __ASSET__assets_images_menu_menu_e_png);
		type.set ("assets/images/menu/menu_E.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_F.png", __ASSET__assets_images_menu_menu_f_png);
		type.set ("assets/images/menu/menu_F.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_J.png", __ASSET__assets_images_menu_menu_j_png);
		type.set ("assets/images/menu/menu_J.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_L.png", __ASSET__assets_images_menu_menu_l_png);
		type.set ("assets/images/menu/menu_L.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_M.png", __ASSET__assets_images_menu_menu_m_png);
		type.set ("assets/images/menu/menu_M.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_N.png", __ASSET__assets_images_menu_menu_n_png);
		type.set ("assets/images/menu/menu_N.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_O.png", __ASSET__assets_images_menu_menu_o_png);
		type.set ("assets/images/menu/menu_O.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_P.png", __ASSET__assets_images_menu_menu_p_png);
		type.set ("assets/images/menu/menu_P.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_R.png", __ASSET__assets_images_menu_menu_r_png);
		type.set ("assets/images/menu/menu_R.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_S.png", __ASSET__assets_images_menu_menu_s_png);
		type.set ("assets/images/menu/menu_S.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_T.png", __ASSET__assets_images_menu_menu_t_png);
		type.set ("assets/images/menu/menu_T.png", AssetType.IMAGE);
		className.set ("assets/images/menu/menu_V.png", __ASSET__assets_images_menu_menu_v_png);
		type.set ("assets/images/menu/menu_V.png", AssetType.IMAGE);
		className.set ("assets/images/meta/hit_door.png", __ASSET__assets_images_meta_hit_door_png);
		type.set ("assets/images/meta/hit_door.png", AssetType.IMAGE);
		className.set ("assets/images/meta/pixel.png", __ASSET__assets_images_meta_pixel_png);
		type.set ("assets/images/meta/pixel.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_ball.png", __ASSET__assets_images_park_park_ball_png);
		type.set ("assets/images/park/park_ball.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_bg_tile.png", __ASSET__assets_images_park_park_bg_tile_png);
		type.set ("assets/images/park/park_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_floor_tile.png", __ASSET__assets_images_park_park_floor_tile_png);
		type.set ("assets/images/park/park_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_left_chair.png", __ASSET__assets_images_park_park_left_chair_png);
		type.set ("assets/images/park/park_left_chair.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_left_flowers.png", __ASSET__assets_images_park_park_left_flowers_png);
		type.set ("assets/images/park/park_left_flowers.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_picnic_basket.png", __ASSET__assets_images_park_park_picnic_basket_png);
		type.set ("assets/images/park/park_picnic_basket.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_right_chair.png", __ASSET__assets_images_park_park_right_chair_png);
		type.set ("assets/images/park/park_right_chair.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_right_flowers.png", __ASSET__assets_images_park_park_right_flowers_png);
		type.set ("assets/images/park/park_right_flowers.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_table.png", __ASSET__assets_images_park_park_table_png);
		type.set ("assets/images/park/park_table.png", AssetType.IMAGE);
		className.set ("assets/images/park/park_wall_tile.png", __ASSET__assets_images_park_park_wall_tile_png);
		type.set ("assets/images/park/park_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/people/child_frames.png", __ASSET__assets_images_people_child_frames_png);
		type.set ("assets/images/people/child_frames.png", AssetType.IMAGE);
		className.set ("assets/images/people/child_jumping_frames.png", __ASSET__assets_images_people_child_jumping_frames_png);
		type.set ("assets/images/people/child_jumping_frames.png", AssetType.IMAGE);
		className.set ("assets/images/people/parent_frames.png", __ASSET__assets_images_people_parent_frames_png);
		type.set ("assets/images/people/parent_frames.png", AssetType.IMAGE);
		className.set ("assets/images/people/person_frames.png", __ASSET__assets_images_people_person_frames_png);
		type.set ("assets/images/people/person_frames.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_bg_tile.png", __ASSET__assets_images_playground_playground_bg_tile_png);
		type.set ("assets/images/playground/playground_bg_tile.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_floor_tile.png", __ASSET__assets_images_playground_playground_floor_tile_png);
		type.set ("assets/images/playground/playground_floor_tile.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_seesaw.png", __ASSET__assets_images_playground_playground_seesaw_png);
		type.set ("assets/images/playground/playground_seesaw.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_slide.png", __ASSET__assets_images_playground_playground_slide_png);
		type.set ("assets/images/playground/playground_slide.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_spring_rider.png", __ASSET__assets_images_playground_playground_spring_rider_png);
		type.set ("assets/images/playground/playground_spring_rider.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_swing.png", __ASSET__assets_images_playground_playground_swing_png);
		type.set ("assets/images/playground/playground_swing.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_teeter_totter.png", __ASSET__assets_images_playground_playground_teeter_totter_png);
		type.set ("assets/images/playground/playground_teeter_totter.png", AssetType.IMAGE);
		className.set ("assets/images/playground/playground_wall_tile.png", __ASSET__assets_images_playground_playground_wall_tile_png);
		type.set ("assets/images/playground/playground_wall_tile.png", AssetType.IMAGE);
		className.set ("assets/images/preloader/click.png", __ASSET__assets_images_preloader_click_png);
		type.set ("assets/images/preloader/click.png", AssetType.IMAGE);
		className.set ("assets/images/preloader/loaded.png", __ASSET__assets_images_preloader_loaded_png);
		type.set ("assets/images/preloader/loaded.png", AssetType.IMAGE);
		className.set ("assets/images/preloader/loading.png", __ASSET__assets_images_preloader_loading_png);
		type.set ("assets/images/preloader/loading.png", AssetType.IMAGE);
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		className.set ("assets/sounds/alarm.mp3", __ASSET__assets_sounds_alarm_mp3);
		type.set ("assets/sounds/alarm.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/bus.mp3", __ASSET__assets_sounds_bus_mp3);
		type.set ("assets/sounds/bus.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/car.mp3", __ASSET__assets_sounds_car_mp3);
		type.set ("assets/sounds/car.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/jostle.mp3", __ASSET__assets_sounds_jostle_mp3);
		type.set ("assets/sounds/jostle.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/kick1.mp3", __ASSET__assets_sounds_kick1_mp3);
		type.set ("assets/sounds/kick1.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/kick2.mp3", __ASSET__assets_sounds_kick2_mp3);
		type.set ("assets/sounds/kick2.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/kick2.wav", __ASSET__assets_sounds_kick2_wav);
		type.set ("assets/sounds/kick2.wav", AssetType.SOUND);
		className.set ("assets/sounds/mower.mp3", __ASSET__assets_sounds_mower_mp3);
		type.set ("assets/sounds/mower.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/shower.mp3", __ASSET__assets_sounds_shower_mp3);
		type.set ("assets/sounds/shower.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/snare1.mp3", __ASSET__assets_sounds_snare1_mp3);
		type.set ("assets/sounds/snare1.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/snare2.wav", __ASSET__assets_sounds_snare2_wav);
		type.set ("assets/sounds/snare2.wav", AssetType.SOUND);
		className.set ("assets/sounds/snare3.mp3", __ASSET__assets_sounds_snare3_mp3);
		type.set ("assets/sounds/snare3.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/snare3.wav", __ASSET__assets_sounds_snare3_wav);
		type.set ("assets/sounds/snare3.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone0.mp3", __ASSET__assets_sounds_tone0_mp3);
		type.set ("assets/sounds/tone0.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone0.wav", __ASSET__assets_sounds_tone0_wav);
		type.set ("assets/sounds/tone0.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone1.mp3", __ASSET__assets_sounds_tone1_mp3);
		type.set ("assets/sounds/tone1.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone1.wav", __ASSET__assets_sounds_tone1_wav);
		type.set ("assets/sounds/tone1.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone2.mp3", __ASSET__assets_sounds_tone2_mp3);
		type.set ("assets/sounds/tone2.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone2.wav", __ASSET__assets_sounds_tone2_wav);
		type.set ("assets/sounds/tone2.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone3.mp3", __ASSET__assets_sounds_tone3_mp3);
		type.set ("assets/sounds/tone3.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone3.wav", __ASSET__assets_sounds_tone3_wav);
		type.set ("assets/sounds/tone3.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone4.mp3", __ASSET__assets_sounds_tone4_mp3);
		type.set ("assets/sounds/tone4.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone4.wav", __ASSET__assets_sounds_tone4_wav);
		type.set ("assets/sounds/tone4.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone5.mp3", __ASSET__assets_sounds_tone5_mp3);
		type.set ("assets/sounds/tone5.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone5.wav", __ASSET__assets_sounds_tone5_wav);
		type.set ("assets/sounds/tone5.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone6.mp3", __ASSET__assets_sounds_tone6_mp3);
		type.set ("assets/sounds/tone6.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone6.wav", __ASSET__assets_sounds_tone6_wav);
		type.set ("assets/sounds/tone6.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone7.mp3", __ASSET__assets_sounds_tone7_mp3);
		type.set ("assets/sounds/tone7.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone7.wav", __ASSET__assets_sounds_tone7_wav);
		type.set ("assets/sounds/tone7.wav", AssetType.SOUND);
		className.set ("assets/sounds/tone8.mp3", __ASSET__assets_sounds_tone8_mp3);
		type.set ("assets/sounds/tone8.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/tone8.wav", __ASSET__assets_sounds_tone8_wav);
		type.set ("assets/sounds/tone8.wav", AssetType.SOUND);
		className.set ("assets/sounds/beep.mp3", __ASSET__assets_sounds_beep_mp3);
		type.set ("assets/sounds/beep.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/flixel.mp3", __ASSET__assets_sounds_flixel_mp3);
		type.set ("assets/sounds/flixel.mp3", AssetType.MUSIC);
		
		
		#elseif html5
		
		var id;
		id = "assets/data/data-goes-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/bathroom/bathroom_bath.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_mirror.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_sink.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_toilet.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bathroom/bathroom_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_full_fence.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_left_cliff.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_left_fence.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_right_cliff.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_right_fence.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_towels.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_umbrella.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/beach/beach_water_strip.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_bed.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_debris.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_dresser.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_ensuite_left.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_ensuite_right.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_shower.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_shower_water_anim.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_toilet.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/bedroom/bedroom_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_bed.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_bg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_desk_and_chair.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_door.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_sink.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_toilet.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/cell/cell_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_bottom_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_bus.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_bus_stop.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_car1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_car2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_car3.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_car4.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_doorstep.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_left_fence.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_right_fence.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/front_of_house_road.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/front_of_house/road.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_bottom_left_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_bottom_right_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_door_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_doorstep.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_lawnmower.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_lower_left_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_middle_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_mowed_grass_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_poison.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_right_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_tool_area.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_top_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_unmowed_grass_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/garden/garden_upper_left_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_bg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_gravestone.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_gravestone_shadow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_parent_gravestone.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_parent_gravestone_shadow.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/graveyard_wall.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/graveyard/raindrop.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/hallway/hallway_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/hallway/hallway_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/hallway/hallway_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_bunk_bed.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_chair.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_desk.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_dresser.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_single_bed.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_table.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_toy_1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_toy_2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_toy_3.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_toy_4.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_toy_5.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_tv.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_tv_box.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/kids_bedroom/kids_bedroom_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/dining_room_chair_left.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/dining_room_chair_right.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/dining_room_sideboard.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/dining_room_table.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/electricity.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_bench_left.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_bench_right.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_drawers.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_floor.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_food_1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_food_2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_food_3.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_food_4.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_food_5.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_fridge.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/kitchen_stove.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_coffee_table.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_door_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_sofa.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_tv.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/living_room/living_room_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_-.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_A.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_C.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_E.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_F.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_J.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_L.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_M.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_N.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_O.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_P.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_R.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_S.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_T.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/menu/menu_V.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/meta/hit_door.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/meta/pixel.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_ball.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_left_chair.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_left_flowers.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_picnic_basket.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_right_chair.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_right_flowers.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_table.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/park/park_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/people/child_frames.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/people/child_jumping_frames.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/people/parent_frames.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/people/person_frames.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_bg_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_floor_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_seesaw.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_slide.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_spring_rider.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_swing.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_teeter_totter.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/playground/playground_wall_tile.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/preloader/click.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/preloader/loaded.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/preloader/loading.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/music/music-goes-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/sounds/alarm.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/bus.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/car.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/jostle.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/kick1.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/kick2.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/kick2.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/mower.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/shower.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/snare1.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/snare2.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/snare3.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/snare3.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone0.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone0.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone1.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone1.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone2.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone2.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone3.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone3.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone4.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone4.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone5.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone5.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone6.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone6.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone7.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone7.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/tone8.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/tone8.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "assets/sounds/beep.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/flixel.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		
		
		var assetsPrefix = ApplicationMain.config.assetsPrefix;
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if openfl
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#end
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("assets/data/data-goes-here.txt", __ASSET__assets_data_data_goes_here_txt);
		type.set ("assets/data/data-goes-here.txt", AssetType.TEXT);
		
		className.set ("assets/images/bathroom/bathroom_bath.png", __ASSET__assets_images_bathroom_bathroom_bath_png);
		type.set ("assets/images/bathroom/bathroom_bath.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_bg_tile.png", __ASSET__assets_images_bathroom_bathroom_bg_tile_png);
		type.set ("assets/images/bathroom/bathroom_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_floor_tile.png", __ASSET__assets_images_bathroom_bathroom_floor_tile_png);
		type.set ("assets/images/bathroom/bathroom_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_mirror.png", __ASSET__assets_images_bathroom_bathroom_mirror_png);
		type.set ("assets/images/bathroom/bathroom_mirror.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_sink.png", __ASSET__assets_images_bathroom_bathroom_sink_png);
		type.set ("assets/images/bathroom/bathroom_sink.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_toilet.png", __ASSET__assets_images_bathroom_bathroom_toilet_png);
		type.set ("assets/images/bathroom/bathroom_toilet.png", AssetType.IMAGE);
		
		className.set ("assets/images/bathroom/bathroom_wall_tile.png", __ASSET__assets_images_bathroom_bathroom_wall_tile_png);
		type.set ("assets/images/bathroom/bathroom_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_bg_tile.png", __ASSET__assets_images_beach_beach_bg_tile_png);
		type.set ("assets/images/beach/beach_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_full_fence.png", __ASSET__assets_images_beach_beach_full_fence_png);
		type.set ("assets/images/beach/beach_full_fence.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_left_cliff.png", __ASSET__assets_images_beach_beach_left_cliff_png);
		type.set ("assets/images/beach/beach_left_cliff.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_left_fence.png", __ASSET__assets_images_beach_beach_left_fence_png);
		type.set ("assets/images/beach/beach_left_fence.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_right_cliff.png", __ASSET__assets_images_beach_beach_right_cliff_png);
		type.set ("assets/images/beach/beach_right_cliff.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_right_fence.png", __ASSET__assets_images_beach_beach_right_fence_png);
		type.set ("assets/images/beach/beach_right_fence.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_towels.png", __ASSET__assets_images_beach_beach_towels_png);
		type.set ("assets/images/beach/beach_towels.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_umbrella.png", __ASSET__assets_images_beach_beach_umbrella_png);
		type.set ("assets/images/beach/beach_umbrella.png", AssetType.IMAGE);
		
		className.set ("assets/images/beach/beach_water_strip.png", __ASSET__assets_images_beach_beach_water_strip_png);
		type.set ("assets/images/beach/beach_water_strip.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_bed.png", __ASSET__assets_images_bedroom_bedroom_bed_png);
		type.set ("assets/images/bedroom/bedroom_bed.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_bg_tile.png", __ASSET__assets_images_bedroom_bedroom_bg_tile_png);
		type.set ("assets/images/bedroom/bedroom_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_debris.png", __ASSET__assets_images_bedroom_bedroom_debris_png);
		type.set ("assets/images/bedroom/bedroom_debris.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_dresser.png", __ASSET__assets_images_bedroom_bedroom_dresser_png);
		type.set ("assets/images/bedroom/bedroom_dresser.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_ensuite_left.png", __ASSET__assets_images_bedroom_bedroom_ensuite_left_png);
		type.set ("assets/images/bedroom/bedroom_ensuite_left.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_ensuite_right.png", __ASSET__assets_images_bedroom_bedroom_ensuite_right_png);
		type.set ("assets/images/bedroom/bedroom_ensuite_right.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_floor_tile.png", __ASSET__assets_images_bedroom_bedroom_floor_tile_png);
		type.set ("assets/images/bedroom/bedroom_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_shower.png", __ASSET__assets_images_bedroom_bedroom_shower_png);
		type.set ("assets/images/bedroom/bedroom_shower.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_shower_water_anim.png", __ASSET__assets_images_bedroom_bedroom_shower_water_anim_png);
		type.set ("assets/images/bedroom/bedroom_shower_water_anim.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_toilet.png", __ASSET__assets_images_bedroom_bedroom_toilet_png);
		type.set ("assets/images/bedroom/bedroom_toilet.png", AssetType.IMAGE);
		
		className.set ("assets/images/bedroom/bedroom_wall_tile.png", __ASSET__assets_images_bedroom_bedroom_wall_tile_png);
		type.set ("assets/images/bedroom/bedroom_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_bed.png", __ASSET__assets_images_cell_cell_bed_png);
		type.set ("assets/images/cell/cell_bed.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_bg.png", __ASSET__assets_images_cell_cell_bg_png);
		type.set ("assets/images/cell/cell_bg.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_bg_tile.png", __ASSET__assets_images_cell_cell_bg_tile_png);
		type.set ("assets/images/cell/cell_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_desk_and_chair.png", __ASSET__assets_images_cell_cell_desk_and_chair_png);
		type.set ("assets/images/cell/cell_desk_and_chair.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_door.png", __ASSET__assets_images_cell_cell_door_png);
		type.set ("assets/images/cell/cell_door.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_floor_tile.png", __ASSET__assets_images_cell_cell_floor_tile_png);
		type.set ("assets/images/cell/cell_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_sink.png", __ASSET__assets_images_cell_cell_sink_png);
		type.set ("assets/images/cell/cell_sink.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_toilet.png", __ASSET__assets_images_cell_cell_toilet_png);
		type.set ("assets/images/cell/cell_toilet.png", AssetType.IMAGE);
		
		className.set ("assets/images/cell/cell_wall_tile.png", __ASSET__assets_images_cell_cell_wall_tile_png);
		type.set ("assets/images/cell/cell_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_bg_tile.png", __ASSET__assets_images_front_of_house_front_of_house_bg_tile_png);
		type.set ("assets/images/front_of_house/front_of_house_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_bottom_wall.png", __ASSET__assets_images_front_of_house_front_of_house_bottom_wall_png);
		type.set ("assets/images/front_of_house/front_of_house_bottom_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_bus.png", __ASSET__assets_images_front_of_house_front_of_house_bus_png);
		type.set ("assets/images/front_of_house/front_of_house_bus.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_bus_stop.png", __ASSET__assets_images_front_of_house_front_of_house_bus_stop_png);
		type.set ("assets/images/front_of_house/front_of_house_bus_stop.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_car1.png", __ASSET__assets_images_front_of_house_front_of_house_car1_png);
		type.set ("assets/images/front_of_house/front_of_house_car1.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_car2.png", __ASSET__assets_images_front_of_house_front_of_house_car2_png);
		type.set ("assets/images/front_of_house/front_of_house_car2.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_car3.png", __ASSET__assets_images_front_of_house_front_of_house_car3_png);
		type.set ("assets/images/front_of_house/front_of_house_car3.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_car4.png", __ASSET__assets_images_front_of_house_front_of_house_car4_png);
		type.set ("assets/images/front_of_house/front_of_house_car4.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_doorstep.png", __ASSET__assets_images_front_of_house_front_of_house_doorstep_png);
		type.set ("assets/images/front_of_house/front_of_house_doorstep.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_left_fence.png", __ASSET__assets_images_front_of_house_front_of_house_left_fence_png);
		type.set ("assets/images/front_of_house/front_of_house_left_fence.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_right_fence.png", __ASSET__assets_images_front_of_house_front_of_house_right_fence_png);
		type.set ("assets/images/front_of_house/front_of_house_right_fence.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/front_of_house_road.png", __ASSET__assets_images_front_of_house_front_of_house_road_png);
		type.set ("assets/images/front_of_house/front_of_house_road.png", AssetType.IMAGE);
		
		className.set ("assets/images/front_of_house/road.png", __ASSET__assets_images_front_of_house_road_png);
		type.set ("assets/images/front_of_house/road.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_bg_tile.png", __ASSET__assets_images_garden_garden_bg_tile_png);
		type.set ("assets/images/garden/garden_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_bottom_left_wall.png", __ASSET__assets_images_garden_garden_bottom_left_wall_png);
		type.set ("assets/images/garden/garden_bottom_left_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_bottom_right_wall.png", __ASSET__assets_images_garden_garden_bottom_right_wall_png);
		type.set ("assets/images/garden/garden_bottom_right_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_door_tile.png", __ASSET__assets_images_garden_garden_door_tile_png);
		type.set ("assets/images/garden/garden_door_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_doorstep.png", __ASSET__assets_images_garden_garden_doorstep_png);
		type.set ("assets/images/garden/garden_doorstep.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_lawnmower.png", __ASSET__assets_images_garden_garden_lawnmower_png);
		type.set ("assets/images/garden/garden_lawnmower.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_lower_left_wall.png", __ASSET__assets_images_garden_garden_lower_left_wall_png);
		type.set ("assets/images/garden/garden_lower_left_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_middle_wall.png", __ASSET__assets_images_garden_garden_middle_wall_png);
		type.set ("assets/images/garden/garden_middle_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_mowed_grass_tile.png", __ASSET__assets_images_garden_garden_mowed_grass_tile_png);
		type.set ("assets/images/garden/garden_mowed_grass_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_poison.png", __ASSET__assets_images_garden_garden_poison_png);
		type.set ("assets/images/garden/garden_poison.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_right_wall.png", __ASSET__assets_images_garden_garden_right_wall_png);
		type.set ("assets/images/garden/garden_right_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_tool_area.png", __ASSET__assets_images_garden_garden_tool_area_png);
		type.set ("assets/images/garden/garden_tool_area.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_top_wall.png", __ASSET__assets_images_garden_garden_top_wall_png);
		type.set ("assets/images/garden/garden_top_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_unmowed_grass_tile.png", __ASSET__assets_images_garden_garden_unmowed_grass_tile_png);
		type.set ("assets/images/garden/garden_unmowed_grass_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/garden/garden_upper_left_wall.png", __ASSET__assets_images_garden_garden_upper_left_wall_png);
		type.set ("assets/images/garden/garden_upper_left_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_bg.png", __ASSET__assets_images_graveyard_graveyard_bg_png);
		type.set ("assets/images/graveyard/graveyard_bg.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_gravestone.png", __ASSET__assets_images_graveyard_graveyard_gravestone_png);
		type.set ("assets/images/graveyard/graveyard_gravestone.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_gravestone_shadow.png", __ASSET__assets_images_graveyard_graveyard_gravestone_shadow_png);
		type.set ("assets/images/graveyard/graveyard_gravestone_shadow.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_parent_gravestone.png", __ASSET__assets_images_graveyard_graveyard_parent_gravestone_png);
		type.set ("assets/images/graveyard/graveyard_parent_gravestone.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_parent_gravestone_shadow.png", __ASSET__assets_images_graveyard_graveyard_parent_gravestone_shadow_png);
		type.set ("assets/images/graveyard/graveyard_parent_gravestone_shadow.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/graveyard_wall.png", __ASSET__assets_images_graveyard_graveyard_wall_png);
		type.set ("assets/images/graveyard/graveyard_wall.png", AssetType.IMAGE);
		
		className.set ("assets/images/graveyard/raindrop.png", __ASSET__assets_images_graveyard_raindrop_png);
		type.set ("assets/images/graveyard/raindrop.png", AssetType.IMAGE);
		
		className.set ("assets/images/hallway/hallway_bg_tile.png", __ASSET__assets_images_hallway_hallway_bg_tile_png);
		type.set ("assets/images/hallway/hallway_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/hallway/hallway_floor_tile.png", __ASSET__assets_images_hallway_hallway_floor_tile_png);
		type.set ("assets/images/hallway/hallway_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/hallway/hallway_wall_tile.png", __ASSET__assets_images_hallway_hallway_wall_tile_png);
		type.set ("assets/images/hallway/hallway_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_bg_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_bg_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_bunk_bed_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_chair.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_chair_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_chair.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_desk.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_desk_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_desk.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_dresser.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_dresser_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_dresser.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_floor_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_floor_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_single_bed.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_single_bed_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_single_bed.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_table.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_table_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_table.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_1.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_1_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_1.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_2.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_2_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_2.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_3.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_3_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_3.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_4.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_4_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_4.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_toy_5.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_5_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_toy_5.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_tv.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_tv.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_tv_box.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_box_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_tv_box.png", AssetType.IMAGE);
		
		className.set ("assets/images/kids_bedroom/kids_bedroom_wall_tile.png", __ASSET__assets_images_kids_bedroom_kids_bedroom_wall_tile_png);
		type.set ("assets/images/kids_bedroom/kids_bedroom_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/dining_room_chair_left.png", __ASSET__assets_images_living_room_dining_room_chair_left_png);
		type.set ("assets/images/living_room/dining_room_chair_left.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/dining_room_chair_right.png", __ASSET__assets_images_living_room_dining_room_chair_right_png);
		type.set ("assets/images/living_room/dining_room_chair_right.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/dining_room_sideboard.png", __ASSET__assets_images_living_room_dining_room_sideboard_png);
		type.set ("assets/images/living_room/dining_room_sideboard.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/dining_room_table.png", __ASSET__assets_images_living_room_dining_room_table_png);
		type.set ("assets/images/living_room/dining_room_table.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/electricity.png", __ASSET__assets_images_living_room_electricity_png);
		type.set ("assets/images/living_room/electricity.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_bench_left.png", __ASSET__assets_images_living_room_kitchen_bench_left_png);
		type.set ("assets/images/living_room/kitchen_bench_left.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_bench_right.png", __ASSET__assets_images_living_room_kitchen_bench_right_png);
		type.set ("assets/images/living_room/kitchen_bench_right.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_drawers.png", __ASSET__assets_images_living_room_kitchen_drawers_png);
		type.set ("assets/images/living_room/kitchen_drawers.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_floor.png", __ASSET__assets_images_living_room_kitchen_floor_png);
		type.set ("assets/images/living_room/kitchen_floor.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_food_1.png", __ASSET__assets_images_living_room_kitchen_food_1_png);
		type.set ("assets/images/living_room/kitchen_food_1.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_food_2.png", __ASSET__assets_images_living_room_kitchen_food_2_png);
		type.set ("assets/images/living_room/kitchen_food_2.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_food_3.png", __ASSET__assets_images_living_room_kitchen_food_3_png);
		type.set ("assets/images/living_room/kitchen_food_3.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_food_4.png", __ASSET__assets_images_living_room_kitchen_food_4_png);
		type.set ("assets/images/living_room/kitchen_food_4.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_food_5.png", __ASSET__assets_images_living_room_kitchen_food_5_png);
		type.set ("assets/images/living_room/kitchen_food_5.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_fridge.png", __ASSET__assets_images_living_room_kitchen_fridge_png);
		type.set ("assets/images/living_room/kitchen_fridge.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/kitchen_stove.png", __ASSET__assets_images_living_room_kitchen_stove_png);
		type.set ("assets/images/living_room/kitchen_stove.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_bg_tile.png", __ASSET__assets_images_living_room_living_room_bg_tile_png);
		type.set ("assets/images/living_room/living_room_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_coffee_table.png", __ASSET__assets_images_living_room_living_room_coffee_table_png);
		type.set ("assets/images/living_room/living_room_coffee_table.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_door_tile.png", __ASSET__assets_images_living_room_living_room_door_tile_png);
		type.set ("assets/images/living_room/living_room_door_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_floor_tile.png", __ASSET__assets_images_living_room_living_room_floor_tile_png);
		type.set ("assets/images/living_room/living_room_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_sofa.png", __ASSET__assets_images_living_room_living_room_sofa_png);
		type.set ("assets/images/living_room/living_room_sofa.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_tv.png", __ASSET__assets_images_living_room_living_room_tv_png);
		type.set ("assets/images/living_room/living_room_tv.png", AssetType.IMAGE);
		
		className.set ("assets/images/living_room/living_room_wall_tile.png", __ASSET__assets_images_living_room_living_room_wall_tile_png);
		type.set ("assets/images/living_room/living_room_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_-.png", __ASSET__assets_images_menu_menu___png);
		type.set ("assets/images/menu/menu_-.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_A.png", __ASSET__assets_images_menu_menu_a_png);
		type.set ("assets/images/menu/menu_A.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_bg_tile.png", __ASSET__assets_images_menu_menu_bg_tile_png);
		type.set ("assets/images/menu/menu_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_C.png", __ASSET__assets_images_menu_menu_c_png);
		type.set ("assets/images/menu/menu_C.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_E.png", __ASSET__assets_images_menu_menu_e_png);
		type.set ("assets/images/menu/menu_E.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_F.png", __ASSET__assets_images_menu_menu_f_png);
		type.set ("assets/images/menu/menu_F.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_J.png", __ASSET__assets_images_menu_menu_j_png);
		type.set ("assets/images/menu/menu_J.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_L.png", __ASSET__assets_images_menu_menu_l_png);
		type.set ("assets/images/menu/menu_L.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_M.png", __ASSET__assets_images_menu_menu_m_png);
		type.set ("assets/images/menu/menu_M.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_N.png", __ASSET__assets_images_menu_menu_n_png);
		type.set ("assets/images/menu/menu_N.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_O.png", __ASSET__assets_images_menu_menu_o_png);
		type.set ("assets/images/menu/menu_O.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_P.png", __ASSET__assets_images_menu_menu_p_png);
		type.set ("assets/images/menu/menu_P.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_R.png", __ASSET__assets_images_menu_menu_r_png);
		type.set ("assets/images/menu/menu_R.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_S.png", __ASSET__assets_images_menu_menu_s_png);
		type.set ("assets/images/menu/menu_S.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_T.png", __ASSET__assets_images_menu_menu_t_png);
		type.set ("assets/images/menu/menu_T.png", AssetType.IMAGE);
		
		className.set ("assets/images/menu/menu_V.png", __ASSET__assets_images_menu_menu_v_png);
		type.set ("assets/images/menu/menu_V.png", AssetType.IMAGE);
		
		className.set ("assets/images/meta/hit_door.png", __ASSET__assets_images_meta_hit_door_png);
		type.set ("assets/images/meta/hit_door.png", AssetType.IMAGE);
		
		className.set ("assets/images/meta/pixel.png", __ASSET__assets_images_meta_pixel_png);
		type.set ("assets/images/meta/pixel.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_ball.png", __ASSET__assets_images_park_park_ball_png);
		type.set ("assets/images/park/park_ball.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_bg_tile.png", __ASSET__assets_images_park_park_bg_tile_png);
		type.set ("assets/images/park/park_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_floor_tile.png", __ASSET__assets_images_park_park_floor_tile_png);
		type.set ("assets/images/park/park_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_left_chair.png", __ASSET__assets_images_park_park_left_chair_png);
		type.set ("assets/images/park/park_left_chair.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_left_flowers.png", __ASSET__assets_images_park_park_left_flowers_png);
		type.set ("assets/images/park/park_left_flowers.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_picnic_basket.png", __ASSET__assets_images_park_park_picnic_basket_png);
		type.set ("assets/images/park/park_picnic_basket.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_right_chair.png", __ASSET__assets_images_park_park_right_chair_png);
		type.set ("assets/images/park/park_right_chair.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_right_flowers.png", __ASSET__assets_images_park_park_right_flowers_png);
		type.set ("assets/images/park/park_right_flowers.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_table.png", __ASSET__assets_images_park_park_table_png);
		type.set ("assets/images/park/park_table.png", AssetType.IMAGE);
		
		className.set ("assets/images/park/park_wall_tile.png", __ASSET__assets_images_park_park_wall_tile_png);
		type.set ("assets/images/park/park_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/people/child_frames.png", __ASSET__assets_images_people_child_frames_png);
		type.set ("assets/images/people/child_frames.png", AssetType.IMAGE);
		
		className.set ("assets/images/people/child_jumping_frames.png", __ASSET__assets_images_people_child_jumping_frames_png);
		type.set ("assets/images/people/child_jumping_frames.png", AssetType.IMAGE);
		
		className.set ("assets/images/people/parent_frames.png", __ASSET__assets_images_people_parent_frames_png);
		type.set ("assets/images/people/parent_frames.png", AssetType.IMAGE);
		
		className.set ("assets/images/people/person_frames.png", __ASSET__assets_images_people_person_frames_png);
		type.set ("assets/images/people/person_frames.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_bg_tile.png", __ASSET__assets_images_playground_playground_bg_tile_png);
		type.set ("assets/images/playground/playground_bg_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_floor_tile.png", __ASSET__assets_images_playground_playground_floor_tile_png);
		type.set ("assets/images/playground/playground_floor_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_seesaw.png", __ASSET__assets_images_playground_playground_seesaw_png);
		type.set ("assets/images/playground/playground_seesaw.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_slide.png", __ASSET__assets_images_playground_playground_slide_png);
		type.set ("assets/images/playground/playground_slide.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_spring_rider.png", __ASSET__assets_images_playground_playground_spring_rider_png);
		type.set ("assets/images/playground/playground_spring_rider.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_swing.png", __ASSET__assets_images_playground_playground_swing_png);
		type.set ("assets/images/playground/playground_swing.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_teeter_totter.png", __ASSET__assets_images_playground_playground_teeter_totter_png);
		type.set ("assets/images/playground/playground_teeter_totter.png", AssetType.IMAGE);
		
		className.set ("assets/images/playground/playground_wall_tile.png", __ASSET__assets_images_playground_playground_wall_tile_png);
		type.set ("assets/images/playground/playground_wall_tile.png", AssetType.IMAGE);
		
		className.set ("assets/images/preloader/click.png", __ASSET__assets_images_preloader_click_png);
		type.set ("assets/images/preloader/click.png", AssetType.IMAGE);
		
		className.set ("assets/images/preloader/loaded.png", __ASSET__assets_images_preloader_loaded_png);
		type.set ("assets/images/preloader/loaded.png", AssetType.IMAGE);
		
		className.set ("assets/images/preloader/loading.png", __ASSET__assets_images_preloader_loading_png);
		type.set ("assets/images/preloader/loading.png", AssetType.IMAGE);
		
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		
		className.set ("assets/sounds/alarm.mp3", __ASSET__assets_sounds_alarm_mp3);
		type.set ("assets/sounds/alarm.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/bus.mp3", __ASSET__assets_sounds_bus_mp3);
		type.set ("assets/sounds/bus.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/car.mp3", __ASSET__assets_sounds_car_mp3);
		type.set ("assets/sounds/car.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/jostle.mp3", __ASSET__assets_sounds_jostle_mp3);
		type.set ("assets/sounds/jostle.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/kick1.mp3", __ASSET__assets_sounds_kick1_mp3);
		type.set ("assets/sounds/kick1.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/kick2.mp3", __ASSET__assets_sounds_kick2_mp3);
		type.set ("assets/sounds/kick2.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/kick2.wav", __ASSET__assets_sounds_kick2_wav);
		type.set ("assets/sounds/kick2.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/mower.mp3", __ASSET__assets_sounds_mower_mp3);
		type.set ("assets/sounds/mower.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/shower.mp3", __ASSET__assets_sounds_shower_mp3);
		type.set ("assets/sounds/shower.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/snare1.mp3", __ASSET__assets_sounds_snare1_mp3);
		type.set ("assets/sounds/snare1.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/snare2.wav", __ASSET__assets_sounds_snare2_wav);
		type.set ("assets/sounds/snare2.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/snare3.mp3", __ASSET__assets_sounds_snare3_mp3);
		type.set ("assets/sounds/snare3.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/snare3.wav", __ASSET__assets_sounds_snare3_wav);
		type.set ("assets/sounds/snare3.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone0.mp3", __ASSET__assets_sounds_tone0_mp3);
		type.set ("assets/sounds/tone0.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone0.wav", __ASSET__assets_sounds_tone0_wav);
		type.set ("assets/sounds/tone0.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone1.mp3", __ASSET__assets_sounds_tone1_mp3);
		type.set ("assets/sounds/tone1.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone1.wav", __ASSET__assets_sounds_tone1_wav);
		type.set ("assets/sounds/tone1.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone2.mp3", __ASSET__assets_sounds_tone2_mp3);
		type.set ("assets/sounds/tone2.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone2.wav", __ASSET__assets_sounds_tone2_wav);
		type.set ("assets/sounds/tone2.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone3.mp3", __ASSET__assets_sounds_tone3_mp3);
		type.set ("assets/sounds/tone3.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone3.wav", __ASSET__assets_sounds_tone3_wav);
		type.set ("assets/sounds/tone3.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone4.mp3", __ASSET__assets_sounds_tone4_mp3);
		type.set ("assets/sounds/tone4.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone4.wav", __ASSET__assets_sounds_tone4_wav);
		type.set ("assets/sounds/tone4.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone5.mp3", __ASSET__assets_sounds_tone5_mp3);
		type.set ("assets/sounds/tone5.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone5.wav", __ASSET__assets_sounds_tone5_wav);
		type.set ("assets/sounds/tone5.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone6.mp3", __ASSET__assets_sounds_tone6_mp3);
		type.set ("assets/sounds/tone6.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone6.wav", __ASSET__assets_sounds_tone6_wav);
		type.set ("assets/sounds/tone6.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone7.mp3", __ASSET__assets_sounds_tone7_mp3);
		type.set ("assets/sounds/tone7.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone7.wav", __ASSET__assets_sounds_tone7_wav);
		type.set ("assets/sounds/tone7.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/tone8.mp3", __ASSET__assets_sounds_tone8_mp3);
		type.set ("assets/sounds/tone8.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/tone8.wav", __ASSET__assets_sounds_tone8_wav);
		type.set ("assets/sounds/tone8.wav", AssetType.SOUND);
		
		className.set ("assets/sounds/beep.mp3", __ASSET__assets_sounds_beep_mp3);
		type.set ("assets/sounds/beep.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/flixel.mp3", __ASSET__assets_sounds_flixel_mp3);
		type.set ("assets/sounds/flixel.mp3", AssetType.MUSIC);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						if (eventCallback != null) {
							
							eventCallback (this, "change");
							
						}
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), ByteArray));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return cast (Type.createInstance (className.get (id), []), ByteArray);
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return bitmapData.getPixels (bitmapData.rect);
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif html5
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), ByteArray);
		else return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String, handler:AudioBuffer -> Void):Void {
		
		#if (flash)
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				handler (audioBuffer);
				
			});
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			handler (getAudioBuffer (id));
			
		}
		#else
		handler (getAudioBuffer (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadImage (id:String, handler:Image -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				handler (Image.fromBitmapData (bitmapData));
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getImage (id));
			
		}
		
		#else
		
		handler (getImage (id));
		
		#end
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = ByteArray.readFile ("../Resources/manifest");
			#elseif ios
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if ios
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	/*public override function loadMusic (id:String, handler:Dynamic -> Void):Void {
		
		#if (flash || html5)
		
		//if (path.exists (id)) {
			
		//	var loader = new Loader ();
		//	loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
		//		handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
		//	});
		//	loader.load (new URLRequest (path.get (id)));
			
		//} else {
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}*/
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		//#if html5
		
		/*if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}*/
		
		//#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		//#end
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_data_data_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_bath_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_mirror_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_sink_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_toilet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bathroom_bathroom_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_full_fence_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_left_cliff_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_left_fence_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_right_cliff_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_right_fence_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_towels_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_umbrella_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_beach_beach_water_strip_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_bed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_debris_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_dresser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_ensuite_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_ensuite_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_shower_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_shower_water_anim_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_toilet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_bedroom_bedroom_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_bed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_desk_and_chair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_door_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_sink_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_toilet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_cell_cell_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bottom_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bus_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bus_stop_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_doorstep_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_left_fence_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_right_fence_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_road_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_front_of_house_road_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_bottom_left_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_bottom_right_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_door_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_doorstep_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_lawnmower_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_lower_left_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_middle_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_mowed_grass_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_poison_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_right_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_tool_area_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_top_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_unmowed_grass_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_garden_garden_upper_left_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_bg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_gravestone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_gravestone_shadow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_parent_gravestone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_parent_gravestone_shadow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_graveyard_wall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_graveyard_raindrop_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_hallway_hallway_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_hallway_hallway_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_hallway_hallway_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_bunk_bed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_chair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_desk_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_dresser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_single_bed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_table_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_box_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_dining_room_chair_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_dining_room_chair_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_dining_room_sideboard_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_dining_room_table_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_electricity_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_bench_left_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_bench_right_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_drawers_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_floor_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_food_1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_food_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_food_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_food_4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_food_5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_fridge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_kitchen_stove_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_coffee_table_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_door_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_sofa_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_tv_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_living_room_living_room_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu___png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_a_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_c_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_e_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_f_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_j_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_l_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_n_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_o_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_r_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_s_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_t_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_menu_menu_v_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_meta_hit_door_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_meta_pixel_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_ball_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_left_chair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_left_flowers_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_picnic_basket_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_right_chair_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_right_flowers_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_table_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_park_park_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_people_child_frames_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_people_child_jumping_frames_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_people_parent_frames_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_people_person_frames_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_bg_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_floor_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_seesaw_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_slide_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_spring_rider_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_swing_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_teeter_totter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_playground_playground_wall_tile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_preloader_click_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_preloader_loaded_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_preloader_loading_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_music_music_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_alarm_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_bus_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_car_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_jostle_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_kick1_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_kick2_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_kick2_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_mower_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_shower_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_snare1_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_snare2_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_snare3_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_snare3_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone0_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone0_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone1_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone1_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone2_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone2_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone3_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone3_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone4_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone4_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone5_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone5_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone6_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone6_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone7_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone7_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone8_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_tone8_wav extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_beep_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_flixel_mp3 extends flash.media.Sound { }


#elseif html5


































































































































































































#else



#if (windows || mac || linux)


@:file("assets/data/data-goes-here.txt") #if display private #end class __ASSET__assets_data_data_goes_here_txt extends lime.utils.ByteArray {}
@:image("assets/images/bathroom/bathroom_bath.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_bath_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_bg_tile.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_floor_tile.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_mirror.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_mirror_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_sink.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_sink_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_toilet.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_toilet_png extends lime.graphics.Image {}
@:image("assets/images/bathroom/bathroom_wall_tile.png") #if display private #end class __ASSET__assets_images_bathroom_bathroom_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_bg_tile.png") #if display private #end class __ASSET__assets_images_beach_beach_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_full_fence.png") #if display private #end class __ASSET__assets_images_beach_beach_full_fence_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_left_cliff.png") #if display private #end class __ASSET__assets_images_beach_beach_left_cliff_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_left_fence.png") #if display private #end class __ASSET__assets_images_beach_beach_left_fence_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_right_cliff.png") #if display private #end class __ASSET__assets_images_beach_beach_right_cliff_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_right_fence.png") #if display private #end class __ASSET__assets_images_beach_beach_right_fence_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_towels.png") #if display private #end class __ASSET__assets_images_beach_beach_towels_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_umbrella.png") #if display private #end class __ASSET__assets_images_beach_beach_umbrella_png extends lime.graphics.Image {}
@:image("assets/images/beach/beach_water_strip.png") #if display private #end class __ASSET__assets_images_beach_beach_water_strip_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_bed.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_bed_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_bg_tile.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_debris.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_debris_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_dresser.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_dresser_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_ensuite_left.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_ensuite_left_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_ensuite_right.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_ensuite_right_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_floor_tile.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_shower.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_shower_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_shower_water_anim.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_shower_water_anim_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_toilet.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_toilet_png extends lime.graphics.Image {}
@:image("assets/images/bedroom/bedroom_wall_tile.png") #if display private #end class __ASSET__assets_images_bedroom_bedroom_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_bed.png") #if display private #end class __ASSET__assets_images_cell_cell_bed_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_bg.png") #if display private #end class __ASSET__assets_images_cell_cell_bg_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_bg_tile.png") #if display private #end class __ASSET__assets_images_cell_cell_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_desk_and_chair.png") #if display private #end class __ASSET__assets_images_cell_cell_desk_and_chair_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_door.png") #if display private #end class __ASSET__assets_images_cell_cell_door_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_floor_tile.png") #if display private #end class __ASSET__assets_images_cell_cell_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_sink.png") #if display private #end class __ASSET__assets_images_cell_cell_sink_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_toilet.png") #if display private #end class __ASSET__assets_images_cell_cell_toilet_png extends lime.graphics.Image {}
@:image("assets/images/cell/cell_wall_tile.png") #if display private #end class __ASSET__assets_images_cell_cell_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_bg_tile.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_bottom_wall.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bottom_wall_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_bus.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bus_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_bus_stop.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_bus_stop_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_car1.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car1_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_car2.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car2_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_car3.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car3_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_car4.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_car4_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_doorstep.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_doorstep_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_left_fence.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_left_fence_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_right_fence.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_right_fence_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/front_of_house_road.png") #if display private #end class __ASSET__assets_images_front_of_house_front_of_house_road_png extends lime.graphics.Image {}
@:image("assets/images/front_of_house/road.png") #if display private #end class __ASSET__assets_images_front_of_house_road_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_bg_tile.png") #if display private #end class __ASSET__assets_images_garden_garden_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_bottom_left_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_bottom_left_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_bottom_right_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_bottom_right_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_door_tile.png") #if display private #end class __ASSET__assets_images_garden_garden_door_tile_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_doorstep.png") #if display private #end class __ASSET__assets_images_garden_garden_doorstep_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_lawnmower.png") #if display private #end class __ASSET__assets_images_garden_garden_lawnmower_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_lower_left_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_lower_left_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_middle_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_middle_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_mowed_grass_tile.png") #if display private #end class __ASSET__assets_images_garden_garden_mowed_grass_tile_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_poison.png") #if display private #end class __ASSET__assets_images_garden_garden_poison_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_right_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_right_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_tool_area.png") #if display private #end class __ASSET__assets_images_garden_garden_tool_area_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_top_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_top_wall_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_unmowed_grass_tile.png") #if display private #end class __ASSET__assets_images_garden_garden_unmowed_grass_tile_png extends lime.graphics.Image {}
@:image("assets/images/garden/garden_upper_left_wall.png") #if display private #end class __ASSET__assets_images_garden_garden_upper_left_wall_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_bg.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_bg_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_gravestone.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_gravestone_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_gravestone_shadow.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_gravestone_shadow_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_parent_gravestone.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_parent_gravestone_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_parent_gravestone_shadow.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_parent_gravestone_shadow_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/graveyard_wall.png") #if display private #end class __ASSET__assets_images_graveyard_graveyard_wall_png extends lime.graphics.Image {}
@:image("assets/images/graveyard/raindrop.png") #if display private #end class __ASSET__assets_images_graveyard_raindrop_png extends lime.graphics.Image {}
@:image("assets/images/hallway/hallway_bg_tile.png") #if display private #end class __ASSET__assets_images_hallway_hallway_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/hallway/hallway_floor_tile.png") #if display private #end class __ASSET__assets_images_hallway_hallway_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/hallway/hallway_wall_tile.png") #if display private #end class __ASSET__assets_images_hallway_hallway_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_bg_tile.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_bunk_bed.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_bunk_bed_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_chair.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_chair_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_desk.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_desk_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_dresser.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_dresser_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_floor_tile.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_single_bed.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_single_bed_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_table.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_table_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_toy_1.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_1_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_toy_2.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_2_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_toy_3.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_3_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_toy_4.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_4_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_toy_5.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_toy_5_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_tv.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_tv_box.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_tv_box_png extends lime.graphics.Image {}
@:image("assets/images/kids_bedroom/kids_bedroom_wall_tile.png") #if display private #end class __ASSET__assets_images_kids_bedroom_kids_bedroom_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/living_room/dining_room_chair_left.png") #if display private #end class __ASSET__assets_images_living_room_dining_room_chair_left_png extends lime.graphics.Image {}
@:image("assets/images/living_room/dining_room_chair_right.png") #if display private #end class __ASSET__assets_images_living_room_dining_room_chair_right_png extends lime.graphics.Image {}
@:image("assets/images/living_room/dining_room_sideboard.png") #if display private #end class __ASSET__assets_images_living_room_dining_room_sideboard_png extends lime.graphics.Image {}
@:image("assets/images/living_room/dining_room_table.png") #if display private #end class __ASSET__assets_images_living_room_dining_room_table_png extends lime.graphics.Image {}
@:image("assets/images/living_room/electricity.png") #if display private #end class __ASSET__assets_images_living_room_electricity_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_bench_left.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_bench_left_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_bench_right.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_bench_right_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_drawers.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_drawers_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_floor.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_floor_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_food_1.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_food_1_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_food_2.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_food_2_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_food_3.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_food_3_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_food_4.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_food_4_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_food_5.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_food_5_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_fridge.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_fridge_png extends lime.graphics.Image {}
@:image("assets/images/living_room/kitchen_stove.png") #if display private #end class __ASSET__assets_images_living_room_kitchen_stove_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_bg_tile.png") #if display private #end class __ASSET__assets_images_living_room_living_room_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_coffee_table.png") #if display private #end class __ASSET__assets_images_living_room_living_room_coffee_table_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_door_tile.png") #if display private #end class __ASSET__assets_images_living_room_living_room_door_tile_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_floor_tile.png") #if display private #end class __ASSET__assets_images_living_room_living_room_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_sofa.png") #if display private #end class __ASSET__assets_images_living_room_living_room_sofa_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_tv.png") #if display private #end class __ASSET__assets_images_living_room_living_room_tv_png extends lime.graphics.Image {}
@:image("assets/images/living_room/living_room_wall_tile.png") #if display private #end class __ASSET__assets_images_living_room_living_room_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_-.png") #if display private #end class __ASSET__assets_images_menu_menu___png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_A.png") #if display private #end class __ASSET__assets_images_menu_menu_a_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_bg_tile.png") #if display private #end class __ASSET__assets_images_menu_menu_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_C.png") #if display private #end class __ASSET__assets_images_menu_menu_c_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_E.png") #if display private #end class __ASSET__assets_images_menu_menu_e_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_F.png") #if display private #end class __ASSET__assets_images_menu_menu_f_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_J.png") #if display private #end class __ASSET__assets_images_menu_menu_j_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_L.png") #if display private #end class __ASSET__assets_images_menu_menu_l_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_M.png") #if display private #end class __ASSET__assets_images_menu_menu_m_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_N.png") #if display private #end class __ASSET__assets_images_menu_menu_n_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_O.png") #if display private #end class __ASSET__assets_images_menu_menu_o_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_P.png") #if display private #end class __ASSET__assets_images_menu_menu_p_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_R.png") #if display private #end class __ASSET__assets_images_menu_menu_r_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_S.png") #if display private #end class __ASSET__assets_images_menu_menu_s_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_T.png") #if display private #end class __ASSET__assets_images_menu_menu_t_png extends lime.graphics.Image {}
@:image("assets/images/menu/menu_V.png") #if display private #end class __ASSET__assets_images_menu_menu_v_png extends lime.graphics.Image {}
@:image("assets/images/meta/hit_door.png") #if display private #end class __ASSET__assets_images_meta_hit_door_png extends lime.graphics.Image {}
@:image("assets/images/meta/pixel.png") #if display private #end class __ASSET__assets_images_meta_pixel_png extends lime.graphics.Image {}
@:image("assets/images/park/park_ball.png") #if display private #end class __ASSET__assets_images_park_park_ball_png extends lime.graphics.Image {}
@:image("assets/images/park/park_bg_tile.png") #if display private #end class __ASSET__assets_images_park_park_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/park/park_floor_tile.png") #if display private #end class __ASSET__assets_images_park_park_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/park/park_left_chair.png") #if display private #end class __ASSET__assets_images_park_park_left_chair_png extends lime.graphics.Image {}
@:image("assets/images/park/park_left_flowers.png") #if display private #end class __ASSET__assets_images_park_park_left_flowers_png extends lime.graphics.Image {}
@:image("assets/images/park/park_picnic_basket.png") #if display private #end class __ASSET__assets_images_park_park_picnic_basket_png extends lime.graphics.Image {}
@:image("assets/images/park/park_right_chair.png") #if display private #end class __ASSET__assets_images_park_park_right_chair_png extends lime.graphics.Image {}
@:image("assets/images/park/park_right_flowers.png") #if display private #end class __ASSET__assets_images_park_park_right_flowers_png extends lime.graphics.Image {}
@:image("assets/images/park/park_table.png") #if display private #end class __ASSET__assets_images_park_park_table_png extends lime.graphics.Image {}
@:image("assets/images/park/park_wall_tile.png") #if display private #end class __ASSET__assets_images_park_park_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/people/child_frames.png") #if display private #end class __ASSET__assets_images_people_child_frames_png extends lime.graphics.Image {}
@:image("assets/images/people/child_jumping_frames.png") #if display private #end class __ASSET__assets_images_people_child_jumping_frames_png extends lime.graphics.Image {}
@:image("assets/images/people/parent_frames.png") #if display private #end class __ASSET__assets_images_people_parent_frames_png extends lime.graphics.Image {}
@:image("assets/images/people/person_frames.png") #if display private #end class __ASSET__assets_images_people_person_frames_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_bg_tile.png") #if display private #end class __ASSET__assets_images_playground_playground_bg_tile_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_floor_tile.png") #if display private #end class __ASSET__assets_images_playground_playground_floor_tile_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_seesaw.png") #if display private #end class __ASSET__assets_images_playground_playground_seesaw_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_slide.png") #if display private #end class __ASSET__assets_images_playground_playground_slide_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_spring_rider.png") #if display private #end class __ASSET__assets_images_playground_playground_spring_rider_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_swing.png") #if display private #end class __ASSET__assets_images_playground_playground_swing_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_teeter_totter.png") #if display private #end class __ASSET__assets_images_playground_playground_teeter_totter_png extends lime.graphics.Image {}
@:image("assets/images/playground/playground_wall_tile.png") #if display private #end class __ASSET__assets_images_playground_playground_wall_tile_png extends lime.graphics.Image {}
@:image("assets/images/preloader/click.png") #if display private #end class __ASSET__assets_images_preloader_click_png extends lime.graphics.Image {}
@:image("assets/images/preloader/loaded.png") #if display private #end class __ASSET__assets_images_preloader_loaded_png extends lime.graphics.Image {}
@:image("assets/images/preloader/loading.png") #if display private #end class __ASSET__assets_images_preloader_loading_png extends lime.graphics.Image {}
@:file("assets/music/music-goes-here.txt") #if display private #end class __ASSET__assets_music_music_goes_here_txt extends lime.utils.ByteArray {}
@:file("assets/sounds/alarm.mp3") #if display private #end class __ASSET__assets_sounds_alarm_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/bus.mp3") #if display private #end class __ASSET__assets_sounds_bus_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/car.mp3") #if display private #end class __ASSET__assets_sounds_car_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/jostle.mp3") #if display private #end class __ASSET__assets_sounds_jostle_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/kick1.mp3") #if display private #end class __ASSET__assets_sounds_kick1_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/kick2.mp3") #if display private #end class __ASSET__assets_sounds_kick2_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/kick2.wav") #if display private #end class __ASSET__assets_sounds_kick2_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/mower.mp3") #if display private #end class __ASSET__assets_sounds_mower_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/shower.mp3") #if display private #end class __ASSET__assets_sounds_shower_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/snare1.mp3") #if display private #end class __ASSET__assets_sounds_snare1_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/snare2.wav") #if display private #end class __ASSET__assets_sounds_snare2_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/snare3.mp3") #if display private #end class __ASSET__assets_sounds_snare3_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/snare3.wav") #if display private #end class __ASSET__assets_sounds_snare3_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone0.mp3") #if display private #end class __ASSET__assets_sounds_tone0_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone0.wav") #if display private #end class __ASSET__assets_sounds_tone0_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone1.mp3") #if display private #end class __ASSET__assets_sounds_tone1_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone1.wav") #if display private #end class __ASSET__assets_sounds_tone1_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone2.mp3") #if display private #end class __ASSET__assets_sounds_tone2_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone2.wav") #if display private #end class __ASSET__assets_sounds_tone2_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone3.mp3") #if display private #end class __ASSET__assets_sounds_tone3_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone3.wav") #if display private #end class __ASSET__assets_sounds_tone3_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone4.mp3") #if display private #end class __ASSET__assets_sounds_tone4_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone4.wav") #if display private #end class __ASSET__assets_sounds_tone4_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone5.mp3") #if display private #end class __ASSET__assets_sounds_tone5_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone5.wav") #if display private #end class __ASSET__assets_sounds_tone5_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone6.mp3") #if display private #end class __ASSET__assets_sounds_tone6_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone6.wav") #if display private #end class __ASSET__assets_sounds_tone6_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone7.mp3") #if display private #end class __ASSET__assets_sounds_tone7_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone7.wav") #if display private #end class __ASSET__assets_sounds_tone7_wav extends lime.utils.ByteArray {}
@:file("assets/sounds/tone8.mp3") #if display private #end class __ASSET__assets_sounds_tone8_mp3 extends lime.utils.ByteArray {}
@:file("assets/sounds/tone8.wav") #if display private #end class __ASSET__assets_sounds_tone8_wav extends lime.utils.ByteArray {}
@:file("/usr/lib/haxe/lib/flixel/3,3,6/assets/sounds/beep.mp3") #if display private #end class __ASSET__assets_sounds_beep_mp3 extends lime.utils.ByteArray {}
@:file("/usr/lib/haxe/lib/flixel/3,3,6/assets/sounds/flixel.mp3") #if display private #end class __ASSET__assets_sounds_flixel_mp3 extends lime.utils.ByteArray {}



#end

#if openfl

#end

#end
#end

