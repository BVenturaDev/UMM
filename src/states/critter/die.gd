extends Node

export(bool) var DEBUG := false
var state_machine: StateMachine
var critter: Critter

func enter():
	# warning-ignore:return_value_discarded
	GameSignals.emit_signal("critter_died")
	var resource_critter = critter.resource_critter_scene.instance()
	
	get_tree().current_scene.add_child(resource_critter)
	resource_critter.global_transform.origin = critter.current_tile.global_transform.origin
	
	if not critter.current_tile.cur_resource:
		critter.current_tile.cur_resource = resource_critter
	critter.is_alive = false
	
	critter.kill()
	# Convert to resource

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func _post_dead_action() -> void:
	pass
