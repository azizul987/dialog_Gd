extends Node

@onready var luffy = $"../world/Luffy"
@onready var Aster = $"../world/Aster"
@onready var dialog_manager = $"../dialogmanager"
@onready var titik_luffy1 =$"../Luffy titik/Titik1"
@onready var titik_luffy2 =$"../Luffy titik/Titik2"

func mulai_cutscene() -> void:
	# NPC Luffy mulai berjalan ke Marker2D
	luffy.look_right()
	luffy.walk_to(titik_luffy1.global_position)

	# Menunggu sampai Luffy benar-benar tiba
	await luffy.wait_until_arrived()
	luffy.look_up()
	luffy.walk_to(titik_luffy2.global_position)

	await  luffy.wait_until_arrived()
	luffy.get_child(3).show()
	# Menampilkan dialog
	dialog_manager.mulai_dialog("start")

	# Menunggu dialog selesai
	await dialog_manager.dialog_selesai
