extends PanelContainer

@onready var movement_speed_label: Label = %MovementSpeedLabel
@onready var load_time_label: Label = %LoadTimeLabel
@onready var unload_time_label: Label = %UnloadTimeLabel


func _on_lift_stats_updated(stats: LiftStats) -> void:
	movement_speed_label.text = "Movement Speed: %d px/s" % stats.movement_speed
	load_time_label.text = "Load Time: %0.1f s" % stats.load_time
	unload_time_label.text = "Unload Time: %0.1f s" % stats.unload_time
