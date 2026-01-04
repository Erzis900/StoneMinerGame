class_name Miner extends Area2D

# exports
@export var stats: MinerStats

# children
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_audio: AudioStreamPlayer = $HitAudio

# private
enum States { WAITING, WALKING, MINING }
var state: States = States.WALKING
var direction: Vector2 = Vector2.RIGHT
var pickaxe_offset: Vector2 = Vector2(8, -5)
var hits: int = 0
var stone: int = 0
var hit_damage: int = 0

# signals
signal request_lift_ready
signal loot_dumped(amount: int)
signal damage_dealt(damage: int)
signal wall_hit(position: Vector2)


func _ready() -> void:
	# Panel sync
	await get_tree().process_frame
	stats.updated.emit(stats)


func _physics_process(delta: float) -> void:
	match state:
		States.WALKING:
			walk(delta)
		States.MINING:
			mine()
		States.WAITING:
			wait()

	add_debug_data()


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		pass


func add_debug_data() -> void:
	#Debug.add("Miner State", States.keys()[state])
	#Debug.add("Miner Stone", stone)
	Debug.add("MS", stats.movement_speed)
	Debug.add("DMG", stats.damage)
	Debug.add("Mining speed", stats.mining_speed)
	Debug.add("Max hits", stats.max_hits)


func wait() -> void:
	animation_player.play("wait")


func walk(delta: float) -> void:
	position += direction * stats.movement_speed * delta
	animation_player.play("walk_right")


func mine() -> void:
	animation_player.play("mine", -1, stats.mining_speed)


func _on_stone_wall_area_entered(_area: Area2D) -> void:
	set_state(States.MINING)


func change_walk_direction() -> void:
	direction.x *= -1
	sprite_2d.flip_h = !sprite_2d.flip_h


func _on_player_stoper_lift_area_entered(_area: Area2D) -> void:
	set_state(States.WAITING)
	request_lift_ready.emit()


func _on_pickaxe_hit() -> void:
	wall_hit.emit(position + pickaxe_offset)

	hit_damage = int(stats.calculate_damage())
	owner.floating_text_manager.display(position + pickaxe_offset, str(hit_damage))


func _on_lift_ready_to_load(is_ready: bool) -> void:
	if is_ready and state == States.WAITING:
		loot_dumped.emit(stone)
		stone = 0

		set_state(States.WALKING)
		change_walk_direction()


func _on_hit_finished() -> void:
	deal_damage()
	check_hits()


func deal_damage() -> void:
	damage_dealt.emit(hit_damage)


func check_hits() -> void:
	hits += 1
	if hits == stats.max_hits:
		hits = 0
		change_walk_direction()
		set_state(States.WALKING)


func _on_stone_wall_stone_dropped(amount: int) -> void:
	var floating_text_position = position + pickaxe_offset - Vector2(16, 16)
	owner.floating_text_manager.display(floating_text_position, "+%d Stone" % amount, 2.0)
	stone += amount


func _on_upgrade_manager_miner_upgrade_applied(upgrade: UpgradeData) -> void:
	stats.apply_upgrade(upgrade)


func set_state(new_state: States) -> void:
	if state == new_state:
		return

	state = new_state
