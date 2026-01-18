extends Node

var up_next = []


func _init() -> void:
	reset()


func reset():
	up_next.clear()
	_generate()
	_generate()
	_generate()


func get_piece():
	var shape = up_next.pop_front()
	_generate()
	return shape


func _generate():
	var shapes = Constants.SHAPES
	var shape = shapes[randi_range(0, shapes.size()-1)]
	up_next.append(shape)
