extends Spatial

onready var fungus = $fungus

var border_tiles: Array = []

func do_turn() -> void:
	border_tiles = []
	for tile in fungus.owned_tiles:
		var neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
		for neighbor in neighbors:
			if neighbor.owner_fungus:
				if not neighbor.owner_fungus.my_owner == self:
					tile.enable_glow(neighbor)
					border_tiles.append(tile)
