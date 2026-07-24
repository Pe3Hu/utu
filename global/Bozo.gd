extends Node


enum Matter {
	NONE = 0,
	GAS = 1,
	LIQUID = 2,
	SOLID = 3
} 


#region string
enum Type {
	NONE = 0,
	MATTER = -1,
}

const type_to_index = {
	Type.NONE: 0,
	Type.MATTER: 1,
	#54
}

const type_to_enum = {
	Type.MATTER: Bozo.Matter,
}

func enum_to_string(type_: Variant, value_: int) -> String:
	var index = value_ - type_to_index[type_] + 1
	var enum_ = type_to_enum[type_]
	var key_name: String = enum_.keys()[index]
	
	if key_name:
		return key_name.to_lower()
	
	return "unknown"
#endregion
