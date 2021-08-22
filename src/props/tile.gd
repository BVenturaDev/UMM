extends Spatial
class_name Tile
const stack_offset: float = 0.2

var food = preload("res://scenes/entities/food.tscn")
var gather_shroom = preload("res://scenes/entities/gather_shroom.tscn")
var poison_shroom = preload("res://scenes/entities/poison_shroom.tscn")
var scout_shroom = preload("res://scenes/entities/scout_shroom.tscn")
var resource_log = preload("res://scenes/entities/resource_log.tscn")
var friendly_ui = preload("res://scenes/ui/friendly_ui.tscn")

onready var hex = $hex_tile
onready var stack = $food_stack
onready var resource_pos = $resource_point
onready var snd_click = $click_sound
onready var snd_food = $food_sound
onready var snd_combat = $combat_sound

# Variables
# Grid Location
var x: int = -1
var y: int = -1
var odd_row: bool = false
var owner_fungus: Object = null
var turn_used: bool = false
var close_neighbors : Array
var region_neighbors : Array

# References to another objects
var critter: Object = null setget set_critter
var cur_shroom: Object = null setget set_cur_shroom
var cur_resource: Object = null setget set_cur_resource
var move_amount: int = 0

# Array of all food stored in this tile
var tile_food: Array = []
var food_in_region := 0 setget , get_food_in_region
var food_amount := 0 setget , get_food_amount
func get_food_amount() -> int:
	return tile_food.size()
# Array of region available to
var region: Array = []
# Array of neighboring enemy tiles
var enemies: Array = []
var enemy: bool = false
var revealed: bool = false
var has_friendly_ui: bool = false
var attacking: bool = false

func _ready() -> void:
	# Initialize the reference dictionary for tiles with not critters or cur_shroom
	initialize_references()

func _process(_delta) -> void:
	if owner_fungus and not Globals.moving_tile:
		if owner_fungus.my_owner.name == "player":
			hex.enable_undergrowth()
			generate_friendly_ui()
		elif enemy and revealed or Globals.DEBUG:
			hex.enable_enemy_undergrowth()
			generate_friendly_ui()
		else:
			hex.disable_undergrowth()
			hex.disable_enemy_undergrowth()
			hex.disable_turn_used()
			remove_friendly_ui()
	else:
		hex.disable_undergrowth()
		hex.disable_enemy_undergrowth()
		#remove_friendly_ui()

func initialize_references():
	$InitTimer.start()
	yield($InitTimer,"timeout")
	$InitTimer.queue_free()
	self.critter = critter
	self.cur_shroom = cur_shroom
	self.cur_resource = cur_resource
	close_neighbors = Globals.grid.find_neighbors(x, y)
	region_neighbors = Globals.grid.find_region(x, y)

func set_critter(new_value: Object) -> void:
	critter = new_value
	update_entitie_state()

func set_cur_shroom(new_value: Object) -> void:
	cur_shroom = new_value
	update_entitie_state()

func set_cur_resource(new_value: Object) -> void:
	cur_resource = new_value
	update_entitie_state()

func update_entitie_state() -> void:
	if (is_instance_valid(critter) 
			or is_instance_valid(cur_shroom) 
			or is_instance_valid(cur_resource)):
		TilesReferences.tile_with_entitie(self)
	else:
		TilesReferences.tile_without_entitie(self)

func do_turn() -> void:
	enemy = false
	enemies = []
	turn_used = false
	hex.disable_turn_used()

func turn_complete() -> void:
	turn_used = true
	hex.enable_turn_used()

func find_enemies() -> void:
	enemies = []
	var neighbors: Array = Globals.grid.find_neighbors(x, y)
	for neighbor in neighbors:
		if neighbor.owner_fungus:
			if not neighbor.owner_fungus.my_owner == owner_fungus.my_owner:
				enemies.append(neighbor)
				if owner_fungus.my_owner.name == "player":
					neighbor.enemy = true

func spawn_food() -> void:
	var new_food = food.instance()
	add_child(new_food)
	add_food(new_food)

func spawn_num_food(var num: int) -> void:
	if num > 0:
		for _i in range(0, num):
			spawn_food()

# Add food to our tile
func add_food(var new_food: Object) -> void:
	new_food.cur_tile = self
	new_food.id = tile_food.size()
	new_food.global_transform.origin = stack.global_transform.origin
	new_food.get_parent().remove_child(new_food)
	self.add_child(new_food)
	new_food.global_transform.origin.y += float(new_food.id) * stack_offset
	tile_food.append(new_food)

# Remove food from our tile
func remove_food(var id: int) -> void:
	if id > -1 and id < tile_food.size():
		tile_food[id].queue_free()
		tile_food.remove(id)

func remove_num_food(var amount: int) -> void:
	if amount > 0:
		for _i in range(0, amount):
			remove_food(tile_food.size() - 1)

func spawn_log() -> void:
	if not cur_resource:
		var new_log: Object = resource_log.instance()
		get_tree().current_scene.add_child(new_log)
		new_log.owner_tile = self
		new_log.global_transform.origin = resource_pos.global_transform.origin
		self.cur_resource = new_log

# Called when the tile was clicked
func clicked() -> void:
	if owner_fungus and not turn_used:
		snd_click.play()
		if Globals.DEBUG:
			print("Tile: (" + str(x) + ", " + str(y) + ") was clicked.")
		if Globals.moving_tile:
			if Globals.moving_tile.attacking:
				Globals.moving_tile.try_attack(self)
			elif owner_fungus.my_owner.name == "player":
				Globals.moving_tile.try_move_food(self)
			else:
				Globals.moving_tile.stop_move_food()
		elif Globals.build_ui and owner_fungus.my_owner.name == "player":
			Globals.build_ui.make_build_menu(self.food_in_region, self)
	else:
		if is_instance_valid(Globals.moving_tile):
			Globals.moving_tile.stop_move_food()

func build_gather_shroom() -> void:
	if tile_food.size() <= Globals.BUILD_GATHER_COST:
		region_food_request(region_neighbors, Globals.BUILD_GATHER_COST - tile_food.size() + 1) 
	if tile_food.size() > Globals.BUILD_GATHER_COST and not cur_shroom and cur_resource and not turn_used and not critter:
		var new_shroom = gather_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		new_shroom.food_amount = cur_resource.FOOD_AMOUNT
		self.cur_shroom = new_shroom
		remove_num_food(5)
		turn_complete()
		
func enable_glow(var neighbor: Tile) -> void:
	var hex_to_glow :Hex = neighbor.hex
	var direction := (transform.origin.direction_to(neighbor.transform.origin))
	# Finded with cardinal coords
	if direction.x < 0 and direction.z == 0:
		#S enable N
		hex_to_glow.enable_b_d_l()
	if direction.x < 0 and direction.z < 0:
		#SO enable NE
		hex_to_glow.enable_b_l()
	if direction.x < 0 and direction.z > 0:
		#SE enable NO
		hex_to_glow.enable_b_d_r()
	if direction.x > 0 and direction.z == 0:
		#N enable S
		hex_to_glow.enable_b_u_r()
	if direction.x > 0 and direction.z < 0:
		#NO enable SE
		hex_to_glow.enable_b_u_l()
	if direction.x > 0 and direction.z > 0:
		#NE enable SO
		hex_to_glow.enable_b_r()

func disable_glow() -> void:
	hex.disable_b_d_l()
	hex.disable_b_l()
	hex.disable_b_d_r()
	hex.disable_b_u_r()
	hex.disable_b_u_l()
	hex.disable_b_r()

func build_poison_shroom() -> void:
	if tile_food.size() <= Globals.BUILD_POISON_COST:
		region_food_request(region_neighbors, Globals.BUILD_POISON_COST - tile_food.size() + 1) 
	if tile_food.size() > Globals.BUILD_POISON_COST and not cur_shroom and not turn_used and not critter:
		var new_shroom = poison_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		self.cur_shroom = new_shroom
		remove_num_food(5)
		turn_complete()

func build_scout_shroom() -> void:
	if tile_food.size() <= Globals.BUILD_GATHER_COST:
		region_food_request(region_neighbors, Globals.BUILD_GATHER_COST - tile_food.size() + 1) 
	if tile_food.size() > Globals.BUILD_GATHER_COST and not cur_shroom and not turn_used and not critter:
		var new_shroom = scout_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		self.cur_shroom = new_shroom
		remove_num_food(5)
		turn_complete()

func move_food(var amount: int) -> void:
	if tile_food.size() >= amount and not Globals.moving_tile and owner_fungus:
		move_amount = amount
		Globals.moving_tile = self
		region = Globals.grid.find_region(x, y)
		Globals.grid.gray_all_tiles()
		for i in range(region.size() - 1, -1, -1):
			if not region[i].owner_fungus:
				region.remove(i)
			elif not region[i].owner_fungus.my_owner.name == "player":
				region.remove(i)
			else:
				region[i].disable_grayed_out()
		if region.size() < 1:
			stop_move_food()

func stop_move_food() -> void:
	Globals.moving_tile = null
	region = []
	Globals.grid.disable_gray_all_tiles()
	move_amount = 0
	attacking = false

func try_move_food(var other_tile: Object) -> void:
	if region.size() > 0:
		for i in region:
			if other_tile == i:
				if other_tile.owner_fungus == owner_fungus:
					do_move_food(other_tile, move_amount)
	stop_move_food()

func do_move_food(var other_tile: Object, var amount: int) -> void:
	if owner_fungus:
		if owner_fungus.my_owner.name == "player":
			snd_food.play()
	other_tile.spawn_num_food(amount)
	remove_num_food(amount)
	turn_complete()

func attack(var amount: int) -> void:
	if tile_food.size() >= amount and not Globals.moving_tile and owner_fungus:
		move_amount = amount
		attacking = true
		Globals.moving_tile = self
		region = Globals.grid.find_neighbors(x, y)
		Globals.grid.gray_all_tiles()
		for i in range(region.size() - 1, -1, -1):
			if not region[i].owner_fungus:
				region.remove(i)
			elif not region[i].owner_fungus.my_owner.name == "ai":
				region.remove(i)
			else:
				region[i].disable_grayed_out()
		if region.size() < 1:
			stop_move_food()

func try_attack(var other_tile: Object) -> void:
	if region.size() > 0:
		for i in region:
			if other_tile == i:
				if not other_tile.owner_fungus == owner_fungus:
					do_attack(other_tile)
	stop_move_food()

func do_attack(var other_tile: Object) -> void:
	turn_complete()
	snd_combat.play()
	var left_over_food: int = other_tile.tile_food.size() - move_amount
	if left_over_food > 0:
		remove_num_food(move_amount)
		other_tile.remove_num_food(move_amount)
	elif left_over_food < 0:
		var amount: int = int(abs(float(left_over_food)))
		if Globals.DEBUG:
			print("You win by: " + str(amount))
		other_tile.remove_fungus()
		owner_fungus.claim_tile(other_tile)
		other_tile.spawn_num_food(amount)
		remove_num_food(amount)
		Globals.player.update_glow()
		other_tile.turn_complete()
	else:
		other_tile.remove_fungus()
		other_tile.remove_num_food(move_amount)

func enable_grayed_out() -> void:
	hex.enable_grayed_out()

func disable_grayed_out() -> void:
	hex.disable_grayed_out()

func remove_fungus() -> void:
	owner_fungus.remove_tile_object(self)
	owner_fungus = null
	tile_food = []
	turn_used = false
	enemy = false
	enemies = []
	revealed = false
	remove_friendly_ui()
	disable_glow()
	if cur_shroom:
		cur_shroom.kill()

func generate_friendly_ui() -> void:
	if not has_friendly_ui:
		has_friendly_ui = true
		var new_ui = friendly_ui.instance()
		add_child(new_ui)
	
func remove_friendly_ui() -> void:
	var nodes: Array = get_children()
	for i in nodes:
		if i.is_in_group("friendly_ui"):
			i.queue_free()
			has_friendly_ui = false


func get_food_in_region() -> int:
	var _food_in_region := 0
	for neigbor in region_neighbors:
		if neigbor.owner_fungus != owner_fungus:
			continue
		if neigbor.tile_food.size() > 1 and not neigbor.turn_used:
			_food_in_region += neigbor.tile_food.size() - 1
			print(_food_in_region)
	_food_in_region += tile_food.size()
	return _food_in_region

func region_food_request(_region: Array, value: int) -> void:
	var tiles_with_enough_food := []
	for tile in _region:
		if tile.owner_fungus != owner_fungus:
			continue
		if tile.tile_food.size() > 1 and not tile.turn_used:
			tiles_with_enough_food.append(tile)

	var food_requested := 0
	var i := 0
	while(food_requested < value):
		tiles_with_enough_food.shuffle()
		if tiles_with_enough_food.size() == 0:
				break
		else:
			tiles_with_enough_food[0].remove_num_food(1)
			if tiles_with_enough_food[0].tile_food.size() <= 1:
				tiles_with_enough_food[0].turn_complete()
				tiles_with_enough_food.remove(i)
			spawn_num_food(1)
		food_requested += 1

