class_name DebugOverlay extends Control

var is_debug: bool = true


func _ready() -> void:
	visible = is_debug
	Global.debug = %PropertyContainer


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		is_debug = !is_debug
		visible = is_debug
