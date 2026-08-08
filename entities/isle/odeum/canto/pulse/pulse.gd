class_name Pulse
extends PanelContainer



@export var value: int = 0:
	set(value_):
		value = value_
		%Number.texture = load("res://entities/dice/images/%d.png" % value)
