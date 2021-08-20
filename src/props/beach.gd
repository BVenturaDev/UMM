extends Spatial

# Constants
const X_OFFSET: float = 1.7
const Z_OFFSET: float = 1.5
const Y_OFFSET: float = 0.25
const OFFSET: int = 2

# Scenes
var Tile: Object = preload("res://scenes/props/sand_tile.tscn")

# Determines if we add by half x_offset first
var odd_row = false


func _ready() -> void:
	# Generate the grid
	_generate_grid(Globals.MAP_SIZE)

func _generate_grid(size: int) -> void:
	if Tile:
		for x in range(0 - OFFSET, size + OFFSET + 1):
			for y in range(0 - OFFSET, size + OFFSET + 2):
				var off_x: int = 0
				if x < 0:
					off_x = 0 - x
				elif x > size:
					off_x = x - size
				var off_y: int = 0
				if y < 0:
					off_y = 0 - y
				elif y > size:
					off_y = y - size
				var z: int = int((off_x + off_y) / 2.0)
				if z > 1:
					z = 1
				_add_tile(x, y, z)
				# Flip row for the offset
				_flip_odd_row()

# Turn the bool between odd and even rows for the offseta
func _flip_odd_row() -> void:
	if odd_row:
		odd_row = false
	else:
		odd_row = true

# Add a tile at x, y
func _add_tile(var x: int, var y: int, var z: int) -> void:
	var new_tile: Object = Tile.instance()
	add_child(new_tile)
	new_tile.global_transform.origin.y = -float(z) * Y_OFFSET - Y_OFFSET
	new_tile.global_transform.origin.x = float(x) * X_OFFSET
	new_tile.global_transform.origin.z = float(y) * Z_OFFSET
	# Offset for every other row
	if odd_row:
		new_tile.global_transform.origin.x += X_OFFSET / 2.0
