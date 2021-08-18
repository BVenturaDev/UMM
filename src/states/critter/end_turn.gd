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
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
