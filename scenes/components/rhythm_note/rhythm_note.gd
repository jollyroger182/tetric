extends Node2D

@export var conductor: Conductor
@export var time: float

var _is_expired = false

signal expired(note: Node2D)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if conductor.playback_pos > time + Constants.MISS_THRESH:
		if not _is_expired:
			expired.emit(self)
			_is_expired = true
	else:
		queue_redraw()


func _draw():
	var radius = (time - conductor.playback_pos) * 300
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 2, true)
