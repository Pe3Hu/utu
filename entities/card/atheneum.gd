class_name Atheneum 
extends Control


@export var card_scene = preload("uid://cbet0tqjycopk")
@export var card_overlap_scene = preload("uid://cfe1p2qnaebxk")

@export var overlaps: Array[CardOverlap]


var current_overlap: CardOverlap


#region init
func _ready() -> void:
	init_overlaps()

func init_overlaps() -> void:
	var n = 3
	var intros: Array[IntroDiceData]
	intros.append(load("res://entities/dice/datas/intro/20_2.tres"))
	intros.append(load("res://entities/dice/datas/intro/20_3.tres"))
	intros.append(load("res://entities/dice/datas/intro/20_4.tres"))
	
	var verses: Array[VerseDiceData]
	verses.append(load("res://entities/dice/datas/verse/34.tres"))
	verses.append(load("res://entities/dice/datas/verse/35.tres"))
	verses.append(load("res://entities/dice/datas/verse/36.tres"))
	
	for _i in n:
		var intro = intros[_i]
		var verse = verses[_i]
		add_card(intro, verse)

func add_card(intro_data_: IntroDiceData, verse_data_: VerseDiceData) -> void:
	var overlap = card_overlap_scene.instantiate()
	%Overlaps.add_child(overlap)
	overlap.atheneum = self
	overlap.card.intro.dice = intro_data_
	overlap.card.verse.dice = verse_data_
	overlaps.append(overlap)

func remove_card() -> void:
	if %Overlaps.get_child_count() == 0: return
	%Overlaps.get_children().back().destroy()
	overlaps.pop_back()
#endregion

func reverse_overlap_z_indexs(is_default: bool = false) -> void:
	for overlap in overlaps:
		overlap.reverse_z_index(is_default)
