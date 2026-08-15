class_name Debt
extends PanelContainer


var data: DebtData:
	set(value_):
		data = value_
		
		connect_datas()
		connect_signals()
		update_textures()

@export var fine: Fine


#region init
func connect_datas() -> void:
	fine.data = data.fine

func connect_signals() -> void:
	data.current_value_changed.connect(_on_current_value_changed)
	_on_current_value_changed()

func _on_current_value_changed() -> void:
	var percentage = remap(data.current_value, 0.0, data.limit_value, 0.0, 1.0)
	%Volume.material.set_shader_parameter("percentage", percentage)

func update_textures() -> void:
	var matter = Bozo.enum_to_string(Bozo.Type.MATTER, data.matter)
	%Outline.texture = load("res://entities/isle/kernel/usurer/dept/images/%s outline.png" % matter)
	%Volume.texture = load("res://entities/isle/kernel/usurer/dept/images/%s volume.png" % matter)
	var color = Digest.matter_to_color[data.matter]
	color.a = 0.6
	%Volume.material.set_shader_parameter("color_1", color)
	color.a = 0.8
	%Volume.material.set_shader_parameter("color_2", color)
	var offest = Helper.rng.randf_range(-0.25, 0.25) * PI / 3
	offest += PI * 2 / 3 * get_index()
	%Volume.material.set_shader_parameter("wave_phase_offset", offest)
#endregion
