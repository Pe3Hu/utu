class_name Home 
extends Control


@export var isle_scene = preload("uid://b4uxyqcdfn3uo")


func _ready() -> void:
	await get_tree().process_frame
	_on_cards_btn_pressed()

func _on_cards_btn_pressed() -> void:
	get_tree().change_scene_to_packed(isle_scene)
