extends Panel

@onready var sfx = $SFX

# labels
@onready var offset_label = $VBoxContainer/Settings/Offset/Value


func _ready():
	_update_offset()


# update ui

func _update_offset():
	var offset = Settings.offset
	if offset < 0:
		offset_label.text = str(offset) + "ms"
	else:
		offset_label.text = "+" + str(offset) + "ms"


func _on_button_mouse_entered() -> void:
	sfx.play_sound("select")


func _on_back() -> void:
	await sfx.play_sound("cancel", true)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_offset_minus() -> void:
	Settings.offset -= 1
	Settings.save()
	_update_offset()


func _on_offset_plus() -> void:
	Settings.offset += 1
	Settings.save()
	_update_offset()
