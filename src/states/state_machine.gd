extends Node
class_name StateMachine

var state : Object

func _ready() -> void:
	state = get_child(0)
	call_deferred("_enter_state")

func change_to(new_state: String) -> void:
	# Clean the previous state
	state.exit()
	# Enter in the new state
	state = get_node(new_state)
	_enter_state()

func _enter_state() -> void:
	if Globals.DEBUG:
		print(name," entering state: ", state.name)
	# give reference to the current state machine
	state.state_machine = self
	# Do the state enter action
	state.enter()

func _process(delta: float) -> void:
	if state.has_method("_process"):
		state._process(delta)
