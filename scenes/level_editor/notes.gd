extends ColorRect

const SCALE = 200

var EditorNote = preload("res://scenes/level_editor/editor_note.tscn")

@export var editor: LevelEditor


func update_size():
	size.x = SCALE * editor.player.stream.get_length()


func _process(_delta: float) -> void:
	position.x = get_viewport().get_visible_rect().size.x / 2 - SCALE * editor.player.playback_pos


func add_note(time: float):
	var note: Control = EditorNote.instantiate()
	note.position.x = time * SCALE
	add_child(note)
