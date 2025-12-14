class_name FloatingText extends Node2D

@onready var label: Label = $Label

@export var rise_amount: float = 50
@export var lifetime: float = 0.5


func init(text_position: Vector2, text_content: String) -> void:
	position = text_position
	label.text = text_content


func play_tween() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - rise_amount, lifetime)
	tween.tween_callback(self.queue_free)
