class_name MatterDiceData
extends DiceData



@export var matter: Bozo.Matter:
	set(value_):
		matter = value_
		#init_values()


#func init_values() -> void:
	#var matter_string = Bozo.enum_to_string(Bozo.Type.MATTER, matter)
	#var source = load("res://entities/dice/datas/matter/%s.tres" % matter_string)
	#values.append_array(source.values)
	#values.shuffle()
