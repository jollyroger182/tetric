extends Node2D

signal selected(path: String)
signal cancelled


func pick():
	if OS.has_feature("web"):
		$Web.pick()
	else:
		$Desktop.pick()


func _on_selected(path: String):
	selected.emit(path)


func _on_cancelled():
	cancelled.emit()
