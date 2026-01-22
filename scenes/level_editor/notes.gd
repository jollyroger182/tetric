extends ColorRect

var EditorNote = preload("res://scenes/level_editor/editor_note.tscn")

signal note_deleted(time: float)

@export var editor: LevelEditor

var notes: Array = []


func update_size():
	size.x = Constants.EDITOR_SCALE * editor.player.stream.get_length()


func _process(_delta: float) -> void:
	position.x = get_viewport().get_visible_rect().size.x / 2 - Constants.EDITOR_SCALE * (editor.player.playback_pos - Settings.offset / 1000.0)


func add_note(time: float):
	var note: EditorNote = EditorNote.instantiate()
	note.time = time
	note.deleted.connect(_on_note_deleted)
	add_child(note)
	
	notes.append(time)
	notes.sort()


func delete_note(time: float):
	for note in get_children():
		if note is EditorNote and note.time == time:
			_delete_note(note)


func _on_note_deleted(note: EditorNote):
	note_deleted.emit(note.time)
	_delete_note(note)


func _delete_note(note: EditorNote):
	note.queue_free()
	
	var index = notes.find(note.time)
	if index >= 0:
		notes.remove_at(index)
	else:
		push_warning("failed to remove note! something bad might have happened")
