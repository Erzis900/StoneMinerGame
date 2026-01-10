extends Node
class_name ExperienceManager

var level: int = 1
var xp: int = 0
@export var max_xp: int = 100
@export var max_xp_multiplier: int = 4

signal xp_updated(xp: int, max_xp: int)
signal level_updated(level: int)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		increment_level()


func gain_xp(added_xp: int) -> void:
	xp += added_xp

	if xp >= max_xp:
		increment_level()
		var overflow_xp = max_xp - xp
		xp = overflow_xp
		max_xp += 200

	xp_updated.emit(xp, max_xp)


func increment_level() -> void:
	level += 1
	level_updated.emit(level)
	FText.display("Level Up!")
