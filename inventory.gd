extends GridContainer

@export var slot_scene: PackedScene
@export var num_slots: int = 20
@export var item_textures: Array[Texture2D]

func _ready():
	for i in range(num_slots):
		var slot = slot_scene.instantiate()
		add_child(slot)
		slot.item_dropped.connect(_on_item_dropped)

	# Füge einige zufällige Items zum Start hinzu
	for i in range(min(num_slots, item_textures.size())):
		if randi_range(0, 1) == 1:
			var item_instance = load("res://item_display.tscn").instantiate() as ItemDisplay
			item_instance.texture = item_textures[i]
			get_child(i).set_item(item_textures[i], item_instance)

func _on_item_dropped(item_display: ItemDisplay, from_slot: Node):
	# Diese Funktion wird aufgerufen, wenn ein Item in einen Slot gezogen wurde
	# Die Logik wird im ItemDisplay abgehandelt, hier brauchst du meist nichts zu tun.
	pass
