@tool
class_name Canto
extends PanelContainer


var data: CantoData:
	set(value_):
		data = value_
		
		connect_datas()

@export var pulse: Pulse

@export var intro: Tune
@export var verse: Tune
@export var outro: Tune


func connect_datas() -> void:
	pulse.value = data.pulse_value
	intro.data = data.intro
	
	if data.verse:
		verse.data = data.verse
		verse.visible = true
	else:
		verse.visible = false
	
	if data.outro:
		outro.data = data.outro
		outro.visible = true
	else:
		outro.visible = false
