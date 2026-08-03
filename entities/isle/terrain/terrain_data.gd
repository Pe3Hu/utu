class_name TerrainData
extends RefCounted



var isle: IsleData
var flows: Array[FlowData]
var channels: Array[ChannelData]

var bastions: Array[BastionData] = []
var coord_to_bastion: Dictionary
var rampart_to_bastions: Dictionary

var visited_bastions: Array[BastionData]
var current_flow_coords: Array[Vector2i]


func _init(isle_: IsleData) -> void:
	isle = isle_

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

func apply_blobs() -> void:
	for bastion in bastions:
		if bastion.blob:
			bastion.blob.apply_value()
		
		bastion.reset()
	
	init_flows()
	#reset()

func reset() -> void:
	flows.clear()
	channels.clear()
	visited_bastions.clear()
	rampart_to_bastions.clear()
