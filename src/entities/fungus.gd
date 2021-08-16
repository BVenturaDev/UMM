extends Spatial

var grid: Object = null
var owned_tiles: Array = []

func _ready() -> void:
	grid = get_parent().get_node("grid")
	var tile: Object = grid.find_tile(Globals.MAP_SIZE * 0.25, Globals.MAP_SIZE * 0.25)
	if tile:
		_claim_tile(tile)
		tile.spawn_num_food(1000)
		
func _claim_tile(var tile: Object) -> void:
	tile.owner_fungus = self
	owned_tiles.append(tile)

func add_tile(var tile: Object) -> void:
	owned_tiles.append(tile)
	
func remove_tile(var id: int) -> void:
	if id > -1 and id < owned_tiles.size():
		owned_tiles.remove(id)

func do_turn() -> void:
	# Expand the fungus
	for tile in owned_tiles:
		var neighbors = Globals.grid.find_neighbors(tile.x, tile.y)
		# Equalize food to neighboring owned tiles
		for neighbor in neighbors:
			if neighbor.owner_fungus == self:
				if neighbor.tile_food.size() < tile.tile_food.size():
					tile.remove_num_food(1)
					neighbor.spawn_food()
		# Try to expand
		if tile.tile_food.size() >= 6 and not tile.turn_used:
			# Has enough food check for expansion tile
			if neighbors.size() > 0:
				# Remove tiles with an owner
				for i in range(neighbors.size() - 1, -1, -1):
					if not neighbors[i].owner_fungus == null:
						neighbors.remove(i)
				# If any remain then pick a random tile and expand
				if neighbors.size() > 0:
					# Remove 5 food from this tile
					var chosen_tile: Object = neighbors[Globals.rng.randi_range(0, neighbors.size() - 1)]
					tile.remove_num_food(5)
					_claim_tile(chosen_tile)
					chosen_tile.spawn_food()
