extends Spatial

onready var fungus = $fungus

var border_tiles: Array = []
var num_turns: int = 1

func do_turn() -> void:
	if not num_turns == 1:
		border_tiles = []
		for tile in fungus.owned_tiles:
			var neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
			for neighbor in neighbors:
				if neighbor.owner_fungus:
					if not neighbor.owner_fungus.my_owner == self:
						neighbor.enable_glow(tile)
						border_tiles.append(tile)
						tile.enemies.append(neighbor)
	num_turns += 1
