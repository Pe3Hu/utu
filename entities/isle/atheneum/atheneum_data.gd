class_name AtheneumData
extends RefCounted


var faction: FactionData

var tribunal: TribunalData
var origins: Array[OriginData]
var scenarios: Array[ScenarioData]

var test_sums = {}
var test_pulses = {}


#region init
func _init(faction_: FactionData) -> void:
	faction = faction_
	
	tribunal = TribunalData.new(self)
	init_origins()
	preparation()
	#init_test()

func init_origins() -> void:
	origins.clear()
	var n = 2
	var intro_sum = 20
	
	var matters = Catalog.matters.duplicate()
	
	for _i in n:
		var matter = matters[_i]
		var intro = Digest.sum_to_matter_to_intro[intro_sum][matter][0]
		var verse_index = Digest.matter_to_verse[matter].pick_random()
		var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
		var _origin = OriginData.new(self, matter, intro, verse)
	
	tribunal.hereafter.stamps.shuffle()

func init_scenarios() -> void:
	init_permutations()
	#var stamp_queue = tribunal.actual.stamps.duplicate()
	#var scenario = ScenarioData.new(self, stamp_queue)
	#print(scenario.total_sum)
#endregion

func preparation() -> void:
	tribunal.refill_actual()
	faction.treasury.kernel.fleet.stamps.append_array(tribunal.actual.stamps)
	init_scenarios()

func init_permutations() -> void:
	scenarios.clear()
	var stamp_queue = tribunal.actual.stamps.duplicate()
	var permutations = Helper.generate_permutations(stamp_queue)
	var spoils: Array[StampData]
	
	for permutation in permutations:
		var _scenario = ScenarioData.new(self, permutation, spoils)
	
	for _i in range(2, stamp_queue.size() - 2, 1):
		var arrangements = Helper.generate_arrangements_fixed_size(stamp_queue, _i)
	
		for arrangement in arrangements:
			spoils = stamp_queue.filter(func (a): return not arrangement.has(a))
			var _scenario = ScenarioData.new(self, arrangement, spoils)
	
	
	scenarios.sort_custom(func (a, b): return a.total_sum > b.total_sum)
	if faction.type == Bozo.Faction.BLUE:
		print([scenarios.front().total_sum, scenarios.front().pulses])
	faction.odeum.scenario = scenarios.front()
	

func init_test() -> void:
	var k_pulse = 0
	var k_sum = 0
	
	for _i in 50000:
		tribunal.reset()
		init_origins()
		preparation()
		var test_sum = scenarios.front().total_sum
		
		for _j in scenarios.size():
			var test_scenario = scenarios[_j]
			
			if test_scenario.total_sum == test_sum:
				k_sum += 1
				
				if !test_sums.has(test_sum):
					test_sums[test_sum] = 0
				
				test_sums[test_sum] += 1
				
				for pulse in test_scenario.pulses:
					if !test_pulses.has(pulse):
						test_pulses[pulse] = 0
					
					test_pulses[pulse] += 1
					k_pulse += 1
	
	var sum_keys = test_sums.keys()
	sum_keys.sort()
	
	print("sum")
	
	for sum in sum_keys:
		var perc = snappedf(float(test_sums[sum]) / k_sum * 100, 0.1)
		if perc > 0:
			print([sum, perc])
	
	print("pulse")
	
	for pulse in Catalog.pulses:
		if test_pulses.has(pulse):
			var perc = snappedf(float(test_pulses[pulse]) / k_pulse * 100, 0.1)
			print([pulse, perc])
