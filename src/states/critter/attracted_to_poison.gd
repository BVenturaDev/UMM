extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter


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
	if critter.is_eating:
		move_to_kill()
	else: 
		exit("wander")
	exit("end_turn")

func move_to_kill() -> void:
	if critter.eating_mushroom == null:
		return
	critter.current_tile = critter.eating_mushroom.owner_tile
	critter.eating_mushroom.kill()
	critter.eating_mushroom = null
	critter.is_eating = false

