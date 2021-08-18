extends Node

export(bool) var DEBUG = false
var state_machine
var critter: Critter


func enter():
	if DEBUG:
		print("Entering state", name)
	# Do action eat?
	critter.mesh_instance.mesh.material.albedo_color = Color.darkgoldenrod
	critter.is_eating = true
	exit("end_turn")

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

