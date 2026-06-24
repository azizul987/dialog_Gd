extends Node2D

@onready var cutscene_controller = $CutsceneController


func _ready() -> void:
	cutscene_controller.mulai_cutscene()
