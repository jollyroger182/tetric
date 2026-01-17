extends ColorRect

const NORMAL_COLOR = Color.WHITE
const HOVER_COLOR = Color.LIGHT_GRAY


func _on_mouse_entered() -> void:
	color = HOVER_COLOR


func _on_mouse_exited() -> void:
	color = NORMAL_COLOR
