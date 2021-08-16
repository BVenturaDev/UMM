extends Spatial

const stack_offset: float = 0.2

var food = preload("res://scenes/entities/food.tscn")

onready var hex = $hex_tile
onready var stack = $food_stack

# Variables
# Grid Location
var x: int = -1
var y: int = -1
var odd_row: bool = false
var owner_fungus = null
var turn_used = false

# Array of all food stored in this tile
var tile_food: Array = []

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
	# Debug to test find_neighbors(x, y) Disabled for now
	if Globals.DEBUG and false:
		print("Tile: (" + str(x) + ", " + str(y) + ") was clicked.")
		_lift_neighbors()
	
# Debug function lift neighbors raise neighbors y axis
func _lift_neighbors() -> void:
	var neighbors: Array = get_parent().find_neighbors(x, y)
	for i in neighbors:
		i.transform.origin.y += 1.0
