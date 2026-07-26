class_name CardOverlap 
extends Control


@export var atheneum: Atheneum
@export var card: Card

@export var angle_min: float = -15.0
@export var angle_max: float = 15.0
@export var min_size_x_default: float = 100.0
@export var min_size_x_hover: float = 200.0

var tween: Tween
var tween_appear: Tween
var tween_rot: Tween
var default_rot: float = 0.0


func _ready() -> void:
	get_parent().child_entered_tree.connect(angle_card)
	get_parent().child_exiting_tree.connect(
		func(node: Node) -> void:
			if node == self: return
			angle_card.call_deferred()
	)
	
	card.mouse_entered.connect(hover)
	card.mouse_exited.connect(hold_unhover)
	
	card.border.self_modulate.a = 0.0
	pivot_offset_ratio = Vector2(0.5, 0.5)

	card.offset_transform_position_ratio.y = 2.0
	#custom_minimum_size.x = min_size_x_default # Setting it directly results in snapping instead of smooth movement
	tween_appear = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_appear.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25)
	tween_appear.parallel().tween_property(card, "offset_transform_position_ratio:y", 0.0, 0.2)

	angle_card()
	
func angle_card(_unused: Node = null) -> void:
	var child_count: int = get_parent().get_child_count()
	default_rot = deg_to_rad(lerp(angle_min, angle_max, float(get_index() + 1)/float(child_count + 1)))
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_rot.tween_property(card, "offset_transform_rotation", default_rot, 0.1)

func hover() -> void:
	if atheneum.current_overlap:
		atheneum.current_overlap.unhover()
	
	atheneum.current_overlap = self
	z_index = 1
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel(true)
	tween.tween_property(card, "offset_transform_scale", Vector2.ONE * 1.2, 0.1)
	tween.tween_property(card, "offset_transform_rotation", 0.0, 0.1)
	tween.tween_property(card, "offset_transform_position_ratio:y", -0.25, 0.15)
	tween.tween_property(card.border, "self_modulate:a", 1.0, 0.1)
	tween.tween_property(self, "custom_minimum_size:x", min_size_x_hover, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func unhover() -> void:
	z_index = 0
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(card, "offset_transform_scale", Vector2.ONE, 0.2)
	tween.tween_property(card, "offset_transform_rotation", default_rot, 0.2)
	tween.tween_property(card, "offset_transform_position_ratio:y", 0.0, 0.25)
	tween.tween_property(card.border, "self_modulate:a", 0.0, 0.1)
	tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func destroy() -> void:
	if tween_appear and tween_appear.is_running():
		tween_appear.kill()
	tween_appear = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_appear.tween_property(self, "custom_minimum_size:x", 0.0, 0.2)
	tween_appear.parallel().tween_property(card, "offset_transform_position_ratio:y", 1.0, 0.2)
	tween_appear.tween_callback(queue_free)

func reverse_z_index(is_default: bool = false) -> void:
	if is_default:
		z_index = 0
		return
	
	var child_count: int = get_parent().get_child_count()
	z_index = child_count - get_index() 

func hold_unhover() -> void:
	await get_tree().create_timer(0.5).timeout
	if atheneum.current_overlap == self:
		unhover()
