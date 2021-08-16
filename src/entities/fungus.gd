extends Spatial

#var grid: Object = null
var owned_tiles: Array = []

func _ready() -> void:
	if Globals.grid:
		var tile: Object = Globals.grid.find_tile(0, 0)
		if tile:
			_claim_tile(tile)
			tile.spawn_num_food(50)

func _claim_tile(var tile: Object) -> void:
	tile.owner_fungus = self
	owned_tiles.append(tile)
	
func remove_tile(var id: int) -> void:
	if id > -1 and id < owned_tiles.size():
		owned_tiles.remove(id)

func do_turn() -> void:
	# Expand the fungus
	for tile in owned_tiles:
		var neighbors = Globals.grid.find_neighbors(tile.x, tile.y)
		# Try to expand
		if tile.tile_food.size() >= 6 and not tile.turn_used:
			# Has enough food check for expansion tile
			if neighbors.size() > 0:
				var expansion_neighbors = neighbors
				# Remove tiles with an owner
				for i in range(expansion_neighbors.size() - 1, -1, -1):
					if not expansion_neighbors[i].owner_fungus == null:
						expansion_neighbors.remove(i)
				# If any remain then pick a random tile and expand
				if expansion_neighbors.size() > 0:
					# Remove 5 food from this tile
					var chosen_tile: Object = neighbors[Globals.rng.randi_range(0, expansion_neighbors.size() - 1)]
					tile.remove_num_food(5)
					_claim_tile(chosen_tile)
					chosen_tile.spawn_food()
		"""# Spread food to neighboring owned tiles
		for neighbor in neighbors:
			if neighbor.owner_fungus == self:
				if neighbor.tile_food.size() < tile.tile_food.size():
					tile.remove_num_food(1)
					neighbor.spawn_food()"""
