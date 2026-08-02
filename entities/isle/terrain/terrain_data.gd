class_name TerrainData
extends RefCounted



var isle: IsleData
var flows: Array[FlowData]
var channels: Array[ChannelData]

var bastions: Array[BastionData] = []

var visited_bastions: Array[BastionData]
var rampart_to_bastions: Dictionary
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

	#const TARGET := [
		#0.35, # ring 0
		#0.4, # ring 1
		#0.45, # ring 2
		#0.55, # ring 3
		#0.6, # ring 4
		#0.75, # ring 5
		#0.85, # ring 6
		#0.95  # ring 7
	#]

	var ring_bastions: Array = []
	var ring_values: Array = []

	for i in 8:
		ring_bastions.append([])
		ring_values.append([])

	for bastion in bastions:
		var p = bastion.fiefdom.coords.front()

		var n = noise.get_noise_2d(float(p.x), float(p.y))
		#n = (n + get_ring_base_value(bastion.ring)) * 0.5 
		n = (n + 1.0) * 0.5
		bastion.galore = n + get_ring_base_value(bastion.ring)

		#ring_bastions[bastion.ring].append(bastion)
		#ring_values[bastion.ring].append(n)
	
	normalize_galores()
	
	for earldom in isle.realm.earldoms:
		earldom.update_rampart()
	
	init_flows()
	return 
	#var exponents: Array = []
#
	#for ring in 8:
		#var invert := ring >= 5
		#exponents.append(
			#find_exponent(ring_values[ring], TARGET[ring], invert)
		#)
#
	#for ring in 8:
		#var k: float = exponents[ring]
		#var invert := ring >= 5
#
		#for bastion in ring_bastions[ring]:
			#var v: float = bastion.galore
#
			#if invert:
				#v = 1.0 - pow(1.0 - v, k)
			#else:
				#v = pow(v, k)
#
			#bastion.galore = clampf(v, 0.0, 1.0)
	#
	## Отладка: средние по кольцам
	#for ring in 8:
		#var mean := 0.0
#
		#for bastion in ring_bastions[ring]:
			#mean += bastion.galore
#
		#mean /= max(1, ring_bastions[ring].size())
#
		#print("ring ", ring, " mean = ", snappedf(mean, 0.001))

func find_exponent(values: Array, target: float, invert: bool) -> float:
	var left := 0.1
	var right := 6.0

	for i in 32:
		var mid := (left + right) * 0.5

		var mean := 0.0

		for value in values:
			var v: float = value

			if invert:
				mean += 1.0 - pow(1.0 - v, mid)
			else:
				mean += pow(v, mid)

		mean /= values.size()

		# ВАЖНО: условие разное для invert/non-invert
		if invert:
			if mean < target:
				left = mid
			else:
				right = mid
		else:
			if mean > target:
				left = mid
			else:
				right = mid

	return (left + right) * 0.5

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

func get_ring_base_value(ring: int) -> float:
	match ring:
		0, 1, 2:  # Внешние - низкие
			return randf_range(0.0, 0.6)
		3, 4:     # Центральные - средние
			return randf_range(0.25, 0.75)
		5, 6, 7:  # Внутренние - высокие
			return randf_range(0.4, 1.0)
		_:
			return 0.5

func init_flows() -> void:
	flows.clear()
	channels.clear()
	visited_bastions.clear()
	rampart_to_bastions.clear()
	
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
	visit_bastion(bastion_)
	var current_bastion = bastion_
	
	while current_bastion != null:
		current_bastion = current_bastion.get_flow_neighbour()
		
		if current_bastion != null:
			current_flow_coords.append(current_bastion.get_coord())
	
	var _flow = FlowData.new(self, current_flow_coords)

func visit_bastion(bastion_: BastionData) -> void:
	current_flow_coords.append(bastion_.get_coord())
	rampart_to_bastions[bastion_.current_rampart].erase(bastion_)
	visited_bastions.append(bastion_)
	
	if rampart_to_bastions[bastion_.current_rampart].is_empty():
		rampart_to_bastions.erase(bastion_.current_rampart)
