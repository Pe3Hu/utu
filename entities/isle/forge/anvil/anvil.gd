class_name Anvil
extends PanelContainer


var data: AnvilData:
	set(value_):
		data = value_
		connect_datas()

@export var forge: Forge

@export var old_stamps: Array[Stamp]


func connect_datas() -> void:
	for _i in data.stamps.size():
		var stamp = old_stamps[_i]
		stamp.data = data.stamps[_i]
		stamp.visible = true
	
	%NewStamp.data = data.new_stamp

func _on_fusion_button_pressed() -> void:
	data.fusion()
