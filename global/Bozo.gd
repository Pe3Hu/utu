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

enum Shape {
	NONE = 0,
	F = 10,
	I = 11,
	L = 12,
	N = 13,
	P = 14,
	T = 15,
	U = 16,
	V = 17,
	W = 18,
	X = 19,
	Y = 20,
	Z = 21
}

enum Domain {
	NONE = 0,
	FIEFDOM = 22,
	EARLDOM = 23,
	DUKEDOM = 24,
	KINGDOM = 25
}

enum Regard {
	NONE = 0,
	ALLY = 26,#UNION
	ENEMY = 27,#HOSTILE
	WILD = 28,
}

enum Region {
	NONE = 0,
	CORNER = 29,
	SIDE = 30,
	CENTER = 31,
}

enum Biome {
	NONE = 0,
	PLAIN = 32,
	SWAMP = 33,
	MOUNTAIN = 34
}

enum Stake {
	NONE = 0,
	LEFT = 35,
	RIGHT = 36
}

enum Gyre {
	NONE = 0,
	HEREAFTER = 37,
	ACTUAL = 38,
	BYGONE = 39,
}

enum Math {
	NONE = 0,
	PLUS = 40,
	MINUS = 41,
	MULTIPLY = 42,
}

enum Ark {
	NONE = 0,
	APPEAR = 43,
	DISAPPEAR = 44,
	ACTIVATE = 45,
	DEACTIVATE = 46
}

enum Faction {
	NONE = 0,
	BLUE = 99,
	RED = 98,
	GREEN = 97
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
	SHAPE = -3,
	DOMAIN = -4,
	REGARD = -5,
	REGION = -6,
	BIOME = -7,
	STAKE = -8,
	GYRE = -9,
	MATH = -10,
	ARK = -11,
	ACTION = -100,
	PHASE = -200,
}

const type_to_index = {
	Type.NONE: 0,
	Type.MATTER: 1,
	Type.TUNE: 4,
	Type.SHAPE: 10,
	Type.DOMAIN: 22,
	Type.REGARD: 26,
	Type.REGION: 29,
	Type.BIOME: 32,
	Type.STAKE: 35,
	Type.MATH: 40,
	Type.ARK: 43,
	
	Type.ACTION: 104,
	Type.PHASE: 200,
}

const type_to_enum = {
	Type.MATTER: Bozo.Matter,
	Type.TUNE: Bozo.Tune,
	Type.SHAPE: Bozo.Shape,
	Type.DOMAIN: Bozo.Domain,
	Type.REGARD: Bozo.Regard,
	Type.REGION: Bozo.Region,
	Type.BIOME: Bozo.Biome,
	Type.STAKE: Bozo.Stake,
	Type.MATH: Bozo.Math,
	Type.ARK: Bozo.Ark,
	
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
