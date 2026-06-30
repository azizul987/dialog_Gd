extends Node

@onready var Luffy = $"../world/Luffy"
@onready var Aster = $"../world/Aster"
@onready var cut = $"../world/Cut"

@onready var dialog_manager = $"../dialogmanager"
@onready var titik_Luffy1 = $"../Luffy titik/Titik1"
@onready var titik_Luffy2 = $"../Luffy titik/Titik2"
@onready var titik_Luffy3 = $"../Luffy titik/Titik3"
@onready var titik_Luffy4 = $"../Luffy titik/Titik4"

@onready var titik_Aster1 = $"../Aster Node/marker"
@onready var titik_Aster2 = $"../Aster Node/marker2"
@onready var titik_Aster3 = $"../Aster Node/marker3"
@onready var titik_Aster4 = $"../Aster Node/marker4"

@onready var titik_cut1 = $"../Cut/titik1"
func mulai_cutscene() -> void:
	# Luffy berjalan ke titik pertama.
	Luffy.look_right()
	Luffy.walk_to(titik_Luffy1.global_position)

	await Luffy.wait_until_arrived()

	Luffy.look_up()
	Luffy.walk_to(titik_Luffy2.global_position)

	await Luffy.wait_until_arrived()

	Luffy.get_child(3).show()

	# Dialog bagian pertama.
	await dialog_manager.mulai_dialog("start")
	Aster .walk_to(titik_Aster1.global_position)
	await  Aster.wait_until_arrived()
	Aster.walk_to(titik_Aster2.global_position)
	await  Aster.wait_until_arrived()
	await dialog_manager.mulai_dialog("Start2")
	Aster.walk_to(titik_Aster3.global_position)
	Luffy.walk_to(titik_Luffy3.global_position)
	await  Aster.wait_until_arrived()
	await  Luffy.wait_until_arrived()
	Aster.walk_to(titik_Aster4.global_position)
	Luffy.walk_to(titik_Luffy4.global_position)
	await  Aster.wait_until_arrived()
	await  Luffy.wait_until_arrived()
	Luffy.look_left()
	await Luffy.wait_until_arrived()
	await get_tree().create_timer(1.0).timeout
	await dialog_manager.mulai_dialog("luffy_tanya")#index 4 
	Luffy.look_down()
	await Luffy.wait_until_arrived()
	## Aksi berikutnya setelah dialog kedua selesai.
	cut.walk_to(titik_cut1.global_position)
	await cut.wait_until_arrived()
	await  dialog_manager.mulai_dialog("cut_bersuara")
	Luffy.look_left()
	await Luffy.wait_until_arrived()
	await dialog_manager.mulai_dialog("luffy_menoleh")#8
	#cut_bersuara
