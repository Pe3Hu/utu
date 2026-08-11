class_name Isle
extends Control


var data: IsleData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel
@export var atheneum: Atheneum
@export var odeum: Odeum

@export var realm: Realm
@export var terrain: Terrain

@export var stepladder: Stepladder


func _ready() -> void:
	data = IsleData.new()
	
	var faction = data.policy.type_to_faction[Bozo.Faction.BLUE]
	var settlement = faction.settlements.front()
	stepladder.data = settlement.stepladder
	
	Arbitrator.chronicler = faction.chronicler

func connect_datas() -> void:
	kernel.data = data.kernel
	atheneum.data = data.atheneum
	odeum.data = data.odeum
	
	realm.data = data.realm
	terrain.data = data.terrain

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
