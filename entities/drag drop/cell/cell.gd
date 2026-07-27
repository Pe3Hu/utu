@tool
class_name DragDropCell
extends Button


@warning_ignore("unused_signal")
signal dragged(from: Vector2i, to: Vector2i)


@export var tune: Tune

var grid: Vector2i:
	set(value_):
		grid = value_
		
		match grid.x:
			0: 
				icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
			1: 
				icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		match grid.y:
			0: 
				vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
			1: 
				vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
			2: 
				vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM

@export var value: int = -1:
	set(value_):
		value = value_
		icon = load("res://entities/dice/images/%d.png" % value)
		
		if tune:
			tune.apply_value()


# Called when clicking and starting to drag
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not icon: return null
	if value < 0: return null
	var preview: TextureRect = TextureRect.new()
	preview.texture = icon
	preview.z_index = 101
	set_drag_preview(preview)
	return self

# Called when holding drag and hovering over this button
func _can_drop_data(_at_position: Vector2, data_: Variant) -> bool:
	if not data_ is DragDropCell or data_ == self: return false
	grab_focus()
	return true

func _drop_data(_at_position: Vector2, data_: Variant) -> void:
	var temp = value
	value = data_.value
	data_.value = temp
	grab_focus(true)
