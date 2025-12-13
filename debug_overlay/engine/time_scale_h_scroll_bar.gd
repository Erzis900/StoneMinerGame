extends HScrollBar


func _ready() -> void:
	value = Engine.time_scale


func _on_value_changed(new_value: float) -> void:
	Engine.time_scale = new_value


func _on_time_scale_reset_button_pressed() -> void:
	value = 1.0
