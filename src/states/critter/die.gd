extends Node

export(bool) var DEBUG := false
var state_machine: StateMachine
var critter: Critter

func enter():
	assert(GameSignals.connect("exit_nature_turn", self, "_post_dead_action") == 0)
	GameSignals.emit_signal("critter_died")
	critter.is_alive = false
	critter.critter_model.start_dead()
	# Convert to resource

func exit(next_state):
	GameSignals.disconnect("exit_nature_turn", self, "_post_dead_action")
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func _post_dead_action() -> void:
	pass
