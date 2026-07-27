extends Node



var net_neighbors = {
	0: [3, 1, 2],
	1: [4, 2, 0],
	2: [5, 0, 1],
	3: [0, 4, 5],
	4: [1, 5, 3],
	5: [2, 3, 4]
}


var pulse_values: Array = [2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 25, 27, 30, 32]

var chorus_values: Dictionary = {
	"I": [7, 11, 13, 17, 19, 23],
	"II": [19, 23, 29, 31, 37, 41],
	"III": [37, 41, 43, 47, 53, 59],
	"IV": [53, 59, 61, 67, 71, 73],
	"V": [71, 73, 79, 83, 89, 97]
}



#region matter
const matters: Array[Bozo.Matter] = [
	Bozo.Matter.SOLID,
	Bozo.Matter.LIQUID,
	Bozo.Matter.GAS
]

var outro_to_matter_to_values: Dictionary = {
	0: {
		Bozo.Matter.GAS: [2, 3, 4, 5],
		Bozo.Matter.LIQUID: [2, 3],
		Bozo.Matter.SOLID: [2]
	},
	1: {
		Bozo.Matter.GAS: [6, 8, 9, 10],
		Bozo.Matter.LIQUID: [4, 5, 6],
		Bozo.Matter.SOLID: [3, 4]
	},
	2: {
		Bozo.Matter.GAS: [12, 15, 18, 20],
		Bozo.Matter.LIQUID: [8, 9, 10, 12],
		Bozo.Matter.SOLID: [5, 6, 8]
	},
	3: {
		Bozo.Matter.GAS: [25, 27, 30],
		Bozo.Matter.LIQUID: [15, 18, 20],
		Bozo.Matter.SOLID: [9, 10, 12]
	},
	4: {
		Bozo.Matter.GAS: [32],
		Bozo.Matter.LIQUID: [25, 27, 30, 32],
		Bozo.Matter.SOLID: [15, 18, 20]
	}
}

var matter_to_factor = {
	Bozo.Matter.SOLID: 5,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.GAS: 2,
}

var matter_to_color = {
	Bozo.Matter.SOLID: Color.from_hsv(30.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.LIQUID: Color.from_hsv(150.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.GAS: Color.from_hsv(270.0 / 360.0, 0.75, 0.75),
}
#endregion


const tunes = [
	Bozo.Tune.INTRO,
	Bozo.Tune.VERSE,
	Bozo.Tune.OUTRO
]

var grids = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(1, 2),
]


const index_to_anchor = {
	0: Control.PRESET_TOP_LEFT,
	1: Control.PRESET_LEFT_WIDE,
	2: Control.PRESET_BOTTOM_LEFT,
	3: Control.PRESET_TOP_RIGHT,
	4: Control.PRESET_RIGHT_WIDE,
	5: Control.PRESET_BOTTOM_RIGHT,
}

var axis_to_anchor = {
	Vector2i(0, 0): Control.PRESET_TOP_LEFT,      # 0
	Vector2i(0, 1): Control.PRESET_LEFT_WIDE,     # 1
	Vector2i(0, 2): Control.PRESET_BOTTOM_LEFT,   # 2
	Vector2i(1, 0): Control.PRESET_TOP_RIGHT,     # 3
	Vector2i(1, 1): Control.PRESET_RIGHT_WIDE,    # 4
	Vector2i(1, 2): Control.PRESET_BOTTOM_RIGHT,  # 5
}
