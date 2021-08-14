extends Spatial

# Constants
const X_OFFSET: float = 1.7
const Z_OFFSET: float = 1.5

# Scenes
onready var Tile: Object = preload("res://scenes/props/tile.tscn")

# Variables
var tiles: Array = []
# Determines if we add by half x_offset first
var odd_row = false

func _ready() -> void:
	# Generate the grid
	if Tile:
		for x in range(0, Globals.MAP_SIZE):
			var col: Array = []
			for y in range(0, Globals.MAP_SIZE):
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

# Find the tile at x, y on the grid return null otherwise
func find_tile(var x: int, var y: int) -> Object:
	if x > -1 and x < tiles.size():
		if y > -1 and y < tiles[x].size():
			return tiles[x][y]
	return null
