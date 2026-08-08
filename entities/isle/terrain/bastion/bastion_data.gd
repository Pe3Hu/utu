class_name BastionData
extends RefCounted


var terrain: TerrainData
var fiefdom: DomainData
var blob: BlobData
var region: RegionData

var neighbour_to_channel: Dictionary

var faction: Bozo.Faction = Bozo.Faction.GREEN
var limit_rampart: int
var current_rampart: int

var ring: int
var galore: float


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
#endregion

func get_coord() -> Vector2i:
	return fiefdom.coords.front()

func get_flow_neighbour() -> Variant:
	var neighbour = null
	var options = fiefdom.neighbours.filter(func (a): return not terrain.visited_bastions.has(a.bastion))
	options = options.filter(func (a): return not terrain.current_flow_coords.has(a.bastion.get_coord()))
	options = options.filter(func (a): return a.bastion.faction == Bozo.Faction.GREEN)
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
