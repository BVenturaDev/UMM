extends Spatial

class Coordinates:
	var x : int 
	var y : int
	
	func _init(_x,_y):
		self.set_coord(_x,_y)
		
	func set_coord(_x: int, _y: int):
		x = _x
		y = _y


var current_coordinates : Coordinates = Coordinates.new(0,0)

func _ready() -> void:
	assert(GameSignals.connect("enter_nature_turn", self, "_do_turn") == 0)
	current_coordinates.set_coord(0,0)
	

func _do_turn():
	_wander()

func _wander():
	var tile: Object = Globals.grid.find_tile(0, 0)
	if is_instance_valid(tile):
		print(tile)
	var neighbors = Globals.grid.find_neighbors(current_coordinates.x, current_coordinates.y)
	print(neighbors)
	neighbors.shuffle()
	var random_tile: Spatial = neighbors[0]
	# transform.origin.x = random_tile.transform.origin.x
	# transform.origin.z = random_tile.transform.origin.z
	current_coordinates.set_coord(random_tile.x, random_tile.y)
	$Tween.interpolate_property(
			self, 'translation:x', 
			global_transform.origin.x, random_tile.global_transform.origin.x, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(
			self, 'translation:z', 
			global_transform.origin.z, random_tile.global_transform.origin.z, 
			0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
