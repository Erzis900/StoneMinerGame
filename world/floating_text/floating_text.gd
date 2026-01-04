class_name FloatingText extends Node2D

@onready var label: Label = $Label

@export var rise_amount: float = 50
@export var lifetime: float = 0.5
var is_crit: bool = false


func init(
	_position: Vector2, text: String, _is_crit: bool, _lifetime: float, font_size: int
) -> void:
	position = _position
	label.text = text
	is_crit = _is_crit
	lifetime = _lifetime

	if font_size != 32:
		label.add_theme_font_size_override("font_size", font_size)

	if is_crit:
		label.add_theme_font_size_override("font_size", font_size * 2)
		#label.add_theme_color_override("font_color", Color.RED)
		rise_amount *= 2
		scale = Vector2(2, 2)


func play_tween() -> void:
	var tween = create_tween()

	if is_crit:
		tween.tween_property(self, "scale", Vector2(1, 1), lifetime * 0.1)

	tween.tween_property(self, "position:y", position.y - rise_amount, lifetime)
	tween.tween_callback(self.queue_free)
