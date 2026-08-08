class_name CantoData
extends RefCounted


var odeum: OdeumData

var intro: TuneData
var verse: TuneData
var outro: TuneData

var joint: int

var pulse_value: int = 0


func _init(odeum_: OdeumData, joint_: int, intro_: StampData, verse_: Variant, outro_: Variant) -> void:
	odeum = odeum_
	joint = joint_
	intro = TuneData.new(self, intro_, Bozo.Tune.INTRO)
	
	if verse_ != null:
		verse = TuneData.new(self, verse_, Bozo.Tune.VERSE)
	
	if outro_ != null:
		outro = TuneData.new(self, outro_, Bozo.Tune.OUTRO)
	
	update_pulse()

func update_pulse() -> void:
	pulse_value = intro.stake.value
	
	if verse:
		pulse_value += verse.stake.value
	
	if outro:
		pulse_value *= outro.stake.value
		
	if Catalog.pulses.has(pulse_value) and pulse_value > 0:
		odeum.cantos.append(self)
	else:
		return
	
	if odeum.faction.type == Bozo.Faction.BLUE:
		if verse:
			print([intro.stake.value, "+", verse.stake.value, "=", pulse_value ])
		
		if outro:
			print([intro.stake.value, "*", outro.stake.value, "=", pulse_value])
