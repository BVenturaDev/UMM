extends Spatial

onready var fungus = $fungus

func do_turn():
	for tile in fungus.owned_tiles:
		if tile.cur_resource and tile.tile_food.size() > 5 and not tile.turn_used and not tile.cur_shroom:
			tile.build_gather_shroom()
