extends AudioStreamPlayer

var SOUNDS = {}


func _ready() -> void:
	max_polyphony = 10
	for file in ResourceLoader.list_directory("res://assets/sfx"):
		var sound = file.split(".")[0]
		SOUNDS[sound] = ResourceLoader.load("res://assets/sfx/" + file)


func play_sound(sound: String):
	if sound in SOUNDS:
		stream = SOUNDS[sound]
		play()
