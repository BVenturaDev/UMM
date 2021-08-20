extends Spatial

onready var fungus = $fungus
var num_turns: int = 1

func do_turn() -> void:
	if not num_turns == 1:
		for tile in fungus.owned_tiles:
			tile.find_enemies()
			for enemy in tile.enemies:
				enemy.enable_glow(tile)
			if tile.cur_shroom:
				if tile.cur_shroom.is_in_group("scout"):
					var neighbors: Array = Globals.grid.find_neighbors(tile.x, tile.y)
					var enemy_neighbors: bool = false
					for neighbor in neighbors:
						if neighbor.owner_fungus:
							if not neighbor.owner_fungus == self:
								neighbor.revealed = true
								enemy_neighbors = true
					if not enemy_neighbors:
						tile.cur_shroom.kill()
	num_turns += 1
