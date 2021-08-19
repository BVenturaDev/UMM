extends Spatial

const DEATH_TIME: float = 2.3

onready var anim = $AnimationPlayer

func set_target(var pos: Vector3) -> void:
	look_at(pos, Vector3(0, 1.0, 0))
	rotation.x = 0
	rotation.z = 0

func clear_target() -> void:
	rotation.y = 0

# Used for critter resource
func start_dead() -> void:
	anim.play("death")
