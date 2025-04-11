extends PanelContainer

signal item_dropped(item_display: ItemDisplay, from_slot: Node)

var item_display: ItemDisplay = null
var is_occupied: bool = false

func set_item(item: Texture2D, item_node: ItemDisplay = null):
	%ItemTexture.texture = item
	item_display = item_node
	is_occupied = (item != null)

	if item_display:
		if item_display.get_parent():
			item_display.get_parent().remove_child(item_display)
		add_child(item_display)
		item_display.position = Vector2.ZERO

func clear_slot():
	%ItemTexture.texture = null
	item_display = null
	is_occupied = false

func can_drop(item_node: Node) -> bool:
	return !is_occupied and item_node is ItemDisplay

func _on_drop_area_dropped(data):
	if data is ItemDisplay:
		item_dropped.emit(data, data.get_parent())

func _ready():
	custom_minimum_size = Vector2(64, 64)
	%ItemTexture.scale = Vector2(0.8, 0.8)
	#%ItemTexture.custom_minimum_size = Vector2(64, 64)
	#%ItemTexture.expand = true
	#%ItemTexture.stretch_mode = TextureRect.STRETCH_SCALE

	var drop_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.extents = get_size() / 2

	drop_area.add_child(collision_shape)
	add_child(drop_area)

	drop_area.connect("input_event", _on_drop_area_input_event)
	drop_area.connect("area_entered", _on_drop_area_entered)
	drop_area.connect("area_exited", _on_drop_area_exited)
	drop_area.connect("body_entered", _on_drop_area_body_entered)
	drop_area.connect("body_exited", _on_drop_area_body_exited)

func _on_drop_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_occupied and item_display:
		var drag_node = item_display.duplicate() as ItemDisplay
		get_tree().get_root().add_child(drag_node)
		drag_node.global_position = get_global_mouse_position() - get_global_position() + item_display.size / 2
		drag_node.start_drag(self)
		clear_slot()

func _on_drop_area_entered(area):
	if area is ItemDisplay:
		area.can_drop_target = self

func _on_drop_area_exited(area):
	if area is ItemDisplay and area.can_drop_target == self:
		area.can_drop_target = null

func _on_drop_area_body_entered(body):
	if body is ItemDisplay:
		body.can_drop_target = self

func _on_drop_area_body_exited(body):
	if body is ItemDisplay and body.can_drop_target == self:
		body.can_drop_target = null
