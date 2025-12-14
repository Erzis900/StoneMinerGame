extends Node

@export var floating_text_manager: FloatingTextManager
@export var sub_viewport_container: SubViewportContainer
@export var sub_viewport: SubViewport
@export var world: World
@export var hud: HUD


func _ready() -> void:
	floating_text_manager.stretch_shrink = sub_viewport_container.stretch_shrink
	world.floating_text_manager = floating_text_manager
	world.sub_viewport_size = sub_viewport.size

	world.gold_amount_changed.connect(hud._on_gold_amount_changed)
