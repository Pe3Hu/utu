class_name ScenarioData
extends Resource


var intro: CardData
var verse: CardData
var outro: CardData

var result: int = 0


func _init(permutation_: Array) -> void:
	intro = permutation_[0]
	
	if permutation_[1]:
		verse = permutation_[1]
	
	if permutation_[2]:
		outro = permutation_[2]
	
	calc_result()

func calc_result() -> void:
	if intro:
		result += intro.intro.result
	
	if verse:
		result += verse.verse.result
		
		if !Catalog.pulse_values.has(result):
			result = -1
			return
	
	if outro:
		if outro.outro_bases.has(result):
			result *= Digest.matter_to_factor[outro.matter]
			
			if !Catalog.pulse_values.has(result):
				result = -1
				return
		else:
			result = -1
			return

func print_result() -> void:
	var intro_str = "(%d" % intro.intro.result
	var verso_str = " + %d)" % verse.verse.result if verse else ")"
	var outro_str = " * %d" % Digest.matter_to_factor[outro.matter] if outro else ""
	var result_str = " = %d" % result if verse or outro else ""
	print("%s%s%s%s" % [intro_str, verso_str, outro_str, result_str])
