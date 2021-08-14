extends Spatial

onready var hex = $hex_tile

# Variables
# Grid Location
var x: int = -1
var y: int = -1
var odd_row: bool = false

# Called when the tile was clicked
func clicked() -> void:
	# Debug to test find_neighbors(x, y)
	if Globals.DEBUG:
		print("Tile: (" + str(x) + ", " + str(y) + ") was clicked.")
		_lift_neighbors()
	
# Debug function lift neighbors raise neighbors y axis
func _lift_neighbors() -> void:
	var neighbors: Array = get_parent().find_neighbors(x, y)
	for i in neighbors:
		i.transform.origin.y += 1.0
