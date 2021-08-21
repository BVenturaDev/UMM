extends Spatial

onready var kill_timer = $kill_timer
onready var anim = $AnimationPlayer
onready var snd_death = $shroom_death
onready var snd_growth = $shroom_growth

const FOOD_AMOUNT: int = 5

var idle_anims: Array = ["left_and_right", "look_back", "wiggle"]
var owner_tile: Object = null
var dying: bool = false

func _ready() -> void:
	snd_growth.play()

func _process(_delta):
	if owner_tile:
		if not owner_tile.cur_shroom == self and not dying:
			queue_free()
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])

func kill() -> void:
	dying = true
	snd_death.play()
	anim.stop()
	anim.play("death")
	kill_timer.start()
	owner_tile.cur_shroom = null

func _on_kill_timer_timeout():
	if owner_tile:
		owner_tile.cur_shroom = null
	queue_free()
