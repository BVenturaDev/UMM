extends Node

var state_machine: StateMachine


func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)


func exit():
	GameSignals.disconnect("next_turn", self, "_next_turn")


func _next_turn() -> void:
	state_machine.change_to("nature_turn")
