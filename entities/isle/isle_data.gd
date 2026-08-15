class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var realm: RealmData
var policy: PolicyData
var terrain: TerrainData

var forge: ForgeData


func _init() -> void:
	terrain = TerrainData.new(self)
	realm = RealmData.new(self)
	forge = ForgeData.new()
	
	terrain.init_galores()
	policy = PolicyData.new(self)
	
	for faction in policy.factions:
		if faction.is_active:
			faction.kernel.apply_starter_volumes()
	
	atheneum = policy.current_faction.atheneum
	kernel = policy.current_faction.kernel
	odeum = policy.current_faction.odeum
