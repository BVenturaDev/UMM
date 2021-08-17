extends Node
class_name StateMachine

export(bool) var autostart := true
var state: Object

var history = []

func _ready() -> void:
	if autostart:
		start_machine()
	else:
		_disabled_node()

func start_machine():
	# Set the initial state to the first child node
	state = get_child(0)
	_enabled_node()
	call_deferred("_enter_state")

func stop_machine():
	_disabled_node()

func change_to(new_state):
	if state.has_method("stop_machine"):
		state.stop_machine()
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	if Globals.DEBUG_SM:
		print("Entering state: ", state.name)
	# Give the new state a reference to this state machine script
	state.state_machine = self
	if state.has_method("start_machine"):
		state.start_machine()
	state.enter()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)

func _notification(what):
	if is_instance_valid(state):
		if state && state.has_method("notification"):
			state.notification(what)

func _disabled_node():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_key_input(false)
	set_process_unhandled_input(false)
	set_block_signals(true)


func _enabled_node():
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	set_process_unhandled_key_input(true)
	set_process_unhandled_input(true)
	set_block_signals(false)

# virtual functions
func enter():
	pass

func exit(_next_state):
	pass
