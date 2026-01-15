extends Node

@export var piece: Tetromino


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate"):
		print("rotatey")
