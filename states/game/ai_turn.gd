extends Node

var state_machine: StateMachine


func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)
	# Actions
	if Globals.DEBUG:
		print("IA is thinking")
		yield(get_tree().create_timer(0.5), "timeout")
	_next_turn()


func exit(next_state: String):
	GameSignals.disconnect("next_turn", self, "_next_turn")
	state_machine.change_to(next_state)


func _next_turn() -> void:
	exit("nature_turn")
