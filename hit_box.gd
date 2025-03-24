class_name HitBox
extends Area2D

# Grundlegender Schaden (beibehalten)
@export var damage: int = 1 : set = set_damage, get = get_damage
@export var health: Health
@export var root_node_name: String # Exportiert die Variable, damit du sie im Editor sehen kannst

# Erweiterte Schadenswerte
@export var crit_chance: float = 0.2
@export var crit_multiplier: float = 2.0
@export var frost_damage: int = 5
@export var fire_damage: int = 5
@export var electrical_damage: int = 5
@export var armor_penetration: float = 0.1
@export var knockback_power: float = 100.0
@export var anti_knockback: float = 0.5
@export var bleeding_chance: float = 0.1
@export var bleeding_damage: int = 3
@export var bleeding_duration: float = 5.0
@export var burning_chance: float = 0.1
@export var burning_damage: int = 3
@export var burning_duration: float = 5.0

func set_damage(value: int):
	damage = value

func get_damage() -> int:
	return damage
	
func _ready():
	root_node_name = owner.name
	connect("area_entered", _on_body_entered) # Signalverbindung hier
	
func _on_body_entered(body):
	
	if body.get_node_or_null("../Health"): #hier wird überprüft, ob der Body node ein Child mit dem Namen Health hat.
		var health_node = body.get_node_or_null("../Health") # hier wird der Health Node abgerufen.
		if health_node.has_method("take_damage"): #hier wird nochmals überprüft, ob der Health Node die Funktion take_damage hat.
			var calculated_damage = damage  # Verwende den grundlegenden Schaden
			# Kritischer Treffer
			if randf() < crit_chance:
				calculated_damage *= crit_multiplier
				#print(root_node_name, " sagte: Ich traf KRITISCH!")


			# Schaden an den getroffenen Körper weitergeben
			health_node.take_damage(calculated_damage)
	else:
		print("NÜSCHT!")
