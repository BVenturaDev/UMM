extends Spatial
class_name Critter

export(NodePath) onready var tween = get_node(tween) as Tween
export(NodePath) onready var state_machine = get_node(state_machine) as Node
export var coord_x: int = 0
export var coord_y: int = 0
var neighbors: Array

var current_tile: Tile setget _set_current_tile

func _set_current_tile(new_value: Tile) -> void:
	if not is_instance_valid(current_tile):
		current_tile = new_value
		current_tile.entitie = self
		return
	# Clean of the current tile
	current_tile.entitie = null
	current_tile = new_value
	# Assign to the new tile
	current_tile.entitie = self


func _ready() -> void:
	actualize_current_tile()
	for state in state_machine.get_children():
		if "critter" in state:
			state.critter = self


func do_turn():
	state_machine.start_machine()


func wander() -> void:
	var posible_tiles = get_tiles_whitout_entities()
	posible_tiles.shuffle()
	var random_tile: Spatial = posible_tiles[0]
	set_coord(random_tile.x, random_tile.y)
	move_to_tile(random_tile)

func get_tiles_whitout_entities() -> Array:
	var tiles_whitout_entities = []
	for neighboor in neighbors:
		if not is_instance_valid(neighboor.entitie):
			tiles_whitout_entities.append(neighboor)
	return tiles_whitout_entities

func set_coord(x: int,y: int) -> void:
	coord_x = x
	coord_y = y
	actualize_current_tile()


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


func actualize_current_tile():
	self.current_tile = Globals.grid.find_tile(coord_x, coord_y)


func actualize_neighbors():
	neighbors = Globals.grid.find_neighbors(coord_x, coord_y)


