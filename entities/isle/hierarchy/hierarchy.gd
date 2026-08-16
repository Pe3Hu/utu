class_name Hierarchy
extends Node2D


@export var league_scene = preload("uid://72g3d2d8xtui")

var data: HierarchyData:
	set(value_):
		data = value_
		
		update_position()
		init_leagues()


func update_position() -> void:
	position = get_parent().size / 2
	position.x -= data.leagues.size() * (Catalog.LEAGUE_SIZE.x + Catalog.LEAGUE_BORDER) / 2

func init_leagues() -> void:
	Helper.clear_children(self)
	
	for league_data in data.leagues:
		add_league(league_data)

func add_league(league_data_) -> void:
	var league = league_scene.instantiate()
	add_child(league)
	league.data = league_data_
