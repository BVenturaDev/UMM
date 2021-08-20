extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter

func enter() -> void:
	exit(decide_what_do())


func exit(next_state) -> void:
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
		print("Next state is: ", next_state)
	state_machine.change_to(next_state)


func decide_what_do() -> String:
	if critter.is_poisoned:
		return "die"
	if (is_mushroom_close() 
			or is_instance_valid(critter.eating_mushroom)):
		return "eat"
	if is_there_shroom_in_area():
		return "calculate_path"
	if is_some_nearby_tile_allows_movement():
		return "wander"
	return "end_turn"

func is_mushroom_close():
	for neighbor in critter.get_close_neighbors():
		if critter.does_tile_has_mushroom(neighbor):
			return true
	return false


func is_there_shroom_in_area() -> bool:
	for neighbor in critter.current_tile.region_neighbors:
		if critter.does_tile_has_mushroom(neighbor):
			return true
	return false


func is_some_nearby_tile_allows_movement() -> bool:
	for neighbor in critter.get_close_neighbors():
		if not is_instance_valid(neighbor.critter):
			return true
	return false
