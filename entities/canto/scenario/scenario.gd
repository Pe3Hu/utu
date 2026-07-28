class_name Scenario
extends Node


var intro: Card
var verse: Card
var outro: Card

var result: int = 0


func apply_permutation(permutation_: Array) -> void:
	intro = permutation_[0].card
	
	if permutation_[1]:
		verse = permutation_[1].card
	
	if permutation_[2]:
		outro = permutation_[2].card
	
	calc_result()

#func set_cards(intro_: Card, verse_: Card, outro_: Card) -> void:
	#intro = intro_
	#verse = verse_
	#outro = outro_
	#
	#calc_result()


func calc_result() -> void:
	if intro:
		result += intro.intro.cell.value
	
	if verse:
		result += verse.verse.cell.value
		
		if !Catalog.pulse_values.has(result):
			result = -1
			return
	
	if outro:
		if outro.outro.bases.has(result):
			result *= outro.outro.cell.value
			
			if !Catalog.pulse_values.has(result):
				result = -1
				return
		else:
			result = -1
			return

func print_result() -> void:
	var intro_str = "(%d" % intro.intro.cell.value
	var verso_str = " + %d)" % verse.verse.cell.value if verse else ")"
	var outro_str = " * %d" % outro.outro.cell.value if outro else ""
	var result_str = " = %d" % result if verse or outro else ""
	print("%s%s%s%s" % [intro_str, verso_str, outro_str, result_str])
