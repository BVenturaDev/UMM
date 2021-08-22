extends Control
class_name RadialButtons
export var radius = 126
export var speed = 0.25

var num := 0
var active := false
export(NodePath) onready var buttons = get_node(buttons) as Control
export(NodePath) onready var build_popup
var comeback_position := Vector2.ZERO
var max_time_without_popup := 0.2
var time_without_popup := 0.0

func _ready():
	num = buttons.get_child_count()

func _process(delta: float) -> void:
	if get_node(build_popup).visible == false:
		time_without_popup += delta
		if time_without_popup > max_time_without_popup:
			if active:
				hide_menu()
				
			else:
				time_without_popup = 0.0
	else:
		time_without_popup = 0.0

func display() -> void:
	rect_global_position = get_global_mouse_position()
	var offset := 100
	var screen_height = get_viewport_rect().size.y
	if rect_global_position.y <= offset:
		rect_global_position.y += offset
	if rect_global_position.y > (screen_height - offset):
		rect_global_position.y -= offset
	var screen_width = get_viewport_rect().size.x
	if rect_global_position.x < offset:
		rect_global_position.x += offset
	if rect_global_position.y > (screen_width - offset):
		rect_global_position.x -= offset
	for button in buttons.get_children():
		comeback_position = rect_global_position 
		
		button.rect_global_position = rect_global_position
	$buttons/poison_shroom.grab_focus()
	show_menu()


func _on_Tween_tween_all_completed():
	if not active:
		hide()


func show_menu():
	active = true
	for button in buttons.get_children():
		button.disabled = false
	var tween = $Tween
	var spacing = TAU / num
	for b in buttons.get_children():
		# Subtract PI/2 to align the first button  to the top
		var a = spacing * b.get_position_in_parent() - PI / 2
		var dest = b.rect_position + Vector2(radius, 0).rotated(a)
		tween.interpolate_property(b, "rect_position",
					b.rect_position, dest, speed,
					Tween.TRANS_BACK, Tween.EASE_OUT)
		tween.interpolate_property(b, "rect_scale",
					Vector2(0.5, 0.5), Vector2.ONE, speed,
					Tween.TRANS_LINEAR)
	show()
	tween.start()

func hide_menu():
	for button in buttons.get_children():
		button.disabled = true
	for b in buttons.get_children():
		$Tween.interpolate_property(b, "rect_global_position", b.rect_global_position,
		comeback_position, speed, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.interpolate_property(b, "rect_scale", null,
					Vector2(0.5, 0.5), speed, Tween.TRANS_LINEAR)
		b.disabled = true
	$Tween.start()
	active = false
	yield($Tween,"tween_all_completed")
	hide()

func _on_close_button_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_close_button_pressed()


func _on_move_food_button_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_move_food_button_pressed()


func _on_RequestFood_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_RequestFood_pressed()


func _on_attack_button_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_attack_button_pressed()


func _on_gather_shroom_button_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_gather_shroom_button_pressed()


func _on_poison_shroom_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_poison_shroom_pressed()


func _on_kill_shroom_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_kill_shroom_pressed()


func _on_scout_shroom_pressed() -> void:
	if Globals.build_ui:
		Globals.build_ui._on_scout_shroom_pressed()
