extends Node



var shape_to_color: Dictionary
var sum_to_matter_to_intro: Dictionary


#region domain
const domain_to_vassal: Dictionary = {
	Bozo.Domain.EARLDOM: Bozo.Domain.FIEFDOM,
	Bozo.Domain.DUKEDOM: Bozo.Domain.EARLDOM,
	Bozo.Domain.KINGDOM: Bozo.Domain.DUKEDOM,
}


const domaint_to_size = {
	Bozo.Domain.EARLDOM: 5,
	Bozo.Domain.DUKEDOM: 4,
	Bozo.Domain.KINGDOM: 3
}
#endregion

#region matter
const verse_to_matter = {
	34: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	35: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	36: [
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

const flag_to_regard = {
	true: Bozo.Regard.ALLY,
	false: Bozo.Regard.ENEMY
}

const flag_to_faction = {
	true: Bozo.Faction.BLUE,
	false: Bozo.Faction.RED
}

const direction_to_diagonal = {
	Vector2i(0, -1): [Vector2i(-1, -1), Vector2i(1, -1)],
	Vector2i(1, 0): [Vector2i(1, -1), Vector2i(1, 1)],
	Vector2i(0, 1): [Vector2i(-1, 1), Vector2i(1, 1)],
	Vector2i(-1, 0): [Vector2i(-1, -1), Vector2i(-1, 1)],
}

const tune_to_stake = {
	Bozo.Tune.INTRO: Bozo.Stake.RIGHT,
	Bozo.Tune.VERSE: Bozo.Stake.LEFT,
	Bozo.Tune.OUTRO: Bozo.Stake.LEFT,
}

const tune_to_math = {
	Bozo.Tune.VERSE: Bozo.Math.PLUS,
	Bozo.Tune.OUTRO: Bozo.Math.MULTIPLY,
	
}


#region color
var regard_to_color = {
	Bozo.Regard.ALLY: Color.from_hsv(210.0 / 360.0, 1.0, 1.0),
	Bozo.Regard.ENEMY: Color.from_hsv(340.0 / 360.0, 1.0, 1.0),
	Bozo.Regard.WILD: Color.from_hsv(120.0 / 360.0, 1.0, 1.0),
}

var faction_to_color = {
	Bozo.Faction.BLUE: Color.from_hsv(210.0 / 360.0, 1.0, 1.0),
	Bozo.Faction.RED: Color.from_hsv(340.0 / 360.0, 1.0, 1.0),
	Bozo.Faction.GREEN: Color.from_hsv(120.0 / 360.0, 1.0, 1.0),
}

var biome_to_color = {
	Bozo.Biome.NONE: Color.FLORAL_WHITE,
	Bozo.Biome.PLAIN: Color.from_hsv(260.0 / 360.0, 1.0, 1.0),
	Bozo.Biome.SWAMP: Color.from_hsv(150.0 / 360.0, 1.0, 1.0),
	Bozo.Biome.MOUNTAIN: Color.from_hsv(30.0 / 360.0, 1.0, 1.0),
}
#endregion

func _init() -> void:
	init_shape_colors()
	init_intros()

func init_shape_colors() -> void:
	shape_to_color.clear()
	var h: float = 0.0
	var s: float = 1.0
	var v: float = 1.0
	
	for shape in Catalog.shapes:
		shape_to_color[shape] = Color.from_hsv(h, s, v)
		h += 1.0 / Catalog.shapes.size()

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
	
