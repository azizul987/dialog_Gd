extends CharacterBody2D

@export var speed: float = 70.0
@onready var luffy: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN
var target_position: Vector2 = Vector2.ZERO

# Variabel lama untuk gerak otomatis (cutscene)
var is_walking: bool = false 

# VARIABEL BARU: Untuk mengunci pemain saat dialog
var bisa_jalan_manual: bool = true 


func _physics_process(_delta: float) -> void:
	# 1. GERAK OTOMATIS (Cutscene / walk_to) - PRIORITAS UTAMA
	if is_walking:
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
		return # <-- Penting: Kalau lagi cutscene, stop baca kode di bawahnya

	# 2. CEK KUNCI DIALOG: Kalau dikunci, MC/NPC diam (menolak input manual)
	if not bisa_jalan_manual:
		velocity = Vector2.ZERO
		play_idle_animation()
		return # <-- Penting: Stop di sini, gak usah baca input keyboard

	# 3. GERAK MANUAL (WASD / Panah)
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * speed
		update_animation(input_dir)
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	move_and_slide()
	
func walk_to(target: Vector2) -> void:
	#bisa_jalan_manual = false
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
