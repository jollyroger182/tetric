extends Node2D
class_name Rhythm

const RhythmNote = preload("res://scenes/components/rhythm_note/RhythmNote.tscn")

@onready var container = $Notes

@export var conductor: Conductor
@export var scorekeeper: Scorekeeper

var notes: Array[Node2D] = []

var hits = 0
var misses = 0


signal update(data: Dictionary)


func _draw():
	draw_rect(Rect2(-325, -325, 650, 650), Color.WHITE, false)


func _on_note_expired(note: Node2D):
	delete_note(note)
	misses += 1
	_update()


func _update():
	update.emit({ "hits": hits, "misses": misses })


func delete_note(note: Node2D):
	note.queue_free()
	notes.remove_at(notes.find(note))


func load_level(level: Dictionary):
	var times = level["notes"]
	for time in times:
		var note = RhythmNote.instantiate()
		note.conductor = conductor
		note.time = time
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
		hits += 1
		scorekeeper.hit_note()
		_update()
		return true
	return false
