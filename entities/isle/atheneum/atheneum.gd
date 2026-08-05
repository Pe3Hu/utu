class_name Atheneum 
extends PanelContainer


@export var card_scene = preload("uid://cfe1p2qnaebxk")
@export var scenario_scene = preload("uid://d2rqlehdldi5j")

var data: AtheneumData:
	set(value_):
		data = value_
		
		init_cards()

@export var isle: Isle
@export var cards: Array[Card]

var current_card: Card


#region init
func _ready() -> void:
	#init_cards()
	#init_rolls()
	pass

func init_cards() -> void:
	for stamp_data in data.tribunal.actual.stamps:
		add_card(stamp_data)

func add_card(stamp_data_: StampData) -> void:
	var card = card_scene.instantiate()
	%Cards.add_child(card)
	card.atheneum = self
	card.stamp.data = stamp_data_
	cards.append(card)

func remove_card() -> void:
	if %Cards.get_child_count() == 0: return
	%Cards.get_children().back().destroy()
	cards.pop_back()
#endregion

func shift_card(card_: Card, shift_: int) -> void:
	var new_index = card_.get_index() + shift_
	if new_index < 0 or new_index >= %Cards.get_child_count(): return
	%Cards.move_child(card_, new_index)

func init_rolls() -> void:
	for card in cards:
		card.card.roll_nets()
	
	await get_tree().create_timer(0.2).timeout
	calc_all_combos()

func calc_all_combos() -> void:
	var permutations = Helper.generate_permutations(cards)
	
	for permutation in permutations:
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = scenario_scene.instantiate()
			%Scenarios.add_child(scenario)
			scenario.apply_permutation(permutation)
	
	var arrangements = Helper.generate_arrangements_fixed_size(cards, 2)
	
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
	
	for card in cards:
		var permutation = [card, null, null]
		
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = scenario_scene.instantiate()
			%Scenarios.add_child(scenario)
			scenario.apply_permutation(permutation)
	
	var scenarios = %Scenarios.get_children()
	scenarios.sort_custom(func (a, b): return a.result > b.result)
	
	#for scenario in scenarios:
	#	scenario.print_result()
