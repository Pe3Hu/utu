@tool
class_name Tune
extends PanelContainer


@export var cell: DragDropCell

@export var type: Bozo.Tune:
	set(value_):
		type = value_
		call_deferred("update_icons")


func update_icons() -> void:
	var passive_flags: Array[bool]
	var active_flags: Array[bool]
	
	for _i in 3:#Catalog.tunes.size():
		var flag = Catalog.tunes[_i] == type
		passive_flags.append(!flag)
		active_flags.append(flag)
	
	%PassiveIcon.material.set_shader_parameter("parts", passive_flags)
	%ActiveIcon.material.set_shader_parameter("parts", active_flags)

func apply_value() -> void:
	%PassiveIcon.visible = cell.value < 0
	%ActiveIcon.visible = cell.value < 0
