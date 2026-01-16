extends Node2D
class_name Tetromino

@export var board: Board

const cell_image = preload("res://assets/images/cell.png")

@onready var cells: Array[Node2D] = [$Cell1, $Cell2, $Cell3, $Cell4]
@onready var input_handler = $InputHandler

# O, I, S, Z, L, J, T
const shapes: Array[Array] = [
	[Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, -1), Vector2i(0, 0)],
	[Vector2i(0, -2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1)],
	[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(0, -1), Vector2i(1, -1)],
	[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, 0)],
	[Vector2i(-1, -2), Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0)],
	[Vector2i(0, -2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(-1, 0)],
	[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, -1)],
]

var offsets: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(0, 3)
]

var offset = Vector2i.ZERO


signal landed(piece: Tetromino)


func _ready() -> void:
	offsets.assign(shapes[randi_range(0, shapes.size()-1)])
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
	else:
		if direction == Vector2i.DOWN:
			landed.emit(self)


func try_rotate(ccw: bool):
	var new_piece: Array[Vector2i] = []
	for tile in offsets:
		var new_tile = Vector2i(tile.y, -tile.x) * (-1 if ccw else 1)
		new_piece.append(new_tile)
	if board.can_place(offset, new_piece):
		offsets.assign(new_piece)
		update_position()
