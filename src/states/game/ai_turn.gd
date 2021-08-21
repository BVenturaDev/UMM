extends Node

var state_machine

func enter():
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	var _a = GameSignals.connect("next_turn", self, "_next_turn")
	#_a = GameSignals.connect("next_turn", self, "_next_turn")
	_do_ai_group_turn()
	_next_turn()


func exit(next_state: String):
	GameSignals.disconnect("next_turn", self, "_next_turn")
	state_machine.change_to(next_state)

func _do_ai_group_turn():
	var all_ai_in_scene = get_tree().get_nodes_in_group("ai")
	for ai in all_ai_in_scene:
		if ai.has_method("do_turn"):
			ai.do_turn()

func _next_turn() -> void:
	exit("nature_turn")
