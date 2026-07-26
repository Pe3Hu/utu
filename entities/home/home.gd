class_name Home 
extends Control

@export var cards_scene = preload("uid://bhlusn1ccigiy")


func _ready() -> void:
	await get_tree().process_frame
	_on_cards_btn_pressed()

func _on_cards_btn_pressed() -> void:
	get_tree().change_scene_to_packed(cards_scene)
