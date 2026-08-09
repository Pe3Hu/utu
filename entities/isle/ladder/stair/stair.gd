class_name Stair
extends Node2D


var data: StairData:
	set(value_):
		data = value_
		
		position = Vector2(Digest.volume_to_coord[data.volume]) * Catalog.STAIR_SIZE
		%Number.texture = load("res://entities/dice/images/%d.png" % data.volume)

var is_current: bool:
	set(value_):
		is_current = value_
		%Highlight.visible = is_current
