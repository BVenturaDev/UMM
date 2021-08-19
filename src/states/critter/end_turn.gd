extends Node

export(bool) var DEBUG = false
var state_machine
var critter: Critter

func enter():
	critter.age += 1
	if critter.age == critter.max_age:
		exit("die")
	else:
		state_machine.stop_machine()

func exit(next_state):
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)
