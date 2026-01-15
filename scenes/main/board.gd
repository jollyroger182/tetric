extends Node2D
class_name Board

const TetrominoScene = preload("res://scenes/components/tetromino/tetromino.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_piece():
	var tetromino: Tetromino = TetrominoScene.instantiate()
	tetromino.board = self
	tetromino.name = "ActivePiece"
	add_child(tetromino)


func can_place(offset: Vector2i, piece: Array[Vector2i]) -> bool:
	return true
