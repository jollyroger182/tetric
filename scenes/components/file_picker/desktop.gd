extends Node2D

signal selected(path: String)
signal cancelled


func pick():
	$FileDialog.show()


func _on_file_selected(path: String) -> void:
	selected.emit(path)


func _on_cancelled():
	cancelled.emit()
