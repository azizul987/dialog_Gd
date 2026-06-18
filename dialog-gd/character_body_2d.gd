extends CharacterBody2D

const SPEED: float = 300.0

@onready var luffy: AnimatedSprite2D = $Luffy

var last_direction: Vector2 = Vector2.DOWN


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity = direction * SPEED

	update_animation(direction)
	move_and_slide()


func update_animation(direction: Vector2) -> void:
	# Karakter sedang diam.
	if direction == Vector2.ZERO:
		play_idle_animation()
		return

	# Menyimpan arah terakhir karakter.
	last_direction = direction

	# Memilih animasi berdasarkan arah dominan.
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
	# Memainkan animasi diam berdasarkan arah terakhir.
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
	# Mencegah animasi yang sama diputar ulang setiap frame.
	if luffy.animation != animation_name:
		luffy.play(animation_name)
