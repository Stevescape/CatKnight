extends CharacterBody2D
class_name Player

# movement
@export var speed: float = 1000.0
@export var jump_velocity: float = -1800.0
@export var gravity: float = 75

# air dash
@export var air_dash_speed: float = 1500.0
@export var air_dash_duration: float = 0.2
var air_dash_available: bool = true # resets on landing

@export var coyote_time: float = 0.15
var coyote_timer: Timer

@onready var sm: Node = $StateMachine

var horizontal_input: float = 0.0

# jump settings
@export var jump_cut_multiplier = 5
@export var fall_gravity_multiplier = 10

# health system
@export var max_health: int = 5
var current_health: float
@export var heal_rate: float = 1
@export var heal_delay: float = 1.0
var time_since_damage: float = 0.0
@export var passive_healing: bool = false

# damage knockback
@export var knockback_duration: float = 0.3   # seconds
# hard coded, change depending on enemey type
@export var knockback_power: Vector2 = Vector2(750, -400) 
var knockback_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready():
	current_health = max_health
	coyote_timer = Timer.new()
	add_child(coyote_timer)
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	
func start_coyote_timer():
	coyote_timer.start()
	
func take_damage(amount: float, attack_direction: int):
	current_health -= amount
	current_health = max(current_health, 0)
	time_since_damage = 0
	print("Health after damage:", current_health)
	
	knockback_timer = knockback_duration
	var last_attack_direction = attack_direction
	knockback_velocity = Vector2(knockback_power.x * last_attack_direction, knockback_power.y)
	
	if current_health <= 0:
		die()
		return
	# hurt state
	sm.force_change_state("hurting")
	
func die():
	print("player dead")
	if sm:
		sm.set_process(false)  
	queue_free() 
	
func update_health(delta):
	if current_health <= 0:
		return
	
	if not passive_healing:
		return
		
	time_since_damage += delta
	
	if time_since_damage >= heal_delay and current_health < max_health:
		var old_health = current_health
		current_health += heal_rate * delta
		current_health = min(current_health, max_health)
		
		if current_health > old_health:
			print("Healed! Current health:", current_health)
	
func _input(event):
	if event.is_action_pressed("Damage"): # 
		take_damage(1, 1)  # attack from right
