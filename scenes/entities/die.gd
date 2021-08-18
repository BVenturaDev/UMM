extends Node

var state_machine: StateMachine
var critter: Critter

func enter():
	GameSignals.emit_signal("critter_died")
	critter.life_state = critter.LifeState.DEAD
	critter.mesh_instance.mesh.material.albedo_color = Color.red

func exit(next_state):
	if Globals.DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)
