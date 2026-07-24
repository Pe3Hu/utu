class_name World
extends Node


@export var encounter: Encounter



func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				pass
			KEY_ESCAPE:
				get_tree().quit()
	
