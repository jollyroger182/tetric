extends Node

var items = []
var redo_items = []

var can_undo: bool:
	get:
		return not items.is_empty()

var can_redo: bool:
	get:
		return not redo_items.is_empty()


func push_action(action):
	items.append(action)
	redo_items.clear()


func undo():
	if not items.is_empty():
		var action = items.pop_back()
		redo_items.append(action)
		return action


func redo():
	if not redo_items.is_empty():
		var action = redo_items.pop_back()
		items.append(action)
		return action
