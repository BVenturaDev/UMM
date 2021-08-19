extends Spatial

const FOOD_AMOUNT: int = 10
const LIFETIME: int = 10

onready var model = $critter_model

var owner_tile = null
var turns_left = LIFETIME

func _ready() -> void:
	model.start_dead()

func do_turn() -> void:
	if owner_tile:
		turns_left -= 1
		if turns_left < 1:
			if owner_tile.cur_shroom:
				owner_tile.cur_shroom.kill()
			owner_tile.cur_resource = null
			queue_free()
