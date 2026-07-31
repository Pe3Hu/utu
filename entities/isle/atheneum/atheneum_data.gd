class_name AtheneumData
extends Resource


var cards: Array[CardData]
var scenarios: Array[ScenarioData]

var pulse_to_count: Dictionary


#region init
func _init() -> void:
	test_pulses()
	#init_cards()
	#init_rolls()

func init_cards() -> void:
	cards.clear()
	var n = 3
	var intro_sum = 30
	
	var matters = Catalog.matters.duplicate()
	matters.shuffle()
	
	for _i in n:
		var matter = matters[_i]
		var intro = Digest.sum_to_matter_to_intro[intro_sum][matter].pick_random()
		var verse_index = Digest.matter_to_verse[matter].pick_random()
		var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
		add_card(matter, intro, verse)

func add_card(matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData) -> void:
	var card = CardData.new(matter_, intro_, verse_)
	cards.append(card)
#endregion

func init_rolls() -> void:
	for card in cards:
		card.roll_dices()
	
	calc_all_combos()

func calc_all_combos() -> void:
	scenarios.clear()
	var permutations = Helper.generate_permutations(cards)
	
	for permutation in permutations:
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = ScenarioData.new(permutation)
			scenarios.append(scenario)
	
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
				var scenario = ScenarioData.new(option)
				scenarios.append(scenario)
	
	for card in cards:
		var permutation = [card, null, null]
		
		if Helper.get_scenario_result(permutation) > 0:
			var scenario = ScenarioData.new(permutation)
			scenarios.append(scenario)

func test_pulses() -> void:
	pulse_to_count.clear()
	var total_rounds: int = 50000
	
	for pulse in Catalog.pulse_values:
		pulse_to_count[pulse] = 0 
	
	for _i in total_rounds:
		test_round()
	
	for pulse in Catalog.pulse_values:
		var percent = float(pulse_to_count[pulse]) / total_rounds * 100
		print(str(snapped(percent, 0.1)).replace(".",","))
	
func test_round() -> void:
	init_cards()
	init_rolls()
	calc_all_combos()
	scenarios.sort_custom(func (a, b): return a.result > b.result)
	pulse_to_count[scenarios.front().result] += 1
