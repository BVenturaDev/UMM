extends Spatial
class_name Critter

export(NodePath) onready var tween = get_node(tween) as Tween
export(NodePath) onready var state_machine = get_node(state_machine) as Node

var current_tile: Tile setget set_current_tile

func set_current_tile(new_tile: Tile) -> void:
	if not is_instance_valid(current_tile):
		current_tile = new_tile
		return
	# Clean of the current tile
	current_tile.critter = null
	# Assign to the new tile
	new_tile.critter = self
	current_tile = new_tile


func _ready() -> void:
	for state in state_machine.get_children():
		if "critter" in state:
			state.critter = self


func wander() -> void:
	var posible_tiles: Array = get_tiles_whitout_entities()
	posible_tiles.shuffle()
	if posible_tiles.size() != 0:
		var random_tile: Spatial = posible_tiles[0]
		self.current_tile = random_tile
		move_to_tile(random_tile)

func get_tiles_whitout_entities() -> Array:
	var tiles_whitout_entities = []
	for neighboor in current_tile.close_neighbors:
		if is_tile_movible(neighboor):
			tiles_whitout_entities.append(neighboor)
	return tiles_whitout_entities

func is_tile_movible(tile: Tile) -> bool:
	return (
			not is_instance_valid(tile.critter) 
			and not has_mushroom(tile)
	)

func has_mushroom(tile: Tile) -> bool:
	return is_instance_valid(tile.cur_shroom)

func move_to_tile(tile) -> void:
	tween.interpolate_property(
			self, 'translation:x', 
			global_transform.origin.x, tile.global_transform.origin.x, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(
			self, 'translation:z', 
			global_transform.origin.z, tile.global_transform.origin.z, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()





