class_name FloatingTextManager extends Node

@export var floating_text: PackedScene
var stretch_shrink: int = 1

func display(text_position: Vector2, text_content: String) -> void:
	var floating_text_instance = floating_text.instantiate()
	add_child(floating_text_instance)
	floating_text_instance.init(text_position * stretch_shrink, text_content)
	floating_text_instance.play_tween()
