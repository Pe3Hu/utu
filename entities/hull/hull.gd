class_name Hull
extends Node2D


@export var module_scene: PackedScene

var compositions: Array[CompositionData]

var composition_indexs: Array[int]

var realm = RealmData.new()

var domain_to_module: Dictionary
var current_domain: DomainData


#region init
func _ready() -> void:
	var board_size = (Catalog.BOARD_SIZE * 2  * 0.5 + Vector2.ONE * 0.5) * 64
	position = Vector2(get_viewport().size / 2) - (board_size) * scale
	init_modules(Bozo.Domain.EARLDOM)

func init_modules(type_: Bozo.Domain) -> void:
	Helper.clear_children(%Modules)
	var domains = realm.get_domains(type_)
	
	for earldom in domains:
		add_module(earldom)

func add_module(domain_: DomainData) -> void:
	var module = module_scene.instantiate()
	%Modules.add_child(module)
	module.domain = domain_
	domain_to_module[domain_] = module
#endregion

func highlight_domain() -> void:
	current_domain = realm.earldoms[0]
	domain_to_module[current_domain].recolor(Color.GAINSBORO)
	
	for neighbour_domain in current_domain.neighbours:
		domain_to_module[neighbour_domain].recolor(Color.DIM_GRAY)

func _input(event) -> void:
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		match event.keycode:
			KEY_1:
				init_modules(Bozo.Domain.FIEFDOM)
			KEY_2:
				init_modules(Bozo.Domain.EARLDOM)
			KEY_3:
				init_modules(Bozo.Domain.DUKEDOM)
			KEY_4:
				init_modules(Bozo.Domain.KINGDOM)
			KEY_SPACE:
				highlight_domain()
