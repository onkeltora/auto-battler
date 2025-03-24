extends PanelContainer

@onready var character_name_label = %Charactername # Annahme: CharacterName ist ein Label-Node
@onready var character_slot_id : int


func _ready() -> void:
	Sessionstats.health_changed.connect(set_character_health_bar)


func set_character_name(name):
	if character_name_label:
		character_name_label.text = name
	else:
		print("Fehler: CharacterName-Label nicht gefunden.")


func set_character_slot_id(value):
	print(character_name_label.text, value)
	character_slot_id = value
	

func set_character_health_bar(value, slot):
	%LifeBar.value = value
	print(character_slot_id)
