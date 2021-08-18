extends Spatial
class_name Tile
const stack_offset: float = 0.2

var food = preload("res://scenes/entities/food.tscn")
var gather_shroom = preload("res://scenes/entities/gather_shroom.tscn")
var poison_shroom = preload("res://scenes/entities/poison_shroom.tscn")
var scout_shroom = preload("res://scenes/entities/scout_shroom.tscn")

onready var hex = $hex_tile
onready var stack = $food_stack
onready var resource_pos = $resource_point

# Variables
# Grid Location
var x: int = -1
var y: int = -1
var odd_row: bool = false
var owner_fungus: Object = null
var turn_used: bool = false
var close_neighbors : Array
var region_neighbors : Array
var critter: Object = null setget set_critter

var cur_shroom: Object = null setget set_cur_shroom
var move_amount: int = 0



# Array of all food stored in this tile
var tile_food: Array = []
# Array of region available to 
var region: Array = []

func _ready() -> void:
	# Initialize the reference dictionary for tiles with not critters or cur_shroom
	initialize_references()

func initialize_references():
	$InitTimer.start()
	yield($InitTimer,"timeout")
	$InitTimer.queue_free()
	self.critter = null
	self.cur_shroom = null
	close_neighbors = Globals.grid.find_neighbors(x, y)
	region_neighbors = Globals.grid.find_region(x, y)

func set_critter(new_value: Object) -> void:
	if not new_value:
		TilesReferences.tile_without_entitie(self)
	else:
		TilesReferences.tile_with_entitie(self)
	critter = new_value

func set_cur_shroom(new_value: Object) -> void:
	if not new_value:
		TilesReferences.tile_without_entitie(self)
	else:
		TilesReferences.tile_with_entitie(self)
	cur_shroom = new_value

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

# Called when the tile was clicked
func clicked() -> void:
	if Globals.DEBUG:
		print("Tile: (" + str(x) + ", " + str(y) + ") was clicked.")
	if Globals.moving_tile:
		Globals.moving_tile.try_move_food(self)
	elif Globals.build_ui:
		Globals.build_ui.make_build_menu(tile_food.size(), self)

func build_gather_shroom() -> void:
	if tile_food.size() > 5 and not cur_shroom:
		var new_shroom = gather_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		self.cur_shroom = new_shroom
		remove_num_food(5)
		
func build_poison_shroom() -> void:
	if tile_food.size() > 5 and not cur_shroom:
		var new_shroom = poison_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		cur_shroom = new_shroom
		remove_num_food(5)
		
func build_scout_shroom() -> void:
	if tile_food.size() > 5 and not cur_shroom:
		var new_shroom = scout_shroom.instance()
		add_child(new_shroom)
		new_shroom.transform.origin = resource_pos.transform.origin
		new_shroom.owner_tile = self
		cur_shroom = new_shroom
		remove_num_food(5)
		
func move_food(var amount: int) -> void:
	if tile_food.size() >= amount and not Globals.moving_tile and owner_fungus:
		move_amount = amount
		Globals.moving_tile = self
		region = Globals.grid.find_region(x, y)
		Globals.grid.gray_all_tiles()
		for i in range(region.size() - 1, -1, -1):
			if not region[i].owner_fungus:
				region.remove(i)
			else:
				region[i].disable_grayed_out()

func stop_move_food() -> void:
	Globals.moving_tile = null
	region = []
	Globals.grid.disable_gray_all_tiles()
	move_amount = 0
	
func try_move_food(var other_tile: Object) -> void:
	if region.size() > 0:
		for i in region:
			if other_tile == i:
				if other_tile.owner_fungus:
					do_move_food(other_tile, move_amount)
	stop_move_food()

func do_move_food(var other_tile: Object, var amount: int) -> void:
	other_tile.spawn_num_food(amount)
	remove_num_food(amount)

func enable_grayed_out() -> void:
	hex.enable_grayed_out()
	
func disable_grayed_out() -> void:
	hex.disable_grayed_out()
