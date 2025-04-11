extends TextureRect
class_name ItemDisplay

var dragging: bool = false
var drag_offset: Vector2
var original_slot: Node = null
var can_drop_target: Node = null

func _ready():
	#scale = Vector2(0.8, 0.8)
	#custom_minimum_size = Vector2(64, 64)
	stretch_mode = TextureRect.STRETCH_SCALE



func start_drag(from_slot: Node):
	dragging = true
	drag_offset = global_position - get_global_mouse_position()
	original_slot = from_slot
	set_process(true)
	set_process_input(true)

	# Füge eine Print-Anweisung hinzu, um zu sehen, ob der Drag-Prozess startet
	print("Item dragging started from slot: ", from_slot)


func _input(event):
	if dragging and event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = false
		set_process(false)
		set_process_input(false)
		if can_drop_target and can_drop_target.has_method("set_item"):
			can_drop_target.set_item(texture, self)
			if original_slot and original_slot != can_drop_target and original_slot.has_method("clear_slot"):
				original_slot.clear_slot()
		else:
			if original_slot and original_slot.has_method("set_item"):
				original_slot.set_item(texture, self)
		original_slot = null
		can_drop_target = null
		queue_free()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
