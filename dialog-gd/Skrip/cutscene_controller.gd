extends Node

@onready var Luffy = $"../world/Luffy"
@onready var Aster = $"../world/Aster"
@onready var dialog_manager = $"../dialogmanager"
@onready var titik_Luffy1 = $"../Luffy titik/Titik1"
@onready var titik_Luffy2 = $"../Luffy titik/Titik2"
@onready var titik_Aster1 = $"../Aster Node/marker"
@onready var titik_Aster2 = $"../Aster Node/marker2"
func mulai_cutscene() -> void:
	# Luffy berjalan ke titik pertama.
	Luffy.look_right()
	Luffy.walk_to(titik_Luffy1.global_position)

	await Luffy.wait_until_arrived()

	# Luffy berjalan ke titik kedua.
	Luffy.look_up()
	Luffy.walk_to(titik_Luffy2.global_position)

	await Luffy.wait_until_arrived()

	# Misalnya child ke-4 dimunculkan.
	Luffy.get_child(3).show()

	# Dialog bagian pertama.
	await dialog_manager.mulai_dialog("start")
	# Contoh menyembunyikan child ke-4.
	Luffy.get_child(3).hide()
	Aster .walk_to(titik_Aster1.global_position)
	await  Aster.wait_until_arrived()
	Aster.walk_to(titik_Aster2.global_position)
	await  Aster.wait_until_arrived()
	Aster.get_child(2).show()
	# Dialog bagian kedua.
	await dialog_manager.mulai_dialog("wifi")

	# Aksi berikutnya setelah dialog kedua selesai.
	Aster.look_up()
