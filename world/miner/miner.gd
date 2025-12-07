class_name Miner extends Area2D

# exports
@export var movement_speed: float = 64

# children
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var mining_timer: Timer = $MiningTimer

# private
enum States { IDLE, WALKING, MINING }
var state: States = States.WALKING
var direction: Vector2 = Vector2.RIGHT

# signals
signal request_lift_ready
signal loot_dumped


func _physics_process(delta: float) -> void:
	match state:
		States.WALKING:
			walk(delta)
		States.MINING:
			mine()
		States.IDLE:
			idle()

	add_debug_data()


func add_debug_data() -> void:
	Global.debug.add_property("Miner State", States.keys()[state])
	Global.debug.add_property("Miner Position", position)


func idle() -> void:
	animated_sprite.play("idle")


func walk(delta: float) -> void:
	position += direction * movement_speed * delta
	animated_sprite.play("walk_right")


func mine() -> void:
	animated_sprite.play("mine")


func _on_stone_wall_area_entered(_area: Area2D) -> void:
	mining_timer.start()
	state = States.MINING


func change_walk_direction() -> void:
	direction.x *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h


func _on_mining_timer_timeout() -> void:
	mining_timer.stop()
	change_walk_direction()
	state = States.WALKING


func _on_lift_response_lift_ready(is_ready: bool) -> void:
	if is_ready:
		state = States.WALKING
		change_walk_direction()
		loot_dumped.emit()


func _on_player_stoper_lift_area_entered(area: Area2D) -> void:
	state = States.IDLE
	request_lift_ready.emit()
