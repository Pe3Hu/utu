extends Node


var shape_to_color: Dictionary
var faction_to_color: Dictionary
var sum_to_matter_to_intro: Dictionary


#region domain
const domain_to_vassal: Dictionary = {
	Bozo.Domain.EARLDOM: Bozo.Domain.FIEFDOM,
	Bozo.Domain.DUKEDOM: Bozo.Domain.EARLDOM,
	Bozo.Domain.KINGDOM: Bozo.Domain.DUKEDOM,
}

const domain_to_size = {
	Bozo.Domain.EARLDOM: 5,
	Bozo.Domain.DUKEDOM: 4,
	Bozo.Domain.KINGDOM: 3,
}

const domain_to_anchor = {
	Bozo.Domain.FIEFDOM: 0,
	Bozo.Domain.EARLDOM: 1,
	Bozo.Domain.DUKEDOM: 2,
	Bozo.Domain.KINGDOM: 3,
}

const region_to_shrine = {
	Bozo.Region.CORNER: [Vector2i(1, 1), Vector2i(1, 4)],
	Bozo.Region.SIDE: [Vector2i(4, 1), Vector2i(7, 1)],
	Bozo.Region.DIAGONAL: [Vector2i(3, 6), Vector2i(6, 4)],
	Bozo.Region.CENTER: [Vector2i(6, 7)]#[Vector2i(5, 7)]
}
#endregion

#region matter
const verse_to_matter = {
	35: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	34: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	36: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
	59: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	57: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	58: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
	89: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	87: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	88: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
}

const matter_to_verse = {
	Bozo.Matter.NONE: [34, 35, 36],
	Bozo.Matter.GAS: [34, 35],
	Bozo.Matter.LIQUID: [35, 36],
	Bozo.Matter.SOLID: [34, 36],
}

const matter_to_factors = {
	Bozo.Matter.NONE: [2, 3, 5],
	Bozo.Matter.GAS: [2, 3],
	Bozo.Matter.LIQUID: [2, 3],
	Bozo.Matter.SOLID: [3, 5],
}

const factor_to_matter = {
	2: Bozo.Matter.GAS,
	3: Bozo.Matter.LIQUID,
	5: Bozo.Matter.SOLID,
}

const matter_to_factor = {
	Bozo.Matter.GAS: 2,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.SOLID: 5,
}

const expiration_to_factor = {
	Bozo.Matter.GAS: 2,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.SOLID: 4,
}
#endregion

#region grade
const sum_to_index = {
	20: 11,
	30: 20,
	40: 22
}

const sum_to_grades = {
	20: [1, 2],#[0, 1, 2],
	30: [2, 3],#[1, 2, 3, 4],#[1, 2, 3],
	40: [3, 4]#[2, 3, 4],
}
#endregion

#region realm
const flag_to_regard = {
	true: Bozo.Regard.ALLY,
	false: Bozo.Regard.ENEMY
}


const direction_to_diagonal = {
	Vector2i(0, -1): [Vector2i(-1, -1), Vector2i(1, -1)],
	Vector2i(1, 0): [Vector2i(1, -1), Vector2i(1, 1)],
	Vector2i(0, 1): [Vector2i(-1, 1), Vector2i(1, 1)],
	Vector2i(-1, 0): [Vector2i(-1, -1), Vector2i(-1, 1)],
}
#endregion

#region canto
const tune_to_stake = {
	Bozo.Tune.INTRO: Bozo.Stake.RIGHT,
	Bozo.Tune.VERSE: Bozo.Stake.LEFT,
	Bozo.Tune.OUTRO: Bozo.Stake.LEFT,
}

const tune_to_math = {
	Bozo.Tune.VERSE: Bozo.Math.PLUS,
	Bozo.Tune.OUTRO: Bozo.Math.MULTIPLY,
}

var verse_to_spoil = {
	34: 1,
	35: 1,
	36: 1,
	57: 2,
	58: 2,
	59: 2,
	87: 3,
	88: 3,
	89: 3
}
#endregion

#region fleet
const ark_to_flag_to_ark = {
	Bozo.Ark.DISAPPEAR: {
		true: Bozo.Ark.APPEAR,
	},
	Bozo.Ark.APPEAR: {
		false: Bozo.Ark.DISAPPEAR,
		true: Bozo.Ark.ACTIVATE,
	},
	Bozo.Ark.DEACTIVATE: {
		false: Bozo.Ark.DISAPPEAR,
		true: Bozo.Ark.ACTIVATE,
	},
	Bozo.Ark.ACTIVATE: {
		false: Bozo.Ark.DEACTIVATE,
	},
}

const volume_to_matter_to_volume = {
	2: {
		Bozo.Matter.GAS: 4,
		Bozo.Matter.LIQUID: 5,
	},
	3: {
		Bozo.Matter.GAS: 5,
		Bozo.Matter.LIQUID: 6,
		Bozo.Matter.SOLID: 8,
	},
	4: {
		Bozo.Matter.GAS: 6,
		Bozo.Matter.SOLID: 9,
	},
	5: {
		Bozo.Matter.LIQUID: 8,
		Bozo.Matter.SOLID: 10,
	},
	6: {
		Bozo.Matter.GAS: 8,
		Bozo.Matter.LIQUID: 9,
	},
	8: {
		Bozo.Matter.GAS: 10,
	},
	9: {
		Bozo.Matter.LIQUID: 12,
	},
	10: {
		Bozo.Matter.GAS: 12,
		Bozo.Matter.SOLID: 15,
	},
	12: {
		Bozo.Matter.LIQUID: 15,
	},
	15: {
		Bozo.Matter.LIQUID: 18,
		Bozo.Matter.SOLID: 20,
	},
	18: {
		Bozo.Matter.GAS: 20,
	},
	20: {
		Bozo.Matter.SOLID: 25,
	},
	25: {
		Bozo.Matter.GAS: 27,
		Bozo.Matter.SOLID: 30,
	},
	27: {
		Bozo.Matter.LIQUID: 30,
		Bozo.Matter.SOLID: 32,
	},
	30: {
		Bozo.Matter.GAS: 32,
	},
	32: {
		#Bozo.Matter.GAS: ,
		#Bozo.Matter.LIQUID: ,
		#Bozo.Matter.SOLID: ,
	},
}

const volume_to_coord = {
	2: Vector2i(2, 8),
	3: Vector2i(2, 7),
	4: Vector2i(4, 7),
	5: Vector2i(0, 7),
	6: Vector2i(3, 6),
	8: Vector2i(1, 6),
	9: Vector2i(4, 5),
	10: Vector2i(0, 5),
	12: Vector2i(2, 5),
	15: Vector2i(1, 4),
	18: Vector2i(3, 4),
	20: Vector2i(2, 3),
	25: Vector2i(2, 2),
	27: Vector2i(3, 1),
	30: Vector2i(1, 1),
	32: Vector2i(2, 0)
}
#endregion

#region ladder
const volume_to_shape = {
	2: 5,
	3: 5,
	4: 5,
	5: 5,
	6: 5,
	8: 5,
	9: 6,
	10: 6,
	12: 6,
	15: 6,
	18: 6,
	20: 6,
	25: 4,
	27: 4,
	30: 4,
	32: 4
}

const volume_to_stage = {
	2: 0,
	3: 2,
	4: 3,
	5: 1,
	6: 5,
	8: 4,
	9: 2,
	10: 0,
	12: 1,
	15: 3,
	18: 4,
	20: 5,
	25: 0,
	27: 2,
	30: 1,
	32: 3
	
}
#endregion

#region stamp
const tune_to_length_to_joints = {
	Bozo.Tune.INTRO: {
		1: [[2, 3]],
		2: [[1, 2], [3, 4]],
		3: [[0, 1], [2, 3], [4, 5]],
		6: [[0], [1], [2], [3], [4], [5]]
	},
	Bozo.Tune.VERSE: {
		1: [[2]],
		2: [[2], [3]],
		3: [[3], [4], [5]],
		6: [[0], [1], [2], [3]]
	},
	Bozo.Tune.OUTRO: {
		1: [[3]],
		2: [[1], [4]],
		3: [[0, 1, 2]],
		6: [[4, 5]]
	},
}
#endregion

#region mount
var mount_to_matter = {
	Bozo.Mount.GIRAFFE: Bozo.Matter.GAS,
	Bozo.Mount.ELEPHANT: Bozo.Matter.LIQUID,
	Bozo.Mount.RHINO: Bozo.Matter.SOLID,
	Bozo.Mount.HORSE: Bozo.Matter.NONE,
	Bozo.Mount.ZEBRA: Bozo.Matter.NONE,
	Bozo.Mount.DONKEY: Bozo.Matter.NONE,
	Bozo.Mount.HYENA: Bozo.Matter.ANY,
}

var mount_to_evaluation = {
	Bozo.Mount.GIRAFFE: Bozo.Evaluation.BEST,
	Bozo.Mount.ELEPHANT: Bozo.Evaluation.BEST,
	Bozo.Mount.RHINO: Bozo.Evaluation.BEST,
	Bozo.Mount.HORSE: Bozo.Evaluation.BEST,
	Bozo.Mount.ZEBRA: Bozo.Evaluation.NORMAL,
	Bozo.Mount.DONKEY: Bozo.Evaluation.WORST,
	Bozo.Mount.HYENA: Bozo.Evaluation.WORST,
}

const matter_to_mount = {
	Bozo.Matter.GAS: Bozo.Mount.GIRAFFE,
	Bozo.Matter.LIQUID: Bozo.Mount.ELEPHANT,
	Bozo.Matter.SOLID: Bozo.Mount.RHINO,
}
#endregion




#region fake dice
var side_to_axis_to_side = {
	0: {
		0: 4,
		1: 3,
		2: 0
	},
	1: {
		0: 0,
		1: 2,
		2: 1
	},
	2: {
		0: 0,
		1: 0,
		2: 2
	},
	3: {
		0: 1,
		1: 5,
		2: 3
	},
	4: {
		0: 5,
		1: 3,
		2: 4
	},
	5: {
		0: 1,
		1: 2,
		2: 5
	}
}

var rotation_to_face = {
	Vector3(0, 0, 0): 0,
	Vector3(0, 0, 90): 0,
	Vector3(0, 0, 180): 0,
	Vector3(0, 0, 270): 0,
	Vector3(0, 90, 0): 3,
	Vector3(0, 90, 90): 4,
	Vector3(0, 90, 180): 2,
	Vector3(0, 90, 270): 1,
	Vector3(0, 180, 0): 5,
	Vector3(0, 180, 90): 5,
	Vector3(0, 180, 180): 5,
	Vector3(0, 180, 270): 5,
	Vector3(0, 270, 0): 2,
	Vector3(0, 270, 90): 1,
	Vector3(0, 270, 180): 3,
	Vector3(0, 270, 270): 4,
	Vector3(90, 0, 0): 1,
	Vector3(90, 0, 90): 3,
	Vector3(90, 0, 180): 4,
	Vector3(90, 0, 270): 2,
	Vector3(90, 90, 0): 3,
	Vector3(90, 90, 90): 4,
	Vector3(90, 90, 180): 2,
	Vector3(90, 90, 270): 1,
	Vector3(90, 180, 0): 4,
	Vector3(90, 180, 90): 2,
	Vector3(90, 180, 180): 1,
	Vector3(90, 180, 270): 3,
	Vector3(90, 270, 0): 2,
	Vector3(90, 270, 90): 1,
	Vector3(90, 270, 180): 3,
	Vector3(90, 270, 270): 4,
	Vector3(180, 0, 0): 5,
	Vector3(180, 0, 90): 5,
	Vector3(180, 0, 180): 5,
	Vector3(180, 0, 270): 5,
	Vector3(180, 90, 0): 3,
	Vector3(180, 90, 90): 4,
	Vector3(180, 90, 180): 2,
	Vector3(180, 90, 270): 1,
	Vector3(180, 180, 0): 0,
	Vector3(180, 180, 90): 0,
	Vector3(180, 180, 180): 0,
	Vector3(180, 180, 270): 0,
	Vector3(180, 270, 0): 2,
	Vector3(180, 270, 90): 1,
	Vector3(180, 270, 180): 3,
	Vector3(180, 270, 270): 4,
	Vector3(270, 0, 0): 4,
	Vector3(270, 0, 90): 2,
	Vector3(270, 0, 180): 1,
	Vector3(270, 0, 270): 3,
	Vector3(270, 90, 0): 3,
	Vector3(270, 90, 90): 4,
	Vector3(270, 90, 180): 2,
	Vector3(270, 90, 270): 1,
	Vector3(270, 180, 0): 1,
	Vector3(270, 180, 90): 3,
	Vector3(270, 180, 180): 4,
	Vector3(270, 180, 270): 2,
	Vector3(270, 270, 0): 2,
	Vector3(270, 270, 90): 1,
	Vector3(270, 270, 180): 3,
	Vector3(270, 270, 270): 4,
}

var face_to_rotations = {
	0: [
		Vector3(0, 0, 0), Vector3(0, 0, 90), Vector3(0, 0, 180), Vector3(0, 0, 270),
		Vector3(180, 180, 0), Vector3(180, 180, 90), Vector3(180, 180, 180), Vector3(180, 180, 270)
	],
	1: [
		Vector3(0, 90, 270), Vector3(0, 270, 90), Vector3(90, 0, 0), Vector3(90, 90, 270),
		Vector3(90, 180, 180), Vector3(90, 270, 90), Vector3(180, 90, 270), Vector3(180, 270, 90),
		Vector3(270, 0, 180), Vector3(270, 90, 270), Vector3(270, 180, 0), Vector3(270, 270, 90)
	],
	2: [
		Vector3(0, 90, 180), Vector3(0, 270, 0), Vector3(90, 0, 270), Vector3(90, 90, 180),
		Vector3(90, 180, 90), Vector3(90, 270, 0), Vector3(180, 90, 180), Vector3(180, 270, 0),
		Vector3(270, 0, 90), Vector3(270, 90, 180), Vector3(270, 180, 270), Vector3(270, 270, 0)
	],
	3: [
		Vector3(0, 90, 0), Vector3(0, 270, 180), Vector3(90, 0, 90), Vector3(90, 90, 0),
		Vector3(90, 180, 270), Vector3(90, 270, 180), Vector3(180, 90, 0), Vector3(180, 270, 180),
		Vector3(270, 0, 270), Vector3(270, 90, 0), Vector3(270, 180, 90), Vector3(270, 270, 180)
	],
	4: [
		Vector3(0, 90, 90), Vector3(0, 270, 270), Vector3(90, 0, 180), Vector3(90, 90, 90),
		Vector3(90, 180, 0), Vector3(90, 270, 270), Vector3(180, 90, 90), Vector3(180, 270, 270),
		Vector3(270, 0, 0), Vector3(270, 90, 90), Vector3(270, 180, 180), Vector3(270, 270, 270)
	],
	5: [
		Vector3(0, 180, 0), Vector3(0, 180, 90), Vector3(0, 180, 180), Vector3(0, 180, 270),
		Vector3(180, 0, 0), Vector3(180, 0, 90), Vector3(180, 0, 180), Vector3(180, 0, 270)
	]
}

var face_to_normals = {
	0: [
		Vector3(0.0, 0.0, 0.0),
		Vector3(180.0, 180.0, 180.0)
	],
	1: [
		Vector3(90.0, 0.0, 0.0),
		Vector3(90.0, 90.0, 270.0),
		Vector3(90.0, 180.0, 180.0),
		Vector3(90.0, 270.0, 90.0)
	],
	2: [
		Vector3(0.0, 270.0, 0.0),
		Vector3(180.0, 90.0, 180.0)
	],
	3: [
		Vector3(0.0, 90.0, 0.0),
		Vector3(180.0, 270.0, 180.0)
	],
	4: [
		Vector3(270.0, 0.0, 0.0),
		Vector3(270.0, 90.0, 90.0),
		Vector3(270.0, 180.0, 180.0),
		Vector3(270.0, 270.0, 270.0)
	],
	5: [
		Vector3(0.0, 180.0, 0.0),
		Vector3(180.0, 0.0, 180.0)
	]
}

var normal_to_mirror = {
	Vector3(270.0, 0.0, 180.0): Vector3(270.0, 90.0, 270.0),
	Vector3(270.0, 180.0, 0.0): Vector3(270.0, 90.0, 270.0),
	Vector3(90.0, 0.0, 270.0): Vector3(90.0, 90.0, 180.0),
	Vector3(90.0, 180.0, 90.0): Vector3(90.0, 90.0, 180.0),
	Vector3(270.0, 0.0, 90.0): Vector3(270.0, 90.0, 180.0),
	Vector3(270.0, 180.0, 270.0): Vector3(270.0, 90.0, 180.0),
	Vector3(90.0, 0.0, 90.0): Vector3(90.0, 90.0, 0.0),
	Vector3(90.0, 180.0, 270.0): Vector3(90.0, 90.0, 0.0),
	Vector3(270.0, 0.0, 270.0): Vector3(270.0, 270.0, 180.0),
	Vector3(270.0, 180.0, 90.0): Vector3(270.0, 270.0, 180.0),
	Vector3(90.0, 0.0, 180.0): Vector3(90.0, 90.0, 90.0),
	Vector3(90.0, 180.0, 0.0): Vector3(90.0, 90.0, 90.0),
}
#endregion

#region color
var matter_to_color = {
	Bozo.Matter.NONE: Color.WHITE,
	Bozo.Matter.ANY: Color.DIM_GRAY,
	Bozo.Matter.SOLID: Color.from_hsv(30.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.LIQUID: Color.from_hsv(150.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.GAS: Color.from_hsv(270.0 / 360.0, 0.75, 0.75),
}

var matter_to_hue = {
	Bozo.Matter.SOLID: 0.05,
	Bozo.Matter.LIQUID: 0.35,
	Bozo.Matter.GAS: 0.75,
}

var matter_to_pallete = [
	Color.from_hsv(0.0, 1.0, 0.2),
	Color.from_hsv(0.0416, 0.6, 0.7),
	Color.from_hsv(0.0416, 0.8, 1.0),
]

var regard_to_color = {
	Bozo.Regard.ALLY: Color.from_hsv(210.0 / 360.0, 1.0, 1.0),
	Bozo.Regard.ENEMY: Color.from_hsv(340.0 / 360.0, 1.0, 1.0),
	Bozo.Regard.WILD: Color.FOREST_GREEN, #Color.from_hsv(120.0 / 360.0, 1.0, 1.0),
}

var biome_to_color = {
	Bozo.Biome.NONE: Color.FLORAL_WHITE,
	Bozo.Biome.PLAIN: Color.from_hsv(260.0 / 360.0, 1.0, 1.0),
	Bozo.Biome.SWAMP: Color.from_hsv(150.0 / 360.0, 1.0, 1.0),
	Bozo.Biome.MOUNTAIN: Color.from_hsv(30.0 / 360.0, 1.0, 1.0),
}

const faction_to_pallete = {
	1: 1,
	2: 8,
	3: 3,
	4: 13,
	5: 4, 
	6: 6,
	7: 7,
	8: 9,
	9: 12,
	10: 11,
	11: 14,
	12: 5,
	13: 2,
	14: 10
}
#endregion

func _init() -> void:
	init_shape_colors()
	init_faction_colors()
	init_intros()
	
	for volume in volume_to_matter_to_volume:
		for matter in volume_to_matter_to_volume[volume]:
			var test_volume = volume + matter_to_factor[matter]
			var original_volume = volume_to_matter_to_volume[volume][matter]
			
			if original_volume != test_volume:
				pass

func init_shape_colors() -> void:
	shape_to_color.clear()
	var h: float = 0.0
	var s: float = 1.0
	var v: float = 1.0
	
	for shape in Catalog.shapes:
		shape_to_color[shape] = Color.from_hsv(h, s, v)
		h += 1.0 / Catalog.shapes.size()

func init_faction_colors() -> void:
	faction_to_color.clear()
	var h: float = 0.0
	var s: float = 1.0
	var v: float = 1.0
	
	for _i in Catalog.ACTIVE_FACTIONS:
		faction_to_color[_i + 1] = Color.from_hsv(h, s, v)
		h += 1.0 / Catalog.ACTIVE_FACTIONS


func init_intros() -> void:
	sum_to_matter_to_intro.clear()
	
	for sum in sum_to_index:
		sum_to_matter_to_intro[sum] = {}
		
		for matter in Catalog.matters:
			sum_to_matter_to_intro[sum][matter] = []
		
		for index in sum_to_index[sum] + 1:
			var matters: Array[Bozo.Matter] = []
			var dice = load("res://entities/dice/datas/intro/%d_%d.tres" % [sum, index])
			
			for value in dice.values:
				for matter in Helper.get_matters(value):
					if not matters.has(matter):
						matters.append(matter)
			
			for matter in matters:
				sum_to_matter_to_intro[sum][matter].append(dice)
