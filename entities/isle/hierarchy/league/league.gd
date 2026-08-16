class_name League
extends Node2D


var data: LeagueData:
	set(value_):
		data = value_
		
		position.x = (data.anchor.x - 1) * (Catalog.LEAGUE_SIZE.x + Catalog.LEAGUE_BORDER)
		position.y = data.anchor.y * (Catalog.LEAGUE_SIZE.x + Catalog.LEAGUE_BORDER)
	
		%Borders.set_cells_terrain_connect(data.coords, 0, 0, true)
		update_emblem()


func update_emblem() -> void:
	var x = 1
	var y = 1
	var l = Catalog.LEAGUE_SIZE.x + Catalog.LEAGUE_BORDER * 2
	var points = []
	var point = Vector2(0, 0) * l
	points.append(point)
	point = Vector2(x, 0) * l
	points.append(point)
	point = Vector2(x, y) * l
	points.append(point)
	point = Vector2(0, y) * l
	points.append(point)
	%Emblem.polygon = points
