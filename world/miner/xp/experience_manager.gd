extends Node
class_name ExperienceManager

var level: int = 1
var xp: int = 0
@export var max_xp: int = 100
@export var max_xp_multiplier: int = 2

signal xp_updated(xp: int, max_xp: int)
signal level_updated(level: int)


func gain_xp(added_xp: int) -> void:
	xp += added_xp

	if xp >= max_xp:
		increment_level()
		var overflow_xp = max_xp - xp
		xp = overflow_xp
		max_xp *= max_xp_multiplier

	xp_updated.emit(xp, max_xp)


func increment_level() -> void:
	level += 1
	level_updated.emit(level)
