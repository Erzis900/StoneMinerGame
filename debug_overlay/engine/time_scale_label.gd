extends Label


func _ready() -> void:
	text = "Time Scale: %.1f" % Global.DEFAULT_TIME_SCALE


func _on_time_scale_h_scroll_bar_value_changed(value: float) -> void:
	text = "Time Scale: %.1f" % value


func _on_time_scale_reset_button_pressed() -> void:
	text = "Time Scale: %.1f" % Global.DEFAULT_TIME_SCALE
