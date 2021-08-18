extends Spatial
class_name Critter

enum LifeState {
	ALIVE,
	DEAD
	}

export(NodePath) onready var tween = get_node(tween) as Tween
export(NodePath) onready var state_machine = get_node(state_machine) as Node
export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance
export(LifeState) var life_state = LifeState.ALIVE
export(int) var max_age := 6
export var age := 0
var is_eating := false
var current_tile: Tile setget set_current_tile

func set_current_tile(new_tile: Tile) -> void:
	if current_tile == null:
		new_tile.critter = self
		current_tile = new_tile
		return
	# Clean of the current tile
	new_tile.critter = self
	current_tile.critter = null
	current_tile = new_tile
	# Assign to the new tile
	move_to_tile(current_tile)


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

func get_tiles_whitout_entities() -> Array:
	var tiles_whitout_entities = []
	for neighboor in current_tile.close_neighbors:
		if is_tile_movible(neighboor):
			tiles_whitout_entities.append(neighboor)
	return tiles_whitout_entities

func is_tile_movible(tile: Tile) -> bool:
	return (
			not is_instance_valid(tile.critter) 
			and not does_tile_has_mushroom(tile)
	)

func does_tile_has_mushroom(tile: Tile) -> bool:
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

func get_close_neighbors() -> Array:
	return current_tile.close_neighbors

