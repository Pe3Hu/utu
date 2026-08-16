class_name RealmData
extends RefCounted


var isle: IsleData

var compositions: Array[CompositionData]
var fiefdoms: Array[DomainData] = []
var earldoms: Array[DomainData] = []
var dukedoms: Array[DomainData] = []
var kingdoms: Array[DomainData] = []

var coord_to_fiefdom: Dictionary = {}

var crossroads: Array[CrossroadData]

var enclaves: Array[EnclaveData]
var shape_to_shape_to_enclave: Dictionary
var current_enclave: EnclaveData


func _init(isle_: IsleData) -> void:
	isle = isle_
	
	load_compositions()
	init_domains()
	init_crossroads()
	init_enclaves()

func load_compositions() -> void:
	var loader = CompositionLoader.new()
	compositions = loader.load_compositions("res://entities/isle/realm/composition/compositions.json")

#region domains
func init_domains() -> void:
	clear_domains()
	init_earldoms()
	init_groups(Bozo.Domain.DUKEDOM)
	init_groups(Bozo.Domain.KINGDOM)
	validate()

func clear_domains() -> void:
	fiefdoms.clear()
	earldoms.clear()
	dukedoms.clear()
	kingdoms.clear()
	coord_to_fiefdom.clear()

func init_earldoms() -> void:
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
	earldom.shape = allocation_.orientation.shape.type
	
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
	var groups = solver.solve(vassals, Digest.domain_to_size[type_])
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

func init_crossroads() -> void:
	for _y in Catalog.BOARD_SIZE.y * 2 - 2:
		for _x in Catalog.BOARD_SIZE.x * 2 - 2:
			var unique_earldoms: Array
			var bastions: Array[BastionData]
			
			for corner in Catalog.corners:
				var coord = Vector2i(_x, _y) + corner
				
				if not coord_to_fiefdom.has(coord):
					break
				
				var fiefdom = coord_to_fiefdom[coord]
				bastions.append(fiefdom.bastion)
				
				if not unique_earldoms.has(fiefdom.suzerain):
					unique_earldoms.append(fiefdom.suzerain)
				else:
					break
			
			if unique_earldoms.size() == Catalog.corners.size():
				var _crossroad = CrossroadData.new(self, bastions)

func init_enclaves() -> void:
	enclaves.clear()
	shape_to_shape_to_enclave.clear()
	
	for _i in Catalog.shapes.size():
		for _j in range(_i, Catalog.shapes.size(), 1):
			var shapes = [Catalog.shapes[_i], Catalog.shapes[_j]]
			var _enclave = EnclaveData.new(self, shapes)
	
	for mother_earldom in earldoms:
		for father_earldom in mother_earldom.neighbours:
			var enclave = shape_to_shape_to_enclave[mother_earldom.shape][father_earldom.shape]
			
			if not enclave.mothers.has(father_earldom):
				enclave.mothers.append(mother_earldom)
				enclave.fathers.append(father_earldom)
	
	for _i in range(enclaves.size()-1, -1, -1):
		var enclave = enclaves[_i]
		
		if enclave.mothers.is_empty():
			shape_to_shape_to_enclave[enclave.shapes[0]].erase(enclave.shapes[1])
			shape_to_shape_to_enclave[enclave.shapes[1]].erase(enclave.shapes[0])
			enclaves.erase(enclave) 
	
	enclaves.sort_custom(func (a, b): return a.mothers.size() < b.mothers.size())
	
	var length_to_size = {}
	
	for enclave in enclaves:
		var l = enclave.mothers.size()
		
		if not length_to_size.has(l):
			length_to_size[l] = 0
		
		length_to_size[l] += 1
	
	for l in length_to_size:
		print([l, length_to_size[l]])
	
	current_enclave = enclaves.back()
#endregion
