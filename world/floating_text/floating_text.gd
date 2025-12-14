class_name FloatingText extends Node2D

@onready var label: Label = $Label

@export var rise_amount: float = 50
@export var lifetime: float = 0.5


func init(_position: Vector2, text: String, _lifetime: float, font_size: int) -> void:
	position = _position
	label.text = text
	lifetime = _lifetime
	
	if font_size != 32:
		label.add_theme_font_size_override("font_size", font_size)


func play_tween() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - rise_amount, lifetime)
	tween.tween_callback(self.queue_free)
