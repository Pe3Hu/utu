class_name Atheneum 
extends PanelContainer


@export var card_overlap_scene = preload("uid://cfe1p2qnaebxk")
@export var scenario_scene = preload("uid://d2rqlehdldi5j")

var data: AtheneumData = AtheneumData.new()

@export var isle: Isle
@export var overlaps: Array[CardOverlap]

var current_overlap: CardOverlap


#region init
func _ready() -> void:
	init_overlaps()
	#init_rolls()
	pass

func init_overlaps() -> void:
	for card_data in data.cards:
		add_card(card_data)

func add_card(card_data_: CardData) -> void:
	var overlap = card_overlap_scene.instantiate()
	%Overlaps.add_child(overlap)
	overlap.atheneum = self
	overlap.card.data = card_data_
	overlaps.append(overlap)
	overlap.card.apply_result()

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
	
	#for scenario in scenarios:
	#	scenario.print_result()
