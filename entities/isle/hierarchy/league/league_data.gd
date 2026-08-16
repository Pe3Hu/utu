class_name LeagueData
extends RefCounted


var hierarchy: HierarchyData
var domain: DomainData

var anchor: Vector2i
var coords: Array[Vector2i]


func _init(hierarchy_: HierarchyData, domain_: DomainData) -> void:
	hierarchy = hierarchy_
	domain = domain_
	
	anchor.x = hierarchy.leagues.size()
	anchor.y = Digest.domain_to_anchor[domain.type]
	
	hierarchy.leagues.append(self)
	
	if not hierarchy.domain_to_leagues.has(domain.type):
		hierarchy.domain_to_leagues[domain.type] = []
	
	hierarchy.domain_to_leagues[domain.type].append(self)
	
	for _i in domain.coords.size():
		var coord = Vector2i(_i, 0)
		coords.append(coord)
