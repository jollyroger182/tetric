extends Node

const BOARD_SIZE = Vector2i(10, 20)
const SIZE = 32

const EDITOR_SCALE = 200

var SHAPES: Array[Dictionary] = [
	_make_shape("O", [0, 0, 0, 1, 1, 0, 1, 1], [1, 1], Color("#F0F000")),
	_make_shape("I", [0, 0, 1, 0, 2, 0, 3, 0], [2, 0], Color("#00F0F0")),
	_make_shape("S", [0, 1, 1, 1, 1, 0, 2, 0], [1, 1], Color("#00F000")),
	_make_shape("Z", [0, 0, 1, 0, 1, 1, 2, 1], [1, 1], Color("#F00000")),
	_make_shape("L", [0, 1, 1, 1, 2, 1, 2, 0], [1, 1], Color("#F0A000")),
	_make_shape("J", [0, 0, 0, 1, 1, 1, 2, 1], [1, 1], Color("#0000F0")),
	_make_shape("T", [1, 0, 0, 1, 1, 1, 2, 1], [1, 1], Color("#A000F0")),
]

const MISS_THRESH = 0.2
const PERFECT_THRESH = 0.1


func _make_shape(name: String, offsets: Array[int], center: Array[int], color: Color):
	var tiles = []
	for i in range(4):
		tiles.append(Vector2i(offsets[i*2], offsets[i*2+1]))
	var center_v = Vector2i(center[0], center[1])
	return { "name": name, "tiles": tiles, "center": center_v, "color": color }
