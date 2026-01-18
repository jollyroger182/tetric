extends Node2D
class_name Rhythm

const RhythmNote = preload("res://scenes/components/rhythm_note/RhythmNote.tscn")

@export var conductor: Conductor

var notes: Array[Node2D] = []


func _draw():
	draw_rect(Rect2(-300, -300, 600, 600), Color.WHITE)


func _on_note_expired(note: Node2D):
	note.queue_free()
	notes.remove_at(notes.find(note))


func load_level(level: Dictionary):
	var times = level["notes"]
	for time in times:
		var note = RhythmNote.instantiate()
		note.conductor = conductor
		note.time = time
		note.expired.connect(_on_note_expired)
		add_child(note)
		notes.append(note)


func validate_input():
	# check if there is a note nearby, if so delete and return true
	if notes.is_empty():
		return false
	var note = notes[0]
	if abs(note.time - conductor.playback_pos) < 0.2:
		_on_note_expired(note)
		return true
	return false
