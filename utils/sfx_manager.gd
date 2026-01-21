extends AudioStreamPlayer

var SOUNDS = {}

var _enabled = true


func _ready() -> void:
	volume_db = -5
	max_polyphony = 1
	for file in ResourceLoader.list_directory("res://assets/sfx"):
		var sound = file.split(".")[0]
		SOUNDS[sound] = ResourceLoader.load("res://assets/sfx/" + file)


func play_sound(sound: String, wait: bool = false):
	if not _enabled:
		return
	if sound in SOUNDS:
		stream = SOUNDS[sound]
		play()
		if wait:
			_enabled = false
			await finished
			_enabled = true
