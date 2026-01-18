extends Node

@export var piece: Tetromino
@export var rhythm: Rhythm


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		if rhythm.validate_input():
			piece.try_rotate(true)
	if Input.is_action_just_pressed("left"):
		if rhythm.validate_input():
			piece.try_move(Vector2i.LEFT)
	if Input.is_action_just_pressed("right"):
		if rhythm.validate_input():
			piece.try_move(Vector2i.RIGHT)
	if Input.is_action_just_pressed("soft_drop"):
		if rhythm.validate_input():
			piece.try_move(Vector2i.DOWN)
	if Input.is_action_just_pressed("hard_drop"):
		if rhythm.validate_input():
			piece.hard_drop()
