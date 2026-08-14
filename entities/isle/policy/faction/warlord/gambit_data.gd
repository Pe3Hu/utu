class_name GambitData
extends RefCounted


var warlord: WarlordData
var foothold: BastionData
var direction: Vector2i
var depth: int

var raids: Array[RaidData]

var total_overrun: int
var total_profit: int


#region init
func _init(warlord_: WarlordData, foothold_: BastionData, direction_: Vector2i, depth_: int = 1) -> void:
	warlord = warlord_
	foothold = foothold_
	direction = direction_
	depth = depth_
	
	if is_it_possible():
		warlord.gambits.append(self)
		
		if not warlord.length_to_gambits.has(raids.size()):
			warlord.length_to_gambits[raids.size()] = []
		
		warlord.length_to_gambits[raids.size()].append(self)
		calc_totals()
	else:
		raids.clear()

func is_it_possible() -> bool:
	var hymns = warlord.faction.odeum.current_scenario.hymns.duplicate()
	var bastions = []
	var raid_bastion = foothold
	
	for _i in depth:
		if raid_bastion.fiefdom.direction_to_fiefdom.has(direction):
			raid_bastion = raid_bastion.fiefdom.direction_to_fiefdom[direction].bastion
			bastions.append(raid_bastion)
		else:
			return false
	
	var jugs = []
	
	for bastion in bastions:
		var jug = {
			"bastion": bastion,
			"current_volume": 0,
			"target_volume": bastion.current_rampart
		}
		jugs.append(jug)
	
	var cups  = []
	
	for hymn in hymns:
		var cup = {
			"canto": hymn.get_canto_with_max_pulse(),
			"volume": hymn.get_canto_with_max_pulse().pulse_value
		}
		cups.append(cup)
	
	var result = Helper.find_optimal_spills(jugs, cups)
	
	for obj in result:
		raid_bastion = bastions[obj.jug]
		var raid_cantos = []
		 
		for _i in obj.cups:
			raid_cantos.append(hymns[_i].get_canto_with_max_pulse())
		
		var _raid = RaidData.new(self, raid_bastion, raid_cantos)
	
	if result.size() < depth:
		return false
	
	
	
	return true

func calc_totals() -> void:
	total_overrun = 0
	total_profit = 0
	
	for raid in raids:
		total_overrun += raid.overrun
		var profit = raid.bastion.limit_rampart
		
		if raid.overrun != 0:
			profit = floor(profit * 0.5)
		
		total_profit += profit
#endregion

func launch() -> void:
	for raid in raids:
		raid.launch()
	
	warlord.faction.isle.terrain.externals_changed.emit()
