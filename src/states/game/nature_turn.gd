extends Node

var state_machine
var critter_scene = preload("res://scenes/entities/critter.tscn")
var tree_scene = preload("res://scenes/entities/resource_tree.tscn")
export(int, 1, 100) var spawn_critter_turns := 3
export(int, 1, 100) var spawn_tree_turns: int = 5
export(int, 1, 100) var max_critter_alive := 5
export(int, 1, 100) var max_trees_alive: int = 10
var critters_alive := 0
var trees_alive: int = 0
var turns_from_last_critter_spawn := 0
var turns_from_last_tree_spawn: int = 0

func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSignals.connect("critter_died", self, "_died_a_critter")
	# warning-ignore:return_value_discarded
	GameSignals.connect("spawn_critter", self, "_spawn_critter")
	# warning-ignore:return_value_discarded
	GameSignals.connect("tree_died", self, "_tree_died")


func enter():
	var _a = GameSignals.connect("next_turn", self, "_next_turn")
	# Events on enter
	GameSignals.emit_signal("enter_nature_turn")
	_do_group_nature_turn()
	# Check squirrel spawns
	if turns_from_last_critter_spawn >= spawn_critter_turns:
		_spawn_critter()
	turns_from_last_critter_spawn += 1

	# Check tree spawns
	if turns_from_last_tree_spawn >= spawn_tree_turns:
		_spawn_tree()
	turns_from_last_tree_spawn += 1
	_next_turn()

func exit(next_state: String):
	if Globals.DEBUG_SM:
		print("Exiting state: ", name)
	GameSignals.disconnect("next_turn", self, "_next_turn")
	# Events on exit
	GameSignals.emit_signal("exit_nature_turn")
	state_machine.change_to(next_state)


func _next_turn() -> void:
	exit("player_turn")

func _do_group_nature_turn():
	var all_nature_in_scene = get_tree().get_nodes_in_group("nature")
	for nature in all_nature_in_scene:
		if nature.has_method("do_turn"):
			nature.do_turn()


func _spawn_critter() -> void:
	if critters_alive >= max_critter_alive:
		return
	var critter = critter_scene.instance()
	var random_tile: Spatial = TilesReferences.get_random_tile_without_entitie()
	if not is_instance_valid(random_tile):
		return
	critter.global_transform.origin = random_tile.resource_pos.global_transform.origin
	critter.current_tile = random_tile
	get_tree().current_scene.add_child(critter)
	turns_from_last_critter_spawn = 0
	critters_alive += 1

func _spawn_tree() -> void:
	if trees_alive >= max_trees_alive:
		return
	var random_tile: Spatial = TilesReferences.get_random_tile_without_entitie()
	if not is_instance_valid(random_tile):
		return
	var tree : Object = tree_scene.instance()
	get_tree().current_scene.add_child(tree)
	tree.global_transform.origin = random_tile.resource_pos.global_transform.origin
	random_tile.cur_resource = tree
	tree.owner_tile = random_tile
	turns_from_last_tree_spawn = 0
	trees_alive += 1

func _tree_died() -> void:
# warning-ignore:narrowing_conversion
	trees_alive -= 1
	trees_alive = clamp(trees_alive,0,  max_trees_alive)


func _died_a_critter() -> void:
# warning-ignore:narrowing_conversion
	critters_alive -= 1
	critters_alive = clamp(critters_alive,0,  max_critter_alive)
	
