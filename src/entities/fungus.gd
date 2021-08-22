extends Spatial
class_name Fungus

export var PLAYER_OFFSET: float = 0.25
export var AI_OFFSET: float = 0.75

var my_owner: Object = null
var owned_tiles: Array = []

func _ready() -> void:
	my_owner = get_parent()
	var x: int = 0
	var y: int = 0
	if my_owner.name == "player":
		x = int(Globals.MAP_SIZE * PLAYER_OFFSET)
		y = int(Globals.MAP_SIZE * PLAYER_OFFSET)
	else:
		x = int(Globals.MAP_SIZE * AI_OFFSET)
		y = int(Globals.MAP_SIZE * AI_OFFSET)
	var tile: Object = Globals.grid.find_tile(x, y)
	if tile:
		claim_tile(tile)
		tile.spawn_num_food(25)
		tile.call_deferred("spawn_log")
		tile.call_deferred("build_gather_shroom")
		
func claim_tile(var tile: Object) -> void:
	tile.owner_fungus = self
	owned_tiles.append(tile)
	if my_owner.name == "player":
		tile.generate_friendly_ui()
	elif my_owner.name == "ai" and Globals.DEBUG:
		tile.generate_friendly_ui()
		
func add_tile(var tile: Object) -> void:
	owned_tiles.append(tile)
	
func remove_tile(var id: int) -> void:
	if id > -1 and id < owned_tiles.size():
		owned_tiles[id].owner_fungus = null
		owned_tiles.remove(id)
		
func remove_tile_object(var tile: Object) -> void:
	owned_tiles.erase(tile)

func do_turn() -> void:
	if owned_tiles.size() == 0:
		if my_owner.name == "player":
			GameSignals.emit_signal("game_finished_with_winner", Globals.ai)
		else:
			GameSignals.emit_signal("game_finished_with_winner", Globals.player)
	# Expand the fungus
	for tile in owned_tiles:
		# Try to expand
		if tile.tile_food.size() >= 6:
			var clean_neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
			# Has enough food check for expansion tile
			if clean_neighbors.size() > 0:
				# Remove tiles with an owner
				for i in range(clean_neighbors.size() - 1, -1, -1):
					if not clean_neighbors[i].owner_fungus == null:
						clean_neighbors.remove(i)
				# If any remain then pick a random tile and expand
				if clean_neighbors.size() > 0:
					# Remove 5 food from this tile
					var chosen_tile: Object = clean_neighbors[Globals.rng.randi_range(0, clean_neighbors.size() - 1)]
					tile.remove_num_food(5)
					claim_tile(chosen_tile)
					chosen_tile.spawn_food()
		var neighbors = Globals.grid.find_neighbors(tile.x, tile.y)
		# Equalize food to neighboring owned tiles
		for neighbor in neighbors:
			if neighbor.owner_fungus == self:
				if neighbor.tile_food.size() < tile.tile_food.size():
					tile.remove_num_food(1)
					neighbor.spawn_food()
	Globals.check_winner(self)

func find_nearest_tile(var dest_tile: Object) -> Object:
	if not dest_tile:
		return null
	var nearest_tile: Object = null
	for tile in owned_tiles:
			if tile.owner_fungus:
				if tile.owner_fungus == self:
					if nearest_tile:
						if Globals.grid.get_distance(dest_tile, tile) < Globals.grid.get_distance(dest_tile, nearest_tile):
							nearest_tile = tile
					else:
						nearest_tile = tile
	return nearest_tile

func owned_tiles_sort(var tiles: Array) -> Array:
	var out_tiles: Array = []
	for other_tile in tiles:
		for my_tile in owned_tiles:
			if other_tile == my_tile:
				out_tiles.append(other_tile)
	return out_tiles
