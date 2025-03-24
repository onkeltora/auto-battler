extends Node2D

@export var player_node_path: NodePath
@export var enemy_node_path: NodePath


@onready var interface_node = %interface
var player_data : Array = []
var enemy_data : Array = []

func _ready() -> void:
	var player_chars = get_node(player_node_path)
	if player_chars:
		var num_players = player_chars.get_child_count()
		player_data = get_child_names(player_chars)
		
# Hier kannst du das array weiterverarbeiten
	else:
		print("Fehler: Zielknoten nicht gefunden.")
	

	if interface_node:
		interface_node.receive_player_data(player_data)
	else:
		print("Fehler: Interface-Knoten nicht gefunden.")
	
	   
	
	
	
	
	
	
	
	
	
	var enemy_chars = get_node(enemy_node_path)
	if enemy_chars:
		var num_enemies = enemy_chars.get_child_count()

# Hier kannst du das Dictionary weiterverarbeiten
	else:
		print("Fehler: Zielknoten nicht gefunden.")
	
	if interface_node:
		interface_node.receive_enemy_data(enemy_data)
	else:
		print("Fehler: Interface-Knoten nicht gefunden.")
	



func get_child_names(node):
	var child_names = []
	var id = 1
	for child in node.get_children():
		child_names.append([str(child.name), id])
		id += 1
	return child_names
