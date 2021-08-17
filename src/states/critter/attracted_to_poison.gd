extends Node

var state_machine: StateMachine

func enter():
	exit("next_state")

func exit(next_state):
	if Globals.DEBUG:
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
