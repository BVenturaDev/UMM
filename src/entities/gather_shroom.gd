extends Spatial

var idle_anims: Array = ["idle", "left_and_right", "look_back", "look_up"]

onready var anim = $AnimationPlayer

func _process(_delta):
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])
