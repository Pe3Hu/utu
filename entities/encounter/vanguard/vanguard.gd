class_name Vanguard
extends PanelContainer



func _input(event) -> void:
	if event is InputEventKey and not event.is_echo() and event.pressed:
		match event.keycode:
			KEY_SPACE:
				%Spinner.spin()
