extends AudioStreamPlayer

@export var audio: AudioStream

var playback_pos: float  # seconds


func _ready() -> void:
	stream = AudioStreamSynchronized.new()
	stream.stream_count = 1
	stream.set_sync_stream(0, audio)
	
	stop()


func _process(_delta: float) -> void:
	playback_pos = get_playback_position()


func pause():
	stream_paused = true


func unpause():
	if stream_paused:
		stream_paused = false
	elif not playing:
		play()


func get_state():
	print(playing, " ", stream_paused)
	if playing:
		return 'playing'
	if stream_paused:
		return 'paused'
	return 'stopped'
