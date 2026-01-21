extends Node

signal play_pause
signal add_note
signal undo
signal redo
signal seek(amount: float)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("editor_play"):
		play_pause.emit()
	if Input.is_action_just_pressed("editor_add_note"):
		add_note.emit()
	if Input.is_action_just_pressed("undo"):
		undo.emit()
	if Input.is_action_just_pressed("redo"):
		redo.emit()
	if Input.is_action_just_pressed("seek_back"):
		seek.emit(-5)
	if Input.is_action_just_pressed("seek_forward"):
		seek.emit(5)
