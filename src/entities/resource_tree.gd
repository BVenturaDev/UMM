extends Spatial

const FOOD_AMOUNT: int = 1
const LIFETIME: int = 30

var resource_log = preload("res://scenes/entities/resource_log.tscn")

var owner_tile = null
var turns_left = LIFETIME

func do_turn() -> void:
	if owner_tile:
		turns_left -= 1
		if turns_left < 1:
			if owner_tile.cur_shroom:
				owner_tile.cur_shroom.kill()
			var new_log: Object = resource_log.instance()
			get_tree().current_scene.add_child(new_log)
			new_log.global_transform.origin = owner_tile.resource_pos.global_transform.origin
			owner_tile.cur_resource = new_log
			new_log.owner_tile = owner_tile
			GameSignals.emit_signal("tree_died")
			queue_free()
