extends Node

@export var sub_viewport_container: SubViewportContainer
@export var sub_viewport: SubViewport
@export var world: World
@export var hud: HUD
@export var upgrade_gui: UpgradeGUI
@export var player_stats_gui: PlayerStatsGUI
@export var lift_stats_gui: LiftStatsGUI


func _ready() -> void:
	FText.stretch_shrink = sub_viewport_container.stretch_shrink
	FText.default_position = sub_viewport.size / 2

	upgrade_gui.buy_pressed.connect(world._on_upgrade_buy_pressed)
	world.gold_updated.connect(hud._on_gold_updated)
	world.gold_updated.connect(upgrade_gui._on_gold_updated)

	world.miner.stats.updated.connect(player_stats_gui.player_stats_panel._on_player_stats_updated)
	world.lift.stats.updated.connect(lift_stats_gui.lift_stats_panel._on_lift_stats_updated)

	world.miner.xp_manager.level_updated.connect(hud._on_level_updated)
	world.miner.xp_manager.xp_updated.connect(hud._on_xp_updated)

	world.upgrade_manager.response_upgrades.connect(upgrade_gui._on_response_upgrades)

	# Sync
	world.upgrade_manager._on_level_updated(world.miner.xp_manager.level)
	world.upgrade_manager.send_upgrades()
	hud._on_gold_updated(world.gold)
	upgrade_gui._on_gold_updated(world.gold)
	player_stats_gui.player_stats_panel._on_player_stats_updated(world.miner.stats)
	lift_stats_gui.lift_stats_panel._on_lift_stats_updated(world.lift.stats)
	hud._on_level_updated(world.miner.xp_manager.level)
	hud._on_xp_updated(world.miner.xp_manager.xp, world.miner.xp_manager.max_xp)
