extends Node

var state_machine: StateMachine


func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)
	# Events on enter
	GameSignals.emit_signal("enter_nature_turn")
	_do_group_nature_turn()
	_next_turn()

func exit(next_state: String):
	GameSignals.disconnect("next_turn", self, "_next_turn")
	# Events on exit
	GameSignals.emit_signal("exit_nature_turn")
	state_machine.change_to(next_state)

#Can add the built functions if is defined in StateMachine class
func _process(_delta: float) -> void:
	pass

func _next_turn() -> void:
	exit("player_turn")

func _do_group_nature_turn():
	var all_nature_in_scene = get_tree().get_nodes_in_group("nature")
	for nature in all_nature_in_scene:
		if nature.has_method("do_turn"):
			nature.do_turn()
