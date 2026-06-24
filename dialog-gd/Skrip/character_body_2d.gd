extends CharacterBody2D

@export var speed: float = 70.0

@onready var luffy: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN
var target_position: Vector2 = Vector2.ZERO
var is_walking: bool = false


func _physics_process(_delta: float) -> void:
	if not is_walking:
		velocity = Vector2.ZERO
		play_idle_animation()
		return

	var direction: Vector2 = global_position.direction_to(target_position)
	var distance: float = global_position.distance_to(target_position)

	if distance <= 2.0:
		global_position = target_position
		velocity = Vector2.ZERO
		is_walking = false
		play_idle_animation()
		return

	velocity = direction * speed

	update_animation(direction)
	move_and_slide()


func walk_to(target: Vector2) -> void:
	target_position = target
	is_walking = true


func wait_until_arrived() -> void:
	while is_walking:
		await get_tree().process_frame


func look_down() -> void:
	last_direction = Vector2.DOWN
	play_idle_animation()


func look_up() -> void:
	last_direction = Vector2.UP
	play_idle_animation()


func look_left() -> void:
	last_direction = Vector2.LEFT
	play_idle_animation()


func look_right() -> void:
	last_direction = Vector2.RIGHT
	play_idle_animation()


func update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		play_idle_animation()
		return

	last_direction = direction

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			play_animation("Walk_Right")
		else:
			play_animation("Walk_Left")
	else:
		if direction.y > 0:
			play_animation("Walk_Bootom")
		else:
			play_animation("Walk_Up")


func play_idle_animation() -> void:
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			play_animation("Idle_Right")
		else:
			play_animation("Idle_Left")
	else:
		if last_direction.y > 0:
			play_animation("Idle_Bootom")
		else:
			play_animation("Idle_Up")


func play_animation(animation_name: StringName) -> void:
	if luffy.animation != animation_name:
		luffy.play(animation_name)
