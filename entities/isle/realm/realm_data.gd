class_name RealmData
extends RefCounted

var compositions: Array[CompositionData]
var fiefdoms: Array[DomainData] = []
var earldoms: Array[DomainData] = []
var dukedoms: Array[DomainData] = []
var kingdoms: Array[DomainData] = []

var coord_to_fiefdom: Dictionary = {}

var bastions: Array[BastionData] = []
var regard_to_order_to_shrines: Dictionary


func _init() -> void:
	load_compositions()
	init_earldoms()
	init_groups(Bozo.Domain.DUKEDOM)
	init_groups(Bozo.Domain.KINGDOM)
	validate()
	init_shrines()

func load_compositions() -> void:
	var loader = CompositionLoader.new()
	compositions = loader.load_compositions("res://entities/isle/realm/composition/compositions.json")

#region domains
func clear_domains() -> void:
	fiefdoms.clear()
	earldoms.clear()
	dukedoms.clear()
	kingdoms.clear()
	coord_to_fiefdom.clear()

func init_earldoms() -> void:
	clear_domains()
	if compositions.is_empty(): return
	
	var options: Array = Array(range(compositions.size()))
	options.shuffle()
	options.resize(Catalog.corners.size())
	var twists: Array = Array(range(options.size()))
	twists.shuffle()
	
	for _i in options.size():
		var corner = Catalog.corners[_i] * Catalog.BOARD_SIZE
		
		for allocation in compositions[options[_i]].allocations:
			allocation.twist = twists[_i]
			allocation.corner = corner
			add_earldom(allocation)
	
	init_neighbours(Bozo.Domain.FIEFDOM)
	init_neighbours(Bozo.Domain.EARLDOM)

func add_earldom(allocation_: AllocationData) -> void:
	var earldom = DomainData.new(self, Bozo.Domain.EARLDOM, allocation_.coords)
	earldoms.append(earldom)
	
	for _coord in allocation_.coords:
		var fiefdom = DomainData.new(self, Bozo.Domain.FIEFDOM, [_coord])
		fiefdoms.append(fiefdom)
		earldom.add_vassal(fiefdom)
		coord_to_fiefdom[_coord] = fiefdom

func get_domains(type_: Bozo.Domain) -> Array[DomainData]:
	var path = Bozo.enum_to_string(Bozo.Type.DOMAIN, type_)
	return get("%ss" % path)

func init_neighbours(type_: Bozo.Domain) -> void:
	var domains = get_domains(type_)
	if domains.is_empty(): return
	
	for domain in domains:
		for coord in domain.coords:
			for direction in Catalog.directions:
				var neighbour_coord = direction + coord
				
				if coord_to_fiefdom.has(neighbour_coord):
					var fiefdom = coord_to_fiefdom[neighbour_coord]
					var neighbour = fiefdom.get_superior(type_)
					
					if neighbour != domain and !domain.neighbours.has(neighbour):
						domain.add_neighbour(neighbour)

func init_groups(type_: Bozo.Domain) -> void:
	var solver = PartitionSolver.new()
	var vassals = get_domains(Digest.domain_to_vassal[type_])
	var groups = solver.solve(vassals, Digest.domaint_to_size[type_])
	create_domains(groups, type_)
	init_neighbours(type_)

func create_domains(groups: Array, type_: Bozo.Domain) -> void:
	var domains = get_domains(type_)
	
	for group in groups:
		var coords: Array[Vector2i] = []
		
		for domain in group:
			for coord in domain.coords:
				coords.append(coord)
		
		var domain = DomainData.new(self, type_, coords)
		
		for vassal: DomainData in group:
			domain.add_vassal(vassal)
		
		domains.append(domain)

func validate() -> void:
	assert(fiefdoms.size() == 240)
	assert(earldoms.size() == 48)
	assert(dukedoms.size() == 12)
	assert(kingdoms.size() == 4)
	
	for e in earldoms:
		assert(e.vassals.size() == 5)
	for d in dukedoms:
		assert(d.vassals.size() == 4)
	for k in kingdoms:
		assert(k.vassals.size() == 3)
#endregion

func init_shrines() -> void:
	regard_to_order_to_shrines.clear()
	var regards = [Bozo.Regard.ALLY, Bozo.Regard.ENEMY]
	
	for regard in regards:
		regard_to_order_to_shrines[regard] = {}
	
	for order in Catalog.shrines.size():
		for regard in regards:
			regard_to_order_to_shrines[regard][order] = []
		
		for shrine in Catalog.shrines[order]:
			for corner_index in Catalog.corners.size():
				var is_even: bool = (order + corner_index) % 2 == 0
				var regard = Digest.flag_to_regard[is_even]
				
				var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
				var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
				regard_to_order_to_shrines[regard][order].append(coord)
				var bastion = coord_to_fiefdom[coord].bastion
				bastion.regard = regard
