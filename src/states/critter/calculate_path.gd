extends Node

export(bool) var DEBUG := false
var state_machine: StateMachine
var critter: Critter

var path_start_tile: Tile  setget set_path_start_tile
var path_end_tile: Tile  setget set_path_end_tile
onready var astar_node = AStar2D.new()
var _point_path :PoolIntArray = []
var tiles_in_region_comun := []


func enter():
	if DEBUG:
		print("Exiting state: ", name)
		
	astar_node = AStar2D.new()
	search_closes_mushroom()
	var walkable_tiles = astar_add_walkable_tile()
	astar_connect_walkable_tiles(walkable_tiles)
	get_astar_path(critter.current_tile, critter.target_tile_with_shroom)
	
	if DEBUG:
		print_debug("Path is: ",_point_path)
		print_debug("Current tile is:", calculate_point_index(critter.current_tile))
	if _point_path.size() == 0:
		exit("wander")
	elif _point_path.size() > 2:
		critter.current_tile = instance_from_id(_point_path[1])
		exit("end_turn")
	

func exit(next_state):
	if DEBUG:
		print("Exiting state: ", name)
	state_machine.change_to(next_state)

func is_path_blocked(tile: Tile) -> bool:
	return tile.critter or tile.cur_resource

func search_closes_mushroom():
	var tiles_with_shroom := []
	for neigboor in critter.current_tile.region_neighbors:
		if neigboor.cur_shroom:
			tiles_with_shroom.append(neigboor)
#	print_array_items(tiles_with_shroom)
	var tiles_with_poisoned_shrooms := []
	for tile in tiles_with_shroom:
		if tile.cur_shroom.is_in_group("poison"):
			tiles_with_poisoned_shrooms.append(tile)
	var closest_tile_with_poisoned_shroom : Tile = get_closes_tile(tiles_with_poisoned_shrooms)
	
	if closest_tile_with_poisoned_shroom != null:
		critter.target_tile_with_shroom = closest_tile_with_poisoned_shroom
	else:
		critter.target_tile_with_shroom = get_closes_tile(tiles_with_shroom)
	if DEBUG:
		print(critter.target_tile_with_shroom.cur_shroom.name)

func get_closes_tile(tiles: Array) -> Tile:
	var closest_tile : Tile = null
	if tiles.size() > 0:
		tiles.shuffle()
		closest_tile = tiles[0]
		for tile in tiles:
			if (critter.get_distance_to_tile(tile)  
					< critter.get_distance_to_tile(closest_tile)):
				closest_tile = tile
	return closest_tile

func astar_add_walkable_tile() -> Array:
	var tiles_walkable_array := []
	var critter_neighbors := critter.current_tile.region_neighbors
	var shroom_neighbors = critter.target_tile_with_shroom.region_neighbors
	tiles_in_region_comun = intersect_array(critter_neighbors, shroom_neighbors)

	for tile in tiles_in_region_comun:
		if is_path_blocked(tile):
			continue
		tiles_walkable_array.append(tile)
		var point_index = calculate_point_index(tile)
		astar_node.add_point(point_index, Vector2(tile.x, tile.y))
	# Its adding points and adding tiles walkable
	# Those are the critter and the shroom owner tile
	tiles_walkable_array.append(add_tile_to_astar(critter.current_tile))
	tiles_walkable_array.append(add_tile_to_astar(critter.target_tile_with_shroom))
	if DEBUG:
		print_debug(tiles_walkable_array)
	return tiles_walkable_array

func add_tile_to_astar(tile: Tile) -> Tile:
	var index := calculate_point_index(tile)
	astar_node.add_point(index, Vector2(tile.x, tile.y))
	return tile
func calculate_point_index(tile: Tile) -> int:
	return tile.get_instance_id()

func astar_connect_walkable_tiles(tiles_array: Array) -> void:
	for tile in tiles_array:
		var point_index = calculate_point_index(tile)
		var points_relative := PoolVector2Array()
		var point_relative_index := []

		for neigbor in tile.close_neighbors:
			points_relative.append(Vector2(neigbor.x, neigbor.y))
			point_relative_index.append(calculate_point_index(neigbor))
		
		var i = 0
		for point_relative in points_relative:
			if astar_node.has_point(point_relative_index[i]):
				astar_node.connect_points(point_index, point_relative_index[i], false)
				i += 1
		
		var get_relative_conections  = astar_node.get_point_connections(point_index)
		if DEBUG:
			print("Index:", point_index, "\nConnected to: ", get_relative_conections)
		
	# Poinst are connected

func get_astar_path(tile_start: Tile, tile_end: Tile):
	self.path_start_tile = tile_start
	self.path_end_tile = tile_end
	_recalculate_path()


func _recalculate_path() -> void:
	var start_point_index = calculate_point_index(path_start_tile)
	var end_point_index = calculate_point_index(path_end_tile)
	_point_path = astar_node.get_id_path(start_point_index, end_point_index)
	pass


func set_path_start_tile(value) -> void:
	# if is_outside_map_boundries(value):
	# 	return 
	path_start_tile = value
#	if path_end_tile and path_end_tile != path_start_tile:
#		_recalculate_path()
#	pass

func set_path_end_tile(value) -> void:
	# if is_outside_map_boundries(value):
	# 	return 
	path_end_tile = value
#	if path_start_tile != value:
#		_recalculate_path()


func intersect_array(arr1: Array, arr2: Array) -> Array:
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true
	var in_both_arrays = []
	for v in arr1:
		if arr2_dict.get(v, false):
			in_both_arrays.append(v)

	return in_both_arrays

func print_array_items(array: Array) -> void:
	for item in array:
		print(item.cur_shroom.name)
