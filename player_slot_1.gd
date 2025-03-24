extends CharacterBody2D

@onready var hurtbox = $HurtBox

@export var slot_position : int


const SPEED = 55.0
const JUMP_VELOCITY = -400.0
var knockback_force = 200.0
var knockback_lift = -300.0
var knockback_duration = 0.65
var knockback_timer = 0.0
var knockback_direction = Vector2.ZERO
var normal_movement_enabled = true

func _ready():
	hurtbox.received_damage.connect(_on_hurtbox_received_damage)
	velocity.x = SPEED
	
	%Name.text = name

func _physics_process(delta):
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity.x = knockback_direction.x * knockback_force  # X-Impuls beibehalten
		if not is_on_floor(): 
			velocity.y += get_gravity().y * delta  # Schwerkraft auf Y anwenden
		#print("Knockback: velocity.y =", velocity.y)
		move_and_slide()
		if knockback_timer <= 0:
			normal_movement_enabled = true
	elif normal_movement_enabled:
		if not is_on_floor():
			velocity.y += get_gravity().y * delta  # Hier += statt =
		velocity.x = SPEED
		move_and_slide()


func _on_hurtbox_received_damage(damage):
	#print("Player: HurtBox hat Schaden erhalten:", damage)
	received_player_damage(damage)

func received_player_damage(damage):
	#print("Der Player hat ", damage, " Schaden erhalten.")
	start_knockback()

func start_knockback():
	knockback_direction = -velocity.normalized()
	if knockback_direction == Vector2.ZERO:
		knockback_direction = Vector2(-1, 0)  # Fallback Richtung
	
	knockback_timer = knockback_duration
	velocity.x = knockback_direction.x * knockback_force  # Nur X beeinflussen
	velocity.y = knockback_lift  # Y separat setzen, damit es nicht überschrieben wird
	#print("Start Knockback: velocity.y =", velocity.y)
	normal_movement_enabled = false























#extends CharacterBody2D
#
#
#const SPEED = 50.0
#const JUMP_VELOCITY = -400.0
#
#func _ready():
	#$HurtBox.received_damage.connect(_on_hurtbox_received_damage)
	#velocity.x = SPEED # Starte die Bewegung nach rechts beim Start der Szene
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	##if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	##	velocity.y = JUMP_VELOCITY
#
	#move_and_slide()
#
#func _on_hurtbox_received_damage(damage):
	#print("Ich hab ", damage, " erhalten!")
	#pass
