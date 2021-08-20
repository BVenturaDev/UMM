extends Node

var state_machine


func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)
	# Events on enter
	GameSignals.emit_signal("enter_player_turn")
	
	_do_player_group_turn()

func exit(next_state: String):
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	GameSignals.disconnect("next_turn", self, "_next_turn")
	# Events on exit
	GameSignals.emit_signal("exit_player_turn")
	state_machine.change_to(next_state)

#Can add the built functions if is defined in StateMachine class
func _process(_delta: float) -> void:
	pass

func _do_player_group_turn():
	var all_player_in_scene = get_tree().get_nodes_in_group("player")
	for player in all_player_in_scene:
		if player.has_method("do_turn"):
			player.do_turn()

func _next_turn() -> void:
	exit("ai_turn")
