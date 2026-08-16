extends Node


var tempo: int = 0
var is_auto_play: bool = true#true false
var is_pause: bool = true

const net_rolls: Array[float] = [0.1, 2]
const appears: Array[float] = [0.05, 0.8]
const activates: Array[float] = [0.05, 0.8]
const peaks: Array[float] = [0.05, 0.8]
const jalousies: Array[float] = [0.05, 0.8]
const straws: Array[float] = [0.05, 0.8]

const min_appear_factor: float = -0.9#0.8
const max_appear_factor: float = -0.9#1.0
