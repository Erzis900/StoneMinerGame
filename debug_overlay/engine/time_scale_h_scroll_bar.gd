extends HScrollBar


func _ready() -> void:
	value = Global.DEFAULT_TIME_SCALE


func _on_value_changed(value: float) -> void:
	Engine.time_scale = value


func _on_time_scale_reset_button_pressed() -> void:
	value = Global.DEFAULT_TIME_SCALE
