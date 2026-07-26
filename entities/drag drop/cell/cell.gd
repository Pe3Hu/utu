class_name DragDropCell
extends Button


@warning_ignore("unused_signal")
signal dragged(from: Vector2i, to: Vector2i)


#Where is this cell in the grid
var grid_position: Vector2i


#Called when clicking and starting to drag
func _get_drag_data(_at_position: Vector2) -> Variant:
	# Empty DragDropCell can't be dragged
	if not icon: return null
	# Make a preview texture of the icon
	var preview: TextureRect = TextureRect.new()
	preview.texture = icon
	set_drag_preview(preview)
	# Return self as the data
	return self

# Called when holding drag and hovering over this button
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Only allow DragDropCell to be dropped
	if not data is DragDropCell or data == self: return false
	# Grab focus to draw focus border around this button
	grab_focus()
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Swap icons between this cell and the cell dragged from
	var temp: Texture2D = icon
	icon = data.icon
	data.icon = temp
	grab_focus(true)
