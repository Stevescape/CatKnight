extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			child.character = self.get_parent()
			
		if initial_state:
			initial_state.enter()
			current_state = initial_state
	

func _physics_process(delta):
	if current_state:
		current_state.update(delta)

func force_change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		print(new_state_name + " does not exist in the state machine")
		return
		
	if current_state == new_state:
		print("State is already set to that")
	
	if current_state:
		var exit_callabe = Callable(current_state, "exit")
		exit_callabe.call_deferred()
		
	new_state.enter()
	
	current_state = new_state

func change_state(old_state : State, new_state_name: String):
	if old_state != current_state:
		print("Invalid change_state trying from: " + old_state.name + " but currently in: " + current_state.name)
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print(new_state_name + " does not exist in the state machine")
		return
		
	if current_state:
		var exit_callabe = Callable(current_state, "exit")
		exit_callabe.call_deferred()
		
	new_state.enter()
	
	current_state = new_state
