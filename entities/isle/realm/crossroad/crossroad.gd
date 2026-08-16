class_name Crossroad
extends Sprite2D


var data: CrossroadData:
	set(value_):
		data = value_
		
		position = Vector2(data.coord) * Catalog.BASTION_SIZE
