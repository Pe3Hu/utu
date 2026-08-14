extends Node


var tempo: int = 0
var is_auto_play: bool = false#true false

const net_rolls: Array[float] = [0.1, 2]
const appears: Array[float] = [0.05, 0.8]
const activates: Array[float] = [0.05, 0.8]
const peaks: Array[float] = [0.05, 0.8]
const jalousies: Array[float] = [0.05, 0.8]
const straws: Array[float] = [1, 0.8]

const min_appear_factor: float = -0.9#0.8
const max_appear_factor: float = -0.9#1.0
