extends Node

var state_machine


func enter():
	var _a = GameSignals.connect("next_turn", self, "_next_turn")
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
	do_scout_shroom_auto_attacks()
	exit("ai_turn")

func do_scout_shroom_auto_attacks():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		var fungus: Fungus = player.fungus
		for tile in fungus.owned_tiles:
			tile = tile as Tile
			if is_scout_shroom_and_turn_is_not_used(tile):
				attack_neighbor_with_scout(tile)

func is_scout_shroom_and_turn_is_not_used(tile: Tile) -> bool:
	if not is_instance_valid(tile.cur_shroom):
		return false
	return (
			tile.cur_shroom.is_in_group("scout") 
			and not tile.turn_used
		)

func attack_neighbor_with_scout(tile: Tile):
	for neighbor in tile.close_neighbors:
		if not is_instance_valid(neighbor.cur_shroom):
			continue
		if neighbor.owner_fungus.my_owner == tile:
			continue
		if neighbor.cur_shroom.is_in_group("scout"):
			# warning-ignore:narrowing_conversion
			tile.attack(clamp(tile.tile_food -1, 0, 5))
			Globals.moving_tile = tile
			tile.do_attack(neighbor)
