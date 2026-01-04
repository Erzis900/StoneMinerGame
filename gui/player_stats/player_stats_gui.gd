extends Control
class_name PlayerStatsGUI

@onready var player_stats_panel: PlayerStatsPanel = $PlayerStatsPanel


func _on_toggle_button_pressed() -> void:
	player_stats_panel.visible = !player_stats_panel.visible
