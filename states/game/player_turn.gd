extends Node

var state_machine: StateMachine


func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)
	# Events on enter
	GameSignals.emit_signal("enter_player_turn")

func exit(next_state: String):
	GameSignals.disconnect("next_turn", self, "_next_turn")
	# Events on exit
	GameSignals.emit_signal("exit_player_turn")
	state_machine.change_to(next_state)

#Can add the built functions if is defined in StateMachine class
func _process(_delta: float) -> void:
	pass

func _next_turn() -> void:
	exit("ai_turn")
