class_name Miner extends Area2D

# exports
@export var movement_speed: float = 64
@export var damage: int = 1
@export var max_hits: int = 3
@export var mining_speed: float = 1

@export var mining_particles: PackedScene

# children
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

# private
enum States { WAITING, WALKING, MINING }
var state: States = States.WALKING
var direction: Vector2 = Vector2.RIGHT
var pickaxe_offset: Vector2 = Vector2(8, -5)
var hits: int = 0
var stone: int = 0

# signals
signal request_lift_ready
signal loot_dumped(amount: int)
signal damage_dealt(damage: int)

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
	Debug.add("Miner State", States.keys()[state])
	Debug.add("Miner Stone", stone)

func wait() -> void:
	animation_player.play("wait")


func walk(delta: float) -> void:
	position += direction * movement_speed * delta
	animation_player.play("walk_right")


func mine() -> void:
	animation_player.play("mine", -1, mining_speed)


func _on_stone_wall_area_entered(_area: Area2D) -> void:
	state = States.MINING


func change_walk_direction() -> void:
	direction.x *= -1
	sprite_2d.flip_h = !sprite_2d.flip_h


func _on_player_stoper_lift_area_entered(_area: Area2D) -> void:
	state = States.WAITING
	request_lift_ready.emit()

func _on_pickaxe_hit() -> void:
	spawn_mining_particles()
	owner.floating_text_manager.display(position + pickaxe_offset, str(damage))

func spawn_mining_particles() -> void:
	var particles_instance = mining_particles.instantiate()
	add_child(particles_instance)
	particles_instance.position = pickaxe_offset


func _on_lift_ready_to_load(is_ready: bool) -> void:
	if is_ready and state == States.WAITING:
		loot_dumped.emit(stone)
		stone = 0

		state = States.WALKING
		change_walk_direction()


func check_hits() -> void:
	damage_dealt.emit(damage)
	hits += 1
	if hits == max_hits:
		hits = 0
		change_walk_direction()
		state = States.WALKING


func _on_stone_wall_stone_dropped(amount: int) -> void:
	var floating_text_position = position + pickaxe_offset - Vector2(16, 16)
	owner.floating_text_manager.display(floating_text_position, "+%d Stone" % amount, 2.0)
	stone += amount
