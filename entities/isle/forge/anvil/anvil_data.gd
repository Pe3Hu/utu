class_name AnvilData
extends RefCounted


var forge: ForgeData
var stamps: Array[StampData]

var new_stamp: StampData


#region init
func _init(forge_: ForgeData, stamps_: Array) -> void:
	forge = forge_
	stamps.append_array(stamps_)
	
	forge.anvils.append(self)
	init_new_stamp()

func init_new_stamp() -> void:
	var intro_values: Array[int]
	var verse_values: Array[int]
	var letters = []
	
	for stamp in stamps:
		for stake in stamp.tune_to_stakes[Bozo.Tune.INTRO]:
			intro_values.append(stake.value)
		
		for stake in stamp.tune_to_stakes[Bozo.Tune.VERSE]:
			verse_values.append(stake.value)
		
		for letter in stamp.mark_digits.split(""):
			if not letters.has(letter):
				letters.append(letter)
	
	var origin = stamps.front().origin
	new_stamp = StampData.new(origin, intro_values, verse_values)
	
	letters.sort()
	var str_mark = ""
	
	for mark in letters:
		str_mark += mark
	
	new_stamp.mark_digits = str_mark
#endregion

func fusion() -> void:
	var origin = stamps.front().origin
	
	for stamp in stamps:
		origin.stamps.erase(stamp)
		origin.atheneum.tribunal.bygone.stamps.erase(stamp)
	
	origin.stamps.append(new_stamp)
	origin.atheneum.tribunal.bygone.stamps.append(new_stamp)
	Arbitrator.current_phase.exit_phase()
