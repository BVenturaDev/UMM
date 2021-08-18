extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter


func enter():
	critter.wander()
	exit("end_turn")

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

