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

var duration_shift: float = 0

var hover_tween: Tween
var appear_tween: Tween


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
	
	custom_minimum_size.x = min_size_x_default
	position.x = 0
	first_appear()

func first_appear() -> void:
	stamp.offset_transform_position_ratio.y = 1.25
	rng_duration_shift()
	appear()
	Arbitrator.current_phase.animation_tweens.append(appear_tween)
	appear_tween.finished.connect(Arbitrator.current_phase._on_tween_finished.bind(appear_tween))
	await appear_tween.finished
	duration_shift = 0

func rng_duration_shift() -> void:
	duration_shift = Gear.appears[Gear.tempo] * Helper.rng.randf_range(Gear.min_appear_factor, Gear.max_appear_factor)

func appear() -> void:
	if appear_tween and appear_tween.is_running(): return
	visible = true
	#custom_minimum_size.x = min_size_x_default # Setting it directly results in snapping instead of smooth movement
	appear_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#appear_tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25)
	appear_tween.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 0.0, Gear.appears[Gear.tempo] + duration_shift)

	await appear_tween.finished
	mouse_filter = Control.MOUSE_FILTER_PASS
	stamp.mouse_filter = Control.MOUSE_FILTER_PASS

func disappear() -> void:
	if appear_tween and appear_tween.is_running(): return
	atheneum.isle.kernel.fleet.apply_ark_animation(stamp.data)
	appear_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)#TRANS_CIRC
	#appear_tween.tween_property(self, "custom_minimum_size:x", 0.0, 0.2)
	appear_tween.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 1.25, Gear.appears[Gear.tempo])
	await appear_tween.finished
	atheneum.close_up_cards(self)

func last_disappear() -> void:
	rng_duration_shift()
	disappear()
	Arbitrator.current_phase.animation_tweens.append(appear_tween)
	appear_tween.finished.connect(Arbitrator.current_phase._on_tween_finished.bind(appear_tween))
#endregion

#region hover
func hover() -> void:
	if appear_tween and appear_tween.is_running(): return
	if atheneum.shift_tween and atheneum.shift_tween.is_running(): return
	z_index = 1
	var current_x = stamp.position.x
	
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE * 1.2, 0.1)
	hover_tween.tween_property(stamp, "offset_transform_rotation", 0.0, 0.1)
	hover_tween.tween_property(stamp, "offset_transform_position_ratio:y", -0.25, 0.15)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 1.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_hover, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_tween.tween_property(stamp, "position:x", current_x + (min_size_x_hover - min_size_x_default) / 2, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func unhover() -> void:
	if appear_tween and appear_tween.is_running(): return
	z_index = 0
	
	if atheneum.shift_tween and atheneum.shift_tween.is_running():
		z_index = 1
	
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE, 0.2)
	hover_tween.tween_property(stamp, "offset_transform_position_ratio:y", 0.0, 0.25)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 0.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_tween.tween_property(stamp, "position:x", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func spoil() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unhover()
	await hover_tween.finished
	disappear()
	await appear_tween.finished
#endregion
