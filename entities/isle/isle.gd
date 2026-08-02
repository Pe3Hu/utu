class_name Isle
extends Control


var data: IsleData:
	set(value_):
		data = value_
		connect_datas()

@export var atheneum: Atheneum
@export var realm: Realm
@export var terrain: Terrain


func _ready() -> void:
	data = IsleData.new()

func connect_datas() -> void:
	realm.data = data.realm
	terrain.data = data.terrain
