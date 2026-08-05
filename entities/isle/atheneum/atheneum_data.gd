class_name AtheneumData
extends RefCounted


var tribunal: TribunalData = TribunalData.new(self)
var origins: Array[OriginData]
var scenarios: Array[ScenarioData]



#region init
func _init() -> void:
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
	var stamp_queue = tribunal.actual.stamps.duplicate()
	var scenario = ScenarioData.new(self, stamp_queue)
	print(scenario.total_sum)
#endregion
