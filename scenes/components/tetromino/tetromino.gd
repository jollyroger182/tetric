extends Node2D

@onready var cells: Array[Node2D] = [$Cell1, $Cell2, $Cell3, $Cell4]
var offsets: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(0, 3)
]


func _ready() -> void:
	for i in range(4):
		cells[i].position = offsets[i] * Constants.SIZE
