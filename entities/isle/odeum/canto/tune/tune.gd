@tool
class_name Tune
extends PanelContainer


var data: TuneData:
	set(value_):
		data = value_
		call_deferred("update_icons")

@export var canto: Canto
@export var cell: DragDropCell


func update_icons() -> void:
	var passive_flags: Array[bool]
	var active_flags: Array[bool]
	
	for _i in Catalog.tunes.size():
		var flag = Catalog.tunes[_i] == data.type
		passive_flags.append(!flag)
		active_flags.append(flag)
	
	%PassiveIcon.material.set_shader_parameter("parts", passive_flags)
	%ActiveIcon.material.set_shader_parameter("parts", active_flags)

#func apply_value() -> void:
	#%PassiveIcon.visible = cell.value < 0
	#%ActiveIcon.visible = cell.value < 0
	#
	#match data.type:
		#Bozo.Tune.INTRO:
			#canto.pulse.value += cell.value
		#Bozo.Tune.VERSE:
			#canto.pulse.value += cell.value
		#Bozo.Tune.OUTRO:
			#canto.pulse.value *= cell.value
