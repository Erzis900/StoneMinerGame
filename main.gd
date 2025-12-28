extends Node

@export var floating_text_manager: FloatingTextManager
@export var sub_viewport_container: SubViewportContainer
@export var sub_viewport: SubViewport
@export var world: World
@export var hud: HUD
@export var upgrade_gui: UpgradeGUI

func _ready() -> void:
	floating_text_manager.stretch_shrink = sub_viewport_container.stretch_shrink
	world.floating_text_manager = floating_text_manager
	world.sub_viewport_size = sub_viewport.size
	
	upgrade_gui.request_upgrades.connect(world.upgrade_manager._on_request_upgrades)
	upgrade_gui.buy_pressed.connect(world._on_upgrade_buy_pressed)
	world.upgrade_manager.response_upgrades.connect(upgrade_gui._on_response_upgrades)
	world.gold_updated.connect(hud._on_gold_updated)
