extends Spatial

onready var kill_timer = $kill_timer
onready var anim = $AnimationPlayer
onready var snd_death = $shroom_death
onready var snd_growth = $shroom_growth
onready var mini_me = $mini_me
onready var base = $Armature

const FOOD_AMOUNT: int = 5

var idle_anims: Array = ["back_and_forth", "left_and_right", "look_around"]
var owner_tile: Object = null
var dying: bool = false

func _ready() -> void:
	snd_growth.play()

func _process(_delta):
	mini_me.visible = false
	base.visible = true
	if owner_tile:
		if not owner_tile.cur_shroom == self and not dying:
			queue_free()
		if owner_tile.cur_resource:
			if owner_tile.cur_resource.is_in_group("trees"):
				mini_me.visible = true
				base.visible = false
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
