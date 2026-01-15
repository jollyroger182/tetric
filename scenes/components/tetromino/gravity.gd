extends Node

@export var piece: Tetromino
@export var fall_interval = 0.5

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	if time >= fall_interval:
		time = 0.0
		piece.try_move(Vector2i.DOWN)
