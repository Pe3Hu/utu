class_name Hull
extends Node2D


@export var module_scene: PackedScene

var compositions: Array[CompositionData]

var composition_index: int = 0


func _ready() -> void:
	var board_size = Catalog.BOARD_SIZE * 64 * 0.5
	position = Vector2(get_viewport().size / 2) - board_size
	load_compositions()
	init_composition()

func load_compositions() -> void:
	var loader = CompositionLoader.new()
	compositions = loader.load_compositions("res://entities/hull/composition/compositions.json")
	print("compositions:", compositions.size())

func init_composition() -> void:
	Helper.clear_children(%Modules)
	if compositions.is_empty(): return
	
	for allocation in compositions[composition_index].allocations:
		add_module(allocation)

func add_module(allocation: AllocationData) -> void:
	var module = module_scene.instantiate()
	%Modules.add_child(module)
	module.allocation = allocation

func _input(event) -> void:
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		match event.keycode:
			KEY_SPACE:
				composition_index = (composition_index + 1) % compositions.size()
				init_composition()
