extends Node

@export var piece: Tetromino
@export var conductor: Conductor
@export var fall_interval = 1.0

var last_fall = -1.0


func _process(_delta: float) -> void:
	if last_fall < 0:
		last_fall = conductor.playback_pos
		return
	if conductor.playback_pos >= last_fall + fall_interval:
		piece.try_move(Vector2i.DOWN)
		last_fall += fall_interval
