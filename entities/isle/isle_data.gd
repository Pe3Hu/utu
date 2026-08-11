class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var realm: RealmData
var policy: PolicyData
var terrain: TerrainData


func _init() -> void:
	terrain = TerrainData.new(self)
	realm = RealmData.new(self)
	policy = PolicyData.new(self)
	
	terrain.init_galores()
	
	for faction_type in Catalog.active_factions:
		policy.type_to_faction[faction_type].treasury.kernel.apply_starter_volumes()
	
	var blue_faction = policy.type_to_faction[Bozo.Faction.BLUE]
	atheneum = blue_faction.atheneum
	kernel = blue_faction.treasury.kernel
	odeum = blue_faction.odeum
	
	for faction in policy.factions:
		faction.isle = self
