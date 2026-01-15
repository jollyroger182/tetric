extends Node2D

@onready var board: Board = $Board


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board.position.x = Constants.BOARD_SIZE.x * Constants.SIZE / 2
	print(board.position.x)
	board.spawn_piece()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
