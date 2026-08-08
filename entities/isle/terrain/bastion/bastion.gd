class_name Bastion
extends Sprite2D


var data: BastionData:
	set(value_):
		data = value_
		%Background.color = Digest.faction_to_color[data.faction]
		#var g = data.galore
		#%Background.color = Color.from_hsv(1.0, 0.0, 1-g)
		#%Background.color = Color.from_hsv(g, 1.0, 1.0)
		position = Vector2(data.fiefdom.coords.front()) * Catalog.BASTION_SIZE
		frame_coords = Helper.get_coord_based_on_value(data.current_rampart)


var is_external: bool:
	set(value_):
		is_external = value_
		seed_select_shader()

func seed_select_shader() -> void:
	%Select.visible = is_external
	if true: return
	if not is_external: return
	
	var deg = Helper.rng.randf_range(25, 35)
	%Select.material.set_shader_parameter("rotation_deg", deg)
	var pos = Helper.rng.randf_range(0, 1.0)
	%Select.material.set_shader_parameter("position", pos)
	var speed = Helper.rng.randf_range(0.6, 0.8)
	%Select.material.set_shader_parameter("speed", speed)
