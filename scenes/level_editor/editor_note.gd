extends Control
class_name EditorNote

@export var time: float

signal deleted(note: EditorNote)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = time * Constants.EDITOR_SCALE


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				deleted.emit(self)
			MOUSE_BUTTON_RIGHT:
				pass
