class_name FloatingTextManager extends Node

#@export var floating_text: PackedScene
var stretch_shrink: int = 0
var floating_text = preload("res://world/floating_text/floating_text.tscn")
var container: Node = null


func display(
	text_position: Vector2,
	text_content: String,
	is_crit: bool = false,
	lifetime: float = 1.0,
	font_size: int = 32
) -> void:
	var floating_text_instance = floating_text.instantiate() as FloatingText
	container.add_child(floating_text_instance)

	floating_text_instance.init(
		text_position * stretch_shrink, text_content, is_crit, lifetime, font_size
	)
	floating_text_instance.play_tween()
