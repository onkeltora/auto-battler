class_name Health
extends Node

#signal health_changed(current_health: int, slot: int)
signal died()

@onready var slot_position : int = owner.slot_position
@export var player_slot_scene: PackedScene


@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health

func take_damage(damage: int):
	current_health -= damage
	Sessionstats.health_changed.emit(current_health, slot_position)

	if current_health <= 0:
		die()

func heal(amount: int):
	current_health += amount
	current_health = min(current_health, max_health)  # Gesundheit nicht über Max-Wert erhöhen
	Sessionstats.health_changed.emit(current_health, slot_position)

func die():
	died.emit()
	# Hier kannst du weitere Logik für den Tod hinzufügen (z.B. Animationen, Partikeleffekte, etc.)
	# In diesem Beispiel wird der Node freigegeben (Option)
	get_parent().queue_free()
