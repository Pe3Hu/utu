class_name Home 
extends Control

@export var cards_scene = preload("uid://bhlusn1ccigiy")


func _on_cards_btn_pressed() -> void:
	get_tree().change_scene_to_packed(cards_scene)
