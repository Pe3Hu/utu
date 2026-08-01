class_name Bastion
extends Sprite2D


var data: BastionData:
	set(value_):
		data = value_
		%Background.color = Digest.regard_to_color[data.regard]
		position = Vector2(data.fiefdom.coords.front()) * Catalog.BASTION_SIZE
		frame_coords = Helper.get_coord_based_on_value(data.current_rampart)
