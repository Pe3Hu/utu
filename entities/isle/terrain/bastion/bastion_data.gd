class_name BastionData
extends RefCounted


signal rampart_changed
signal faction_changed

var terrain: TerrainData
var fiefdom: DomainData
var blob: BlobData
var region: RegionData
var settlement: SettlementData

var neighbour_to_channel: Dictionary

var faction: FactionData:
	set(value_):
		faction = value_
		faction_changed.emit()
var limit_rampart: int
var current_rampart: int:
	set(value_):
		if terrain.rampart_to_bastions.has(current_rampart):
			if terrain.rampart_to_bastions[current_rampart].has(self):
				terrain.rampart_to_bastions[current_rampart].erase(self)
		
		current_rampart = value_
		
		if not terrain.rampart_to_bastions.has(current_rampart):
			terrain.rampart_to_bastions[current_rampart] = []
		
		terrain.rampart_to_bastions[current_rampart].append(self)
		
		if terrain.isle.policy:
			var current_faction = terrain.isle.policy.current_faction
			
			if current_faction and current_faction.odeum:
				current_faction.odeum.current_scenario.update_critical_cantos()
		
		rampart_changed.emit()

var ring: int
var galore: float

var is_halocline: bool = false


#region init
func _init(fiefdom_: DomainData) -> void:
	fiefdom = fiefdom_
	terrain = fiefdom.realm.isle.terrain
	
	terrain.bastions.append(self)
	terrain.coord_to_bastion[get_coord()] = self
	
	reset_ramparts(Catalog.DEFAULT_RAMPART)
	calc_ring()

func reset_ramparts(value_: int) -> void:
	limit_rampart = int(value_)
	current_rampart = int(limit_rampart)

func calc_ring() -> void:
	var center = Catalog.REALM_SIZE.x / 2.0 - 0.5
	var dx = abs(get_coord().x - center)
	var dy = abs(get_coord().y - center)
	var distance = max(dx, dy)
	ring = int(floor(distance))
	ring = Catalog.BOARD_SIZE.x - 1 - mini(ring, Catalog.BOARD_SIZE.x - 1)

func establish_settlement() -> void:
	settlement = SettlementData.new(self)
	faction.settlements.append(settlement)
#endregion

func get_coord() -> Vector2i:
	return fiefdom.coords.front()

func get_flow_neighbour() -> Variant:
	var neighbour = null
	var options = fiefdom.neighbours.filter(func (a): return not terrain.visited_bastions.has(a.bastion))
	options = options.filter(func (a): return not terrain.current_flow_coords.has(a.bastion.get_coord()))
	options = options.filter(func (a): return a.bastion.faction and a.bastion.faction.type == Bozo.Faction.GREEN)
	if options.is_empty(): return neighbour
	var gap_to_options: Dictionary
	
	for option in options:
		var gap = current_rampart - option.bastion.current_rampart
		
		if gap > 0:
			if not gap_to_options.has(gap):
				gap_to_options[gap] = []
			
			gap_to_options[gap].append(option.bastion)
	
	var gaps = gap_to_options.keys()
	if gaps.is_empty(): return neighbour
	gaps.sort()
	var best_gap = gaps.front()
	neighbour = gap_to_options[best_gap].pick_random()
	return neighbour

func reset() -> void:
	blob = null
	neighbour_to_channel.clear()

func try_capture(canto_: CantoData) -> bool:
	canto_.hymn.scenario.hymns.erase(canto_.hymn)
	
	if current_rampart > canto_.pulse_value:
		current_rampart -= canto_.pulse_value
		return false
	else:
		terrain.isle.policy.current_faction.capture_bastion(self)
		
		if current_rampart != canto_.pulse_value:
			current_rampart = floor(limit_rampart * 0.5)
		else:
			current_rampart = limit_rampart
		
		return true
