class_name AtheneumData
extends RefCounted


var isle: IsleData

var tribunal: TribunalData = TribunalData.new(self)
var origins: Array[OriginData]
var scenarios: Array[ScenarioData]



#region init
func _init(isle_: IsleData) -> void:
	isle = isle_
	init_origins()
	init_scenarios()

func init_origins() -> void:
	origins.clear()
	var n = 1
	var intro_sum = 20
	
	var matters = Catalog.matters.duplicate()
	matters.resize(1)
	#matters.shuffle()
	
	for _i in n:
		var matter = matters[_i]
		var intro = Digest.sum_to_matter_to_intro[intro_sum][matter][0]
		var verse_index = Digest.matter_to_verse[matter].pick_random()
		var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
		var _origin = OriginData.new(self, matter, intro, verse)

func init_scenarios() -> void:
	tribunal.refill_actual()
	isle.kernel.fleet.stamps.append_array(tribunal.actual.stamps)
	init_permutations()
	#var stamp_queue = tribunal.actual.stamps.duplicate()
	#var scenario = ScenarioData.new(self, stamp_queue)
	#print(scenario.total_sum)
#endregion

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
	
	for scenario in scenarios:
		print([scenario.total_sum, scenario.pulses])
