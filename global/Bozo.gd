extends Node


enum Matter {
	NONE = 0,
	GAS = 1,
	LIQUID = 2,
	SOLID = 3
}

enum Tune {
	NONE = 0,
	INTRO = 4,
	VERSE = 5,
	OUTRO = 6,
	HOOK = 7,
	CHORUS = 8,
	BRIDGE = 9,
}

enum Action {
	NONE = 0,
	SELECT_INTRO = 104,
	SELECT_VERSE = 105,
	SELECT_OUTRO = 106,
}

enum Phase {
	NONE = 0,
	CANTO = 200,
}

#region string
enum Type {
	NONE = 0,
	MATTER = -1,
	TUNE = -2,
	ACTION = -100,
	PHASE = -200,
}

const type_to_index = {
	Type.NONE: 0,
	Type.MATTER: 1,
	Type.TUNE: 4,
	Type.ACTION: 104,
	Type.PHASE: 200,
	#9
}

const type_to_enum = {
	Type.MATTER: Bozo.Matter,
	Type.TUNE: Bozo.Tune,
	Type.ACTION: Bozo.Action,
	Type.PHASE: Bozo.Phase,
}

func enum_to_string(type_: Variant, value_: int) -> String:
	var index = value_ - type_to_index[type_] + 1
	var enum_ = type_to_enum[type_]
	var key_name: String = enum_.keys()[index]
	
	if key_name:
		return key_name.to_lower()
	
	return "unknown"
#endregion
