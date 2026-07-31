class_name CardData
extends Resource


var matter: Bozo.Matter

var intro: DiceData
var verse: DiceData

var outro_bases: Array[int]
var current_outro: int = -1


#region init
func _init(matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData) -> void:
	matter = matter_
	intro = intro_
	verse = verse_
	
	init_bases()

func init_bases() -> void:
	var grades = Digest.sum_to_grades[intro.grade]#[2, 3]#[1, 2]# [2, 3, 4]
	
	for _i in Catalog.OUTRO_BASE_LIMIT:
		var value = 0
		
		if _i in grades:
			var options = Catalog.outro_to_matter_to_values[_i][matter]
			value = options.pick_random()
			outro_bases.append(value)
#endregion

func roll_dices() -> void:
	intro.roll_result()
	verse.roll_result()
