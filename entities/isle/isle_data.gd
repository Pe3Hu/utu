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
	
	for faction_type in Catalog.active_factions:
		policy.type_to_faction[faction_type].kernel.apply_starter_volumes()
	
	var blue_faction = policy.type_to_faction[Bozo.Faction.BLUE]
	atheneum = blue_faction.atheneum
	kernel = blue_faction.kernel
	odeum = blue_faction.odeum
	
	for faction in policy.factions:
		faction.isle = self
