extends Spatial

class Coordinates:
	var x : int 
	var y : int
	
	func _init(_x,_y):
		self.set_coord(_x,_y)
		
	func set_coord(_x: int, _y: int):
		x = _x
		y = _y

export(NodePath) onready var tween = get_node(tween) as Tween

var current_coordinates : Coordinates = Coordinates.new(0,0)

func _ready() -> void:
	current_coordinates.set_coord(0,0)
	

func do_turn():
	_wander()

func _wander():
	var tile: Object = Globals.grid.find_tile(0, 0)
	if not is_instance_valid(tile):
		return
	var neighbors = Globals.grid.find_neighbors(current_coordinates.x, current_coordinates.y)
	neighbors.shuffle()
	var random_tile: Spatial = neighbors[0]
	current_coordinates.set_coord(random_tile.x, random_tile.y)
	move_to_tile(random_tile)

func move_to_tile(tile):
	tween.interpolate_property(
			self, 'translation:x', 
			global_transform.origin.x, tile.global_transform.origin.x, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(
			self, 'translation:z', 
			global_transform.origin.z, tile.global_transform.origin.z, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
