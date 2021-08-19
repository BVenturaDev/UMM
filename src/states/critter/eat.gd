extends Node

export(bool) var DEBUG = false
var state_machine
var critter: Critter


func enter():
	if DEBUG:
		print("Entering state", name)
	# Do action eat?
	eat_shroom()
	exit("end_turn")

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func eat_shroom() -> void:
	var nearby_shrooms = critter.get_tiles_with_shroom()
	
	for shroom in nearby_shrooms:
		if shroom.is_in_group("poison"):
			critter.eating_mushroom = shroom
			break
	# If there are not poisoned close eat any
	if not critter.eating_mushroom:
		nearby_shrooms.shuffle()
		critter.eating_mushroom = nearby_shrooms.pop_front()
	
	if is_instance_valid(critter.eating_mushroom):
		critter.critter_model.set_target(critter.eating_mushroom.global_transform.origin)
		critter.critter_model.anim.play("eating")
