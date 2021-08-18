extends Viewport

var tile: Object

func _ready() -> void:
	tile = get_parent().get_parent().get_parent()

func _process(_delta):
	get_parent().texture = self.get_texture()
	size = $food_label.rect_size
	if tile:
		get_child(0).text = str(tile.tile_food.size())
