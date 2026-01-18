extends Node2D
class_name Tetromino

@export var board: Board
@export var rhythm: Rhythm

const cell_image = preload("res://assets/images/cell.png")

@onready var cells: Array[Node2D] = [$Cell1, $Cell2, $Cell3, $Cell4]
@onready var input_handler = $InputHandler
@onready var gravity = $Gravity

var shape

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
	shape = shape if shape else Randomizer.get_piece()
	offsets.assign(shape["tiles"])
	modulate = shape["color"]
	if board:
		# i'm on a board, enable falling and stuff
		offset.x += shape["center"].x
		$Gravity.conductor = board.conductor
		$InputHandler.rhythm = rhythm
		update_position()
	else:
		# i'm just a static piece
		set_process(false)
		$Gravity.set_process(false)
		$InputHandler.set_process(false)
	update_cell_positions()


func _process(_delta: float):
	if not board.can_place(offset, offsets):
		landed.emit(self)


func update_position():
	position = offset * Constants.SIZE


func update_cell_positions():
	for i in range(4):
		cells[i].position = offsets[i] * Constants.SIZE
		cells[i].scale.x = 1.0 * Constants.SIZE / cell_image.get_width()
		cells[i].scale.y = 1.0 * Constants.SIZE / cell_image.get_height()


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
		var recentered = tile - shape["center"]
		var new_tile = Vector2i(recentered.y, -recentered.x) * (-1 if ccw else 1) + shape["center"]
		new_piece.append(new_tile)
	print(new_piece)
	if board.can_place(offset, new_piece):
		offsets.assign(new_piece)
		update_cell_positions()


func hard_drop():
	while try_move(Vector2i.DOWN):
		pass
