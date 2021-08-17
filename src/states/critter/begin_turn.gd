extends Node

export(bool) var DEBUG = false

var state_machine
var critter: Critter

func enter() -> void:
	yield(GameSignals,"enter_nature_turn")
	critter.actualize_neighbors()
	exit(decide_what_do())


func exit(next_state) -> void:
	if Globals.DEBUG_SM or DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)


func decide_what_do() -> String:
	if is_some_nearby_tile_allows_movement():
		return "wander"
	return "end_turn"


func is_some_nearby_tile_allows_movement() -> bool:
	for neighbor in critter.neighbors:
		if not is_instance_valid((neighbor as Tile).critter):
			return true
	return false
