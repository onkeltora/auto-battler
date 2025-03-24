extends Control

@export var player_slot_scene: PackedScene
@onready var slot_container = %SlotContainer

func receive_player_data(player_data):
	print("Das steht im array [Player_Data]: ", player_data)

	if player_data is Array and player_slot_scene:
		for player_name in player_data:
			var player_slot_instance = player_slot_scene.instantiate()
			slot_container.add_child(player_slot_instance)
			player_slot_instance.set_character_name(player_name[0])
			player_slot_instance.set_character_slot_id(player_name[1])
	else:
		print("Fehler: player_data ist kein Array oder player_slot_scene ist nicht zugewiesen.")
		

func receive_enemy_data(enemy_data):
	print("Das steht im array [Enemy_Data]: ", enemy_data)
