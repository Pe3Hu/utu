class_name Realm
extends Node2D


@export var domain_scene = preload("uid://cjgtra88saw87")
@export var crossroad_scene = preload("uid://bo3b1skq20ak8")


@export var isle: Isle

var compositions: Array[CompositionData]

var composition_indexs: Array[int]

var data: RealmData:
	set(value_):
		data = value_
		
		init_domains(Bozo.Domain.EARLDOM)
		init_crossroads()

var data_to_domain: Dictionary
var current_domain: DomainData

var enclave_index: int = 0


#region init
func _ready() -> void:
	var board_size = (Catalog.BOARD_SIZE * 2  * 0.5 + Vector2.ONE * 0.5) * 48
	position = Vector2(get_parent().size / 2) - (board_size) * scale

func init_domains(type_: Bozo.Domain) -> void:
	if data == null: return
	Helper.clear_children(%Domains)
	var domains = data.get_domains(type_)
	
	for domain_data in domains:
		add_domain(domain_data)

func add_domain(domain_data_: DomainData) -> void:
	var domain = domain_scene.instantiate()
	%Domains.add_child(domain)
	domain.data = domain_data_
	data_to_domain[domain_data_] = domain

func init_crossroads() -> void:
	Helper.clear_children(%Crossroads)
	
	for crossroad_data in data.crossroads:
		add_crossroad(crossroad_data)

func add_crossroad(crossroad_data_: CrossroadData) -> void:
	var crossroad = crossroad_scene.instantiate()
	%Crossroads.add_child(crossroad)
	crossroad.data = crossroad_data_
#endregion

func highlight_domain() -> void:
	current_domain = data.earldoms[0]
	data_to_domain[current_domain].recolor(Color.GAINSBORO)
	
	for neighbour_domain in current_domain.neighbours:
		data_to_domain[neighbour_domain].recolor(Color.DIM_GRAY)

func show_next_enclave(hide_: bool = false) -> void:
	var mother_domain = data.current_enclave.mothers[enclave_index]
	var father_domain = data.current_enclave.fathers[enclave_index]
	
	data_to_domain[mother_domain].recolor(Color.WHITE)
	data_to_domain[father_domain].recolor(Color.WHITE)
	if hide_: return
	enclave_index = (enclave_index + 1) % data.current_enclave.mothers.size()
	
	mother_domain = data.current_enclave.mothers[enclave_index]
	father_domain = data.current_enclave.fathers[enclave_index]
	
	data_to_domain[mother_domain].recolor(Color.DIM_GRAY)
	data_to_domain[father_domain].recolor(Color.DIM_GRAY)

func change_enclave_size() -> void:
	show_next_enclave(true)
	var index = data.enclaves.find(data.current_enclave)
	index = (index - 1 + data.enclaves.size()) % data.enclaves.size()
	data.current_enclave = data.enclaves[index]
	enclave_index = 0
	show_next_enclave()
	print([data.current_enclave.mothers.size()])

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
			KEY_Q:
				show_next_enclave()
			KEY_W:
				change_enclave_size()
				
				
