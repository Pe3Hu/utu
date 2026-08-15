class_name Fine
extends TextureRect


var data: FineData:
	set(value_):
		data = value_
		
		connect_signals()
		update_textures()


#region init
func update_textures() -> void:
	var matter = Bozo.enum_to_string(Bozo.Type.MATTER, data.debt.matter)
	var text = load("res://entities/isle/kernel/usurer/dept/fine/images/%s volume.png" % matter)
	texture = text
	material.set_shader_parameter("mask_texture", text)
	Helper.update_colors(self, data.debt.matter)
	%Outline.texture = load("res://entities/isle/kernel/usurer/dept/fine/images/%s outline.png" % matter)

func connect_signals() -> void:
	data.value_changed.connect(_on_value_changed)

func _on_value_changed() -> void:
	%Amount.text = str(data.value)
#endregion
