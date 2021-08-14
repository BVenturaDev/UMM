extends Spatial

onready var hex = $hex_tile

# Variables
# Grid Location
var x: int = -1
var y: int = -1

func clicked() -> void:
	print("Tile: (" + str(x) + ", " + str(y) + ") was clicked.")
