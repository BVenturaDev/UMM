extends Node

var empty_tiles := {}

func _ready() -> void:
	empty_tiles.clear()
	# This wait for the first frame to succed
	yield(get_tree(),"idle_frame")
#	for tile in get_tree().get_nodes_in_group("tile"):
#		if not is_instance_valid(tile.critter):
#			empty_tiles[tile.name] = tile

func get_tiles_without_entitie() -> Array:
	return empty_tiles.keys()

func tile_without_entitie(tile: Object) -> void:
	empty_tiles[tile.name] = tile

func tile_with_entitie(tile: Object) -> void:
	# warning-ignore:return_value_discarded
	empty_tiles.erase(tile.name)

func get_random_tile_without_entitie() -> Object:
	if empty_tiles.size() > 0:
		var all_keys = empty_tiles.keys()
		all_keys.shuffle()
		var random_tile = empty_tiles.get(all_keys[0])
		return random_tile
	return null
