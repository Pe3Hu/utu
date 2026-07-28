class_name Atheneum 
extends Control


@export var card_overlap_scene = preload("uid://cfe1p2qnaebxk")
@export var scenario_scene = preload("uid://d2rqlehdldi5j")

@export var overlaps: Array[CardOverlap]


var current_overlap: CardOverlap


#region init
func _ready() -> void:
	init_overlaps()
	init_rolls()

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
	
	var matters = Catalog.matters.duplicate()
	
	for _i in n:
		var matter = matters[_i]
		var intro = intros[_i]
		var verse = verses[_i]
		add_card(matter, intro, verse)

func add_card(matter_: Bozo.Matter, intro_data_: IntroDiceData, verse_data_: VerseDiceData) -> void:
	var overlap = card_overlap_scene.instantiate()
	%Overlaps.add_child(overlap)
	overlap.atheneum = self
	overlap.card.matter = matter_
	overlap.card.intro.dice = intro_data_
	overlap.card.verse.dice = verse_data_
	overlaps.append(overlap)

func remove_card() -> void:
	if %Overlaps.get_child_count() == 0: return
	%Overlaps.get_children().back().destroy()
	overlaps.pop_back()
#endregion

func init_rolls() -> void:
	for overlap in overlaps:
		overlap.card.roll_nets()
	
	await get_tree().create_timer(0.2).timeout
	calc_all_combos()

func calc_all_combos() -> void:
	var permutations = Helper.generate_permutations(overlaps)
	
	for permutation in permutations:
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = scenario_scene.instantiate()
			%Scenarios.add_child(scenario)
			scenario.apply_permutation(permutation)
	
	var arrangements = Helper.generate_arrangements_fixed_size(overlaps, 2)
	
	for arrangement in arrangements:
		var options = [
			arrangement.duplicate(),
			arrangement.duplicate()
		]
		
		options[0].insert(1, null)
		options[1].insert(2, null)
		
		for option in options:
			if Helper.get_scenario_result(option) > 0:
				var scenario = scenario_scene.instantiate()
				%Scenarios.add_child(scenario)
				scenario.apply_permutation(option)
	
	for overlap in overlaps:
		var permutation = [overlap, null, null]
		
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = scenario_scene.instantiate()
			%Scenarios.add_child(scenario)
			scenario.apply_permutation(permutation)
	
	var scenarios = %Scenarios.get_children()
	scenarios.sort_custom(func (a, b): return a.result > b.result)
	
	for scenario in scenarios:
		scenario.print_result()
