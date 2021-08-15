extends Spatial

var grid: Object = null
var owned_tiles: Array = []

func _ready() -> void:
	grid = get_parent().get_node("grid")
	var tile: Object = grid.find_tile(0, 0)
	if tile:
		for _i in range(0, 20):
			tile.spawn_food()
		owned_tiles.append(tile)

func add_tile(var tile: Object) -> void:
	owned_tiles.append(tile)
	
func remove_tile(var id: int) -> void:
	if id > -1 and id < owned_tiles.size():
		owned_tiles.remove(id)
