extends Spatial

onready var anim = $AnimationPlayer
onready var base = $Armature
onready var mini_me = $mini_me
onready var kill_timer = $kill_timer
onready var snd_death = $shroom_death
onready var snd_growth = $shroom_growth

var food_amount: int = 0
var dying: bool = false

var idle_anims: Array = ["idle", "left_and_right", "look_back", "look_up"]
var owner_tile: Object = null

func _ready() -> void:
	snd_growth.play()

func _process(_delta) -> void:
	if owner_tile:
		if not owner_tile.cur_shroom == self and not dying:
			kill()
	elif not dying:
		if owner_tile.cur_resource.is_in_group("trees"):
			mini_me.visible = true
			base.visible = false
		else:
			mini_me.visible = false
			base.visible = true
	if owner_tile:
		if not owner_tile.cur_shroom == self:
			queue_free()
	if anim:
		if not anim.is_playing():
			var i = Globals.rng.randi_range(0, idle_anims.size() - 1)
			anim.play(idle_anims[i])

func do_turn() -> void:
	if owner_tile:
		owner_tile.spawn_num_food(food_amount)

func kill() -> void:
	snd_death.play()
	dying = true
	anim.stop()
	anim.play("death")
	kill_timer.start()
	owner_tile.cur_shroom = null

func _on_kill_timer_timeout():
	if owner_tile:
		owner_tile.cur_shroom = null
	queue_free()
