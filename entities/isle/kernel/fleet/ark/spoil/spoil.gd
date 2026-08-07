@tool
class_name Spoil
extends Panel


@export var ark: Ark

@export var stake: Bozo.Stake:
	set(value_):
		stake = value_
		
		set("theme_override_styles/panel", panel)
		
		match stake:
			Bozo.Stake.LEFT:
				panel.corner_radius_top_left = Catalog.SPOIL_CORNER
				panel.corner_radius_bottom_left = Catalog.SPOIL_CORNER
				panel.corner_radius_top_right = 0
				panel.corner_radius_bottom_right = 0
				button.offset_transform_position.x = 2
			Bozo.Stake.RIGHT:
				panel.corner_radius_top_left = 0
				panel.corner_radius_bottom_left = 0
				panel.corner_radius_top_right = Catalog.SPOIL_CORNER
				panel.corner_radius_bottom_right = Catalog.SPOIL_CORNER
				button.offset_transform_position.x = -2

var panel: StyleBoxFlat = StyleBoxFlat.new()

@export var button: TextureButton


func _on_button_pressed() -> void:
	var flag = stake == Bozo.Stake.LEFT
	
	if ark.last_animation == Bozo.Ark.APPEAR or ark.last_animation == Bozo.Ark.DEACTIVATE:
		flag = !flag
	
	ark.apply_animation(flag)

func _on_button_mouse_entered() -> void:
	if ark.is_animation_running(): return
	panel.bg_color = Color.WHITE

func _on_button_mouse_exited() -> void:
	if ark.is_animation_running(): return
	var color = Digest.matter_to_color[ark.stamp.origin.matter]
	panel.bg_color = color

func update_texture(is_visible_: bool = true) -> void:
	var value = -1
	
	if is_visible_:
		value = 1
	
	button.texture_normal = load("res://entities/dice/images/%d.png" % value)

func is_mouse_inside() -> bool:
	var mouse = get_local_mouse_position()
	return mouse.x >= 0 and mouse.y >= 0 and mouse.x <= size.x and mouse.y <= size.y
