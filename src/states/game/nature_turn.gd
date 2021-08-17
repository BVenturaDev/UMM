extends Node

var state_machine
var critter_scene = preload("res://scenes/entities/critter.tscn")
export(int, 1, 10) var spawn_critter_turns := 3
var turns_from_last_critter_spawn := 0
 
func enter():
	assert(GameSignals.connect("next_turn", self, "_next_turn") == 0)
	# Events on enter
	GameSignals.emit_signal("enter_nature_turn")
	_do_group_nature_turn()
	_spawn_critter()
	_next_turn()

func exit(next_state: String):
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
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


func _spawn_critter() -> void:
	if turns_from_last_critter_spawn == spawn_critter_turns:
		var critter : Critter = critter_scene.instance()
		var random_tile: Spatial = TilesReferences.get_random_tile_without_entitie()
		if not is_instance_valid(random_tile):
			return
		critter.transform.origin = random_tile.transform.origin
		critter.set_coord(random_tile.x,random_tile.y)
		get_tree().current_scene.add_child(critter)
		turns_from_last_critter_spawn = 0
	turns_from_last_critter_spawn += 1
