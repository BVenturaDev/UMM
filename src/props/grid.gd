extends Spatial
# Constants
const X_OFFSET: float = 1.7
const Z_OFFSET: float = 1.5

# Scenes
var Tile: Object = preload("res://scenes/props/tile.tscn")

# Variables
var tiles: Array = []
# Determines if we add by half x_offset first
var odd_row = false

func _ready() -> void:
	Globals.grid = self
	# Generate the grid
	_generate_grid(Globals.MAP_SIZE)

func _generate_grid(size: int) -> void:
	if Tile:
		for x in range(0, size):
			var col: Array = []
			for y in range(0, size):
				var new_tile: Object = _add_tile(x, y)
				col.append(new_tile)
				# Flip row for the offset
				_flip_odd_row()
			tiles.append(col)

# Add a tile at x, y
func _add_tile(var x: int, var y: int) -> Object:
	var new_tile: Object = Tile.instance()
	add_child(new_tile)
	new_tile.x = x
	new_tile.y = y
	new_tile.odd_row = odd_row
	new_tile.global_transform.origin.x = float(x) * X_OFFSET
	new_tile.global_transform.origin.z = float(y) * Z_OFFSET
	# Offset for every other row
	if odd_row:
		new_tile.global_transform.origin.x += X_OFFSET / 2.0
	return new_tile

# Turn the bool between odd and even rows for the offseta
func _flip_odd_row() -> void:
	if odd_row:
		odd_row = false
	else:
		odd_row = true

# Returns true if x and y are in the grid range
func _in_range(var x:int , var y: int) -> bool:
	if x > -1 and x < tiles.size():
		if y > -1 and y < tiles[x].size():
			return true
	return false

# Find the tile at x, y on the grid return null otherwise
func find_tile(var x: int, var y: int) -> Object:
	if _in_range(x, y):
			return tiles[x][y]
	return null

# Returns an array of all neighboring tiles or null
func find_neighbors(var x: int, var y: int) -> Array:
	var neighbors: Array = []
	var this_tile: Object = find_tile(x, y)
	for i_x in range(-1, 2):
		for i_y in range(-1, 2):
			# Value to check edges because of odd / even offset
			var in_bounds: bool = true
			if this_tile.odd_row:
				if i_x == -1 and not i_y == 0:
					in_bounds = false
			else:
				if i_x == 1 and not i_y == 0:
					in_bounds = false
			if _in_range(x + i_x, y + i_y) and in_bounds:
				var neighbor: Object = find_tile(x + i_x, y + i_y)
				if neighbor and this_tile:
					if not neighbor == this_tile:
						# Found neighbor
						neighbors.append(neighbor)
	return neighbors
	
	# Finds all neighbors in 3 tile range
func find_region(var x: int, var y: int) -> Array:
	# warning-ignore:unused_variable
	var max_distance_hexagon_3 = 34
	var region: Array = []
	var this_tile: Spatial = find_tile(x, y)
	for i_x in range(-3, 4):
		for i_y in range(-3, 4):
			if _in_range(x + i_x, y + i_y):
				var neighbor: Object = find_tile(x + i_x, y + i_y)
				if neighbor and this_tile:
					if not neighbor == this_tile:
						var distance_to_tile = this_tile.global_transform.origin.distance_squared_to(
								neighbor.global_transform.origin)
						if distance_to_tile < max_distance_hexagon_3:
							region.append(neighbor)
	return region
	
func gray_all_tiles() -> void:
	for x in range(0, tiles.size()):
		for y in range(0, tiles[x].size()):
			tiles[x][y].enable_grayed_out()
			
func disable_gray_all_tiles() -> void:
	for x in range(0, tiles.size()):
		for y in range(0, tiles[x].size()):
			tiles[x][y].disable_grayed_out()
