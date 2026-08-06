class_name Card
extends Control


@export var atheneum: Atheneum
@export var stamp: Stamp

@export var angle_min: float = -0.0
@export var angle_max: float = 0.0

@export var min_size_x_default: float:
	get:
		return stamp.size.x
@export var min_size_x_hover: float:
	get:
		return stamp.size.x * 1.2

var tween: Tween
var tween_appear: Tween
var tween_rot: Tween
var default_rot: float = 0.0


#region init
func _ready() -> void:
	stamp.border.self_modulate.a = 0.0
	pivot_offset_ratio = Vector2(0.5, 0.5)
	pivot_offset = size / 2
	
	stamp.mouse_entered.connect(hover)
	stamp.mouse_exited.connect(
		func() -> void:
			if !stamp.get_global_rect().has_point(get_global_mouse_position()):
				unhover()
	)
	
	stamp.offset_transform_position_ratio.y = 2.0
	#custom_minimum_size.x = min_size_x_default # Setting it directly results in snapping instead of smooth movement
	tween_appear = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_appear.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25)
	tween_appear.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 0.0, 0.2)

func destroy() -> void:
	if tween_appear and tween_appear.is_running():
		tween_appear.kill()
	tween_appear = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween_appear.tween_property(self, "custom_minimum_size:x", 0.0, 0.2)
	tween_appear.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 2.0, 1.2)
	tween_appear.tween_callback(queue_free)
#endregion

#region hover
func hover() -> void:
	if atheneum.current_card:
		atheneum.current_card.unhover()
	
	atheneum.current_card = self
	z_index = 1
	var current_x = stamp.position.x
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel(true)
	tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE * 1.2, 0.1)
	tween.tween_property(stamp, "offset_transform_rotation", 0.0, 0.1)
	tween.tween_property(stamp, "offset_transform_position_ratio:y", -0.25, 0.15)
	tween.tween_property(stamp.border, "self_modulate:a", 1.0, 0.1)
	tween.tween_property(self, "custom_minimum_size:x", min_size_x_hover, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(stamp, "position:x", current_x + (min_size_x_hover - min_size_x_default) / 2, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func unhover() -> void:
	z_index = 0
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE, 0.2)
	tween.tween_property(stamp, "offset_transform_rotation", default_rot, 0.2)
	tween.tween_property(stamp, "offset_transform_position_ratio:y", 0.0, 0.25)
	tween.tween_property(stamp.border, "self_modulate:a", 0.0, 0.1)
	tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(stamp, "position:x", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func spoil() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unhover()
	tween.tween_callback(destroy)
#endregion

func process_click() -> void:
	var local_mouse_pos = get_local_mouse_position()
	var half_height = size.y / 2
	
	if local_mouse_pos.y > half_height:
		atheneum.spoil_card(self)
		return
	
	var half_width = size.x / 2
	var shift_value = 0
	
	if local_mouse_pos.x < half_width:
		shift_value = -1
	else:
		shift_value = 1
	
	atheneum.shift_card(self, shift_value)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_click()
