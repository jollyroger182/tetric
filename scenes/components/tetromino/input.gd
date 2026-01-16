extends Node

@export var piece: Tetromino


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		piece.try_rotate(true)
	if Input.is_action_just_pressed("left"):
		piece.try_move(Vector2i.LEFT)
	if Input.is_action_just_pressed("right"):
		piece.try_move(Vector2i.RIGHT)
	if Input.is_action_just_pressed("soft_drop"):
		piece.try_move(Vector2i.DOWN)
	if Input.is_action_just_pressed("hard_drop"):
		piece.hard_drop()
