extends Spatial

const FOOD_AMOUNT: int = 5
const LIFETIME: int = 20

var owner_tile = null
var turns_left = LIFETIME

func do_turn() -> void:
	if owner_tile:
		turns_left -= 1
		if turns_left < 1:
			if owner_tile.cur_shroom:
				owner_tile.cur_shroom.kill()
			owner_tile.cur_resource = null
			queue_free()
