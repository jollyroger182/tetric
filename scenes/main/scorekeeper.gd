extends Node
class_name Scorekeeper

var score: int = 0
var hits: int = 0
var misses: int = 0

signal changed


func cleared_rows(number: int):
	var delta = [100, 300, 500, 800][min(3, number-1)]
	change_score(delta)


func hit_note():
	hits += 1
	change_score(10)


func miss_note():
	misses += 1
	changed.emit()


func change_score(delta: int):
	score += delta
	changed.emit()
