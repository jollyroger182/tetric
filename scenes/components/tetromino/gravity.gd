extends Node

@export var piece: Tetromino
@export var conductor: Conductor
@export var fall_interval = 1.0

var last_fall = 0.0


func _ready():
	last_fall = conductor.playback_pos


func _process(_delta: float) -> void:
	if conductor.playback_pos >= last_fall + fall_interval:
		piece.try_move(Vector2i.DOWN)
		last_fall += fall_interval
