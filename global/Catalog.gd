extends Node



#region matter
const matters: Array[Bozo.Matter] = [
	Bozo.Matter.GAS,
	Bozo.Matter.LIQUID,
	Bozo.Matter.SOLID,
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

#endregion

#region canto
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

var net_neighbors = {
	0: [3, 1, 2],
	1: [4, 2, 0],
	2: [5, 0, 1],
	3: [0, 4, 5],
	4: [1, 5, 3],
	5: [2, 3, 4]
}

var volumes = [2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 25, 27, 30, 32]

var pulses = [0, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 25, 27, 30, 
		32, 36, 40, 45, 50, 54, 60, 64, 75, 81, 90, 96, 100]

var chorus_values = {
	"I": [7, 11, 13, 17, 19, 23],
	"II": [19, 23, 29, 31, 37, 41],
	"III": [37, 41, 43, 47, 53, 59],
	"IV": [53, 59, 61, 67, 71, 73],
	"V": [71, 73, 79, 83, 89, 97]
}

const verse_indexs = [34, 35, 36]

const OUTRO_BASE_LIMIT: int = 5
#endregion

#region align
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
#endregion

#region shape
const letters = ["f", "i", "l", "n", "p", "t", "u", "v", "w", "x", "y", "z"]

const shapes = [
	Bozo.Shape.F,
	Bozo.Shape.I,
	Bozo.Shape.L,
	Bozo.Shape.N,
	Bozo.Shape.P,
	Bozo.Shape.T,
	Bozo.Shape.U,
	Bozo.Shape.V,
	Bozo.Shape.W,
	Bozo.Shape.X,
	Bozo.Shape.Y,
	Bozo.Shape.Z
]
#endregion

#region board
const BOARD_SIZE = Vector2i(8, 8)

var corners = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(0, 1),
]

const directions = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

const shrines = [
	[Vector2i(1, 1)],
	[Vector2i(1, 4), Vector2i(4, 1)],
	[Vector2i(7, 1)],
	[Vector2i(3, 6)],
	[Vector2i(6, 4), Vector2i(5, 7)]
]
#endregion

#region realm
const TIDE_AMOUNT: int = 3
const DEFAULT_RAMPART: int = 11
const BASTION_SIZE: Vector2 = Vector2(48, 48)
const REALM_SIZE: Vector2i = BOARD_SIZE * 2

const factions = [Bozo.Faction.BLUE, Bozo.Faction.RED, Bozo.Faction.GREEN]
const active_factions = [Bozo.Faction.BLUE, Bozo.Faction.RED]
#endregion

#region biome
const biomes = [Bozo.Biome.PLAIN, Bozo.Biome.SWAMP, Bozo.Biome.MOUNTAIN]

const region_sizes = [
	Vector2i(5, 3),
	Vector2i(3, 5),
]

const region_anchors = [
	[
		Vector2i(0, 0),
		Vector2i(5, 0),
		Vector2i(3, 5),
		Vector2i(0, 3),
	],
	[
		Vector2i(3, 0),
		Vector2i(0, 0),
		Vector2i(0, 5),
		Vector2i(5, 3),
	]
]

const biome_sizes = [[3, 3], [4 ,1]]

const regions = [
	Bozo.Region.CORNER,
	Bozo.Region.SIDE,
	Bozo.Region.CENTER
]
#endregion

#region card
const JOINT_SIZE = Vector2(36, 36)
const JOINT_OFFEST: float = -4.0
const STAKE_SIGN_OFFEST: float = 4.0
const GYRE_ACTUAL_STAMP_SIZE = 4

const stakes = [Bozo.Stake.LEFT, Bozo.Stake.RIGHT]
#endregion

#region fleet
const VOLUME_SIZE = Vector2(36, 36)
const VOLUME_BORDER: float = 4.0
const ARK_PIVOT = Vector2(124, 18)
const SPOIL_CORNER: int = 18
#endregion

const LADDER_SIZE = Vector2i(5, 9) 
const STAIR_SIZE = Vector2(64, 64)

var axes: Array[Vector3] = [
	Vector3(90, 0, 0),
	Vector3(0, 90, 0),
	Vector3(0, 0, 90)
]

const NO_RAMPART_COORD = Vector2i(9, 10)

const STARTER_HARVEST_AMOUNT: int = 20

const MARK_DIGITS_MAX_LENGTH: int = 6
const fusion_mark_lengths = [2, 3, 6]
