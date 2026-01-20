extends Node

@export var piece: Tetromino
@export var rhythm: Rhythm

var soft_dropping = false

signal soft_drop_start
signal soft_drop_end


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
	if Input.is_action_just_pressed("hard_drop"):
		if rhythm.validate_input():
			piece.hard_drop()
	
	var soft_drop_pressed = Input.is_action_pressed("soft_drop")
	if soft_drop_pressed and not soft_dropping:
		soft_drop_start.emit()
		soft_dropping = true
	elif not soft_drop_pressed and soft_dropping:
		soft_drop_end.emit()
		soft_dropping = false
