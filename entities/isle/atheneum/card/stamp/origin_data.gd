class_name OriginData
extends RefCounted


var atheneum: AtheneumData
var matter: Bozo.Matter

var intro: DiceData
var verse: DiceData

var stamps: Array[StampData]

var mark_letter: String


#region init
func _init(atheneum_: AtheneumData, matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData) -> void:
	atheneum = atheneum_
	matter = matter_
	intro = intro_
	verse = verse_
	mark_letter = atheneum.alphabet.pop_back()
	
	if atheneum.alphabet.is_empty():
		atheneum.refill_alphabet()
	
	init_stamps()

func init_stamps() -> void:
	var intro_indexs = []
	intro_indexs.assign(range(6))
	var verse_indexs = []
	verse_indexs.assign(range(6))
	intro_indexs.shuffle()
	verse_indexs.shuffle()
	var n = intro_indexs.size()
	
	for _i in n:
		var intro_values: Array[int] = [intro.values[intro_indexs.pop_back()]]
		var verse_values: Array[int] = [verse.values[verse_indexs.pop_back()]]
		add_stamp(intro_values, verse_values)

func add_stamp(intro_values_: Array[int], verse_values_: Array[int]) -> void:
	var stamp = StampData.new(self, intro_values_, verse_values_)
	stamps.append(stamp)
	atheneum.tribunal.hereafter.stamps.append(stamp)
	stamp.mark_digits = str(stamps.size())
#endregion
