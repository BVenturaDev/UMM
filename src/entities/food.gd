extends Spatial

var cur_tile: Object = null
var id = -1

func move_food() -> void:
	if cur_tile:
		cur_tile.remove_food(id)
