class_name OriginData
extends RefCounted


var atheneum: AtheneumData
var matter: Bozo.Matter

var intro: DiceData
var verse: DiceData

var stamps: Array[StampData]


#region init
func _init(atheneum_: AtheneumData, matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData) -> void:
	atheneum = atheneum_
	matter = matter_
	intro = intro_
	verse = verse_
	
	init_stamps()

func init_stamps() -> void:#indexs_: Array = Catalog.default_stamp_indexs
	var intro_indexs = []
	intro_indexs.assign(range(6))
	var verse_indexs = []
	verse_indexs.assign(range(6))
	intro_indexs.shuffle()
	verse_indexs.shuffle()
	var n = intro_indexs.size()
	
	for _i in n:
		var intro_value = intro.values[intro_indexs.pop_back()]
		var verse_value = verse.values[verse_indexs.pop_back()]
		var _stamp = StampData.new(self, intro_value, verse_value)
#endregion
