extends Spatial

onready var kill_timer = $kill_timer
onready var anim = $AnimationPlayer

const FOOD_AMOUNT: int = 5

var idle_anims: Array = ["left_and_right", "look_back", "wiggle"]
var owner_tile: Object = null

func _process(_delta):
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])

func kill() -> void:
	anim.stop()
	anim.play("death")
	kill_timer.start()
	owner_tile.cur_shroom = null


func _on_kill_timer_timeout():
	if owner_tile:
		owner_tile.cur_shroom = null
	queue_free()
