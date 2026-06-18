extends PointLight2D

## Jumlah siklus mengecil-membesar per detik.
@export_range(0.05, 5.0, 0.05)
var pulse_speed: float = 0.65

## Ukuran terkecil dibanding ukuran awal.
@export_range(0.1, 1.0, 0.01)
var minimum_size: float = 0.92

## Ukuran terbesar dibanding ukuran awal.
@export_range(1.0, 2.0, 0.01)
var maximum_size: float = 1.08

## Besarnya perubahan intensitas.
@export_range(0.0, 0.5, 0.01)
var energy_variation: float = 0.05

## Variasi lembut agar gerakan tidak terlalu mekanis.
@export_range(0.0, 0.1, 0.001)
var natural_variation: float = 0.008


var _time: float = 0.0
var _base_texture_scale: float
var _base_energy: float
var _random_phase: float


func _ready() -> void:
	_base_texture_scale = texture_scale
	_base_energy = energy
	_random_phase = randf_range(0.0, TAU)

	# Pastikan tekstur cahaya tidak bergeser.
	offset = Vector2.ZERO


func _process(delta: float) -> void:
	_time += delta

	# Gelombang utama yang bergerak halus dari 0 sampai 1.
	var main_pulse: float = (
		sin(_time * TAU * pulse_speed) + 1.0
	) * 0.5

	# Variasi kedua sangat kecil dan tetap halus.
	var secondary_pulse: float = sin(
		_time * TAU * pulse_speed * 0.43
		+ _random_phase
	) * natural_variation

	# Cahaya menyusut lalu membesar dari titik yang sama.
	var size_multiplier: float = lerp(
		minimum_size,
		maximum_size,
		main_pulse
	)

	size_multiplier += secondary_pulse

	texture_scale = (
		_base_texture_scale
		* size_multiplier
	)

	# Saat membesar sedikit lebih terang.
	var centered_pulse: float = (
		main_pulse * 2.0
		- 1.0
	)

	energy = max(
		0.0,
		_base_energy
		* (
			1.0
			+ centered_pulse
			* energy_variation
		)
	)


func reset_light() -> void:
	_time = 0.0
	texture_scale = _base_texture_scale
	energy = _base_energy
	offset = Vector2.ZERO
