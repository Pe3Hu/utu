class_name Isle
extends Control


var data: IsleData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel
@export var atheneum: Atheneum
@export var realm: Realm
@export var terrain: Terrain


func _ready() -> void:
	data = IsleData.new()

func connect_datas() -> void:
	kernel.data = data.kernel
	atheneum.data = data.atheneum
	realm.data = data.realm
	terrain.data = data.terrain


func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
