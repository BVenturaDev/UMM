extends Spatial

onready var fungus = $fungus

var border_tiles: Array = []
var num_turns: int = 1

func do_turn() -> void:
	if not num_turns == 1:
		border_tiles = []
		for tile in fungus.owned_tiles:
			tile.find_enemies()
			for enemy in tile.enemies:
				enemy.enable_glow(tile)
				border_tiles.append(tile)
	num_turns += 1
