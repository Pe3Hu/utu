class_name FactionData
extends RefCounted


var policy: PolicyData
var type: Bozo.Faction

var isle: IsleData
var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData
var chronicler: ChroniclerData
var warlord: WarlordData

var current_order: int = 0

var order_to_shrines: Dictionary
var captured_shrines: Array[BastionData]
var available_shrines: Array[BastionData]

var internals: Array[BastionData]
var externals: Array[BastionData]

var settlements: Array[SettlementData]


#region init
func _init(policy_: PolicyData, type_: Bozo.Faction) -> void:
	policy = policy_
	type = type_
	
	if type != Bozo.Faction.GREEN:
		kernel = KernelData.new(self)
		odeum = OdeumData.new(self)
		
		init_shrines()
		
		atheneum = AtheneumData.new(self)
		chronicler = ChroniclerData.new(self)
		warlord = WarlordData.new(self)

func init_shrines() -> void:
	for order in Catalog.shrines.size():
		order_to_shrines[order] = []
		
		for shrine in Catalog.shrines[order]:
			for corner_index in Catalog.corners.size():
				var is_odd: bool = (order + corner_index) % 2 == 1
				var shrine_faction = Digest.flag_to_faction[is_odd]
				
				if shrine_faction == type:
					var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
					var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
					order_to_shrines[order].append(coord)
	
	capture_default_shrines()
#endregion

#region capture
func capture_default_shrines() -> void:
	for coord in order_to_shrines[0]:
		var shrine = captured_shrine(coord)
		var allowance = shrine.fiefdom.neighbours.pick_random()
		captured_bastion(allowance.bastion)

func captured_shrine(coord_: Vector2i) -> BastionData:
	var bastion = policy.isle.realm.coord_to_fiefdom[coord_].bastion
	captured_shrines.append(bastion)
	captured_bastion(bastion)
	bastion.establish_settlement()
	return bastion

func captured_bastion(bastion_: BastionData) -> void:
	if bastion_.faction != null:
		bastion_.faction.lose_bastion(bastion_)
	
	bastion_.faction = self
	internals.append(bastion_)
	update_externals(bastion_)

func update_externals(bastion_: BastionData) -> void:
	if type == Bozo.Faction.GREEN: return
	if externals.has(bastion_):
		externals.erase(bastion_)
	
	if internals.has(bastion_):
		for fiefdom in bastion_.fiefdom.neighbours:
			if not externals.has(fiefdom.bastion) and not internals.has(fiefdom.bastion):
				externals.append(fiefdom.bastion)
	else:
		for external_fiefdom in bastion_.fiefdom.neighbours:
			var still_external: bool = false
			
			for internal_fiefdom in external_fiefdom.neighbours:
				if internals.has(internal_fiefdom.bastion):
					still_external = true
					break
			
			if not still_external:
				externals.erase(external_fiefdom.bastion)

func lose_bastion(bastion_: BastionData) -> void:
	internals.erase(bastion_)
	update_externals(bastion_)
#endregion
