class_name Channel
extends Line2D


var data: ChannelData:
	set(value_):
		data = value_
		points = data.get_points()
