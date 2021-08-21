extends Spatial
class_name Critter


export(bool) var DEBUG = false
export(PackedScene) var resource_critter_scene : PackedScene
export(NodePath) onready var tween = get_node(tween) as Tween
export(NodePath) onready var state_machine = get_node(state_machine) as Node
export(NodePath) onready var critter_model = get_node(critter_model) as Spatial

export(int) var time_after_death := 10
export(int) var max_age := 6
export var age := 0

var is_alive := true
var is_poisoned := false

var target_tile_with_shroom: Tile = null
var eating_mushroom: Object = null setget set_eating_mushroom
var current_tile: Tile setget set_current_tile

func set_current_tile(new_tile: Tile) -> void:
	if is_alive:
		if new_tile == null:
			current_tile = new_tile
			return
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

func active_highlight(tiles : Array) -> void:
	for tile in tiles:
		tile.hex.enable_highlighted()
		
func desactive_highlight(tiles : Array) -> void:
	for tile in tiles:
		tile.hex.disable_highlighted()
		
func set_eating_mushroom(new_shroom: Object) -> void:
	if new_shroom == null:
		if is_instance_valid(eating_mushroom):
			eating_mushroom.kill()
			critter_model.anim.play("idle")
		eating_mushroom = null
	else:
		eating_mushroom = new_shroom
		
		if eating_mushroom.is_in_group("poison"):
			is_poisoned = true
		
		critter_model.set_target(eating_mushroom.global_transform.origin)
		critter_model.anim.play("eating")

func _ready() -> void:
	for state in state_machine.get_children():
		if "critter" in state:
			state.critter = self
	critter_model.anim.play("idle")


func do_turn() -> void:
	randomize()
	if is_alive:
		state_machine.start_machine()
	else:
		time_after_death -= 1
		if time_after_death == 0:
			current_tile = null
			queue_free()

func wander() -> void:
	var posible_tiles: Array = get_tiles_whitout_entities()
	posible_tiles.shuffle()
	if posible_tiles.size() != 0:
		var random_tile: Spatial = posible_tiles[0]
		self.current_tile = random_tile

func get_tiles_whitout_entities() -> Array:
	var tiles_whitout_entities = []
	for neighboor in current_tile.close_neighbors:
		if DEBUG:
			print("Shroom: ", neighboor.cur_shroom, "\nResource: ", neighboor.cur_resource, "\n Critter: ", neighboor.critter)
		if is_tile_movible(neighboor):
			tiles_whitout_entities.append(neighboor)
	return tiles_whitout_entities

func is_tile_movible(tile: Tile) -> bool:
	return (
			tile.critter == null
			and tile.cur_shroom == null
			and tile.cur_resource == null
	)
func is_tile_walkable(tile: Tile) -> bool:
	return (
			not is_instance_valid(tile.critter) 
			and not is_instance_valid(tile.cur_resource)
	)
func does_tile_has_mushroom(tile: Tile) -> bool:
	return is_instance_valid(tile.cur_shroom)

func move_to_tile(tile) -> void:
	if is_alive:
		var anim: AnimationPlayer = critter_model.anim
		critter_model.set_target(tile.global_transform.origin)
		anim.play("walk")
		critter_model.snd_move.play()

		tween.interpolate_property(
				self, 'translation:x', 
				global_transform.origin.x, tile.global_transform.origin.x, 
				1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(
				self, 'translation:z', 
				global_transform.origin.z, tile.global_transform.origin.z, 
				1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		global_transform.origin.y = 0.4
		tween.start()
		
		yield(tween,"tween_all_completed")
		if is_alive:
			anim.stop()
			critter_model.snd_move.stop()
			$Timer.wait_time = randf()
			$Timer.start()
			yield($Timer,"timeout")
			anim.play("idle")
		else:
			anim.play("death")

func get_close_neighbors() -> Array:
	return current_tile.close_neighbors

func get_tiles_with_shroom() -> Array:
	var tiles_with_shroom = []
	for neighbor in get_close_neighbors():
		if is_instance_valid(neighbor.cur_shroom):
			tiles_with_shroom.append(neighbor.cur_shroom)
	return tiles_with_shroom

func get_distance_to_tile(tile: Tile) -> float:
	return global_transform.origin.distance_squared_to(tile.global_transform.origin)


func kill():
	GameSignals.emit_signal("critter_died")
	self.current_tile = null
	self.eating_mushroom = null
	queue_free()
