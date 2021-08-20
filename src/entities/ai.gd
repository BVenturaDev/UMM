extends Spatial

onready var fungus = $fungus

func do_turn():
	for tile in fungus.owned_tiles:
		tile.disable_glow()
		if not tile.turn_used and not tile.cur_shroom and not tile.critter:
			# Make gather shroom if possible
			if tile.cur_resource:
				if tile.tile_food.size() > 5:
					tile.build_gather_shroom()
				else:
					if _try_gather_food(tile, 5):
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
						if _try_gather_food(tile, 5):
							tile.build_poison_shroom()
				# Check if we need a scout shroom
				var neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
				var has_scout: bool = false
				var need_scout: bool = false
				for neighbor in neighbors:
					# Check if owned and has shroom
					if neighbor.owner_fungus:
						if neighbor.owner_fungus == self:
							if neighbor.cur_shroom:
								if neighbor.cur_shroom.is_in_group("scout"):
									has_scout = true
						elif neighbor.owner_fungus.my_owner.name == "player":
							need_scout = true
				if not has_scout and need_scout:
					if tile.tile_food.size() > 5:
						tile.build_scout_shroom()
					else:
						if _try_gather_food(tile, 5):
							tile.build_scout_shroom()
		# Check shroom
		if tile.cur_shroom and not tile.turn_used:
			if tile.cur_shroom.is_in_group("scout"):
				# Reveals enemy neighbors
				var neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
				var enemy_neighbors: bool = false
				for neighbor in neighbors:
					if neighbor.owner_fungus and not tile.turn_used:
						if not neighbor.owner_fungus.my_owner == self:
							# Enemy revealed (maybe attack here)
							var my_food: int = tile.tile_food.size()
							var enemy_food: int = neighbor.tile_food.size()
							if my_food - 1 > enemy_food:
								attack_tile(tile, neighbor, get_attack_amount(tile))
							elif _try_gather_food(tile, enemy_food - my_food + 1):
								attack_tile(tile, neighbor, get_attack_amount(tile))
							enemy_neighbors = true
				if not enemy_neighbors:
					tile.cur_shroom.kill()
					
func get_attack_amount(var tile: Object) -> int:
	var amount: int = 0
	if tile.tile_food.size() > Globals.MAX_FOOD_MOVE:
		amount = Globals.MAX_FOOD_MOVE
	elif tile.tile_food.size() > 0:
		amount = tile.tile_food.size() - 1
	return amount

func attack_tile(var my_tile: Object, var enemy_tile: Object, var amount: int) -> void:
	my_tile.move_amount = amount
	my_tile.do_attack(enemy_tile)

func _try_gather_food(var tile: Object, var amount: int) -> bool:
	var region: Array = Globals.grid.find_region(tile.x, tile.y)
	region = fungus.owned_tiles_sort(region)
	for i in region:
		if i.tile_food.size() > 1 and not i.turn_used:
			i.do_move_food(tile, i.tile_food.size() - 1)
			i.turn_used = true
			if tile.tile_food.size() > amount:
				return true
	return false
