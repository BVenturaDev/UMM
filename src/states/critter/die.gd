extends Node

export(bool) var DEBUG := false
var state_machine: StateMachine
var critter: Critter

func enter():
	# warning-ignore:return_value_discarded
	GameSignals.emit_signal("critter_died")
	var resource_critter = critter.resource_critter_scene.instance()

	get_tree().current_scene.add_child(resource_critter)

	if not is_instance_valid(critter.current_tile.cur_resource):
		resource_critter.global_transform.origin = critter.current_tile.resource_pos.global_transform.origin
		critter.current_tile.cur_resource = resource_critter
		resource_critter.owner_tile = critter.current_tile
	critter.is_alive = false

	critter.kill()
	# Convert to resource

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func _post_dead_action() -> void:
	pass
