extends Panel

@onready var conductor = $Conductor
@onready var sfx = $SFX

@onready var countdown_label = $CountdownLabel
@onready var offset_label = $VBoxContainer/OffsetLabel

var last_offset = 0
var total_offset = 0.0
var total_beats = 0
var last_beat = 1.5

# update ui

func _update_offset_label():
	offset_label.text = \
		"Last offset: " + \
		str(Utils.format_offset(last_offset * 1000)) + \
		"\nAverage offset: " + \
		str(Utils.format_offset(total_offset * 1000 / total_beats))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if conductor.playing:
		if conductor.playback_pos < 0.5:
			countdown_label.text = "3"
		elif conductor.playback_pos < 1:
			countdown_label.text = "2"
		elif conductor.playback_pos < 1.5:
			countdown_label.text = "1"
		elif conductor.playback_pos < 2:
			countdown_label.text = "GO"
		else:
			countdown_label.text = ""
		if Input.is_action_just_pressed("hard_drop"):
			var current_pos = conductor.playback_pos
			if current_pos > last_beat:
				var expected = last_beat + 0.5
				var offset = current_pos - expected
				last_offset = offset
				total_offset += offset
				total_beats += 1
				last_beat += 0.5
				_update_offset_label()


func _on_start() -> void:
	conductor.unpause()


func _on_finish() -> void:
	if total_beats > 0:
		Settings.offset = roundi(total_offset * 1000 / total_beats)
		Settings.save()
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")


func _on_discard() -> void:
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")
