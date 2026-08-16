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
@export var forge: Forge
@export var hierarchy: Hierarchy


func _ready() -> void:
	data = IsleData.new()
	Arbitrator.start_new_round()
	
	var settlement = data.policy.current_faction.settlements.front()
	stepladder.data = settlement.stepladder

func connect_datas() -> void:
	kernel.data = data.kernel
	atheneum.data = data.atheneum
	odeum.data = data.odeum
	
	realm.data = data.realm
	terrain.data = data.terrain
	
	forge.data = data.forge
	hierarchy.data = data.hierarchy

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_S:
				Gear.is_pause = !Gear.is_pause
				Arbitrator.start_next_phase()
			KEY_ESCAPE:
				get_tree().quit()
