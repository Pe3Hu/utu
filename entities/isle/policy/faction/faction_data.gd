class_name FactionData
extends RefCounted


var policy: PolicyData
var type: Bozo.Faction

var current_order: int = 0

var order_to_shrines: Dictionary
var captured_shrines: Array[BastionData]
var available_shrines: Array[BastionData]

var internals: Array[BastionData]
var externals: Array[BastionData]


func _init(policy_: PolicyData, type_: Bozo.Faction) -> void:
	policy = policy_
	type = type_
	
	init_shrines()

func init_shrines() -> void:
	for order in Catalog.shrines.size():
		order_to_shrines[order] = []
		
		for shrine in Catalog.shrines[order]:
			for corner_index in Catalog.corners.size():
				var is_even: bool = (order + corner_index) % 2 == 0
				var shrine_faction = Digest.flag_to_faction[is_even]
				
				if shrine_faction == type:
					var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
					var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
					order_to_shrines[order].append(coord)
	
	capture_default_shrines()

func capture_default_shrines() -> void:
	for coord in order_to_shrines[0]:
		var shrine = captured_shrine(coord)
		var allowance = shrine.fiefdom.neighbours.pick_random()
		captured_bastion(allowance.bastion)

func captured_shrine(coord_: Vector2i) -> BastionData:
	var bastion = policy.isle.realm.coord_to_fiefdom[coord_].bastion
	captured_shrines.append(bastion)
	captured_bastion(bastion)
	return bastion

func captured_bastion(bastion_: BastionData) -> void:
	bastion_.faction = type
	internals.append(bastion_)
	update_externals(bastion_)

func update_externals(bastion_: BastionData) -> void:
	if externals.has(bastion_):
		externals.erase(bastion_)
	
	for fiefdom in bastion_.fiefdom.neighbours:
		if not externals.has(fiefdom.bastion) and not internals.has(fiefdom.bastion):
			externals.append(fiefdom.bastion)
