class_name FactionData
extends RefCounted


var policy: PolicyData
var region: Bozo.Region
var corner: Vector2i
var is_active: bool
var index: int

var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData
var chronicler: ChroniclerData
var warlord: WarlordData

var shrines: Array[BastionData]

var internals: Array[BastionData]
var externals: Array[BastionData]

var settlements: Array[SettlementData]


#region init
func _init(policy_: PolicyData, region_: Bozo.Region = Bozo.Region.NONE, corner_: Vector2i = -Vector2i.ONE, is_active_: bool = false) -> void:
	policy = policy_
	region = region_
	corner = corner_
	is_active = is_active_
	
	index = policy_.factions.size()
	policy_.factions.append(self)
	
	if is_active:
		kernel = KernelData.new(self)
		odeum = OdeumData.new(self)
		
		init_shrines()
		
		atheneum = AtheneumData.new(self)
		chronicler = ChroniclerData.new(self)
		warlord = WarlordData.new(self)

func init_shrines() -> void:
	var corner_index = Catalog.corners.find(corner)
	var corner_coord = corner * Catalog.BOARD_SIZE
	
	for shrine in Digest.region_to_shrine[region]:
		var shrine_coord = corner_coord + Helper.apply_acnhor_twist(shrine, corner_index)
		var shrine_bastion = capture_shrine(shrine_coord)
		var allowance = shrine_bastion.fiefdom.neighbours.pick_random()
		capture_bastion(allowance.bastion)
	
	if region == Bozo.Region.CENTER:
		corner_index += 1
		corner_coord = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
		var shrine = Digest.region_to_shrine[region].front()
		var shrine_coord = corner_coord + Helper.apply_acnhor_twist(shrine, corner_index)
		var shrine_bastion = capture_shrine(shrine_coord)
		var allowance = shrine_bastion.fiefdom.neighbours.pick_random()
		capture_bastion(allowance.bastion)
	
	#for order in Catalog.shrines.size():
		#order_to_shrines[order] = []
		#
		#for shrine in Catalog.shrines[order]:
			#for corner_index in Catalog.corners.size():
				#var is_odd: bool = (order + corner_index) % 2 == 1
				#var shrine_faction = Digest.flag_to_faction[is_odd]
				#
				#if shrine_faction == type:
					#var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
					#var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
					#order_to_shrines[order].append(coord)
	pass
	#for coord in order_to_shrines[0]:
		#var shrine = capture_shrine(coord)
		#var allowance = shrine.fiefdom.neighbours.pick_random()
		#capture_bastion(allowance.bastion)
#endregion

#region capture

func capture_shrine(coord_: Vector2i) -> BastionData:
	var bastion = policy.isle.realm.coord_to_fiefdom[coord_].bastion
	shrines.append(bastion)
	capture_bastion(bastion)
	bastion.establish_settlement()
	return bastion

func capture_bastion(bastion_: BastionData) -> void:
	if bastion_.faction != null:
		bastion_.faction.lose_bastion(bastion_)
	
	bastion_.faction = self
	internals.append(bastion_)
	update_externals(bastion_)

func update_externals(bastion_: BastionData) -> void:
	if not is_active: return
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
