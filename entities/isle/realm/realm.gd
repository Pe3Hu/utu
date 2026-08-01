class_name Realm
extends Node2D


@export var domain_scene = preload("uid://cjgtra88saw87")
@export var bastion_scene = preload("uid://dqu1hfm51no6n")


@export var isle: Isle

var compositions: Array[CompositionData]

var composition_indexs: Array[int]

var data = RealmData.new()

var data_to_domain: Dictionary
var data_to_bastion: Dictionary
var current_domain: DomainData


#region init
func _ready() -> void:
	var board_size = (Catalog.BOARD_SIZE * 2  * 0.5 + Vector2.ONE * 0.5) * 48
	position = Vector2(get_parent().size / 2) - (board_size) * scale
	init_domains(Bozo.Domain.EARLDOM)
	init_bastions()

func init_domains(type_: Bozo.Domain) -> void:
	Helper.clear_children(%Domains)
	var domains = data.get_domains(type_)
	
	for earldom in domains:
		add_domain(earldom)

func add_domain(domain_data_: DomainData) -> void:
	var domain = domain_scene.instantiate()
	%Domains.add_child(domain)
	domain.data = domain_data_
	data_to_domain[domain_data_] = domain

func init_bastions() -> void:
	for bastion_data in data.bastions:
		add_bastion(bastion_data)

func add_bastion(bastion_data_: BastionData) -> void:
	var bastion = bastion_scene.instantiate()
	%Bastions.add_child(bastion)
	bastion.data = bastion_data_
#endregion

func highlight_domain() -> void:
	current_domain = data.earldoms[0]
	data_to_domain[current_domain].recolor(Color.GAINSBORO)
	
	for neighbour_domain in current_domain.neighbours:
		data_to_domain[neighbour_domain].recolor(Color.DIM_GRAY)

func _input(event) -> void:
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		match event.keycode:
			KEY_1:
				init_domains(Bozo.Domain.FIEFDOM)
			KEY_2:
				init_domains(Bozo.Domain.EARLDOM)
			KEY_3:
				init_domains(Bozo.Domain.DUKEDOM)
			KEY_4:
				init_domains(Bozo.Domain.KINGDOM)
			KEY_SPACE:
				highlight_domain()
