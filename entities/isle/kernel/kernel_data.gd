class_name KernelData
extends RefCounted


@warning_ignore("unused_signal")
signal growth_phase
@warning_ignore("unused_signal")
signal stock_phase

var treasury: TreasuryData

var harvest: CornfieldData = CornfieldData.new(self)
var granary: CornfieldData = CornfieldData.new(self)
var fleet: FleetData = FleetData.new(self)


func _init(treasury_: TreasuryData) -> void:
	treasury = treasury_

func apply_starter_volumes() -> void:
	if treasury.faction.type == Bozo.Faction.GREEN: return
	
	for _i in Catalog.STARTER_HARVEST_AMOUNT:
		grow_harvest(true)

func grow_harvest(instant_stock_: bool = false) -> void:
	for bastion in treasury.faction.internals:
		var source = bastion.region.biome.source
		var volume = source.get_rnd_volume()
		
		if instant_stock_:
			var granary_straw = granary.volume_to_matter_to_straw[volume][source.matter]
			granary_straw.amount += 1
			granary_straw.next_amount += 1
		else:
			var straw = harvest.volume_to_matter_to_straw[volume][source.matter]
			straw.next_amount += 1

func stock_granary() -> void:
	for harvest_straw in harvest.straws:
		if harvest_straw.amount > 0:
			var granary_straw = granary.volume_to_matter_to_straw[harvest_straw.volume][harvest_straw.matter]
			granary_straw.next_amount = granary_straw.amount + harvest_straw.amount 
			harvest_straw.next_amount = 0
