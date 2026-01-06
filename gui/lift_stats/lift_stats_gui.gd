extends Control
class_name LiftStatsGUI

@onready var lift_stats_panel: PanelContainer = $LiftStatsPanel


func _on_toggle_button_pressed() -> void:
	lift_stats_panel.visible = !lift_stats_panel.visible
