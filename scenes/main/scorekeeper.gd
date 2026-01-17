extends Node
class_name Scorekeeper

var score: int = 0

signal changed(old: int, new: int)


func cleared_rows(number: int):
	var delta = [100, 300, 500, 800][min(3, number-1)]
	change_score(delta)


func change_score(delta: int):
	score += delta
	changed.emit(score - delta, score)
