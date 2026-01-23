extends Node2D
class_name Rhythm

const RhythmNote = preload("res://scenes/components/rhythm_note/rhythm_note.tscn")

@onready var container = $Notes

@export var conductor: Conductor
@export var scorekeeper: Scorekeeper

var notes: Array[Node2D] = []


func _draw():
	draw_circle(Vector2.ZERO, 50, Color("#008b8b"), false, 5, true)


func _on_note_expired(note: Node2D):
	delete_note(note)
	scorekeeper.miss_note()


func delete_note(note: Node2D):
	note.queue_free()
	notes.remove_at(notes.find(note))


func load_level(level: Dictionary):
	var times = level["notes"]
	for time in times:
		var note = RhythmNote.instantiate()
		note.conductor = conductor
		note.time = time + Settings.offset / 1000.0
		note.expired.connect(_on_note_expired)
		container.add_child(note)
		notes.append(note)


func validate_input():
	# check if there is a note nearby, if so delete and return true
	if notes.is_empty():
		return false
	var note = notes[0]
	if abs(note.time - conductor.playback_pos) < Constants.MISS_THRESH:
		delete_note(note)
		scorekeeper.hit_note()
		return true
	return false
