extends Node

var state_machine: StateMachine
var critter: Critter

func enter():
	assert(GameSignals.connect("exit_nature_turn", self, "_post_dead_action") == 0)
	GameSignals.emit_signal("critter_died")
	critter.life_state = critter.LifeState.DEAD
	critter.mesh_instance.mesh.material.albedo_color = Color.red

func exit(next_state):
	GameSignals.disconnect("exit_nature_turn", self, "_post_dead_action")
	if Globals.DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func _post_dead_action() -> void:
	pass
