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


func _physics_process(delta: float) -> void:
	if state == States.WALKING:
		walk(delta)
	elif state == States.MINING:
		mine()

	add_debug_data()


func add_debug_data() -> void:
	Global.debug.add_property("Miner State", States.keys()[state])
	Global.debug.add_property("Miner Position", position)


func walk(delta: float) -> void:
	position += direction * movement_speed * delta
	animated_sprite.play("walk_right")


func mine() -> void:
	animated_sprite.play("mine")


func _on_stone_wall_area_entered(_area: Area2D) -> void:
	mining_timer.start()
	change_state(States.MINING)


func _on_lift_area_entered(_area: Area2D) -> void:
	change_walk_direction()


func change_walk_direction() -> void:
	direction.x *= -1
	animated_sprite.flip_h = !animated_sprite.flip_h


func _on_mining_timer_timeout() -> void:
	mining_timer.stop()
	change_walk_direction()
	change_state(States.WALKING)


func change_state(new_state: States) -> void:
	state = new_state
