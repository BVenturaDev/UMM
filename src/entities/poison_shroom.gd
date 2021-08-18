extends Spatial

onready var anim = $AnimationPlayer

const FOOD_AMOUNT: int = 5

var idle_anims: Array = ["left_and_right", "look_back", "wiggle"]
var owner_tile: Object = null

func _process(_delta):
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])
