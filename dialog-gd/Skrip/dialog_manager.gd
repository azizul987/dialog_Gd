extends Node

signal dialog_selesai

@export var dialog_data: data_dialog
@onready var ui:CanvasLayer = $"../ui"
@onready var label_penutur :Label = $"../ui/Dialog/Name/name"
@onready var label_narasi :Label = $"../ui/Dialog/Isi/dialog_txt"

var id_awal: String = "start"

func _ready() -> void:
	ui.hide()
func mulai_dialog(id_dialog: String) -> void:
	ui.show()
	
	await get_tree().create_timer(2.0).timeout
	
	dialog_selesai.emit()
