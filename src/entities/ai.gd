extends Spatial

onready var fungus = $fungus

func do_turn():
	for tile in fungus.owned_tiles:
		if not tile.turn_used and not tile.cur_shroom and not tile.critter:
			# Make gather shroom if possible
			if tile.cur_resource:
				if tile.tile_food.size() > 5:
					tile.build_gather_shroom()
				else:
					if _try_gather_food(tile):
						tile.build_gather_shroom()
			else:
				# Check neighbors and decide if we need a poison shroom
				var region: Array = Globals.grid.find_region(tile.x, tile.y)
				var is_critter: bool = false
				for other_tile in region:
					if other_tile.critter:
						is_critter = true
				var owned_region: Array = fungus.owned_tiles_sort(region)
				var is_poisoned: bool = false
				for owned_tile in owned_region:
					if owned_tile.cur_shroom:
						if owned_tile.cur_shroom.is_in_group("poison"):
							is_poisoned = true
				if is_critter and not is_poisoned:
					if tile.tile_food.size() > 5:
						tile.build_poison_shroom()
					else:
						if _try_gather_food(tile):
							tile.build_poison_shroom()

func _try_gather_food(var tile: Object) -> bool:
	var region: Array = Globals.grid.find_region(tile.x, tile.y)
	region = fungus.owned_tiles_sort(region)
	for i in region:
		if i.tile_food.size() > 1:
			i.do_move_food(tile, i.tile_food.size() - 1)
			if tile.tile_food.size() > 5:
				return true
	return false
