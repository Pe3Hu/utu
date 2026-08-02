class_name IsleData
extends RefCounted


var realm: RealmData
var policy: PolicyData
var terrain: TerrainData


func _init() -> void:
	terrain = TerrainData.new(self)
	realm = RealmData.new(self)
	policy = PolicyData.new(self)
	
	terrain.init_galores()
