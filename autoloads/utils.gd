extends Node


func format_offset(offset):
	offset = roundi(offset)
	if offset <= 0:
		return str(offset) + "ms"
	return "+" + str(offset) + "ms"
