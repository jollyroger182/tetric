extends Node2D
class_name Tetromino

@export var board: Board

const cell_image = preload("res://assets/images/cell.png")

@onready var cells: Array[Node2D] = [$Cell1, $Cell2, $Cell3, $Cell4]
@onready var input_handler = $InputHandler

# O, I, S, Z, L, J, T
var SHAPES: Array[Dictionary] = [
	_make_shape("O", [-1, -1, -1, 0, 0, -1, 0, 0], Color("#F0F000")),
	_make_shape("I", [0, -2, 0, -1, 0, 0, 0, 1], Color("#00F0F0")),
	_make_shape("S", [-1, 0, 0, 0, 0, -1, 1, -1], Color("#00F000")),
	_make_shape("Z", [-1, -1, 0, -1, 0, 0, 1, 0], Color("#F00000")),
	_make_shape("L", [-1, -2, -1, -1, -1, 0, 0, 0], Color("#F0A000")),
	_make_shape("J", [0, -2, 0, -1, 0, 0, -1, 0], Color("#0000F0")),
	_make_shape("T", [-1, -1, 0, -1, 0, 0, 1, -1], Color("#A000F0")),
]

var offsets: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(0, 3)
]

var offset = Vector2i.ZERO

var has_landed := false


signal landed(piece: Tetromino)


func _ready() -> void:
	var shape = SHAPES[randi_range(0, SHAPES.size()-1)]
	offsets.assign(shape["tiles"])
	modulate = shape["color"]
	var min_y = 0
	for i in range(4):
		min_y = min(min_y, offsets[i].y)
	offset.y = -min_y
	update_position()


func update_position():
	for i in range(4):
		cells[i].position = offsets[i] * Constants.SIZE
		cells[i].scale.x = 1.0 * Constants.SIZE / cell_image.get_width()
		cells[i].scale.y = 1.0 * Constants.SIZE / cell_image.get_height()
	position = offset * Constants.SIZE


func try_move(direction: Vector2i):
	if board.can_place(offset + direction, offsets):
		offset += direction
		update_position()
		return true
	else:
		if direction == Vector2i.DOWN and not has_landed:
			has_landed = true
			landed.emit(self)
		return false


func try_rotate(ccw: bool):
	var new_piece: Array[Vector2i] = []
	for tile in offsets:
		var new_tile = Vector2i(tile.y, -tile.x) * (-1 if ccw else 1)
		new_piece.append(new_tile)
	if board.can_place(offset, new_piece):
		offsets.assign(new_piece)
		update_position()


func hard_drop():
	while try_move(Vector2i.DOWN):
		pass


func _make_shape(name: String, offsets: Array[int], color: Color):
	var tiles = []
	for i in range(4):
		tiles.append(Vector2i(offsets[i*2], offsets[i*2+1]))
	return { "name": name, "tiles": tiles, "color": color }
