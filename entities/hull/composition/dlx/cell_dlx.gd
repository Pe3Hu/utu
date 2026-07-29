class_name DLXCell
extends RefCounted

var up: DLXCell
var down: DLXCell
var left: DLXCell
var right: DLXCell

var header: DLXColumnHeader
var row_id: int  # ID строки в исходной матрице

func _init(header_: DLXColumnHeader) -> void:
	header = header_
	up = self
	down = self
	left = self
	right = self
	row_id = -1
