extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter


func enter() -> void:
	critter.wander()
	exit("end_turn")

func exit(next_state) -> void:
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

