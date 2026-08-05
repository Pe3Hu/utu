class_name TerrainData
extends RefCounted



var isle: IsleData
var flows: Array[FlowData]
var channels: Array[ChannelData]

var bastions: Array[BastionData]
var coord_to_bastion: Dictionary
var rampart_to_bastions: Dictionary

var visited_bastions: Array[BastionData]
var current_flow_coords: Array[Vector2i]

var regions: Array[RegionData]
var type_to_regions: Dictionary

var biomes: Array[BiomeData]
var type_to_biomes: Dictionary



#region init
func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_regions()

func init_regions() -> void:
	type_to_regions.clear()
	
	for corner_anchor in Catalog.corners:
		var region_anchors = Catalog.region_anchors.pick_random()
		
		for _i in region_anchors.size():
			var region_anchor = region_anchors[_i]
			var region_size = Catalog.region_sizes[_i % 2]
			var anchor = corner_anchor * Catalog.BOARD_SIZE + region_anchor
			add_region(anchor, region_size)
	

func add_region(anchor_: Vector2i, region_size_: Vector2i) -> void:
	var coords: Array[Vector2i]
	
	for _y in region_size_.y:
		for _x in region_size_.x:
			var coord = anchor_ + Vector2i(_x, _y)
			coords.append(coord)
	
	var _region = RegionData.new(self, coords)

func init_region_neighbours() -> void:
	for _i in regions.size():
		var region = regions[_i]
		
		for coord in region.coords:
			for direction in Catalog.directions:
				var neighbour_coord = coord + direction
				
				if coord_to_bastion.has(neighbour_coord) and not region.coords.has(neighbour_coord):
					for _j in range(_i + 1, regions.size(), 1):
						var neighbour_region = regions[_j]
						
						if neighbour_region.coords.has(neighbour_coord) and not region.neighbours.has(neighbour_region):
							region.add_neighbour(neighbour_region)
	
	for region in regions:
		region.update_type()

func reset_biomes() -> void:
	for region in regions:
		region.biome = null
	
	type_to_biomes.clear()
	biomes.clear()

func init_biomes() -> void:
	reset_biomes()
	var major_type = Catalog.biomes.pick_random()
	var minor_types = Catalog.biomes.duplicate()
	minor_types.erase(major_type)
	var biome_size = Catalog.biome_sizes[0][0]
	var current_biomes: Array
	var start_regions = type_to_regions[Bozo.Region.CORNER].duplicate()
	start_regions.shuffle()
	
	for _i in Catalog.biome_sizes[0]:
		var region = start_regions.pick_random()
		start_regions.erase(region)
		var biome = BiomeData.new(self, major_type)
		biome.add_region(region)
		biomes.append(biome)
		current_biomes.append(biome)
	
	for _i in biome_size - 1:
		for biome in current_biomes:
			var options = biome.neighbour_regions.filter(func (a): return biome.is_region_allowed(a))
			options = options.filter(func (a): return a.type != Bozo.Region.CENTER)
			
			if not options.is_empty():
				var region = options.pick_random()
				biome.add_region(region)
	
	
	start_regions = type_to_regions[Bozo.Region.CENTER].duplicate()
	biome_size = Catalog.biome_sizes[1][0]
	current_biomes.clear()
	
	for _i in minor_types.size():
		var biome = BiomeData.new(self, minor_types[_i])
		biomes.append(biome)
		current_biomes.append(biome)
		var region = start_regions.pick_random()
		start_regions.erase(region)
		biome.add_region(region)
		
		var options = biome.neighbour_regions.filter(func (a): return a.type == Bozo.Region.CENTER and start_regions.has(a))
		region = options.pick_random()
		start_regions.erase(region)
		biome.add_region(region)
	
	while not current_biomes.is_empty():
		current_biomes.shuffle()
		var biome_to_options: Dictionary
	
		for biome in current_biomes:
			biome_to_options[biome] = biome.neighbour_regions.filter(func (a): return a.biome == null)
	
		var stuck_biome: BiomeData = current_biomes.back()
		
		for biome in current_biomes:
			if biome != stuck_biome and biome_to_options[stuck_biome].size() < biome_to_options[biome].size():
				stuck_biome = biome
		
		if biome_to_options[stuck_biome].is_empty():
			init_biomes()
			return
		
		var region = biome_to_options[stuck_biome].pick_random()
		stuck_biome.add_region(region)
		
		if stuck_biome.regions.size() == biome_size:
			current_biomes.erase(stuck_biome)
	
	var minor_to_regions: Dictionary
	
	for minor in minor_types:
		minor_to_regions[minor] = []
	
	for region in regions:
		if region.biome == null:
			var options = minor_types.duplicate()
			
			for neighbour in region.neighbours:
				if neighbour.biome:
					if options.has(neighbour.biome.type):
						options.erase(neighbour.biome.type)
			
			for minor in options:
				minor_to_regions[minor].append(region)
	
	var biome_type: Bozo.Biome = minor_types.back()
	
	for minor in minor_types:
		if minor_to_regions[minor].is_empty():
			init_biomes()
			return
		
		if minor_to_regions[biome_type].size() > minor_to_regions[minor].size():
			biome_type = minor
	
	var minor_region: RegionData = minor_to_regions[biome_type].pick_random()
	var minor_biome = BiomeData.new(self, biome_type)
	biomes.append(minor_biome)
	minor_biome.add_region(minor_region)
	
	minor_types.erase(biome_type)
	minor_to_regions[biome_type].erase(biome_type)
	biome_type = minor_types.back()
	
	if minor_to_regions[biome_type].is_empty():
		init_biomes()
		return
	
	minor_region = minor_to_regions[biome_type].pick_random()
	minor_biome = BiomeData.new(self, biome_type)
	biomes.append(minor_biome)
	minor_biome.add_region(minor_region)
	
	var last_check: bool = true
	
	for region in regions:
		if region.biome == null:
			last_check = false
			break
		else:
			if region.biome.type == Bozo.Biome.NONE:
				last_check = false
				break
	
	if not last_check:
		init_biomes()
		return
	
	region_coords_exchange()

func region_coords_exchange() -> void:
	for region in regions:
		for neighbour in region.neighbours:
			if region.biome != neighbour.biome:
				region.coords_exchange(neighbour)
	
	for region in biomes:
		print(region.coords.size())

func init_galores() -> void:
	var noise := FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.12
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	noise.fractal_lacunarity = 2.0

	var ring_bastions: Array = []
	var ring_values: Array = []

	for i in 8:
		ring_bastions.append([])
		ring_values.append([])

	for bastion in bastions:
		var p = bastion.fiefdom.coords.front()

		var n = noise.get_noise_2d(float(p.x), float(p.y))
		n = (n + 1.0) * 0.5
		bastion.galore = n + get_ring_base_value(bastion.ring)
	
	normalize_galores()
	
	for earldom in isle.realm.earldoms:
		earldom.update_rampart()
	
	init_flows()
	init_region_neighbours()
	init_biomes()

func normalize_galores() -> void:
	var min_galore = INF
	var max_galore = -INF
	
	for bastion in bastions:
		if bastion.galore > max_galore:
			max_galore = bastion.galore
		if bastion.galore < min_galore:
			min_galore = bastion.galore
	
	for bastion in bastions:
		bastion.galore = remap(bastion.galore, min_galore, max_galore, 0.0, 1.0)

func get_ring_base_value(ring_: int) -> float:
	match ring_:
		0, 1, 2:  # Внешние - низкие
			return randf_range(0.0, 0.6)
		3, 4:     # Центральные - средние
			return randf_range(0.25, 0.75)
		5, 6, 7:  # Внутренние - высокие
			return randf_range(0.4, 1.0)
		_:
			return 0.5

func init_flows() -> void:
	reset()
	
	for bastion in bastions:
		if not rampart_to_bastions.has(bastion.current_rampart):
			rampart_to_bastions[bastion.current_rampart] = []
		
		rampart_to_bastions[bastion.current_rampart].append(bastion)
	
	var ramparts = rampart_to_bastions.keys()
	
	while not rampart_to_bastions.keys().is_empty():
		ramparts = rampart_to_bastions.keys()
		ramparts.sort()
		var rampart = ramparts.back()
		var bastion = rampart_to_bastions[rampart].pick_random()
		start_flow(bastion)

func start_flow(bastion_: BastionData) -> void:
	current_flow_coords.clear()
	var current_bastion = bastion_
	visit_bastion(current_bastion)
	
	while current_bastion != null:
		current_bastion = current_bastion.get_flow_neighbour()
		
		if current_bastion != null:
			visit_bastion(current_bastion)
	
	var _flow = FlowData.new(self, current_flow_coords)

func visit_bastion(bastion_: BastionData) -> void:
	current_flow_coords.append(bastion_.get_coord())
	
	if current_flow_coords.front() == bastion_.get_coord():
		rampart_to_bastions[bastion_.current_rampart].erase(bastion_)
		visited_bastions.append(bastion_)
		
		if rampart_to_bastions[bastion_.current_rampart].is_empty():
			rampart_to_bastions.erase(bastion_.current_rampart)

func reset() -> void:
	flows.clear()
	channels.clear()
	visited_bastions.clear()
	rampart_to_bastions.clear()
#endregion

func apply_blobs() -> void:
	for bastion in bastions:
		if bastion.blob:
			bastion.blob.apply_value()
		
		bastion.reset()
	
	init_flows()
	#reset()
