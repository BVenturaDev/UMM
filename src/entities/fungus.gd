extends Spatial

const PLAYER_OFFSET: float = 0.25
const AI_OFFSET: float = 0.75

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
		_claim_tile(tile)
		tile.spawn_num_food(20)
		tile.spawn_log()
		
func _claim_tile(var tile: Object) -> void:
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

func do_turn() -> void:
	print("Fungus Turn: " + str(my_owner.name))
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
