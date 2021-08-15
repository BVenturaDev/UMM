extends Spatial
tool

const X_OFFSET: float = 1.7
const Z_OFFSET: float = 1.5

export(bool) var show_tiles_in_editor = false setget set_show_in_editor
# If map_size value is to large the editor can break, limitatios is own computer
export(int, 4, 24, 2) var map_size = 4 setget set_map_size_debug

var Tile: Object = preload("res://scenes/props/tile.tscn")

var odd_row = false

func _clean_children():
	for child in get_children():
		(child as Node).queue_free()


# Functions below only for show editor purposes

func set_show_in_editor(new_value):
	show_tiles_in_editor = new_value
	self.map_size = map_size

func set_map_size_debug(_new_value):
	map_size = _new_value
	_clean_children()
	if not show_tiles_in_editor:
		return
	_generate_grid_debug(_new_value)

func _add_tile_debug(var x: int, var y: int) -> Object:
	var new_tile: Object = Tile.instance()
	add_child(new_tile)
	new_tile.transform.origin.x = float(x) * X_OFFSET
	new_tile.transform.origin.z = float(y) * Z_OFFSET
	# Offset for every other row
	if odd_row:
		new_tile.transform.origin.x += X_OFFSET / 2.0
	return new_tile

func _generate_grid_debug(size: int) -> void:
	if Tile:
		for x in range(0, size):
			var col: Array = []
			for y in range(0, size):
				var new_tile: Object = _add_tile_debug(x, y)
				col.append(new_tile)
				# Flip row for the offset
				_flip_odd_row()

func _flip_odd_row() -> void:
	if odd_row:
		odd_row = false
	else:
		odd_row = true
