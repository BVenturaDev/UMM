extends Spatial

onready var anim = $AnimationPlayer
onready var kill_timer = $kill_timer

var food_amount: int = 0

var idle_anims: Array = ["idle", "left_and_right", "look_back", "look_up"]
var owner_tile: Object = null

func _process(_delta) -> void:
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])

func do_turn() -> void:
	if owner_tile:
		owner_tile.spawn_num_food(food_amount)

func kill() -> void:
	anim.stop()
	anim.play("death")
	kill_timer.start()
	owner_tile.cur_shroom = null

func _on_kill_timer_timeout():
	if owner_tile:
		owner_tile.cur_shroom = null
	queue_free()
