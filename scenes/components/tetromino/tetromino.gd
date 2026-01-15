extends Node2D
class_name Tetromino

@export var board: Board

const cell_image = preload("res://assets/images/cell.png")

@onready var cells: Array[Node2D] = [$Cell1, $Cell2, $Cell3, $Cell4]
@onready var input_handler = $InputHandler

var offsets: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(0, 3)
]

var offset = Vector2i.ZERO

	
func _ready() -> void:
	for i in range(4):
		cells[i].position = offsets[i] * Constants.SIZE
		cells[i].scale.x = 1.0 * Constants.SIZE / cell_image.get_width()
		cells[i].scale.y = 1.0 * Constants.SIZE / cell_image.get_height()


func _process(delta: float):
	pass


func update_position():
	position = offset * Constants.SIZE


func try_move(direction: Vector2i):
	if board.can_place(offset + direction, offsets):
		offset += direction
		update_position()
