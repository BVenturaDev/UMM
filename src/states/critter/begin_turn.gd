extends Node

var state_machine: StateMachine
var critter: Critter

func enter() -> void:
	critter.actualize_neighbors()
	exit(decide_what_do())


func exit(next_state) -> void:
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)


func decide_what_do() -> String:
	if is_some_nearby_tile_allows_movement():
		return "wander"
	return "end_turn"


func is_some_nearby_tile_allows_movement() -> bool:
	for neighbor in critter.neighbors:
		if not is_instance_valid((neighbor as Tile).entitie):
			return true
	return false
