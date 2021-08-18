extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter
var target_shroom: Tile


func enter():
	if DEBUG:
		print("Entering state: ", name)
	move_to_target()

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func move_to_target() -> void:
	# Not Implemented yed
	exit("wander")

