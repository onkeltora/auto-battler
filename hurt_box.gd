class_name HurtBox
extends Area2D

signal received_damage(damage: int)

@export var health: Health
@export var root_node_name: String # Exportiert die Variable, damit du sie im Editor sehen kannst

func _ready() -> void:
	root_node_name = owner.name
	#print(root_node_name)
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		var damage_data = {
			"damage": hitbox.damage,
			"frost_damage": hitbox.frost_damage,
			"fire_damage": hitbox.fire_damage,
			"electrical_damage": hitbox.electrical_damage,
			"armor_penetration": hitbox.armor_penetration,
			"knockback_power": hitbox.knockback_power,
			"anti_knockback": hitbox.anti_knockback,
			"bleeding_chance": hitbox.bleeding_chance,
			"bleeding_damage": hitbox.bleeding_damage,
			"bleeding_duration": hitbox.bleeding_duration,
			"burning_chance": hitbox.burning_chance,
			"burning_damage": hitbox.burning_damage,
			"burning_duration": hitbox.burning_duration
		}
		take_damage(damage_data)

func take_damage(damage_data: Dictionary):
	var damage = damage_data.damage
	var frost_damage = damage_data.frost_damage
	var fire_damage = damage_data.fire_damage
	var electrical_damage = damage_data.electrical_damage
	var armor_penetration = damage_data.armor_penetration
	var knockback_power = damage_data.knockback_power
	var anti_knockback = damage_data.anti_knockback
	var bleeding_chance = damage_data.bleeding_chance
	var bleeding_damage = damage_data.bleeding_damage
	var bleeding_duration = damage_data.bleeding_duration
	var burning_chance = damage_data.burning_chance
	var burning_damage = damage_data.burning_damage
	var burning_duration = damage_data.burning_duration

	# Rüstungsdurchdringung anwenden (Beispiel)
	var armor = 10 # Beispielwert für die Rüstung
	damage -= damage * armor_penetration * armor/100

	# Schaden anwenden
	var total_damage = damage + frost_damage + fire_damage + electrical_damage
	health.take_damage(total_damage) # Hier greift deine Health Klasse

	# Knockback anwenden
	apply_knockback(knockback_power, anti_knockback)

	# Statuseffekte anwenden
	apply_bleeding(bleeding_chance, bleeding_damage, bleeding_duration)
	apply_burning(burning_chance, burning_damage, burning_duration)

	# Signal ausgeben (optional, falls du das weiterhin verwenden möchtest)
	received_damage.emit(total_damage)

func apply_knockback(knockback_power, anti_knockback):
	# Logik für Knockback (Beispiel: Bewege den Körper weg)
	#var knockback_direction = (global_position - get_tree().get_first_node_in_group("character").global_position).normalized()
	#position += knockback_direction * knockback_power * (1-anti_knockback)
	pass

func apply_bleeding(chance, damage, duration):
	if randf() < chance:
		#print(root_node_name, " SCHREIT: Ich erleide Bluten für ", duration," Sekunden!")
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): remove_child(timer))
		var bleeding_damage_timer = Timer.new()
		add_child(bleeding_damage_timer)
		bleeding_damage_timer.wait_time = 1
		bleeding_damage_timer.timeout.connect(func():
			health.take_damage(damage)
			#print("Blutungsschaden: ", damage)
		)
		bleeding_damage_timer.timeout.connect(func(): if not is_instance_valid(timer): remove_child(bleeding_damage_timer))
		bleeding_damage_timer.start()
		timer.start()

func apply_burning(chance, damage, duration):
	if randf() < chance:
		#print(root_node_name, " SCHREIT: Ich erleide Brennen für ", duration," Sekunden!")
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): remove_child(timer))
		var burning_damage_timer = Timer.new()
		add_child(burning_damage_timer)
		burning_damage_timer.wait_time = 1
		burning_damage_timer.timeout.connect(func():
			health.take_damage(damage)
			#print("Brandschaden: ", damage)
		)
		burning_damage_timer.timeout.connect(func(): if not is_instance_valid(timer): remove_child(burning_damage_timer))
		burning_damage_timer.start()
		timer.start()
